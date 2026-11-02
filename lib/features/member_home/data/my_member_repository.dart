import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers.dart';
import '../../../core/errors.dart';
import '../../auth/application/auth_providers.dart';

part 'my_member_repository.g.dart';

class MyMember {
  const MyMember({required this.id, required this.name, required this.memberCode, required this.phone});

  factory MyMember.fromJson(Map<String, dynamic> j) => MyMember(
    id: j['id'] as String,
    name: j['name'] as String,
    memberCode: j['member_code'] as String,
    phone: j['phone'] as String,
  );

  final String id;
  final String name;
  final String memberCode;
  final String phone;
}

/// The signed-in member's own record (RLS limits the read to their row).
@riverpod
Future<MyMember?> myMember(Ref ref) async {
  final client = ref.watch(supabaseClientProvider);
  final memberId = ref.watch(currentUserProvider).value?.memberId;
  if (client == null || memberId == null) return null;
  try {
    final row = await client.from('members').select('id, name, member_code, phone').eq('id', memberId).maybeSingle();
    return row == null ? null : MyMember.fromJson(row);
  } on PostgrestException catch (e) {
    throw ServerFailure(e.message);
  }
}
