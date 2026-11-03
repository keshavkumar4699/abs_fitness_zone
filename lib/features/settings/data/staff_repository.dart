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

  /// Creates the staff record and login (owner only, enforced server-side).
  /// Returns the one-time temporary password.
  Future<String> invite({required String name, required String email, String? phone, required UserRole role});

  /// Turns a staff member's access off or back on (owner only, via RLS).
  Future<void> setActive({required String staffId, required bool active});
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
  Future<String> invite({required String name, required String email, String? phone, required UserRole role}) async {
    try {
      final res = await _client.functions.invoke(
        'invite-staff',
        body: {'name': name.trim(), 'email': email.trim().toLowerCase(), 'phone': phone, 'role': role.wire},
      );
      return (res.data as Map<String, dynamic>)['temp_password'] as String;
    } on FunctionException catch (e) {
      throw switch (e.status) {
        409 => const StaffEmailTakenFailure(),
        403 => const NotAllowedFailure(),
        _ => ServerFailure('invite-staff ${e.status}'),
      };
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
