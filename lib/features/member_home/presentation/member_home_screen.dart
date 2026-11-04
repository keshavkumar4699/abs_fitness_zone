import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/routes.dart';
import '../../../app/theme/theme.dart';
import '../../../core/utils/dates.dart';
import '../../../core/utils/money.dart';
import '../../../core/utils/phone.dart';
import '../../../core/widgets/widgets.dart';
import '../../auth/application/auth_providers.dart';
import '../../checkin/presentation/scanner_view.dart';
import '../../diet/application/diet_providers.dart';
import '../../diet/presentation/my_diet_screen.dart' show TodayDietCard;
import '../../members/application/members_providers.dart';
import '../../members/domain/models.dart';
import '../../members/presentation/member_ui.dart';
import '../../shell/greeting_header.dart';
import '../../workouts/application/workouts_providers.dart';
import '../../workouts/presentation/my_workout_screen.dart' show TodayWorkoutCard;
import '../data/my_member_repository.dart';

/// Member home: membership card with QR, days left, self check-in, visits.
class MemberHomeScreen extends ConsumerWidget {
  const MemberHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final user = ref.watch(currentUserProvider).value;
    final member = ref.watch(myMemberProvider);
    // Upload workouts finished offline as soon as the app opens.
    ref.listen(syncWorkoutsProvider, (_, next) {
      final id = user?.memberId;
      if ((next.value ?? 0) > 0 && id != null) ref.refreshWorkouts(id);
    });
    // …and meals, water and supplements marked offline.
    ref.listen(syncDietProvider, (_, next) {
      final id = user?.memberId;
      if ((next.value ?? 0) > 0 && id != null) ref.refreshDiet(id);
    });
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: AbsRefresh(
          onRefresh: () => ref.refresh(myMemberProvider.future),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              context.screenPadding,
              AbsSpace.x4,
              context.screenPadding,
              MediaQuery.paddingOf(context).bottom + AbsSpace.x8,
            ),
            children: [
              GreetingHeader(name: (user?.name ?? '').split(' ').first),
              const SizedBox(height: AbsSpace.x6),
              AsyncView<Member?>(
                value: member,
                onRetry: () => ref.invalidate(myMemberProvider),
                loading: const SkeletonBlock(
                  child: MemberCard(name: 'Member name', code: 'ABS-0000', phone: '+910000000000'),
                ),
                isEmpty: (m) => m == null,
                empty: const SizedBox.shrink(),
                data: (m) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MemberCard(
                      name: m!.name,
                      code: m.memberCode,
                      phone: m.phone,
                      memberId: m.id,
                      planName: m.planName,
                      validTill: m.membershipEnd,
                      status: m.status,
                    ),
                    const SizedBox(height: AbsSpace.x5),
                    _FeesCard(member: m),
                    _DaysAndVisits(member: m),
                    const SizedBox(height: AbsSpace.x5),
                    AbsButton(
                      label: l.memberCheckIn,
                      hue: PopHue.lime,
                      icon: PhosphorIcons.scan(PhosphorIconsStyle.bold),
                      onPressed: () => context.push(Routes.meCheckIn),
                    ),
                  ],
                ),
              ),
              if (user?.memberId != null) ...[
                const SizedBox(height: AbsSpace.x5),
                TodayWorkoutCard(memberId: user!.memberId!),
                const SizedBox(height: AbsSpace.x3),
                TodayDietCard(memberId: user.memberId!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Fees due (with Pay now) or a quiet link to receipts.
class _FeesCard extends StatelessWidget {
  const _FeesCard({required this.member});

  final Member member;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.text;
    final c = context.colors;
    final due = member.duesPaise > 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: AbsSpace.x5),
      child: AbsCard(
        key: const ValueKey('fees-card'),
        hue: due ? PopHue.tangerine : PopHue.mint,
        solid: due,
        onTap: () => context.push(Routes.mePayments),
        padding: const EdgeInsets.all(AbsSpace.x4),
        child: Row(
          children: [
            IconBubble(
              icon: due
                  ? PhosphorIcons.currencyInr(PhosphorIconsStyle.bold)
                  : PhosphorIcons.receipt(PhosphorIconsStyle.bold),
              hue: due ? PopHue.tangerine : PopHue.mint,
            ),
            const SizedBox(width: AbsSpace.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    due ? l.meDuesTitle : l.mePayments,
                    style: t.heading.copyWith(color: due ? c.pop(PopHue.tangerine).onFill : null),
                  ),
                  Text(
                    due ? Money.format(member.duesPaise) : l.mePaymentsSubtitle,
                    style: due
                        ? t.numericOf(t.title).copyWith(color: c.pop(PopHue.tangerine).onFill)
                        : t.caption.copyWith(color: c.textSecondary),
                  ),
                ],
              ),
            ),
            if (due)
              PopSticker(label: l.mePayNow, hue: PopHue.grape)
            else
              Icon(PhosphorIcons.caretRight(PhosphorIconsStyle.bold), size: AbsSize.iconSmall),
          ],
        ),
      ),
    );
  }
}

