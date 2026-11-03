import 'dart:async';
import 'dart:typed_data';

import 'package:abs_fitness/core/errors.dart';
import 'package:abs_fitness/core/paging.dart';
import 'package:abs_fitness/features/members/data/members_repository.dart';
import 'package:abs_fitness/features/members/data/plans_repository.dart';
import 'package:abs_fitness/features/members/domain/models.dart';
import 'package:abs_fitness/features/settings/data/gym_settings_repository.dart';

/// Fixed "today" used by member fakes and the pinned test clock (3 Nov 2026).
final fakeToday = DateTime.utc(2026, 11, 3);

const monthly = Plan(
  id: 'plan-monthly',
  name: 'Monthly',
  durationValue: 1,
  pricePaise: 150000,
  joiningFeePaise: 50000,
  freezeDaysAllowed: 7,
  color: 'sky',
);
const quarterly = Plan(
  id: 'plan-quarterly',
  name: 'Quarterly',
  durationValue: 3,
  pricePaise: 400000,
  freezeDaysAllowed: 15,
  color: 'tangerine',
);
const locker = Addon(id: 'addon-locker', name: 'Locker', pricePaise: 30000, kind: 'locker');

String _d(DateTime d) => dateParam(d)!;

/// Ports the database status rules so fakes behave like the real thing.
MemberStatus statusFor(DateTime start, DateTime end, {bool cancelled = false, bool frozen = false}) {
  final t = fakeToday;
  if (cancelled) return MemberStatus.cancelled;
  if (frozen) return MemberStatus.frozen;
  if (t.isBefore(start)) return MemberStatus.upcoming;
  if (t.isAfter(end)) return t.difference(end).inDays >= 90 ? MemberStatus.inactive : MemberStatus.expired;
  if (end.difference(t).inDays < 7) return MemberStatus.expiring;
  return MemberStatus.active;
}

class FakeMembersRepository implements MembersRepository {
  FakeMembersRepository({List<Member>? members}) : members = members ?? sampleMembers();

  final List<Member> members;
  final Map<String, List<Membership>> membershipsByMember = {};
  final Map<String, List<Attendance>> checkIns = {};
  final Map<String, List<MemberEvent>> eventsByMember = {};
  final Map<String, MemberHealth> healthByMember = {};
  final List<String> calls = [];
  Object? error;
  String gymCode = 'ABSGYM-TODAY12345';
  int _seq = 100;

  void _maybeThrow() {
    final e = error;
    if (e != null) throw e;
  }

  void _log(String memberId, String kind, String title) {
    eventsByMember
        .putIfAbsent(memberId, () => [])
        .insert(0, MemberEvent(id: _seq++, kind: kind, title: title, at: DateTime.utc(2026, 11, 3, 5)));
  }

  void _refresh(String memberId) {
    final i = members.indexWhere((m) => m.id == memberId);
    final list = (membershipsByMember[memberId] ?? []).where((m) => m.cancelledReason == null).toList()
      ..sort((a, b) => b.endDate!.compareTo(a.endDate!));
    Membership? current;
    for (final m in list) {
      if (!fakeToday.isBefore(m.startDate!) && !fakeToday.isAfter(m.endDate!)) current = m;
    }
    current ??= list.isEmpty ? null : list.first;
    members[i] = members[i].copyWith(
      status: current == null ? MemberStatus.inactive : statusFor(current.startDate!, current.endDate!),
      planName: current?.planName,
      membershipStart: current?.startDate,
      membershipEnd: current?.endDate,
      currentMembershipId: current?.id,
    );
  }

  @override
  Future<Paged<Member>> list({required int offset, MemberQuery query = const MemberQuery()}) async {
    _maybeThrow();
    final all = await listAll(query);
    final page = all.skip(offset).take(kPageSize).toList();
    return Paged(page, hasMore: offset + page.length < all.length);
  }

