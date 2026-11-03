import 'dart:async';
import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers.dart';
import '../../../core/errors.dart';
import '../../../core/paging.dart';
import '../../../core/utils/dates.dart';
import '../domain/models.dart';

part 'members_repository.g.dart';

/// Everything about members (F1). Writes that change memberships or
/// attendance go through database RPCs so rules live in the database.
abstract interface class MembersRepository {
  Future<Paged<Member>> list({required int offset, MemberQuery query = const MemberQuery()});
  Future<List<Member>> listAll(MemberQuery query);
  Future<Member> get(String id);
  Future<List<Member>> findDuplicates({required String phone, required String name});
  Future<String> add(NewMember input);
  Future<void> update(String id, Map<String, dynamic> fields);
  Future<void> setArchived(String id, {required bool archived});
  Future<void> deleteForever(String id);
  Future<void> assignTrainer(List<String> memberIds, String? trainerId);

  Future<MemberHealth?> health(String memberId);
  Future<void> saveHealth(MemberHealth health);
  Future<List<Measurement>> measurements(String memberId);
  Future<void> addMeasurement(Measurement m);

  Future<List<Membership>> memberships(String memberId);
  Future<String> startMembership({
    required String memberId,
    required String planId,
    DateTime? start,
    int discountPaise = 0,
    String? discountReason,
    List<String> addonIds = const [],
  });
  Future<String> renew({required String memberId, String? planId, int discountPaise = 0, String? discountReason});
  Future<void> freeze({required String membershipId, required DateTime from, required int days, String? reason});
  Future<void> unfreeze(String membershipId);
  Future<void> cancel({required String membershipId, required String reason, int refundPaise = 0});
  Future<void> transfer({required String membershipId, required String toMemberId});

  Future<List<MemberEvent>> events(String memberId, {int offset = 0});
  Future<void> addNote(String memberId, String text);

  Future<List<Attendance>> attendance(String memberId, {required DateTime from, required DateTime to});
  Future<CheckInResult> checkIn(String memberId);
  Future<CheckInResult> selfCheckIn(String code);
  Future<String> todaysGymCode();

  Future<DashboardCounts> dashboard();
  Future<List<NeedsAction>> needsAction();
  Stream<List<Attendance>> todaysCheckIns();

  Future<List<ImportRowResult>> importRows(List<Map<String, dynamic>> rows, {void Function(int done)? onProgress});

  Future<void> uploadPhoto(String memberId, Uint8List jpeg);
  Future<String?> photoUrl(String? path);
}

/// Translates database errors into failures the UI can explain. Messages
/// raised by our own RPC checks (e.g. "only 3 freeze days left") are shown.
Never _rethrow(Object e) {
  if (e is AppFailure) throw e;
  if (e is PostgrestException) {
    switch (e.code) {
      case '42501':
        throw const NotAllowedFailure();
      case '23505':
        throw const DuplicatePhoneFailure();
      case 'P0002':
        throw const NotFoundFailure();
      case '22023' || '23P01' || '23514':
        throw RuleFailure(e.message);
    }
    throw ServerFailure(e.message);
  }
  if (e is StorageException) throw ServerFailure(e.message);
  final text = e.toString();
  if (text.contains('SocketException') || text.contains('ClientException') || e is TimeoutException) {
    throw const NetworkFailure();
  }
  throw ServerFailure(text);
}

Future<T> _guard<T>(Future<T> Function() run) async {
  try {
    return await run();
  } catch (e) {
    _rethrow(e);
  }
}

class SupabaseMembersRepository implements MembersRepository {
  SupabaseMembersRepository(this._db);

  final SupabaseClient _db;
  static const _bucket = 'member-photos';
  final Map<String, (String, DateTime)> _signed = {};