class _DaysAndVisits extends ConsumerWidget {
  const _DaysAndVisits({required this.member});

  final Member member;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final t = context.text;
    final days = member.daysLeft();
    final today = IstDates.today();
    final visits = ref.watch(memberAttendanceProvider(member.id)).value ?? const <Attendance>[];
    final thisMonth = visits
        .where((a) => a.day != null && a.day!.year == today.year && a.day!.month == today.month)
        .length;
    final hue = hueForStatus(member.status);
    return Row(
      children: [
        Expanded(
          child: AbsCard(
            hue: hue,
            padding: const EdgeInsets.all(AbsSpace.x4),
            child: Row(
              children: [
                ProgressRing(
                  progress: member.status.isCurrent ? 1 - member.usedFraction() : 0,
                  size: 64,
                  strokeWidth: 7,
                  hue: hue,
                  child: Text(days == null || days < 0 ? '0' : '$days', style: t.numericOf(t.heading)),
                ),
                const SizedBox(width: AbsSpace.x3),
                Expanded(
                  child: Text(
                    member.status.isCurrent && days != null ? l.daysLeft(days) : statusLabel(l, member.status),
                    style: t.label,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AbsSpace.x3),
        Expanded(
          child: StatTile(
            label: l.myVisitsTitle,
            value: thisMonth,
            hue: PopHue.mint,
            icon: PhosphorIcons.footprints(PhosphorIconsStyle.bold),
          ),
        ),
      ],
    );
  }
}

/// Digital membership card (1.16): candy gradient sticker with name, ID,
/// plan, validity and the QR the desk scans to check the member in.
class MemberCard extends StatelessWidget {
  const MemberCard({
    super.key,
    required this.name,
    required this.code,
    required this.phone,
    this.memberId,
    this.planName,
    this.validTill,
    this.status,
  });

  final String name;
  final String code;
  final String phone;
  final String? memberId;
  final String? planName;
  final DateTime? validTill;
  final MemberStatus? status;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final l = context.l10n;
    final ink = c.pop(PopHue.grape).onFill;
    return Semantics(
      container: true,
      label: '${l.memberCardTitle}: $name, $code',
      child: Container(
        padding: const EdgeInsets.all(AbsSpace.x5),
        decoration: stickerDecoration(c, color: c.pop(PopHue.grape).fill).copyWith(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [c.pop(PopHue.grape).fill, c.pop(PopHue.bubblegum).fill, c.pop(PopHue.tangerine).fill],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const BrandMark(size: 40),
                const SizedBox(width: AbsSpace.x3),
                Expanded(
                  child: Text(l.memberCardTitle.toUpperCase(), style: t.label.copyWith(color: ink, letterSpacing: 1.5)),
                ),
                if (status != null)
                  StatusPill(status: pillFor(status!), days: validTill == null ? 0 : IstDates.daysUntil(validTill!)),
              ],
            ),
            const SizedBox(height: AbsSpace.x5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: t.displayL.copyWith(color: ink, fontSize: 30),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (planName != null)
                        Text('$planName · ${l.endsOn(dateLabel(validTill))}', style: t.label.copyWith(color: ink)),
                      const SizedBox(height: AbsSpace.x2),
                      Wrap(
                        spacing: AbsSpace.x2,
                        runSpacing: AbsSpace.x2,
                        children: [
                          PopSticker(label: code, hue: PopHue.lime, numeric: true),
                          PopSticker(label: Phone.display(phone), hue: PopHue.sky, numeric: true),
                        ],
                      ),
                    ],
                  ),
                ),
                if (memberId != null) ...[
                  const SizedBox(width: AbsSpace.x3),
                  Container(
                    padding: const EdgeInsets.all(AbsSpace.x1 + 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AbsRadius.chipAll,
                      border: Border.all(color: c.ink, width: AbsDepth.outline),
                    ),
                    child: QrImageView(
                      data: memberQrPayload(memberId!),
                      size: 88,
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.white,
                      semanticsLabel: l.memberQrTitle,
                      eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.square, color: c.ink),
                      dataModuleStyle: QrDataModuleStyle(color: c.ink),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
