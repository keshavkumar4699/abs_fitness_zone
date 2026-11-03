import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/routes.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/services/contact_links.dart';
import '../../../core/widgets/widgets.dart';
import '../../auth/application/auth_providers.dart';
import '../../settings/data/gym_settings_repository.dart';
import '../application/member_csv.dart';
import '../application/members_providers.dart';
import '../data/members_repository.dart';
import '../domain/models.dart';
import 'member_filters_sheet.dart';
import 'member_ui.dart';
import 'widgets/member_photo.dart';

/// Members list (1.13, 1.14): search, quick status chips, full filters, saved
/// filters, sort, paging, pull-to-refresh, multi-select bulk actions.
class MembersScreen extends ConsumerStatefulWidget {
  const MembersScreen({super.key, this.initialStatus, this.initialSort});

  /// From the dashboard tiles: `?status=expiring`, `?sort=joined`.
  final String? initialStatus;
  final String? initialSort;

  @override
  ConsumerState<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends ConsumerState<MembersScreen> {
  final _search = TextEditingController();
  Timer? _debounce;
  MemberQuery _query = const MemberQuery();
  final Set<String> _selected = {};
  bool _firstLoad = true;

  bool get _selecting => _selected.isNotEmpty;

  MemberQuery _fromParams(MemberQuery base) {
    final status = widget.initialStatus;
    final sort = MemberSort.values.where((s) => s.name == widget.initialSort).firstOrNull;
    return base.copyWith(
      statuses: status == null
          ? base.statuses
          : status == 'active'
          ? const ['active', 'expiring']
          : [status],
      sort: sort ?? base.sort,
    );
  }

  @override
  void initState() {
    super.initState();
    _query = _fromParams(_query);
  }

  @override
  void didUpdateWidget(MembersScreen old) {
    super.didUpdateWidget(old);
    if (old.initialStatus != widget.initialStatus || old.initialSort != widget.initialSort) {
      setState(() => _query = _fromParams(const MemberQuery()));
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _onSearch(String v) {
    _debounce?.cancel();
    _debounce = Timer(AbsMotion.standard.duration, () {
      if (mounted) setState(() => _query = _query.copyWith(search: v.trim()));
    });
  }

  void _setQuery(MemberQuery q) => setState(() {
    _query = q.copyWith(search: _query.search);
    _selected.clear();
  });

  Future<void> _openFilters() async {
    final q = await showMemberFilters(context, _query);
    if (q != null) _setQuery(q);
  }

  void _toggle(String id) => setState(() => _selected.contains(id) ? _selected.remove(id) : _selected.add(id));

  Future<void> _export({List<Member>? only}) async {
    final l = context.l10n;
    try {
      final members = only ?? await ref.read(membersRepositoryProvider).listAll(_query);
      final csv = membersToCsv(members);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile.fromData(utf8.encode(csv), mimeType: 'text/csv', name: 'abs-members.csv')],
          fileNameOverrides: const ['abs-members.csv'],
        ),
      );
      if (mounted) showAbsSnackbar(context, l.exportReady(members.length), tone: SnackTone.success);
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    }
  }

