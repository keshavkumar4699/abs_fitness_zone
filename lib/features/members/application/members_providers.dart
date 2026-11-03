import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/providers.dart';
import '../../../core/paging.dart';
import '../../../core/utils/dates.dart';
import '../../settings/data/staff_repository.dart';
import '../data/members_repository.dart';
import '../data/plans_repository.dart';
import '../domain/models.dart';

part 'members_providers.g.dart';

/// Paged, searchable, filterable members list (1.13).
@riverpod
class MemberList extends _$MemberList {
  @override
  Future<Paged<Member>> build(MemberQuery query) => ref.watch(membersRepositoryProvider).list(offset: 0, query: query);

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;
    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      final next = await ref.read(membersRepositoryProvider).list(offset: current.items.length, query: query);
      state = AsyncData(Paged([...current.items, ...next.items], hasMore: next.hasMore));
    } catch (_) {
      state = AsyncData(current.copyWith(loadingMore: false));
    }
  }
}

@riverpod
Future<Member> member(Ref ref, String id) => ref.watch(membersRepositoryProvider).get(id);

@riverpod
Future<List<Membership>> memberMemberships(Ref ref, String id) => ref.watch(membersRepositoryProvider).memberships(id);

@riverpod
Future<MemberHealth?> memberHealth(Ref ref, String id) => ref.watch(membersRepositoryProvider).health(id);

@riverpod
Future<List<Measurement>> memberMeasurements(Ref ref, String id) =>
    ref.watch(membersRepositoryProvider).measurements(id);

@riverpod
Future<List<MemberEvent>> memberEvents(Ref ref, String id) => ref.watch(membersRepositoryProvider).events(id);

/// Check-ins for the 12 weeks up to today.
@riverpod
Future<List<Attendance>> memberAttendance(Ref ref, String id) {
  final today = IstDates.today();
  return ref.watch(membersRepositoryProvider).attendance(id, from: today.subtract(const Duration(days: 83)), to: today);
}

@riverpod
Future<List<Plan>> plans(Ref ref) => ref.watch(plansRepositoryProvider).plans();

@riverpod
Future<List<Plan>> allPlans(Ref ref) => ref.watch(plansRepositoryProvider).plans(includeArchived: true);

@riverpod
Future<Map<String, int>> planCounts(Ref ref) => ref.watch(plansRepositoryProvider).activeCountsByPlan();

@riverpod
Future<List<Addon>> addons(Ref ref) => ref.watch(plansRepositoryProvider).addons();

@riverpod
Future<List<Addon>> allAddons(Ref ref) => ref.watch(plansRepositoryProvider).addons(includeArchived: true);

@riverpod
Future<List<StaffMember>> trainers(Ref ref) => ref.watch(staffRepositoryProvider).trainers();

@riverpod
Future<DashboardCounts> dashboard(Ref ref) => ref.watch(membersRepositoryProvider).dashboard();

@riverpod
Future<List<NeedsAction>> needsAction(Ref ref) => ref.watch(membersRepositoryProvider).needsAction();

@riverpod
Stream<List<Attendance>> todaysCheckIns(Ref ref) => ref.watch(membersRepositoryProvider).todaysCheckIns();

/// Short-lived signed URL for a private member photo.
@riverpod
Future<String?> photoUrl(Ref ref, String? path) => ref.watch(membersRepositoryProvider).photoUrl(path);

/// Refresh everything that depends on one member after a change.
extension MemberRefresh on WidgetRef {
  void refreshMember(String id) {
    invalidate(memberProvider(id));
    invalidate(memberMembershipsProvider(id));
    invalidate(memberEventsProvider(id));
    invalidate(memberAttendanceProvider(id));
    invalidate(memberListProvider);
    invalidate(dashboardProvider);
    invalidate(needsActionProvider);
  }
}

/// Filters saved on this device (1.13 "saved filters").
@Riverpod(keepAlive: true)
class SavedFilters extends _$SavedFilters {
  static const _key = 'saved_member_filters';

  @override
  Map<String, MemberQuery> build() {
    final raw = ref.watch(sharedPreferencesProvider).getString(_key);
    if (raw == null) return {};
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return {for (final e in map.entries) e.key: MemberQuery.fromJson(e.value as Map<String, dynamic>)};
    } catch (_) {
      return {};
    }
  }

  Future<void> _persist() => ref
      .read(sharedPreferencesProvider)
      .setString(_key, jsonEncode({for (final e in state.entries) e.key: e.value.toJson()}));

  Future<void> save(String name, MemberQuery query) async {
    state = {...state, name.trim(): query.copyWith(search: '')};
    await _persist();
  }

  Future<void> remove(String name) async {
    state = {...state}..remove(name);
    await _persist();
  }
}
