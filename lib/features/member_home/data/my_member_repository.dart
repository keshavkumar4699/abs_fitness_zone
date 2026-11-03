import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/application/auth_providers.dart';
import '../../members/data/members_repository.dart';
import '../../members/domain/models.dart';

part 'my_member_repository.g.dart';

/// The signed-in member's own record (RLS limits the read to their row).
@riverpod
Future<Member?> myMember(Ref ref) async {
  final memberId = ref.watch(currentUserProvider).value?.memberId;
  if (memberId == null) return null;
  return ref.watch(membersRepositoryProvider).get(memberId);
}
