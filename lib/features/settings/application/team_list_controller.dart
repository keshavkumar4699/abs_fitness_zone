import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/paging.dart';
import '../data/staff_repository.dart';

part 'team_list_controller.g.dart';

/// Paged, searchable staff roster.
@riverpod
class TeamList extends _$TeamList {
  @override
  Future<Paged<StaffMember>> build(String query) => ref.watch(staffRepositoryProvider).list(offset: 0, query: query);

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;
    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      final next = await ref.read(staffRepositoryProvider).list(offset: current.items.length, query: query);
      state = AsyncData(Paged([...current.items, ...next.items], hasMore: next.hasMore));
    } catch (_) {
      // Keep what we have; the user can scroll again to retry.
      state = AsyncData(current.copyWith(loadingMore: false));
    }
  }
}