  PostgrestFilterBuilder<List<Map<String, dynamic>>> _filtered(MemberQuery q) {
    var f = _db.from('members').select();
    if (!q.includeArchived) f = f.isFilter('archived_at', null);
    final s = sanitizeSearch(q.search);
    if (s.isNotEmpty) {
      final digits = s.replaceAll(RegExp(r'\D'), '');
      final ors = ['name.ilike.*$s*', 'member_code.ilike.*$s*', if (digits.length >= 3) 'phone.ilike.*$digits*'];
      f = f.or(ors.join(','));
    }
    if (q.statuses.isNotEmpty) f = f.inFilter('status', q.statuses);
    if (q.planName != null) f = f.eq('plan_name', q.planName!);
    if (q.trainerId != null) f = f.eq('trainer_id', q.trainerId!);
    if (q.batch != null) f = f.eq('batch', q.batch!);
    if (q.gender != null) f = f.eq('gender', q.gender!);
    if (q.birthdayThisMonth) f = f.eq('dob_month', IstDates.today().month);
    if (q.joinedFrom != null) f = f.gte('joined_on', dateParam(q.joinedFrom)!);
    if (q.joinedTo != null) f = f.lte('joined_on', dateParam(q.joinedTo)!);
    return f;
  }

  PostgrestTransformBuilder<List<Map<String, dynamic>>> _sorted(MemberQuery q) {
    final f = _filtered(q);
    return switch (q.sort) {
      MemberSort.name => f.order('name', ascending: true),
      MemberSort.endDate => f.order('membership_end', ascending: true, nullsFirst: false),
      MemberSort.joined => f.order('joined_on', ascending: false),
    };
  }

  @override
  Future<Paged<Member>> list({required int offset, MemberQuery query = const MemberQuery()}) => _guard(() async {
    final rows = await _sorted(query).range(offset, offset + kPageSize - 1);
    final items = rows.map(Member.fromJson).toList();
    return Paged(items, hasMore: items.length == kPageSize);
  });

  @override
  Future<List<Member>> listAll(MemberQuery query) => _guard(() async {
    final out = <Member>[];
    for (var offset = 0; ; offset += 1000) {
      final rows = await _sorted(query).range(offset, offset + 999);
      out.addAll(rows.map(Member.fromJson));
      if (rows.length < 1000) return out;
    }
  });

  @override
  Future<Member> get(String id) => _guard(() async {
    final row = await _db.from('members').select().eq('id', id).maybeSingle();
    if (row == null) throw const NotFoundFailure();
    return Member.fromJson(row);
  });

  @override
  Future<List<Member>> findDuplicates({required String phone, required String name}) => _guard(() async {
    final n = sanitizeSearch(name);
    final ors = ['phone.eq.$phone', if (n.length >= 3) 'name.ilike.$n'];
    final rows = await _db.from('members').select().or(ors.join(',')).limit(5);
    return rows.map(Member.fromJson).toList();
  });

  @override
  Future<String> add(NewMember input) => _guard(() async {
    final id = await _db.rpc<String>(
      'add_member',
      params: {
        'p_member': input.member,
        'p_health': input.health,
        'p_membership': input.planId == null
            ? null
            : {
                'plan_id': input.planId,
                'start_date': dateParam(input.startDate),
                'discount_paise': input.discountPaise,
                'discount_reason': input.discountReason,
                'addon_ids': input.addonIds,
              },
      },
    );
    return id;
  });

  @override
  Future<void> update(String id, Map<String, dynamic> fields) => _guard(() async {
    final rows = await _db.from('members').update(fields).eq('id', id).select('id');
    if (rows.isEmpty) throw const NotAllowedFailure();
  });

  @override
  Future<void> setArchived(String id, {required bool archived}) =>
      update(id, {'archived_at': archived ? DateTime.now().toUtc().toIso8601String() : null});

  @override
  Future<void> deleteForever(String id) => _guard(() async {
    final rows = await _db.from('members').delete().eq('id', id).select('id');
    if (rows.isEmpty) throw const NotAllowedFailure();
  });

