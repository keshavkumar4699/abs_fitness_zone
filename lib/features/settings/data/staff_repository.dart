import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers.dart';
import '../../../core/errors.dart';
import '../../../core/paging.dart';
import '../../auth/domain/app_user.dart';

part 'staff_repository.g.dart';

class StaffMember {
  const StaffMember({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isActive,
    this.phone,
  });

  factory StaffMember.fromJson(Map<String, dynamic> j) => StaffMember(
    id: j['id'] as String,
    name: j['name'] as String,
    email: j['email'] as String,
    phone: j['phone'] as String?,
    role: UserRole.fromWire(j['role'] as String),
    isActive: j['is_active'] as bool,
  );

  final String id;
  final String name;
  final String email;
  final String? phone;
  final UserRole role;
  final bool isActive;
}

abstract interface class StaffRepository {
  Future<Paged<StaffMember>> list({required int offset, String query = ''});

  /// Adds a staff record (owner only, enforced server-side). The person signs
  /// in with Google using this email; there is no password.
  Future<void> invite({required String name, required String email, String? phone, required UserRole role});

  /// Turns a staff member's access off or back on (owner only, via RLS).
  Future<void> setActive({required String staffId, required bool active});

  /// Active trainers, for assigning members.
  Future<List<StaffMember>> trainers();
}

class SupabaseStaffRepository implements StaffRepository {
  SupabaseStaffRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<Paged<StaffMember>> list({required int offset, String query = ''}) async {
    try {
      var q = _client.from('staff').select('id, name, email, phone, role, is_active').isFilter('archived_at', null);
      final s = sanitizeSearch(query);
      if (s.isNotEmpty) q = q.or('name.ilike.*$s*,email.ilike.*$s*');
      final rows = await q.order('name').range(offset, offset + kPageSize - 1);
      final items = rows.map(StaffMember.fromJson).toList();
      return Paged(items, hasMore: items.length == kPageSize);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<void> invite({required String name, required String email, String? phone, required UserRole role}) async {
    try {
      await _client.rpc<String>(
        'add_staff',
        params: {'p_name': name.trim(), 'p_email': email.trim().toLowerCase(), 'p_phone': phone, 'p_role': role.wire},
      );
    } on PostgrestException catch (e) {
      throw switch (e.code) {
        '23505' => const StaffEmailTakenFailure(),
        '42501' => const NotAllowedFailure(),
        '22023' => RuleFailure(e.message),
        _ => ServerFailure(e.message),
      };
    }
  }

  @override
  Future<List<StaffMember>> trainers() async {
    try {
      final rows = await _client
          .from('staff')
          .select('id, name, email, phone, role, is_active')
          .eq('role', 'trainer')
          .eq('is_active', true)
          .isFilter('archived_at', null)
          .order('name');
      return rows.map(StaffMember.fromJson).toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<void> setActive({required String staffId, required bool active}) async {
    try {
      final rows = await _client.from('staff').update({'is_active': active}).eq('id', staffId).select('id');
      if (rows.isEmpty) throw const NotAllowedFailure();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}

@Riverpod(keepAlive: true)
StaffRepository staffRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  if (client == null) throw const NotConfiguredFailure();
  return SupabaseStaffRepository(client);
}