  @override
  Future<List<Member>> listAll(MemberQuery query) async {
    _maybeThrow();
    final s = query.search.toLowerCase();
    final out = members.where((m) {
      if (!query.includeArchived && m.isArchived) return false;
      if (s.isNotEmpty &&
          !(m.name.toLowerCase().contains(s) || m.memberCode.toLowerCase().contains(s) || m.phone.contains(s))) {
        return false;
      }
      if (query.statuses.isNotEmpty && !query.statuses.contains(m.status.name)) return false;
      if (query.planName != null && m.planName != query.planName) return false;
      if (query.batch != null && m.batch != query.batch) return false;
      if (query.trainerId != null && m.trainerId != query.trainerId) return false;
      return true;
    }).toList();
    out.sort((a, b) => a.name.compareTo(b.name));
    return out;
  }

  @override
  Future<Member> get(String id) async {
    _maybeThrow();
    return members.firstWhere((m) => m.id == id, orElse: () => throw const NotFoundFailure());
  }

  @override
  Future<List<Member>> findDuplicates({required String phone, required String name}) async =>
      members.where((m) => m.phone == phone || m.name.toLowerCase() == name.toLowerCase()).toList();

  @override
  Future<String> add(NewMember input) async {
    _maybeThrow();
    calls.add('add:${input.member['name']}');
    final phone = input.member['phone'] as String;
    if (members.any((m) => m.phone == phone)) throw const DuplicatePhoneFailure();
    final id = 'm-${_seq++}';
    members.add(
      Member(
        id: id,
        memberCode: 'ABS-${(members.length + 1).toString().padLeft(4, '0')}',
        name: input.member['name'] as String,
        phone: phone,
        joinedOn: fakeToday,
        batch: input.member['batch'] as String?,
      ),
    );
    _log(id, 'joined', 'Joined the gym');
    if (input.health != null) {
      healthByMember[id] = MemberHealth(memberId: id, conditions: input.health!['conditions'] as String?);
    }
    if (input.planId != null) {
      await startMembership(memberId: id, planId: input.planId!, start: input.startDate, addonIds: input.addonIds);
    }
    return id;
  }

  @override
  Future<void> update(String id, Map<String, dynamic> fields) async {
    _maybeThrow();
    final i = members.indexWhere((m) => m.id == id);
    members[i] = Member.fromJson({...members[i].toJson(), ...fields});
    _log(id, 'profile_updated', 'Profile updated');
  }

  @override
  Future<void> setArchived(String id, {required bool archived}) async {
    final i = members.indexWhere((m) => m.id == id);
    members[i] = members[i].copyWith(archivedAt: archived ? DateTime.utc(2026, 11, 3) : null);
  }

  @override
  Future<void> deleteForever(String id) async => members.removeWhere((m) => m.id == id);

  @override
  Future<void> assignTrainer(List<String> memberIds, String? trainerId) async {
    calls.add('assignTrainer:${memberIds.length}:$trainerId');
    for (final id in memberIds) {
      final i = members.indexWhere((m) => m.id == id);
      members[i] = members[i].copyWith(trainerId: trainerId);
    }
  }

  @override
  Future<MemberHealth?> health(String memberId) async => healthByMember[memberId];

  @override
  Future<void> saveHealth(MemberHealth health) async => healthByMember[health.memberId] = health;

  final Map<String, List<Measurement>> measurementsByMember = {};

  @override
  Future<List<Measurement>> measurements(String memberId) async => measurementsByMember[memberId] ?? [];

  @override
  Future<void> addMeasurement(Measurement m) async =>
      measurementsByMember.putIfAbsent(m.memberId, () => []).insert(0, m);

  @override
  Future<List<Membership>> memberships(String memberId) async {
    _maybeThrow();
    final list = [...?membershipsByMember[memberId]]..sort((a, b) => b.endDate!.compareTo(a.endDate!));
    return list;
  }