  Future<void> _assignTrainer() async {
    final l = context.l10n;
    final trainers = await ref.read(trainersProvider.future).catchError((_) => <Never>[]);
    if (!mounted) return;
    final picked = await showAbsBottomSheet<(String?,)>(
      context: context,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: EdgeInsets.symmetric(horizontal: context.screenPadding),
        children: [
          Text(l.bulkAssignTrainer, style: context.text.title),
          const SizedBox(height: AbsSpace.x4),
          for (final t in trainers)
            ListTile(
              leading: AbsAvatar(name: t.name, size: 36),
              title: Text(t.name),
              onTap: () => Navigator.pop(context, (t.id,)),
            ),
          ListTile(
            leading: Icon(PhosphorIcons.userMinus(PhosphorIconsStyle.bold)),
            title: Text(l.bulkNoTrainer),
            onTap: () => Navigator.pop(context, (null,)),
          ),
        ],
      ),
    );
    if (picked == null || !mounted) return;
    try {
      final ids = _selected.toList();
      await ref.read(membersRepositoryProvider).assignTrainer(ids, picked.$1);
      ref.invalidate(memberListProvider);
      if (!mounted) return;
      showAbsSnackbar(context, l.bulkTrainerAssigned(ids.length), tone: SnackTone.success);
      setState(_selected.clear);
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final user = ref.watch(currentUserProvider).value;
    final isDesk = user?.role.isDesk ?? false;
    final list = ref.watch(memberListProvider(_query));
    final gym = ref.watch(publicGymProfileProvider).value?['gym_name'] as String? ?? l.gymName;
    final saved = ref.watch(savedFiltersProvider);
    final bottomPad = AbsSpace.x14 * 2 + MediaQuery.paddingOf(context).bottom;
    if (list.hasValue) WidgetsBinding.instance.addPostFrameCallback((_) => _firstLoad = false);

    final statusChips = <(String?, String)>[
      (null, l.filterAny),
      ('active', l.statusActive),
      ('expiring', l.statusExpiring(7).split('·').first.trim()),
      ('expired', l.statusExpired),
      ('frozen', l.statusFrozen),
      ('inactive', l.statusInactive),
    ];

    final List<Widget> content = switch (list) {
      AsyncData(:final value) when value.items.isNotEmpty => [
        SliverList.builder(
          itemCount: value.items.length,
          itemBuilder: (context, i) {
            final m = value.items[i];
            final days = m.daysLeft();
            return Entrance(
              index: i,
              animate: _firstLoad,
              child: MemberTile(
                key: ValueKey(m.id),
                name: m.name,
                plan: [m.memberCode, m.planName ?? l.noPlan].join(' · '),
                status: pillFor(m.status),
                daysLeft: m.status.isCurrent ? days : null,
                avatar: MemberPhoto(
                  name: m.name,
                  path: m.photoPath,
                  ringColor: StatusPill.colorFor(c, pillFor(m.status)),
                ),
                heroTag: 'member-${m.id}',
                selected: _selected.contains(m.id),
                trailing: _selecting
                    ? Padding(
                        padding: const EdgeInsets.only(left: AbsSpace.x2),
                        child: Icon(
                          _selected.contains(m.id)
                              ? PhosphorIcons.checkCircle(PhosphorIconsStyle.fill)
                              : PhosphorIcons.circle(PhosphorIconsStyle.bold),
                          color: _selected.contains(m.id) ? c.pop(PopHue.grape).text : c.textSecondary,
                        ),
                      )
                    : null,
                onTap: _selecting ? () => _toggle(m.id) : () => context.push(Routes.memberDetail(m.id)),
                onLongPress: isDesk ? () => _toggle(m.id) : null,
                onRemind: _selecting ? null : () => ContactLinks.openWhatsApp(m.phone, text: reminderText(l, m, gym)),
              ),
            );
          },
        ),
        if (value.loadingMore) const SliverToBoxAdapter(child: SizedBox(height: 80, child: SkeletonList(itemCount: 1))),
        SliverToBoxAdapter(child: SizedBox(height: bottomPad)),
      ],
      AsyncData() when _query.search.isNotEmpty || _query.activeFilters > 0 => [
        SliverFillRemaining(
          hasScrollBody: false,
          child: EmptyState(
            title: l.membersNoMatchTitle,
            message: l.membersNoMatchBody,
            actionLabel: l.membersClearFilters,
            onAction: () {
              _search.clear();
              setState(() => _query = const MemberQuery());
            },
            illustration: EmptyIllustration.search,
            hue: PopHue.sky,
          ),
        ),
      ],
      AsyncData() => [
        SliverFillRemaining(
          hasScrollBody: false,
          child: EmptyState(
            title: l.membersEmptyTitle,
            message: l.membersEmptyBody,
            actionLabel: isDesk ? l.membersAdd : null,
            onAction: isDesk ? () => context.push(Routes.memberNew) : null,
            illustration: EmptyIllustration.people,
            hue: PopHue.sky,
          ),
        ),
      ],
      AsyncError(:final error) => [
        SliverFillRemaining(
          hasScrollBody: false,
          child: ErrorState(
            message: friendlyError(l, error),
            onRetry: () => ref.invalidate(memberListProvider(_query)),
          ),
        ),
      ],
      _ => [const SliverFillRemaining(child: SkeletonList(itemCount: 8))],
    };

    return Scaffold(
      floatingActionButton: _selecting || !isDesk
          ? null
          : Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
              child: QuickActionFab(
                actions: [
                  QuickAction(
                    icon: PhosphorIcons.userPlus(PhosphorIconsStyle.bold),
                    label: l.membersAdd,
                    hue: PopHue.sky,
                    onTap: () => context.push(Routes.memberNew),
                  ),
                  QuickAction(
                    icon: PhosphorIcons.qrCode(PhosphorIconsStyle.bold),
                    label: l.checkInTitle,
                    hue: PopHue.mint,
                    onTap: () => context.push(Routes.checkIn),
                  ),
                  QuickAction(
                    icon: PhosphorIcons.fileArrowUp(PhosphorIconsStyle.bold),
                    label: l.membersImport,
                    hue: PopHue.tangerine,
                    onTap: () => context.push(Routes.memberImport),
                  ),
                  QuickAction(
                    icon: PhosphorIcons.export(PhosphorIconsStyle.bold),
                    label: l.membersExport,
                    hue: PopHue.grape,
                    onTap: _export,
                  ),
                ],
              ),
            ),
      bottomNavigationBar: _selecting
          ? SafeArea(
              child: Container(
                margin: const EdgeInsets.fromLTRB(AbsSpace.x3, 0, AbsSpace.x3, AbsSpace.x2),
                padding: const EdgeInsets.symmetric(horizontal: AbsSpace.x3, vertical: AbsSpace.x2),
                decoration: stickerDecoration(c, color: c.pop(PopHue.grape).fill, borderRadius: AbsRadius.cardAll),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: l.commonClose,
                      icon: Icon(PhosphorIcons.x(PhosphorIconsStyle.bold), color: c.pop(PopHue.grape).onFill),
                      onPressed: () => setState(_selected.clear),
                    ),
                    Expanded(
                      child: Text(
                        l.membersSelected(_selected.length),
                        style: context.text.heading.copyWith(color: c.pop(PopHue.grape).onFill),
                      ),
                    ),
                    TextButton(
                      onPressed: _assignTrainer,
                      child: Text(l.bulkAssignTrainer, style: TextStyle(color: c.pop(PopHue.grape).onFill)),
                    ),
                    TextButton(
                      onPressed: () {
                        final rows = list.value?.items.where((m) => _selected.contains(m.id)).toList() ?? [];
                        _export(only: rows);
                      },
                      child: Text(l.bulkExport, style: TextStyle(color: c.pop(PopHue.grape).onFill)),
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: AbsRefresh(
        onRefresh: () => ref.refresh(memberListProvider(_query).future),
        child: NotificationListener<ScrollNotification>(
          onNotification: (n) {
            if (n.metrics.extentAfter < 600) ref.read(memberListProvider(_query).notifier).loadMore();
            return false;
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SearchBarHero(
                title: l.membersTitle,
                hint: l.membersSearchHint,
                controller: _search,
                onChanged: _onSearch,
                actions: [
                  Badge(
                    isLabelVisible: _query.activeFilters > 0,
                    label: Text('${_query.activeFilters}'),
                    backgroundColor: c.pop(PopHue.bubblegum).fill,
                    textColor: c.pop(PopHue.bubblegum).onFill,
                    child: IconButton(
                      tooltip: l.membersFilters,
                      icon: Icon(PhosphorIcons.slidersHorizontal(PhosphorIconsStyle.bold)),
                      onPressed: _openFilters,
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 52,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: context.screenPadding, vertical: AbsSpace.x1),
                    children: [
                      for (final (value, label) in statusChips)
                        Padding(
                          padding: const EdgeInsets.only(right: AbsSpace.x2),
                          child: PopChip(
                            label: label,
                            hue: PopHue.sky,
                            selected: value == null
                                ? _query.statuses.isEmpty
                                : _query.statuses.length == 1 && _query.statuses.first == value,
                            onTap: () => _setQuery(_query.copyWith(statuses: value == null ? const [] : [value])),
                          ),
                        ),
                      for (final name in saved.keys)
                        Padding(
                          padding: const EdgeInsets.only(right: AbsSpace.x2),
                          child: PopChip(
                            label: name,
                            hue: PopHue.bubblegum,
                            icon: PhosphorIcons.bookmarkSimple(PhosphorIconsStyle.bold),
                            selected: false,
                            onTap: () => _setQuery(saved[name]!),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              ...content,
            ],
          ),
        ),
      ),
    );
  }
}
