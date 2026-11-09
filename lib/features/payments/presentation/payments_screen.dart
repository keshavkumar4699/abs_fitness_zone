import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/routes.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/utils/dates.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/widgets.dart';
import '../../auth/application/auth_providers.dart';
import '../../auth/domain/app_user.dart';
import '../../shell/staff_shell.dart' show StaffHues;
import '../application/payments_providers.dart';
import '../../whatsapp/application/whatsapp_providers.dart';
import '../data/payments_repository.dart';
import '../domain/payment_models.dart';
import 'collect_sheet.dart';
import 'payment_ui.dart';

/// Payments tab (2.10): today's hero, fee reminders, and Due / Overdue /
/// Paid / To verify lists with search. Trainers never see payments.
class PaymentsScreen extends ConsumerStatefulWidget {
  const PaymentsScreen({super.key});

  @override
  ConsumerState<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends ConsumerState<PaymentsScreen> {
  final _search = TextEditingController();
  String _query = '';
  int _tab = 0;

  static const _tabs = [InvoiceTab.due, InvoiceTab.overdue, InvoiceTab.paid];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  PaymentFilter get _pending => PaymentFilter(status: PaymentStatus.pendingVerification, search: _query);

  Future<void> _refresh() async {
    ref.refreshPayments();
    await ref.read(duesSummaryProvider.future);
  }

  void _loadMore() {
    if (_tab == 3) {
      ref.read(paymentHistoryProvider(_pending).notifier).loadMore();
    } else {
      ref.read(invoiceListProvider(_tabs[_tab], _query).notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final user = ref.watch(currentUserProvider).value;
    if (user == null) return const SizedBox.shrink();
    if (!user.role.isDesk) {
      return Scaffold(
        body: SafeArea(
          child: EmptyState(
            title: l.payTrainerTitle,
            message: l.payTrainerBody,
            illustration: EmptyIllustration.wallet,
            hue: StaffHues.payments,
          ),
        ),
      );
    }
    final dues = ref.watch(duesSummaryProvider).value;
    final bottomPad = AbsSpace.x14 * 2 + MediaQuery.paddingOf(context).bottom;
    String count(String label, int? n) => n == null || n == 0 ? label : '$label $n';
    final labels = [
      count(l.payTabDue, dues?.dueCount),
      count(l.payTabOverdue, dues?.overdueCount),
      l.payTabPaid,
      count(l.payTabPending, dues?.pendingClaims),
    ];

    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
        child: CollectFab(onTap: () => showCollectSheet(context)),
      ),
      body: AbsRefresh(
        onRefresh: _refresh,
        child: NotificationListener<ScrollNotification>(
          onNotification: (n) {
            if (n.metrics.extentAfter < 600) _loadMore();
            return false;
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SearchBarHero(
                title: l.payTitle,
                hint: l.paySearchHint,
                controller: _search,
                onChanged: (v) => setState(() => _query = v.trim()),
                actions: [
                  IconButton(
                    tooltip: l.payHistory,
                    icon: Icon(PhosphorIcons.clockCounterClockwise(PhosphorIconsStyle.bold)),
                    onPressed: () => context.push(Routes.paymentHistory),
                  ),
                ],
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x2, context.screenPadding, 0),
                sliver: SliverList.list(
                  children: [
                    _TodayHero(user: user),
                    const SizedBox(height: AbsSpace.x3),
                    const _RemindersCard(),
                    const SizedBox(height: AbsSpace.x4),
                    SegmentedTabs(
                      labels: labels,
                      selected: _tab,
                      hue: StaffHues.payments,
                      dense: true,
                      onChanged: (i) => setState(() => _tab = i),
                    ),
                    const SizedBox(height: AbsSpace.x4),
                  ],
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: context.screenPadding),
                sliver: _tab == 3 ? _PendingList(filter: _pending) : _InvoiceList(tab: _tabs[_tab], search: _query),
              ),
              SliverToBoxAdapter(child: SizedBox(height: bottomPad)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Big tangerine "Collect" sticker button.
class CollectFab extends StatelessWidget {
  const CollectFab({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final p = c.pop(PopHue.tangerine);
    final label = context.l10n.payCollect;
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      onTap: onTap,
      child: Pressable(
        onTap: onTap,
        child: Container(
          key: const ValueKey('collect-fab'),
          height: AbsSpace.x14,
          padding: const EdgeInsets.symmetric(horizontal: AbsSpace.x5),
          decoration: stickerDecoration(c, color: p.fill, lip: c.isDark ? p.deep : c.ink),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(PhosphorIcons.currencyInr(PhosphorIconsStyle.bold), color: p.onFill),
              const SizedBox(width: AbsSpace.x2),
              Text(label, style: context.text.heading.copyWith(color: p.onFill)),
            ],
          ),
        ),
      ),
    );
  }
}

class _TodayHero extends ConsumerWidget {
  const _TodayHero({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final owner = user.role.isOwner;
    final day = ref.watch(myDayProvider).value;
    final gym = owner ? ref.watch(collectionsProvider(RevenuePeriod.today)).value : null;
    final total = owner ? gym?.collected ?? 0 : day?.total ?? 0;
    final count = owner ? gym?.paymentsCount ?? 0 : day?.count ?? 0;
    final byMode = owner
        ? {for (final e in (gym?.byMode ?? const <String, int>{}).entries) e.key: e.value}
        : {'cash': day?.cash ?? 0, 'upi': day?.upi ?? 0, 'card': day?.card ?? 0, 'bank': day?.bank ?? 0};
    final p = c.pop(StaffHues.payments);
    final closed = day?.closed ?? false;
    return Container(
      padding: const EdgeInsets.all(AbsSpace.x5),
      decoration: stickerDecoration(c, color: p.fill, lip: c.isDark ? p.deep : c.ink),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(owner ? l.payCollectedToday : l.payMyCollections, style: t.label.copyWith(color: p.onFill)),
              ),
              if (closed)
                PopSticker(label: l.payDayClosed, hue: PopHue.grape, dot: true)
              else
                _HeroAction(
                  label: l.payCloseDay,
                  icon: PhosphorIcons.lockKey(PhosphorIconsStyle.bold),
                  onTap: () => context.push(Routes.dayClose),
                ),
            ],
          ),
          const SizedBox(height: AbsSpace.x1),
          CountUp(
            key: const ValueKey('collected-today'),
            value: total,
            format: (v) => Money.format(v.round()),
            style: t.numericOf(t.displayXL).copyWith(color: p.onFill, height: 1.1),
          ),
          Text(l.payPaymentsCount(count), style: t.label.copyWith(color: p.onFill)),
          if (byMode.values.any((v) => v > 0)) ...[
            const SizedBox(height: AbsSpace.x3),
            Wrap(
              spacing: AbsSpace.x2,
              runSpacing: AbsSpace.x2,
              children: [
                for (final m in PaymentMode.values)
                  if ((byMode[m.wire] ?? 0) > 0)
                    PopSticker(
                      label: '${modeName(l, m)} ${Money.format(byMode[m.wire]!)}',
                      hue: modeHue(m),
                      numeric: true,
                    ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _HeroAction extends StatelessWidget {
  const _HeroAction({required this.label, required this.icon, required this.onTap});

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AbsRadius.pill,
        side: BorderSide(color: c.isDark ? c.border : c.ink, width: 1.5),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 36),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AbsSpace.x3),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: AbsSize.iconSmall, color: c.textPrimary),
                const SizedBox(width: AbsSpace.x1),
                Text(label, style: context.text.label),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Today's fee reminders (3 days before, on the day, 3 and 7 days after).
class _RemindersCard extends ConsumerWidget {
  const _RemindersCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final list = ref.watch(remindersTodayProvider).value ?? const <DueReminder>[];
    if (list.isEmpty) return const SizedBox.shrink();
    return AbsCard(
      key: const ValueKey('reminders-card'),
      hue: PopHue.mint,
      onTap: () => showRemindersSheet(context, list),
      padding: const EdgeInsets.all(AbsSpace.x4),
      child: Row(
        children: [
          IconBubble(icon: PhosphorIcons.bellRinging(PhosphorIconsStyle.bold), hue: PopHue.mint),
          const SizedBox(width: AbsSpace.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.payReminders, style: context.text.heading),
                Text(
                  l.payRemindersBody(list.length),
                  style: context.text.caption.copyWith(color: context.colors.textSecondary),
                ),
              ],
            ),
          ),
          Icon(PhosphorIcons.caretRight(PhosphorIconsStyle.bold), size: AbsSize.iconSmall),
        ],
      ),
    );
  }
}

/// One-tap WhatsApp per reminder, with the UPI link when the gym has one.
Future<void> showRemindersSheet(BuildContext context, List<DueReminder> list) => showAbsBottomSheet<void>(
  context: context,
  builder: (context, controller) => Consumer(
    builder: (context, ref, _) {
      final l = context.l10n;
      final profile = ref.watch(billingProfileProvider).value;
      return ListView(
        controller: controller,
        padding: EdgeInsets.fromLTRB(context.screenPadding, 0, context.screenPadding, AbsSpace.x6),
        children: [
          Text(l.payReminders, style: context.text.title),
          const SizedBox(height: AbsSpace.x4),
          for (final r in list)
            Padding(
              padding: const EdgeInsets.only(bottom: AbsSpace.x2),
              child: AbsCard(
                padding: const EdgeInsets.fromLTRB(AbsSpace.x4, AbsSpace.x3, AbsSpace.x2, AbsSpace.x3),
                child: Row(
                  children: [
                    AbsAvatar(name: r.memberName, size: 40, hue: r.daysToDue < 0 ? PopHue.coral : PopHue.tangerine),
                    const SizedBox(width: AbsSpace.x3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r.memberName, style: context.text.heading, maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text(
                            '${Money.format(r.balancePaise)} · ${r.daysToDue < 0 ? l.payOverdueBy(-r.daysToDue) : l.payDueIn(r.daysToDue)}',
                            style: context.text.caption.copyWith(color: context.colors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    if (r.memberPhone != null)
                      IconButton(
                        tooltip: l.actionWhatsApp,
                        icon: Icon(PhosphorIcons.whatsappLogo(PhosphorIconsStyle.bold)),
                        onPressed: () {
                          final link = profile?.upiId == null
                              ? null
                              : upiLinkFor(
                                  profile!,
                                  Invoice(
                                    id: r.invoiceId,
                                    invoiceNo: r.invoiceNo,
                                    memberName: r.memberName,
                                    memberCode: '',
                                    issueDate: null,
                                    dueDate: r.nextDueDate,
                                    nextDueDate: r.nextDueDate,
                                    balancePaise: r.balancePaise,
                                  ),
                                  amountPaise: r.balancePaise,
                                );
                          ref.sendWhatsApp(
                            memberId: r.memberId,
                            phone: r.memberPhone!,
                            text: duesReminderText(
                              l,
                              name: r.memberName,
                              balancePaise: r.balancePaise,
                              dueDate: r.nextDueDate,
                              gym: profile?.gymName ?? l.gymName,
                              upiLink: link,
                            ),
                            replaces: 'dues_reminder',
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
        ],
      );
    },
  ),
);

class _InvoiceList extends ConsumerWidget {
  const _InvoiceList({required this.tab, required this.search});

  final InvoiceTab tab;
  final String search;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final list = ref.watch(invoiceListProvider(tab, search));
    return switch (list) {
      AsyncData(:final value) when value.items.isNotEmpty => SliverList.builder(
        itemCount: value.items.length + (value.loadingMore ? 1 : 0),
        itemBuilder: (context, i) {
          if (i == value.items.length) return const SizedBox(height: 80, child: SkeletonList(itemCount: 1));
          final inv = value.items[i];
          return Entrance(
            index: i,
            child: InvoiceTile(
              key: ValueKey(inv.id),
              invoice: inv,
              onTap: () => context.push(Routes.invoiceDetail(inv.id)),
              onCollect: inv.status.isOpen ? () => showCollectSheet(context, invoice: inv) : null,
            ),
          );
        },
      ),
      AsyncData() => SliverToBoxAdapter(
        child: search.isNotEmpty
            ? EmptyState(
                title: l.payEmptySearchTitle,
                message: l.payEmptySearchBody,
                illustration: EmptyIllustration.search,
              )
            : switch (tab) {
                InvoiceTab.due => EmptyState(
                  title: l.payEmptyDueTitle,
                  message: l.payEmptyDueBody,
                  illustration: EmptyIllustration.receipt,
                  hue: PopHue.sky,
                ),
                InvoiceTab.overdue => EmptyState(
                  title: l.payEmptyOverdueTitle,
                  message: l.payEmptyOverdueBody,
                  illustration: EmptyIllustration.trophy,
                  hue: PopHue.mint,
                ),
                InvoiceTab.paid => EmptyState(
                  title: l.payEmptyPaidTitle,
                  message: l.payEmptyPaidBody,
                  illustration: EmptyIllustration.wallet,
                  hue: PopHue.tangerine,
                ),
              },
      ),
      AsyncError(:final error) => SliverToBoxAdapter(
        child: ErrorState(
          message: friendlyError(l, error),
          onRetry: () => ref.invalidate(invoiceListProvider(tab, search)),
        ),
      ),
      _ => const SliverToBoxAdapter(child: SizedBox(height: 320, child: SkeletonList(itemCount: 4))),
    };
  }
}

/// Member "I've paid" claims waiting for a quick check (2.5).
class _PendingList extends ConsumerWidget {
  const _PendingList({required this.filter});

  final PaymentFilter filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final list = ref.watch(paymentHistoryProvider(filter));
    return switch (list) {
      AsyncData(:final value) when value.items.isNotEmpty => SliverList.builder(
        itemCount: value.items.length,
        itemBuilder: (context, i) => Entrance(
          index: i,
          child: _ClaimCard(key: ValueKey(value.items[i].id), payment: value.items[i]),
        ),
      ),
      AsyncData() => SliverToBoxAdapter(
        child: EmptyState(
          title: l.payEmptyPendingTitle,
          message: l.payEmptyPendingBody,
          illustration: EmptyIllustration.clock,
          hue: PopHue.grape,
        ),
      ),
      AsyncError(:final error) => SliverToBoxAdapter(
        child: ErrorState(
          message: friendlyError(l, error),
          onRetry: () => ref.invalidate(paymentHistoryProvider(filter)),
        ),
      ),
      _ => const SliverToBoxAdapter(child: SizedBox(height: 240, child: SkeletonList(itemCount: 3))),
    };
  }
}

class _ClaimCard extends ConsumerStatefulWidget {
  const _ClaimCard({super.key, required this.payment});

  final Payment payment;

  @override
  ConsumerState<_ClaimCard> createState() => _ClaimCardState();
}

class _ClaimCardState extends ConsumerState<_ClaimCard> {
  bool _busy = false;

  Future<void> _decide(bool approve) async {
    final l = context.l10n;
    String? reason;
    if (!approve) {
      reason = await askReason(context, title: l.payRejectTitle, label: l.payRejectReason, confirm: l.payReject);
      if (reason == null) return;
    }
    setState(() => _busy = true);
    try {
      final res = await ref
          .read(paymentsRepositoryProvider)
          .verify(paymentId: widget.payment.id, approve: approve, reason: reason);
      ref.refreshPayments(memberId: widget.payment.memberId, invoiceId: widget.payment.invoiceId);
      if (mounted) {
        showAbsSnackbar(
          context,
          approve ? l.payApproved(res.receiptNo ?? '') : l.payRejected,
          tone: approve ? SnackTone.success : SnackTone.neutral,
        );
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
    final c = context.colors;
    final t = context.text;
    final p = widget.payment;
    return Padding(
      padding: const EdgeInsets.only(bottom: AbsSpace.x3),
      child: AbsCard(
        hue: PopHue.grape,
        onTap: p.invoiceId == null ? null : () => context.push(Routes.invoiceDetail(p.invoiceId!)),
        padding: const EdgeInsets.all(AbsSpace.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                AbsAvatar(name: p.memberName, size: 40, hue: PopHue.grape),
                const SizedBox(width: AbsSpace.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.memberName, style: t.heading, maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(
                        '${l.payUtr(p.utr ?? '—')} · ${l.payClaimedAt(IstDates.formatDateTime(p.paidAt))}',
                        style: t.numericOf(t.caption).copyWith(color: c.textSecondary),
                      ),
                    ],
                  ),
                ),
                MoneyText(p.amountPaise, style: t.title),
              ],
            ),
            const SizedBox(height: AbsSpace.x3),
            Row(
              children: [
                Expanded(
                  child: AbsButton.secondary(
                    key: ValueKey('reject-${p.id}'),
                    label: l.payReject,
                    icon: PhosphorIcons.x(PhosphorIconsStyle.bold),
                    onPressed: _busy ? null : () => _decide(false),
                  ),
                ),
                const SizedBox(width: AbsSpace.x2),
                Expanded(
                  child: AbsButton(
                    key: ValueKey('approve-${p.id}'),
                    label: l.payApprove,
                    hue: PopHue.mint,
                    icon: PhosphorIcons.check(PhosphorIconsStyle.bold),
                    isLoading: _busy,
                    onPressed: _busy ? null : () => _decide(true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Asks for a required reason; returns null when cancelled.
Future<String?> askReason(
  BuildContext context, {
  required String title,
  required String label,
  required String confirm,
  String? body,
  bool destructive = true,
}) => showDialog<String>(
  context: context,
  builder: (_) => _ReasonDialog(title: title, label: label, confirm: confirm, body: body, destructive: destructive),
);

class _ReasonDialog extends StatefulWidget {
  const _ReasonDialog({
    required this.title,
    required this.label,
    required this.confirm,
    required this.destructive,
    this.body,
  });

  final String title;
  final String label;
  final String confirm;
  final String? body;
  final bool destructive;

  @override
  State<_ReasonDialog> createState() => _ReasonDialogState();
}

class _ReasonDialogState extends State<_ReasonDialog> {
  final _c = TextEditingController();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final ok = _c.text.trim().isNotEmpty;
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.body != null) ...[Text(widget.body!), const SizedBox(height: AbsSpace.x4)],
          AbsTextField(
            key: const ValueKey('reason-field'),
            label: widget.label,
            controller: _c,
            autofocus: true,
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l.commonCancel)),
        TextButton(
          key: const ValueKey('reason-confirm'),
          onPressed: ok ? () => Navigator.pop(context, _c.text.trim()) : null,
          child: Text(widget.confirm, style: TextStyle(color: ok && widget.destructive ? context.colors.danger : null)),
        ),
      ],
    );
  }
}
