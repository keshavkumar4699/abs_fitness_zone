import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/utils/phone_input.dart';
import '../../../core/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../../auth/application/auth_providers.dart';
import '../../auth/domain/app_user.dart';
import '../application/team_list_controller.dart';
import '../data/staff_repository.dart';
import 'more_screen.dart' show roleHue, roleLabel;

/// Owner-only staff roster: search, pull-to-refresh, pagination (30 a page),
/// invite, and turning access off/on.
class TeamScreen extends ConsumerStatefulWidget {
  const TeamScreen({super.key});

  @override
  ConsumerState<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends ConsumerState<TeamScreen> {
  final _search = TextEditingController();
  Timer? _debounce;
  String _query = '';
  bool _firstLoad = true;

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _onSearch(String v) {
    _debounce?.cancel();
    _debounce = Timer(AbsMotion.standard.duration, () {
      if (mounted) setState(() => _query = v.trim());
    });
  }

  Future<void> _invite() async {
    final created = await showAbsBottomSheet<(String, String)>(
      context: context,
      expandToFull: true,
      builder: (context, controller) => _InviteSheet(controller),
    );
    if (created == null || !mounted) return;
    ref.invalidate(teamListProvider);
    final (name, password) = created;
    await showDialog<void>(
      context: context,
      builder: (_) => _TempPasswordDialog(name: name, password: password),
    );
  }

  Future<void> _manage(StaffMember staff) async {
    final changed = await showAbsBottomSheet<bool>(
      context: context,
      builder: (context, controller) => _ManageSheet(staff: staff, controller: controller),
    );
    if (changed == true && mounted) ref.invalidate(teamListProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final list = ref.watch(teamListProvider(_query));
    final bottomPad = AbsSpace.x14 * 2 + MediaQuery.paddingOf(context).bottom;
    if (list.hasValue) {
      // Entrance animation only on the very first load, never on refresh.
      WidgetsBinding.instance.addPostFrameCallback((_) => _firstLoad = false);
    }

    final List<Widget> content = switch (list) {
      AsyncData(:final value) when value.items.isNotEmpty => [
        SliverList.builder(
          itemCount: value.items.length,
          itemBuilder: (context, i) => Entrance(
            index: i,
            animate: _firstLoad,
            child: _StaffTile(value.items[i], onTap: () => _manage(value.items[i])),
          ),
        ),
        if (value.loadingMore) const SliverToBoxAdapter(child: SizedBox(height: 80, child: SkeletonList(itemCount: 1))),
        SliverToBoxAdapter(child: SizedBox(height: bottomPad)),
      ],
      AsyncData() => [
        SliverFillRemaining(
          hasScrollBody: false,
          child: EmptyState(
            title: l.staffEmptyTitle,
            message: l.staffEmptyBody,
            actionLabel: l.staffInvite,
            onAction: _invite,
            illustration: EmptyIllustration.people,
            hue: PopHue.sky,
          ),
        ),
      ],
      AsyncError(:final error) => [
        SliverFillRemaining(
          hasScrollBody: false,
          child: ErrorState(message: friendlyError(l, error), onRetry: () => ref.invalidate(teamListProvider(_query))),
        ),
      ],
      // The skeleton is itself a list, so this sliver must allow a scroll body.
      _ => [const SliverFillRemaining(child: SkeletonList(itemCount: 6))],
    };

    return Scaffold(
      // Lift the FAB above the shell's floating tab bar.
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
        child: AbsButton(
          label: l.staffInvite,
          icon: PhosphorIcons.userPlus(PhosphorIconsStyle.bold),
          hue: PopHue.sky,
          expand: false,
          onPressed: _invite,
        ),
      ),
      body: AbsRefresh(
        onRefresh: () => ref.refresh(teamListProvider(_query).future),
        child: NotificationListener<ScrollNotification>(
          onNotification: (n) {
            if (n.metrics.extentAfter < 400) ref.read(teamListProvider(_query).notifier).loadMore();
            return false;
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SearchBarHero(
                title: l.staffTitle,
                hint: l.staffSearchHint,
                controller: _search,
                onChanged: _onSearch,
                leading: Navigator.canPop(context) ? const BackButton() : null,
              ),
              ...content,
            ],
          ),
        ),
      ),
    );
  }
}

class _StaffTile extends StatelessWidget {
  const _StaffTile(this.staff, {required this.onTap});

  final StaffMember staff;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final l = context.l10n;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.screenPadding, vertical: AbsSpace.x3),
        child: Row(
          children: [
            Opacity(
              opacity: staff.isActive ? 1 : AbsOpacity.disabled,
              child: AbsAvatar(name: staff.name),
            ),
            const SizedBox(width: AbsSpace.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(staff.name, style: t.heading, maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(
                    staff.email,
                    style: t.caption.copyWith(color: c.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AbsSpace.x2),
            if (staff.isActive)
              PopSticker(label: roleLabel(l, staff.role), hue: roleHue(staff.role))
            else
              PopSticker(label: l.staffInactive, hue: PopHue.coral),
          ],
        ),
      ),
    );
  }
}

/// Owner: turn a staff member's access off or back on.
class _ManageSheet extends ConsumerStatefulWidget {
  const _ManageSheet({required this.staff, required this.controller});

  final StaffMember staff;
  final ScrollController controller;

  @override
  ConsumerState<_ManageSheet> createState() => _ManageSheetState();
}