  @override
  Future<String> startMembership({
    required String memberId,
    required String planId,
    DateTime? start,
    int discountPaise = 0,
    String? discountReason,
    List<String> addonIds = const [],
  }) async {
    _maybeThrow();
    final plan = [monthly, quarterly].firstWhere((p) => p.id == planId);
    final s = start ?? fakeToday;
    final id = 'ms-${_seq++}';
    membershipsByMember
        .putIfAbsent(memberId, () => [])
        .add(
          Membership(
            id: id,
            memberId: memberId,
            planId: plan.id,
            planName: plan.name,
            startDate: s,
            endDate: plan.endFor(s),
            pricePaise: plan.pricePaise,
            joiningFeePaise: plan.joiningFeePaise,
            addonsPaise: addonIds.contains(locker.id) ? locker.pricePaise : 0,
            discountPaise: discountPaise,
            status: statusFor(s, plan.endFor(s)),
          ),
        );
    _log(memberId, 'membership_started', '${plan.name} started');
    _refresh(memberId);
    return id;
  }

  @override
  Future<String> renew({
    required String memberId,
    String? planId,
    int discountPaise = 0,
    String? discountReason,
  }) async {
    _maybeThrow();
    calls.add('renew:$memberId');
    final list = await memberships(memberId);
    if (list.isEmpty) throw const RuleFailure('no membership to renew; start one instead');
    final last = list.first;
    final start = last.endDate!.isBefore(fakeToday) ? fakeToday : last.endDate!.add(const Duration(days: 1));
    final plan = [monthly, quarterly].firstWhere((p) => p.id == (planId ?? last.planId));
    final id = 'ms-${_seq++}';
    membershipsByMember[memberId]!.add(
      Membership(
        id: id,
        memberId: memberId,
        planId: plan.id,
        planName: plan.name,
        startDate: start,
        endDate: plan.endFor(start),
        pricePaise: plan.pricePaise,
        source: 'renewal',
        status: statusFor(start, plan.endFor(start)),
      ),
    );
    _log(memberId, 'renewed', '${plan.name} renewed');
    _refresh(memberId);
    return id;
  }

  @override
  Future<void> freeze({required String membershipId, required DateTime from, required int days, String? reason}) async {
    calls.add('freeze:$membershipId:$days');
    for (final e in membershipsByMember.entries) {
      final i = e.value.indexWhere((m) => m.id == membershipId);
      if (i < 0) continue;
      final m = e.value[i];
      e.value[i] = m.copyWith(
        endDate: m.endDate!.add(Duration(days: days)),
        freezeDaysUsed: m.freezeDaysUsed + days,
        freezes: [
          MembershipFreeze(
            id: 'f-${_seq++}',
            fromDate: from,
            toDate: from.add(Duration(days: days - 1)),
            reason: reason,
          ),
        ],
      );
      _log(e.key, 'frozen', 'Frozen for $days days');
      _refresh(e.key);
      final mi = members.indexWhere((x) => x.id == e.key);
      members[mi] = members[mi].copyWith(status: MemberStatus.frozen);
    }
  }

  @override
  Future<void> unfreeze(String membershipId) async => calls.add('unfreeze:$membershipId');

  @override
  Future<void> cancel({required String membershipId, required String reason, int refundPaise = 0}) async {
    calls.add('cancel:$membershipId:$reason');
    for (final e in membershipsByMember.entries) {
      final i = e.value.indexWhere((m) => m.id == membershipId);
      if (i < 0) continue;
      e.value[i] = e.value[i].copyWith(cancelledReason: reason, status: MemberStatus.cancelled);
      final mi = members.indexWhere((x) => x.id == e.key);
      members[mi] = members[mi].copyWith(status: MemberStatus.cancelled);
    }
  }

  @override
  Future<void> transfer({required String membershipId, required String toMemberId}) async =>
      calls.add('transfer:$membershipId:$toMemberId');

  @override
  Future<List<MemberEvent>> events(String memberId, {int offset = 0}) async => eventsByMember[memberId] ?? [];

  @override
  Future<void> addNote(String memberId, String text) async => _log(memberId, 'note', text);

  @override
  Future<List<Attendance>> attendance(String memberId, {required DateTime from, required DateTime to}) async =>
      checkIns[memberId] ?? [];