  @override
  Future<void> assignTrainer(List<String> memberIds, String? trainerId) => _guard(() async {
    if (memberIds.isEmpty) return;
    await _db.from('members').update({'trainer_id': trainerId}).inFilter('id', memberIds);
  });

  @override
  Future<MemberHealth?> health(String memberId) => _guard(() async {
    final row = await _db.from('member_health').select().eq('member_id', memberId).maybeSingle();
    return row == null ? null : MemberHealth.fromJson(row);
  });

  @override
  Future<void> saveHealth(MemberHealth health) => _guard(() async {
    await _db.from('member_health').upsert(health.toJson());
  });

  @override
  Future<List<Measurement>> measurements(String memberId) => _guard(() async {
    final rows = await _db
        .from('member_measurements')
        .select()
        .eq('member_id', memberId)
        .order('measured_on', ascending: false)
        .limit(100);
    return rows.map(Measurement.fromJson).toList();
  });

  @override
  Future<void> addMeasurement(Measurement m) => _guard(() async {
    final json = m.toJson()..remove('id');
    await _db.from('member_measurements').insert(json);
  });

  @override
  Future<List<Membership>> memberships(String memberId) => _guard(() async {
    final rows = await _db
        .from('memberships')
        .select('*, membership_freezes(id, from_date, to_date, reason)')
        .eq('member_id', memberId)
        .order('end_date', ascending: false);
    return rows.map(Membership.fromJson).toList();
  });

  @override
  Future<String> startMembership({
    required String memberId,
    required String planId,
    DateTime? start,
    int discountPaise = 0,
    String? discountReason,
    List<String> addonIds = const [],
  }) => _guard(
    () => _db.rpc<String>(
      'start_membership',
      params: {
        'p_member_id': memberId,
        'p_plan_id': planId,
        'p_start': dateParam(start),
        'p_discount_paise': discountPaise,
        'p_discount_reason': discountReason,
        'p_addon_ids': addonIds,
      },
    ),
  );

  @override
  Future<String> renew({required String memberId, String? planId, int discountPaise = 0, String? discountReason}) =>
      _guard(
        () => _db.rpc<String>(
          'renew_membership',
          params: {
            'p_member_id': memberId,
            'p_plan_id': planId,
            'p_discount_paise': discountPaise,
            'p_discount_reason': discountReason,
          },
        ),
      );

  @override
  Future<void> freeze({required String membershipId, required DateTime from, required int days, String? reason}) =>
      _guard(
        () => _db.rpc<void>(
          'freeze_membership',
          params: {'p_membership_id': membershipId, 'p_from': dateParam(from), 'p_days': days, 'p_reason': reason},
        ),
      );

  @override
  Future<void> unfreeze(String membershipId) =>
      _guard(() => _db.rpc<void>('unfreeze_membership', params: {'p_membership_id': membershipId}));

  @override
  Future<void> cancel({required String membershipId, required String reason, int refundPaise = 0}) => _guard(
    () => _db.rpc<void>(
      'cancel_membership',
      params: {'p_membership_id': membershipId, 'p_reason': reason, 'p_refund_paise': refundPaise},
    ),
  );

  @override
  Future<void> transfer({required String membershipId, required String toMemberId}) => _guard(
    () =>
        _db.rpc<String>('transfer_membership', params: {'p_membership_id': membershipId, 'p_to_member_id': toMemberId}),
  );

  @override
  Future<List<MemberEvent>> events(String memberId, {int offset = 0}) => _guard(() async {
    final rows = await _db
        .from('member_events')
        .select('id, kind, title, data, at')
        .eq('member_id', memberId)
        .order('at', ascending: false)
        .range(offset, offset + kPageSize - 1);
    return rows.map(MemberEvent.fromJson).toList();
  });

  @override
  Future<void> addNote(String memberId, String text) =>
      _guard(() => _db.rpc<void>('add_member_note', params: {'p_member_id': memberId, 'p_text': text}));

