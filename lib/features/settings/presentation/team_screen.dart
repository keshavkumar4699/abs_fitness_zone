import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/paging.dart';
import '../../../core/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../../auth/domain/app_user.dart';
import '../application/team_list_controller.dart';
import '../data/staff_repository.dart';
import 'more_screen.dart' show roleLabel;

/// Owner-only staff roster with search, pull-to-refresh, pagination and invite.
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
    _debounce = Timer(AbsMotion.standard.duration, () => setState(() => _query = v.trim()));
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

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final list = ref.watch(teamListProvider(_query));
    if (list.hasValue) _firstLoad = false;

    return Scaffold(
      // Lift the FAB above the shell's glass bottom bar.
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
        child: FloatingActionButton.extended(
          onPressed: _invite,
          backgroundColor: context.colors.accent,
          foregroundColor: context.colors.onAccent,
          icon: Icon(PhosphorIcons.userPlus()),
          label: Text(l.staffInvite),
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
              SliverFillRemaining(
                hasScrollBody: true,
                child: AsyncView<Paged<StaffMember>>(
                  value: list,
                  onRetry: () => ref.invalidate(teamListProvider(_query)),
                  isEmpty: (p) => p.isEmpty,
                  empty: EmptyState(
                    title: l.staffEmptyTitle,
                    message: l.staffEmptyBody,
                    actionLabel: l.staffInvite,
                    onAction: _invite,
                    illustration: EmptyIllustration.people,
                  ),
                  data: (page) => ListView.builder(
                    padding: EdgeInsets.only(
                      bottom: AbsSpace.x14 + AbsSpace.x10 + MediaQuery.paddingOf(context).bottom,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: page.items.length + (page.loadingMore ? 1 : 0),
                    itemBuilder: (context, i) {
                      if (i >= page.items.length) {
                        return const SizedBox(height: 72, child: SkeletonList(itemCount: 1));
                      }
                      return Entrance(index: i, animate: _firstLoad, child: _StaffTile(page.items[i]));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StaffTile extends StatelessWidget {
  const _StaffTile(this.staff);

  final StaffMember staff;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final l = context.l10n;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.screenPadding, vertical: AbsSpace.x3),
      child: Row(
        children: [
          AbsAvatar(name: staff.name, ringColor: staff.isActive ? c.success : c.border),
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
          InfoPill(
            label: staff.isActive ? roleLabel(l, staff.role) : l.staffInactive,
            color: staff.isActive ? c.accentText : c.textSecondary,
          ),
        ],
      ),
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
    if (!_form.currentState!.validate()) return;
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
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
            validator: (value) => (value == null || value.isEmpty) ? null : v.phone(value),
          ),
          const SizedBox(height: AbsSpace.x5),
          Text(l.fieldRole, style: context.text.label.copyWith(color: context.colors.textSecondary)),
          const SizedBox(height: AbsSpace.x2),
          SegmentedTabs(
            labels: [for (final r in _roles) roleLabel(l, r)],
            selected: _role,
            onChanged: (i) => setState(() => _role = i),
          ),
          const SizedBox(height: AbsSpace.x6),
          AbsButton(label: l.staffInviteAction, isLoading: _busy, onPressed: _submit),
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
    return AlertDialog(
      title: Text(l.staffTempPasswordTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.staffTempPasswordBody(name)),
          const SizedBox(height: AbsSpace.x4),
          SelectableText(password, style: t.numericOf(t.title).copyWith(color: context.colors.accentText)),
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
    );
  }
}