  @override
  Future<CheckInResult> checkIn(String memberId) async {
    _maybeThrow();
    final m = await get(memberId);
    final already = (checkIns[memberId] ?? []).any((a) => a.day == fakeToday);
    if (!already) {
      checkIns
          .putIfAbsent(memberId, () => [])
          .add(
            Attendance(
              id: 'a-${_seq++}',
              memberId: memberId,
              day: fakeToday,
              checkedInAt: DateTime.utc(2026, 11, 3, 1, 30),
              method: 'desk',
              memberName: m.name,
            ),
          );
    }
    return CheckInResult(
      memberId: m.id,
      name: m.name,
      memberCode: m.memberCode,
      status: m.status,
      planName: m.planName,
      daysLeft: m.daysLeft(now: DateTime.utc(2026, 11, 3, 5)),
      already: already,
    );
  }

  @override
  Future<CheckInResult> selfCheckIn(String code) async {
    if (code != gymCode) throw const RuleFailure('this code is not valid today');
    return checkIn(members.first.id);
  }

  @override
  Future<String> todaysGymCode() async => gymCode;

  @override
  Future<DashboardCounts> dashboard() async {
    _maybeThrow();
    final live = members.where((m) => !m.isArchived);
    return DashboardCounts(
      active: live.where((m) => m.status.isCurrent).length,
      expiring: live.where((m) => m.status == MemberStatus.expiring).length,
      expired: live.where((m) => m.status == MemberStatus.expired).length,
      total: live.length,
      newThisMonth: 2,
      checkinsToday: checkIns.values.expand((v) => v).length,
    );
  }

  @override
  Future<List<NeedsAction>> needsAction() async => [
    for (final m in members.where((m) => m.status == MemberStatus.expiring))
      NeedsAction(
        memberId: m.id,
        name: m.name,
        phone: m.phone,
        reason: ActionReason.renewalDue,
        detail: _d(m.membershipEnd!),
      ),
    for (final m in members.where((m) => m.status == MemberStatus.expired))
      NeedsAction(
        memberId: m.id,
        name: m.name,
        phone: m.phone,
        reason: ActionReason.expired,
        detail: _d(m.membershipEnd!),
      ),
  ];

  final _checkInsController = StreamController<List<Attendance>>.broadcast();

  @override
  Stream<List<Attendance>> todaysCheckIns() async* {
    yield checkIns.values.expand((v) => v).toList();
    yield* _checkInsController.stream;
  }

  @override
  Future<List<ImportRowResult>> importRows(
    List<Map<String, dynamic>> rows, {
    void Function(int done)? onProgress,
  }) async {
    final out = <ImportRowResult>[];
    for (final r in rows) {
      final row = r['row'] as int;
      if (members.any((m) => m.phone == r['phone'])) {
        out.add(ImportRowResult(row: row, status: 'duplicate', message: 'phone already exists'));
      } else {
        members.add(
          Member(id: 'm-${_seq++}', memberCode: 'ABS-9$_seq', name: r['name'] as String, phone: r['phone'] as String),
        );
        out.add(ImportRowResult(row: row, status: 'imported', memberCode: 'ABS-9$_seq'));
      }
    }
    onProgress?.call(out.length);
    return out;
  }

  @override
  Future<void> uploadPhoto(String memberId, Uint8List jpeg) async {}

  @override
  Future<String?> photoUrl(String? path) async => null;
}