  @override
  Future<List<Attendance>> attendance(String memberId, {required DateTime from, required DateTime to}) =>
      _guard(() async {
        final rows = await _db
            .from('attendance')
            .select('id, member_id, day, checked_in_at, method')
            .eq('member_id', memberId)
            .gte('day', dateParam(from)!)
            .lte('day', dateParam(to)!)
            .order('day', ascending: false);
        return rows.map(Attendance.fromJson).toList();
      });

  @override
  Future<CheckInResult> checkIn(String memberId) => _guard(() async {
    final res = await _db.rpc<Map<String, dynamic>>('check_in', params: {'p_member_id': memberId});
    return CheckInResult.fromJson(res);
  });

  @override
  Future<CheckInResult> selfCheckIn(String code) => _guard(() async {
    final res = await _db.rpc<Map<String, dynamic>>('self_check_in', params: {'p_code': code});
    return CheckInResult.fromJson(res);
  });

  @override
  Future<String> todaysGymCode() => _guard(() => _db.rpc<String>('todays_gym_code'));

  @override
  Future<DashboardCounts> dashboard() => _guard(() async {
    final res = await _db.rpc<Map<String, dynamic>>('staff_dashboard');
    return DashboardCounts.fromJson(res);
  });

  @override
  Future<List<NeedsAction>> needsAction() => _guard(() async {
    final rows = await _db.rpc<List<dynamic>>('needs_action', params: {'p_limit': 50});
    return rows.cast<Map<String, dynamic>>().map(NeedsAction.fromJson).toList();
  });

  Future<List<Attendance>> _todayWithNames() async {
    final rows = await _db
        .from('attendance')
        .select('id, member_id, day, checked_in_at, method, members(name)')
        .eq('day', dateParam(IstDates.today())!)
        .order('checked_in_at', ascending: false)
        .limit(20);
    return [
      for (final r in rows)
        Attendance.fromJson(r).copyWith(memberName: (r['members'] as Map<String, dynamic>?)?['name'] as String?),
    ];
  }

  @override
  Stream<List<Attendance>> todaysCheckIns() async* {
    // Realtime tells us something changed; re-read with member names.
    yield await _todayWithNames();
    await for (final _ in _db.from('attendance').stream(primaryKey: ['id']).eq('day', dateParam(IstDates.today())!)) {
      yield await _todayWithNames();
    }
  }

  @override
  Future<List<ImportRowResult>> importRows(List<Map<String, dynamic>> rows, {void Function(int done)? onProgress}) =>
      _guard(() async {
        final out = <ImportRowResult>[];
        for (var i = 0; i < rows.length; i += 500) {
          final chunk = rows.sublist(i, i + 500 > rows.length ? rows.length : i + 500);
          final res = await _db.rpc<List<dynamic>>('import_members', params: {'p_rows': chunk});
          out.addAll(res.cast<Map<String, dynamic>>().map(ImportRowResult.fromJson));
          onProgress?.call(out.length);
        }
        return out;
      });

  @override
  Future<void> uploadPhoto(String memberId, Uint8List jpeg) => _guard(() async {
    final path = '$memberId/photo.jpg';
    await _db.storage
        .from(_bucket)
        .uploadBinary(path, jpeg, fileOptions: const FileOptions(upsert: true, contentType: 'image/jpeg'));
    _signed.remove(path);
    await update(memberId, {'photo_url': path});
  });

  @override
  Future<String?> photoUrl(String? path) async {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http')) return path;
    final cached = _signed[path];
    if (cached != null && cached.$2.isAfter(DateTime.now())) return cached.$1;
    try {
      final url = await _db.storage.from(_bucket).createSignedUrl(path, 3600);
      _signed[path] = (url, DateTime.now().add(const Duration(minutes: 50)));
      return url;
    } catch (_) {
      return null; // Missing photo: show initials.
    }
  }
}

@Riverpod(keepAlive: true)
MembersRepository membersRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  if (client == null) throw const NotConfiguredFailure();
  return SupabaseMembersRepository(client);
}
