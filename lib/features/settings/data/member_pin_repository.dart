import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers.dart';
import '../../../core/errors.dart';
import '../../../core/utils/phone.dart';

part 'member_pin_repository.g.dart';

class MemberLookup {
  const MemberLookup({required this.id, required this.name, required this.memberCode});

  final String id;
  final String name;
  final String memberCode;
}

abstract interface class MemberPinRepository {
  Future<MemberLookup> findByPhone(String phone);

  /// Hashes and stores the PIN and makes sure the member has an app login.
  Future<void> setPin({required String memberId, required String pin});
}

class SupabaseMemberPinRepository implements MemberPinRepository {
  SupabaseMemberPinRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<MemberLookup> findByPhone(String phone) async {
    final normalized = Phone.normalize(phone);
    if (normalized == null) throw const NotFoundFailure();
    try {
      final row = await _client
          .from('members')
          .select('id, name, member_code')
          .eq('phone', normalized)
          .isFilter('archived_at', null)
          .maybeSingle();
      if (row == null) throw const NotFoundFailure();
      return MemberLookup(
        id: row['id'] as String,
        name: row['name'] as String,
        memberCode: row['member_code'] as String,
      );
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<void> setPin({required String memberId, required String pin}) async {
    try {
      await _client.functions.invoke('set-member-pin', body: {'member_id': memberId, 'pin': pin});
    } on FunctionException catch (e) {
      throw ServerFailure('set-member-pin ${e.status}');
    }
  }
}

@Riverpod(keepAlive: true)
MemberPinRepository memberPinRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  if (client == null) throw const NotConfiguredFailure();
  return SupabaseMemberPinRepository(client);
}