/// A small, varied roster: active, expiring, expired, frozen, no plan.
List<Member> sampleMembers() {
  Member m(
    String id,
    String code,
    String name,
    String phone,
    MemberStatus status, {
    String? plan,
    DateTime? start,
    DateTime? end,
    String? batch,
    String? trainer,
  }) => Member(
    id: id,
    memberCode: code,
    name: name,
    phone: phone,
    status: status,
    planName: plan,
    membershipStart: start,
    membershipEnd: end,
    batch: batch,
    trainerId: trainer,
    joinedOn: DateTime.utc(2026, 1, 10),
  );
  return [
    m(
      'm-1',
      'ABS-0001',
      'Aarav Sharma',
      '+919876500001',
      MemberStatus.active,
      plan: 'Quarterly',
      start: DateTime.utc(2026, 10, 1),
      end: DateTime.utc(2026, 12, 31),
      batch: 'morning',
      trainer: '3',
    ),
    m(
      'm-2',
      'ABS-0002',
      'Priya Verma',
      '+919876500002',
      MemberStatus.expiring,
      plan: 'Monthly',
      start: DateTime.utc(2026, 10, 7),
      end: DateTime.utc(2026, 11, 6),
      batch: 'evening',
    ),
    m(
      'm-3',
      'ABS-0003',
      'Rohit Yadav',
      '+919876500003',
      MemberStatus.expired,
      plan: 'Monthly',
      start: DateTime.utc(2026, 9, 1),
      end: DateTime.utc(2026, 9, 30),
    ),
    m(
      'm-4',
      'ABS-0004',
      'Sneha Kumari',
      '+919876500004',
      MemberStatus.frozen,
      plan: 'Quarterly',
      start: DateTime.utc(2026, 9, 15),
      end: DateTime.utc(2026, 12, 20),
    ),
    m('m-5', 'ABS-0005', 'Zoya Khan', '+919876500005', MemberStatus.inactive),
  ];
}

FakeMembersRepository seededMembers() {
  final repo = FakeMembersRepository();
  // Like the status engine: point members at their current membership.
  repo.members[0] = repo.members[0].copyWith(currentMembershipId: 'ms-1');
  repo.members[1] = repo.members[1].copyWith(currentMembershipId: 'ms-2');
  repo.membershipsByMember['m-1'] = [
    Membership(
      id: 'ms-1',
      memberId: 'm-1',
      planId: quarterly.id,
      planName: 'Quarterly',
      startDate: DateTime.utc(2026, 10, 1),
      endDate: DateTime.utc(2026, 12, 31),
      pricePaise: 400000,
    ),
  ];
  repo.membershipsByMember['m-2'] = [
    Membership(
      id: 'ms-2',
      memberId: 'm-2',
      planId: monthly.id,
      planName: 'Monthly',
      startDate: DateTime.utc(2026, 10, 7),
      endDate: DateTime.utc(2026, 11, 6),
      status: MemberStatus.expiring,
      pricePaise: 150000,
      joiningFeePaise: 50000,
    ),
  ];
  return repo;
}

class FakePlansRepository implements PlansRepository {
  final List<Plan> planList = [monthly, quarterly];
  final List<Addon> addonList = [locker];

  @override
  Future<List<Plan>> plans({bool includeArchived = false}) async =>
      planList.where((p) => includeArchived || !p.isArchived).toList();

  @override
  Future<Map<String, int>> activeCountsByPlan() async => {monthly.id: 12, quarterly.id: 31};

  @override
  Future<void> savePlan(Plan plan, {bool isNew = false}) async {
    if (isNew) {
      planList.add(plan.copyWith(id: 'plan-${planList.length + 1}'));
    } else {
      planList[planList.indexWhere((p) => p.id == plan.id)] = plan;
    }
  }

  @override
  Future<void> setPlanArchived(String id, {required bool archived}) async {
    final i = planList.indexWhere((p) => p.id == id);
    planList[i] = planList[i].copyWith(isArchived: archived);
  }

  @override
  Future<List<Addon>> addons({bool includeArchived = false}) async =>
      addonList.where((a) => includeArchived || !a.isArchived).toList();

  @override
  Future<void> saveAddon(Addon addon, {bool isNew = false}) async {
    if (isNew) {
      addonList.add(addon.copyWith(id: 'addon-${addonList.length + 1}'));
    } else {
      addonList[addonList.indexWhere((a) => a.id == addon.id)] = addon;
    }
  }

  @override
  Future<void> setAddonArchived(String id, {required bool archived}) async {
    final i = addonList.indexWhere((a) => a.id == id);
    addonList[i] = addonList[i].copyWith(isArchived: archived);
  }
}

class FakeGymSettingsRepository implements GymSettingsRepository {
  Map<String, Object?> values = {'gym_name': 'ABS Fitness Zone', 'expiring_window_days': 7, 'absent_days': 7};

  @override
  Future<GymSettings> load() async => GymSettings(values);

  @override
  Future<void> save(Map<String, Object?> changes) async => values = {...values, ...changes};
}
