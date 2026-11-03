import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/routes.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/services/contact_links.dart';
import '../../../core/utils/dates.dart';
import '../../../core/utils/money.dart';
import '../../../core/utils/phone.dart';
import '../../../core/widgets/widgets.dart';
import '../../auth/application/auth_providers.dart';
import '../../auth/domain/app_user.dart';
import '../../payments/application/payments_providers.dart';
import '../../payments/domain/payment_models.dart';
import '../../payments/presentation/collect_sheet.dart';
import '../../payments/presentation/payment_ui.dart';
import '../../settings/data/gym_settings_repository.dart';
import '../../workouts/presentation/member_workouts_tab.dart';
import '../application/members_providers.dart';
import '../data/members_repository.dart';
import '../domain/models.dart';
import 'member_form.dart' show parqKeys, parqQuestion;
import 'member_ui.dart';
import 'membership_sheets.dart';
import 'widgets/member_photo.dart';

/// What the signed-in staff member may do with this member.
class _Perms {
  _Perms(AppUser? u, Member m)
    : desk = u?.role.isDesk ?? false,
      owner = u?.role.isOwner ?? false,
      ownTrainer = u?.role == UserRole.trainer && m.trainerId != null && m.trainerId == u?.staffId;

  final bool desk;
  final bool owner;
  final bool ownTrainer;

  bool get health => owner || ownTrainer;
  bool get attendance => desk || ownTrainer;
  bool get notes => desk || ownTrainer;
}

/// Member detail: header with status + days-left ring, eight tabs and a
/// sticky bottom bar (Collect, Renew, WhatsApp, Call).
class MemberDetailScreen extends ConsumerStatefulWidget {
  const MemberDetailScreen({super.key, required this.memberId, this.openCollect = false, this.initialTab});

  final String memberId;

  /// Opens the collect sheet once the member loads (after adding a member).
  final bool openCollect;

  /// Opens on this tab ('workouts', 'payments', …).
  final String? initialTab;

  @override
  ConsumerState<MemberDetailScreen> createState() => _MemberDetailScreenState();
}

class _MemberDetailScreenState extends ConsumerState<MemberDetailScreen> {
  bool _collectOpened = false;

  String get memberId => widget.memberId;

  @override
  Widget build(BuildContext context) {
    final member = ref.watch(memberProvider(memberId));
    if (widget.openCollect && !_collectOpened && member.hasValue) {
      _collectOpened = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) showCollectSheet(context, member: CollectTarget.of(member.value!));
      });
    }
    return Scaffold(
      body: AsyncView<Member>(
        value: member,
        isEmpty: (_) => false,
        empty: const SizedBox.shrink(),
        onRetry: () => ref.invalidate(memberProvider(memberId)),
        loading: const SafeArea(child: SkeletonList(itemCount: 6)),
        data: (m) => _Detail(member: m, initialTab: widget.initialTab),
      ),
    );
  }
}

class _Detail extends ConsumerWidget {
  const _Detail({required this.member, this.initialTab});

  final Member member;
  final String? initialTab;