class _ManageSheetState extends ConsumerState<_ManageSheet> {
  bool _busy = false;

  Future<void> _toggle() async {
    if (_busy) return;
    final s = widget.staff;
    setState(() => _busy = true);
    try {
      await ref.read(staffRepositoryProvider).setActive(staffId: s.id, active: !s.isActive);
      if (!mounted) return;
      final l = context.l10n;
      showAbsSnackbar(
        context,
        s.isActive ? l.staffDeactivated(s.name) : l.staffReactivated(s.name),
        tone: SnackTone.success,
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(context.l10n, e), tone: SnackTone.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.text;
    final s = widget.staff;
    final me = ref.watch(currentUserProvider).value;
    final isSelf = me?.staffId == s.id;
    final locked = s.role == UserRole.owner;
    return ListView(
      controller: widget.controller,
      padding: EdgeInsets.symmetric(horizontal: context.screenPadding),
      children: [
        Row(
          children: [
            AbsAvatar(name: s.name, size: AbsSpace.x14),
            const SizedBox(width: AbsSpace.x4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.name, style: t.title),
                  Text(s.email, style: t.caption.copyWith(color: context.colors.textSecondary)),
                ],
              ),
            ),
            PopSticker(label: isSelf ? l.staffYou : roleLabel(l, s.role), hue: roleHue(s.role)),
          ],
        ),
        const SizedBox(height: AbsSpace.x6),
        if (locked || isSelf)
          Text(l.staffOwnerLocked, style: t.body.copyWith(color: context.colors.textSecondary))
        else if (s.isActive)
          AbsButton.destructive(
            label: l.staffDeactivate,
            icon: PhosphorIcons.prohibit(PhosphorIconsStyle.bold),
            isLoading: _busy,
            onPressed: _toggle,
          )
        else
          AbsButton(
            label: l.staffReactivate,
            hue: PopHue.mint,
            icon: PhosphorIcons.checkCircle(PhosphorIconsStyle.bold),
            isLoading: _busy,
            onPressed: _toggle,
          ),
      ],
    );
  }
}

class _InviteSheet extends ConsumerStatefulWidget {
  const _InviteSheet(this.controller);

  final ScrollController controller;

  @override
  ConsumerState<_InviteSheet> createState() => _InviteSheetState();
}

class _InviteSheetState extends ConsumerState<_InviteSheet> {
  static const _roles = [UserRole.frontDesk, UserRole.trainer];
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  int _role = 0;
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy || !_form.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      final password = await ref
          .read(staffRepositoryProvider)
          .invite(
            name: _name.text,
            email: _email.text,
            phone: _phone.text.isEmpty ? null : '+91${_phone.text}',
            role: _roles[_role],
          );
      if (mounted) Navigator.pop(context, (_name.text.trim(), password));
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(context.l10n, e), tone: SnackTone.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final v = Validators(l);
    return Form(
      key: _form,
      child: ListView(
        controller: widget.controller,
        padding: EdgeInsets.symmetric(horizontal: context.screenPadding),
        children: [
          Text(l.staffInviteTitle, style: context.text.title),
          const SizedBox(height: AbsSpace.x5),
          AbsTextField(
            label: l.fieldName,
            controller: _name,
            validator: v.required,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AbsSpace.x4),
          AbsTextField(
            label: l.fieldEmail,
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            validator: v.email,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AbsSpace.x4),
          AbsTextField(
            label: l.fieldPhone,
            controller: _phone,
            prefixText: '+91',
            numeric: true,
            keyboardType: TextInputType.phone,
            inputFormatters: const [IndianMobileInputFormatter()],
            validator: (value) => (value == null || value.isEmpty) ? null : v.phone(value),
          ),
          const SizedBox(height: AbsSpace.x5),
          Text(l.fieldRole, style: context.text.label.copyWith(color: context.colors.textSecondary)),
          const SizedBox(height: AbsSpace.x2),
          SegmentedTabs(
            hue: PopHue.sky,
            labels: [for (final r in _roles) roleLabel(l, r)],
            selected: _role,
            onChanged: (i) => setState(() => _role = i),
          ),
          const SizedBox(height: AbsSpace.x6),
          AbsButton(label: l.staffInviteAction, hue: PopHue.sky, isLoading: _busy, onPressed: _submit),
          const SizedBox(height: AbsSpace.x6),
        ],
      ),
    );
  }
}

class _TempPasswordDialog extends StatelessWidget {
  const _TempPasswordDialog({required this.name, required this.password});

  final String name;
  final String password;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.text;
    final c = context.colors;
    return Stack(
      children: [
        AlertDialog(
          title: Text(l.staffTempPasswordTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.staffTempPasswordBody(name)),
              const SizedBox(height: AbsSpace.x4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AbsSpace.x4, vertical: AbsSpace.x2),
                decoration: stickerDecoration(
                  c,
                  color: c.pop(PopHue.lime).fill,
                  lipDepth: 3,
                  borderRadius: AbsRadius.buttonAll,
                ),
                child: SelectableText(password, style: t.numericOf(t.title).copyWith(color: c.pop(PopHue.lime).onFill)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: password));
                if (context.mounted) showAbsSnackbar(context, l.commonCopied, tone: SnackTone.success);
              },
              child: Text(l.commonCopy),
            ),
            TextButton(onPressed: () => Navigator.pop(context), child: Text(l.commonDone)),
          ],
        ),
        const Positioned.fill(child: ConfettiBurst()),
      ],
    );
  }
}