  Future<void> _menu(BuildContext context, WidgetRef ref, String action) async {
    final l = context.l10n;
    final repo = ref.read(membersRepositoryProvider);
    try {
      switch (action) {
        case 'edit':
          await context.push(Routes.memberEdit(member.id));
          ref.refreshMember(member.id);
        case 'archive':
          await repo.setArchived(member.id, archived: !member.isArchived);
          ref.refreshMember(member.id);
          if (context.mounted) {
            showAbsSnackbar(context, member.isArchived ? l.restoredDone : l.archivedDone, tone: SnackTone.success);
          }
        case 'delete':
          final ok = await showDialog<bool>(
            context: context,
            builder: (_) => _DeleteDialog(name: member.name),
          );
          if (ok != true) return;
          await repo.deleteForever(member.id);
          ref.invalidate(memberListProvider);
          if (!context.mounted) return;
          showAbsSnackbar(context, l.deleted, tone: SnackTone.success);
          context.pop();
      }
    } catch (e) {
      if (context.mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final perms = _Perms(ref.watch(currentUserProvider).value, member);
    final gym = ref.watch(publicGymProfileProvider).value?['gym_name'] as String? ?? l.gymName;
    final days = member.daysLeft();
    final hue = hueForStatus(member.status);
    final tabs = [
      l.tabOverview,
      l.tabMembership,
      if (perms.desk) l.tabPayments,
      l.tabWorkouts,
      l.tabDiet,
      l.tabProgress,
      l.tabAttendance,
      l.tabNotes,
    ];

    final start = switch (initialTab) {
      'workouts' => tabs.indexOf(l.tabWorkouts),
      'payments' => tabs.indexOf(l.tabPayments),
      'progress' => tabs.indexOf(l.tabProgress),
      _ => 0,
    };
    return DefaultTabController(
      length: tabs.length,
      initialIndex: start < 0 ? 0 : start,
      child: Scaffold(
        appBar: AppBar(
          title: Text(member.memberCode, style: t.numericOf(t.heading)),
          actions: [
            if (perms.desk)
              PopupMenuButton<String>(
                tooltip: l.actionMore,
                onSelected: (a) => _menu(context, ref, a),
                itemBuilder: (_) => [
                  PopupMenuItem(value: 'edit', child: Text(l.actionEdit)),
                  if (perms.owner)
                    PopupMenuItem(value: 'archive', child: Text(member.isArchived ? l.actionRestore : l.actionArchive)),
                  if (perms.owner)
                    PopupMenuItem(
                      value: 'delete',
                      child: Text(l.actionDelete, style: TextStyle(color: c.danger)),
                    ),
                ],
              ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            margin: const EdgeInsets.fromLTRB(AbsSpace.x3, 0, AbsSpace.x3, AbsSpace.x2),
            padding: const EdgeInsets.symmetric(vertical: AbsSpace.x1),
            decoration: stickerDecoration(c, borderRadius: BorderRadius.circular(AbsRadius.sheet)),
            child: Row(
              children: [
                if (perms.desk)
                  _BarButton(
                    icon: PhosphorIcons.currencyInr(PhosphorIconsStyle.bold),
                    label: l.actionCollect,
                    hue: PopHue.tangerine,
                    onTap: () => showCollectSheet(context, member: CollectTarget.of(member)),
                  ),
                if (perms.desk)
                  _BarButton(
                    icon: PhosphorIcons.arrowsClockwise(PhosphorIconsStyle.bold),
                    label: l.actionRenew,
                    hue: PopHue.lime,
                    onTap: () async {
                      final done = await showPlanSheet(
                        context,
                        member: member,
                        renew: member.currentMembershipId != null,
                      );
                      // The renewal raised an invoice: offer to collect now.
                      if (done == true && context.mounted) {
                        ref.refreshPayments(memberId: member.id);
                        await showCollectSheet(context, member: CollectTarget.of(member));
                      }
                    },
                  ),
                _BarButton(
                  icon: PhosphorIcons.whatsappLogo(PhosphorIconsStyle.bold),
                  label: l.actionWhatsApp,
                  hue: PopHue.mint,
                  onTap: () => ContactLinks.openWhatsApp(member.phone, text: reminderText(l, member, gym)),
                ),
                _BarButton(
                  icon: PhosphorIcons.phone(PhosphorIconsStyle.bold),
                  label: l.actionCall,
                  hue: PopHue.sky,
                  onTap: () => ContactLinks.openCall(member.phone),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(context.screenPadding, 0, context.screenPadding, AbsSpace.x3),
              child: AbsCard(
                hue: hue,
                padding: const EdgeInsets.all(AbsSpace.x4),
                child: Row(
                  children: [
                    Hero(
                      tag: 'member-${member.id}',
                      child: MemberPhoto(name: member.name, path: member.photoPath, size: 64),
                    ),
                    const SizedBox(width: AbsSpace.x3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(member.name, style: t.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                          Text(member.planName ?? l.noPlan, style: t.label.copyWith(color: c.textSecondary)),
                          const SizedBox(height: AbsSpace.x1),
                          Wrap(
                            spacing: AbsSpace.x2,
                            runSpacing: AbsSpace.x1,
                            children: [
                              StatusPill(status: pillFor(member.status), days: days ?? 0),
                              if (perms.desk && member.duesPaise > 0)
                                PopSticker(
                                  key: const ValueKey('member-dues'),
                                  label: l.memberDues(Money.format(member.duesPaise)),
                                  hue: PopHue.coral,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (member.status.isCurrent && days != null)
                      ProgressRing(
                        progress: 1 - member.usedFraction(),
                        size: 76,
                        strokeWidth: 8,
                        hue: hue,
                        semanticsLabel: l.daysLeft(days),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CountUp(value: days, style: t.numericOf(t.title).copyWith(height: 1)),
                            Text(l.daysShort, style: t.caption, textScaler: TextScaler.noScaling),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: [for (final x in tabs) Tab(text: x)],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _OverviewTab(member: member, perms: perms),
                  _MembershipTab(member: member, perms: perms),
                  if (perms.desk) _PaymentsTab(member: member),
                  MemberWorkoutsTab(member: member, canCoach: perms.owner || perms.ownTrainer),
                  _SoonTab(message: l.dietSoon, hue: PopHue.mint),
                  _ProgressTab(member: member, perms: perms),
                  _AttendanceTab(member: member, perms: perms),
                  _NotesTab(member: member, perms: perms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarButton extends StatelessWidget {
  const _BarButton({required this.icon, required this.label, required this.hue, required this.onTap});

  final IconData icon;
  final String label;
  final PopHue hue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Semantics(
      button: true,
      label: label,
      onTap: onTap,
      excludeSemantics: true,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: AbsRadius.buttonAll,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AbsSpace.x1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconBubble(icon: icon, hue: hue, size: 38),
                const SizedBox(height: 2),
                Text(label, style: context.text.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _DeleteDialog extends StatefulWidget {
  const _DeleteDialog({required this.name});

  final String name;

  @override
  State<_DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<_DeleteDialog> {
  final _c = TextEditingController();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final match = _c.text.trim().toLowerCase() == widget.name.trim().toLowerCase();
    return AlertDialog(
      title: Text(l.deleteConfirmTitle(widget.name)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l.deleteConfirmBody),
          const SizedBox(height: AbsSpace.x4),
          AbsTextField(label: l.fieldName, controller: _c, onChanged: (_) => setState(() {})),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.commonCancel)),
        TextButton(
          onPressed: match ? () => Navigator.pop(context, true) : null,
          child: Text(l.actionDelete, style: TextStyle(color: match ? context.colors.danger : null)),
        ),
      ],
    );
  }
}

class _TabList extends StatelessWidget {
  const _TabList({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x4, context.screenPadding, AbsSpace.x10),
    children: children,
  );
}

class _SoonTab extends StatelessWidget {
  const _SoonTab({required this.message, required this.hue});

  final String message;
  final PopHue hue;

  @override
  Widget build(BuildContext context) => EmptyState(
    title: context.l10n.comingSoonTitle,
    message: message,
    illustration: EmptyIllustration.rocket,
    hue: hue,
  );
}

// ---------------------------------------------------------------------------
// Payments (desk and owner)
// ---------------------------------------------------------------------------

class _PaymentsTab extends ConsumerWidget {
  const _PaymentsTab({required this.member});

  final Member member;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final invoices = ref.watch(memberInvoicesProvider(member.id));
    final payments = ref.watch(memberPaymentsProvider(member.id)).value ?? const <Payment>[];
    final credit = ref.watch(memberCreditProvider(member.id)).value ?? 0;
    return AsyncView<List<Invoice>>(
      value: invoices,
      onRetry: () => ref.invalidate(memberInvoicesProvider(member.id)),
      loading: const SkeletonList(itemCount: 3),
      isEmpty: (list) => list.isEmpty,
      empty: EmptyState(
        title: l.memberNoInvoicesTitle,
        message: l.memberNoInvoicesBody,
        illustration: EmptyIllustration.receipt,
        hue: PopHue.tangerine,
      ),
      data: (list) => _TabList(
        children: [
          if (credit > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: AbsSpace.x3),
              child: PopSticker(label: l.memberCredit(Money.format(credit)), hue: PopHue.lime, numeric: true),
            ),
          for (final i in list)
            InvoiceTile(
              invoice: i,
              showMember: false,
              onTap: () => context.push(Routes.invoiceDetail(i.id)),
              onCollect: () => showCollectSheet(context, invoice: i),
            ),
          if (payments.isNotEmpty) ...[
            const SizedBox(height: AbsSpace.x2),
            Text(l.invoicePayments, style: context.text.title),
            const SizedBox(height: AbsSpace.x2),
            for (final p in payments)
              PaymentTile(
                payment: p,
                showMember: false,
                onTap: p.invoiceId == null ? null : () => context.push(Routes.invoiceDetail(p.invoiceId!)),
              ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Overview
// ---------------------------------------------------------------------------

class _OverviewTab extends ConsumerWidget {
  const _OverviewTab({required this.member, required this.perms});

  final Member member;
  final _Perms perms;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final trainers = ref.watch(trainersProvider).value ?? const [];
    final trainer = trainers.where((x) => x.id == member.trainerId).firstOrNull?.name;

    Widget row(IconData icon, String k, String? v) => v == null || v.isEmpty
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: AbsSpace.x2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: AbsSize.iconSmall, color: c.textSecondary),
                const SizedBox(width: AbsSpace.x3),
                SizedBox(
                  width: 96,
                  child: Text(k, style: t.label.copyWith(color: c.textSecondary)),
                ),
                Expanded(child: Text(v, style: t.body)),
              ],
            ),
          );

    return _TabList(
      children: [
        if (perms.desk && (member.email == null || member.email!.trim().isEmpty)) ...[
          AbsCard(
            key: const ValueKey('no-gmail'),
            hue: PopHue.sky,
            onTap: () async {
              await context.push(Routes.memberEdit(member.id));
              ref.refreshMember(member.id);
            },
            padding: const EdgeInsets.all(AbsSpace.x4),
            child: Row(
              children: [
                IconBubble(icon: PhosphorIcons.googleLogo(PhosphorIconsStyle.bold), hue: PopHue.sky),
                const SizedBox(width: AbsSpace.x3),
                Expanded(child: Text(l.memberNoGmail(member.name.split(' ').first), style: t.body)),
                Icon(PhosphorIcons.caretRight(PhosphorIconsStyle.bold), size: AbsSize.iconSmall),
              ],
            ),
          ),
          const SizedBox(height: AbsSpace.x4),
        ],
        AbsCard(
          child: Column(
            children: [
              row(PhosphorIcons.phone(), l.infoPhone, Phone.display(member.phone)),
              row(PhosphorIcons.envelope(), l.infoEmail, member.email),
              row(PhosphorIcons.cake(), l.infoDob, member.dob == null ? null : dateLabel(member.dob)),
              row(PhosphorIcons.mapPin(), l.infoAddress, member.address),
              row(
                PhosphorIcons.firstAidKit(),
                l.infoEmergency,
                member.emergencyName == null
                    ? null
                    : [
                        member.emergencyName,
                        if (member.emergencyRelation != null) '(${member.emergencyRelation})',
                        if (member.emergencyPhone != null) Phone.display(member.emergencyPhone!),
                      ].join(' '),
              ),
              row(PhosphorIcons.sun(), l.infoBatch, member.batch == null ? null : batchLabel(l, member.batch!)),
              row(PhosphorIcons.barbell(), l.infoTrainer, trainer),
              row(PhosphorIcons.drop(), l.infoBlood, member.bloodGroup),
              row(PhosphorIcons.calendarPlus(), l.infoJoined, dateLabel(member.joinedOn)),
              row(PhosphorIcons.megaphone(), l.infoSource, member.source),
              row(PhosphorIcons.note(), l.fieldNotes, member.notes),
            ],
          ),
        ),
        const SizedBox(height: AbsSpace.x4),
        if (perms.health)
          _HealthCard(memberId: member.id)
        else
          Text(l.healthPrivate, style: t.caption.copyWith(color: c.textSecondary)),
      ],
    );
  }
}

class _HealthCard extends ConsumerWidget {
  const _HealthCard({required this.memberId});

  final String memberId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final t = context.text;
    final health = ref.watch(memberHealthProvider(memberId));
    return AbsCard(
      hue: PopHue.mint,
      title: l.healthTitle,
      action: IconButton(
        tooltip: l.actionEdit,
        icon: Icon(PhosphorIcons.pencilSimple(PhosphorIconsStyle.bold)),
        onPressed: () => showHealthSheet(context, memberId: memberId, current: health.value),
      ),
      child: AsyncView<MemberHealth?>(
        value: health,
        onRetry: () => ref.invalidate(memberHealthProvider(memberId)),
        loading: const SizedBox(height: 60),
        isEmpty: (h) => h == null,
        empty: Text(l.healthNone, style: t.body),
        data: (h) {
          final yes = [
            for (final k in parqKeys)
              if (h!.parq[k] == true) parqQuestion(l, k),
          ];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: AbsSpace.x2,
                runSpacing: AbsSpace.x2,
                children: [
                  if (h!.heightCm != null) PopSticker(label: '${h.heightCm} cm', hue: PopHue.sky, numeric: true),
                  if (h.weightKg != null) PopSticker(label: '${h.weightKg} kg', hue: PopHue.tangerine, numeric: true),
                  if (h.doctorClearance) PopSticker(label: l.fieldDoctorClearance, hue: PopHue.mint),
                ],
              ),
              for (final (k, v) in [
                (l.fieldConditions, h.conditions),
                (l.fieldInjuries, h.injuries),
                (l.fieldMedications, h.medications),
              ])
                if (v != null && v.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: AbsSpace.x2),
                    child: Text('$k: $v', style: t.body),
                  ),
              if (yes.isNotEmpty) ...[
                const SizedBox(height: AbsSpace.x3),
                Text(l.parqWarning, style: t.label.copyWith(color: context.colors.warning)),
                for (final q in yes) Text('• $q', style: t.caption),
              ],
            ],
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Membership
// ---------------------------------------------------------------------------

class _MembershipTab extends ConsumerWidget {
  const _MembershipTab({required this.member, required this.perms});

  final Member member;
  final _Perms perms;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final list = ref.watch(memberMembershipsProvider(member.id));
    final plans = ref.watch(allPlansProvider).value ?? const <Plan>[];
    return AsyncView<List<Membership>>(
      value: list,
      onRetry: () => ref.invalidate(memberMembershipsProvider(member.id)),
      empty: EmptyState(
        title: l.membershipNone,
        message: l.paymentNote,
        actionLabel: perms.desk ? l.membershipStart : null,
        onAction: perms.desk ? () => showPlanSheet(context, member: member, renew: false) : null,
        illustration: EmptyIllustration.dumbbell,
        hue: PopHue.lime,
      ),
      data: (items) {
        final current = items.where((m) => m.id == member.currentMembershipId).firstOrNull;
        final history = items.where((m) => m.id != current?.id).toList();
        return _TabList(
          children: [
            if (current != null) ...[
              Text(l.membershipCurrent, style: context.text.heading),
              const SizedBox(height: AbsSpace.x2),
              _MembershipCard(
                m: current,
                perms: perms,
                freezeAllowed: plans.where((p) => p.id == current.planId).firstOrNull?.freezeDaysAllowed ?? 0,
                highlight: true,
              ),
            ] else if (perms.desk)
              AbsButton(
                label: l.membershipStart,
                hue: PopHue.lime,
                onPressed: () => showPlanSheet(context, member: member, renew: false),
              ),
            if (history.isNotEmpty) ...[
              const SizedBox(height: AbsSpace.x5),
              Text(l.membershipHistory, style: context.text.heading),
              const SizedBox(height: AbsSpace.x2),
              for (final m in history)
                Padding(
                  padding: const EdgeInsets.only(bottom: AbsSpace.x2),
                  child: _MembershipCard(m: m, perms: perms, freezeAllowed: 0, highlight: false),
                ),
            ],
          ],
        );
      },
    );
  }
}

class _MembershipCard extends StatelessWidget {
  const _MembershipCard({required this.m, required this.perms, required this.freezeAllowed, required this.highlight});

  final Membership m;
  final _Perms perms;
  final int freezeAllowed;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final open = m.openFreeze(IstDates.today());
    final live = m.cancelledReason == null && m.status != MemberStatus.expired && m.status != MemberStatus.inactive;
    return AbsCard(
      hue: highlight ? hueForStatus(m.status) : null,
      padding: const EdgeInsets.all(AbsSpace.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(m.planName, style: t.heading)),
              StatusPill(status: pillFor(m.status), days: m.endDate == null ? 0 : IstDates.daysUntil(m.endDate!)),
            ],
          ),
          const SizedBox(height: AbsSpace.x1),
          Text(
            '${dateLabel(m.startDate)} → ${dateLabel(m.endDate)}',
            style: t.numericOf(t.label).copyWith(color: c.textSecondary),
          ),
          if (m.totalPaise > 0)
            Text(
              '${l.summaryTotal}: ${Money.format(m.totalPaise)}',
              style: t.numericOf(t.caption).copyWith(color: c.textSecondary),
            ),
          if (m.cancelledReason != null) Text(m.cancelledReason!, style: t.caption.copyWith(color: c.danger)),
          if (highlight && live && (perms.desk || perms.owner)) ...[
            const SizedBox(height: AbsSpace.x3),
            Wrap(
              spacing: AbsSpace.x2,
              runSpacing: AbsSpace.x2,
              children: [
                if (perms.desk && open == null)
                  PopChip(
                    label: l.freeze,
                    icon: PhosphorIcons.snowflake(PhosphorIconsStyle.bold),
                    hue: PopHue.sky,
                    selected: false,
                    onTap: () => showFreezeSheet(context, membership: m, allowedDays: freezeAllowed),
                  ),
                if (perms.desk && open != null)
                  Consumer(
                    builder: (context, ref, _) => PopChip(
                      label: l.unfreeze,
                      icon: PhosphorIcons.sun(PhosphorIconsStyle.bold),
                      hue: PopHue.sky,
                      selected: true,
                      onTap: () async {
                        try {
                          await ref.read(membersRepositoryProvider).unfreeze(m.id);
                          ref.refreshMember(m.memberId);
                          if (context.mounted) showAbsSnackbar(context, l.unfreezeDone, tone: SnackTone.success);
                        } catch (e) {
                          if (context.mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
                        }
                      },
                    ),
                  ),
                if (perms.owner)
                  PopChip(
                    label: l.transfer,
                    icon: PhosphorIcons.arrowsLeftRight(PhosphorIconsStyle.bold),
                    hue: PopHue.grape,
                    selected: false,
                    onTap: () => showTransferSheet(context, membership: m),
                  ),
                if (perms.owner)
                  PopChip(
                    label: l.cancelMembership,
                    icon: PhosphorIcons.prohibit(PhosphorIconsStyle.bold),
                    hue: PopHue.coral,
                    selected: false,
                    onTap: () => showCancelSheet(context, membership: m),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Progress (measurements)
// ---------------------------------------------------------------------------

class _ProgressTab extends ConsumerWidget {
  const _ProgressTab({required this.member, required this.perms});

  final Member member;
  final _Perms perms;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    if (!perms.health) {
      return EmptyState(
        title: l.tabProgress,
        message: l.healthPrivate,
        illustration: EmptyIllustration.search,
        hue: PopHue.mint,
      );
    }
    return MeasurementsView(memberId: member.id, canAdd: true);
  }
}

/// Measurements list with a weight trend; shared with the member app.
class MeasurementsView extends ConsumerWidget {
  const MeasurementsView({super.key, required this.memberId, required this.canAdd});

  final String memberId;
  final bool canAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final t = context.text;
    final c = context.colors;
    final list = ref.watch(memberMeasurementsProvider(memberId));
    return AsyncView<List<Measurement>>(
      value: list,
      onRetry: () => ref.invalidate(memberMeasurementsProvider(memberId)),
      empty: EmptyState(
        title: l.progressEmpty,
        message: canAdd ? l.progressAdd : l.myProgressEmpty,
        actionLabel: canAdd ? l.progressAdd : null,
        onAction: canAdd ? () => showMeasurementSheet(context, memberId: memberId) : null,
        illustration: EmptyIllustration.dumbbell,
        hue: PopHue.mint,
      ),
      data: (items) {
        final weights = [
          for (final m in items.reversed)
            if (m.weightKg != null) m.weightKg!.toDouble(),
        ];
        String fmt(num? v, String unit) => v == null ? '' : '$v $unit';
        return _TabList(
          children: [
            if (canAdd)
              Align(
                alignment: Alignment.centerRight,
                child: AbsButton(
                  label: l.progressAdd,
                  icon: PhosphorIcons.plus(PhosphorIconsStyle.bold),
                  hue: PopHue.mint,
                  expand: false,
                  onPressed: () => showMeasurementSheet(context, memberId: memberId),
                ),
              ),
            if (weights.length > 1) ...[
              const SizedBox(height: AbsSpace.x3),
              AbsCard(
                hue: PopHue.mint,
                title: l.weightTrend,
                child: SizedBox(
                  height: 80,
                  child: Sparkline(values: weights, color: c.pop(PopHue.mint).text),
                ),
              ),
            ],
            const SizedBox(height: AbsSpace.x3),
            for (final m in items)
              Padding(
                padding: const EdgeInsets.only(bottom: AbsSpace.x2),
                child: AbsCard(
                  padding: const EdgeInsets.all(AbsSpace.x4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dateLabel(m.measuredOn), style: t.heading),
                      const SizedBox(height: AbsSpace.x1),
                      Wrap(
                        spacing: AbsSpace.x2,
                        runSpacing: AbsSpace.x2,
                        children: [
                          for (final (label, value, hue) in [
                            (l.fieldWeight, fmt(m.weightKg, 'kg'), PopHue.tangerine),
                            (l.fieldBodyFat, fmt(m.bodyFat, '%'), PopHue.bubblegum),
                            (l.fieldChest, fmt(m.chest, 'cm'), PopHue.sky),
                            (l.fieldWaist, fmt(m.waist, 'cm'), PopHue.grape),
                            (l.fieldHips, fmt(m.hips, 'cm'), PopHue.mint),
                            (l.fieldArms, fmt(m.arms, 'cm'), PopHue.lime),
                            (l.fieldThighs, fmt(m.thighs, 'cm'), PopHue.sky),
                          ])
                            if (value.isNotEmpty)
                              PopSticker(label: '${label.split(' (').first}: $value', hue: hue, numeric: true),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Attendance
// ---------------------------------------------------------------------------

class _AttendanceTab extends ConsumerStatefulWidget {
  const _AttendanceTab({required this.member, required this.perms});

  final Member member;
  final _Perms perms;

  @override
  ConsumerState<_AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends ConsumerState<_AttendanceTab> {
  bool _busy = false;

  Future<void> _mark() async {
    final l = context.l10n;
    setState(() => _busy = true);
    try {
      final r = await ref.read(membersRepositoryProvider).checkIn(widget.member.id);
      ref.refreshMember(widget.member.id);
      if (mounted) {
        showAbsSnackbar(context, r.already ? l.attendanceAlready : l.attendanceMarked, tone: SnackTone.success);
      }
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final visits = ref.watch(memberAttendanceProvider(widget.member.id));
    return AsyncView<List<Attendance>>(
      value: visits,
      onRetry: () => ref.invalidate(memberAttendanceProvider(widget.member.id)),
      isEmpty: (_) => false,
      empty: const SizedBox.shrink(),
      data: (items) => _TabList(
        children: [
          if (widget.perms.attendance)
            AbsButton(
              label: l.attendanceMark,
              hue: PopHue.mint,
              icon: PhosphorIcons.checkCircle(PhosphorIconsStyle.bold),
              isLoading: _busy,
              onPressed: _mark,
            ),
          const SizedBox(height: AbsSpace.x4),
          AttendanceGrid(visits: items),
          const SizedBox(height: AbsSpace.x4),
          if (items.isEmpty)
            Text(l.attendanceEmpty, style: context.text.body)
          else
            for (final a in items.take(15))
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: IconBubble(
                  icon: PhosphorIcons.footprints(PhosphorIconsStyle.bold),
                  hue: PopHue.mint,
                  size: 36,
                  solid: false,
                ),
                title: Text(dateLabel(a.day)),
                subtitle: Text(l.visitedAt(IstDates.formatTime(a.checkedInAt))),
              ),
        ],
      ),
    );
  }
}

/// 12-week visit grid (one column per week, Mon–Sun).
class AttendanceGrid extends StatelessWidget {
  const AttendanceGrid({super.key, required this.visits});

  final List<Attendance> visits;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final today = IstDates.today();
    final days = {
      for (final a in visits)
        if (a.day != null) DateTime.utc(a.day!.year, a.day!.month, a.day!.day),
    };
    final start = today.subtract(Duration(days: 7 * 11 + today.weekday - 1));
    return AbsCard(
      hue: PopHue.mint,
      title: l.attendanceLast12,
      action: PopSticker(label: l.attendanceVisits(days.length), hue: PopHue.mint, numeric: true),
      child: LayoutBuilder(
        builder: (context, box) {
          final cell = ((box.maxWidth - 11 * 4) / 12).clamp(8.0, 22.0);
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var w = 0; w < 12; w++)
                Column(
                  children: [
                    for (var d = 0; d < 7; d++)
                      () {
                        final day = start.add(Duration(days: w * 7 + d));
                        final future = day.isAfter(today);
                        final hit = days.contains(day);
                        return Container(
                          width: cell,
                          height: cell,
                          margin: const EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            color: future ? Colors.transparent : (hit ? c.pop(PopHue.mint).fill : c.border),
                            borderRadius: BorderRadius.circular(4),
                            border: day == today ? Border.all(color: c.ink, width: 1.5) : null,
                          ),
                        );
                      }(),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Notes & history timeline (1.11)
// ---------------------------------------------------------------------------

class _NotesTab extends ConsumerStatefulWidget {
  const _NotesTab({required this.member, required this.perms});

  final Member member;
  final _Perms perms;

  @override
  ConsumerState<_NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends ConsumerState<_NotesTab> {
  final _note = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    if (_busy || _note.text.trim().isEmpty) return;
    setState(() => _busy = true);
    try {
      await ref.read(membersRepositoryProvider).addNote(widget.member.id, _note.text.trim());
      _note.clear();
      ref.invalidate(memberEventsProvider(widget.member.id));
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(context.l10n, e), tone: SnackTone.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  static (IconData, PopHue) _look(String kind) => switch (kind) {
    'joined' => (PhosphorIcons.confetti(PhosphorIconsStyle.bold), PopHue.lime),
    'membership_started' || 'renewed' => (PhosphorIcons.arrowsClockwise(PhosphorIconsStyle.bold), PopHue.lime),
    'frozen' || 'unfrozen' => (PhosphorIcons.snowflake(PhosphorIconsStyle.bold), PopHue.sky),
    'cancelled' => (PhosphorIcons.prohibit(PhosphorIconsStyle.bold), PopHue.coral),
    'transferred_in' || 'transferred_out' => (PhosphorIcons.arrowsLeftRight(PhosphorIconsStyle.bold), PopHue.grape),
    'note' => (PhosphorIcons.note(PhosphorIconsStyle.bold), PopHue.tangerine),
    'archived' || 'restored' => (PhosphorIcons.archive(PhosphorIconsStyle.bold), PopHue.coral),
    _ => (PhosphorIcons.pencilSimple(PhosphorIconsStyle.bold), PopHue.bubblegum),
  };

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final events = ref.watch(memberEventsProvider(widget.member.id));
    return _TabList(
      children: [
        if (widget.perms.notes)
          Row(
            children: [
              Expanded(
                child: AbsTextField(label: l.notesHint, controller: _note, onFieldSubmitted: (_) => _add()),
              ),
              const SizedBox(width: AbsSpace.x2),
              AbsButton(label: l.notesAdd, hue: PopHue.tangerine, expand: false, isLoading: _busy, onPressed: _add),
            ],
          ),
        const SizedBox(height: AbsSpace.x4),
        AsyncView<List<MemberEvent>>(
          value: events,
          onRetry: () => ref.invalidate(memberEventsProvider(widget.member.id)),
          loading: const SizedBox(height: 200, child: SkeletonList(itemCount: 3)),
          empty: Text(l.notesEmpty, style: context.text.body),
          data: (items) => Column(
            children: [
              for (final e in items)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: IconBubble(icon: _look(e.kind).$1, hue: _look(e.kind).$2, size: 38),
                  title: Text(e.title, style: context.text.body),
                  subtitle: Text(IstDates.formatDateTime(e.at)),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
