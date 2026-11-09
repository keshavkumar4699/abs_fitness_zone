import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/routes.dart';
import '../../../app/theme/theme.dart';
import '../../../core/utils/dates.dart';
import '../../../core/widgets/widgets.dart';
import '../../members/presentation/member_ui.dart' show batchLabel;
import '../../members/presentation/widgets/member_photo.dart';
import '../../settings/data/staff_repository.dart';
import '../application/whatsapp_providers.dart';
import '../domain/whatsapp_models.dart';

String messageStatusLabel(AppLocalizations l, MessageStatus s) => switch (s) {
  MessageStatus.queued => l.waStatusQueued,
  MessageStatus.sending => l.waStatusSending,
  MessageStatus.sent => l.waStatusSent,
  MessageStatus.delivered => l.waStatusDelivered,
  MessageStatus.read => l.waStatusRead,
  MessageStatus.failed => l.waStatusFailed,
  MessageStatus.skipped => l.waStatusSkipped,
  MessageStatus.cancelled => l.waStatusCancelled,
};

PopHue messageStatusHue(MessageStatus s) => switch (s) {
  MessageStatus.queued || MessageStatus.sending => PopHue.sky,
  MessageStatus.sent => PopHue.mint,
  MessageStatus.delivered || MessageStatus.read => PopHue.lime,
  MessageStatus.failed => PopHue.coral,
  MessageStatus.skipped || MessageStatus.cancelled => PopHue.grape,
};

/// The name staff see for a template key.
String messageKindLabel(AppLocalizations l, String key) => switch (key) {
  'expiry_soon' => l.waKeyExpirySoon,
  'expiry_today' => l.waKeyExpiryToday,
  'expired' => l.waKeyExpired,
  'dues_reminder' || 'dues_reminder_desk' => l.waKeyDues,
  'payment_received' => l.waKeyPayment,
  'membership_started' => l.waKeyMembershipStarted,
  'membership_renewed' => l.waKeyMembershipRenewed,
  'program_assigned' => l.waKeyProgram,
  'diet_assigned' => l.waKeyDiet,
  'birthday' => l.waKeyBirthday,
  'festival' => l.waKeyFestival,
  'manual' => l.waKeyManual,
  _ when key.startsWith('broadcast') => l.waKeyBroadcast,
  _ => key,
};

IconData messageKindIcon(String key) => switch (key) {
  'expiry_soon' || 'expiry_today' => PhosphorIcons.hourglassMedium(PhosphorIconsStyle.bold),
  'expired' => PhosphorIcons.calendarX(PhosphorIconsStyle.bold),
  'dues_reminder' || 'dues_reminder_desk' => PhosphorIcons.currencyInr(PhosphorIconsStyle.bold),
  'payment_received' => PhosphorIcons.receipt(PhosphorIconsStyle.bold),
  'membership_started' || 'membership_renewed' => PhosphorIcons.sparkle(PhosphorIconsStyle.bold),
  'program_assigned' => PhosphorIcons.barbell(PhosphorIconsStyle.bold),
  'diet_assigned' => PhosphorIcons.forkKnife(PhosphorIconsStyle.bold),
  'birthday' => PhosphorIcons.cake(PhosphorIconsStyle.bold),
  'festival' => PhosphorIcons.confetti(PhosphorIconsStyle.bold),
  'manual' => PhosphorIcons.handTap(PhosphorIconsStyle.bold),
  _ => PhosphorIcons.megaphone(PhosphorIconsStyle.bold),
};

PopHue messageKindHue(String key) => switch (key) {
  'expiry_soon' || 'expiry_today' => PopHue.tangerine,
  'expired' || 'dues_reminder' || 'dues_reminder_desk' => PopHue.coral,
  'payment_received' || 'membership_started' || 'membership_renewed' => PopHue.mint,
  'program_assigned' || 'diet_assigned' => PopHue.lime,
  'birthday' || 'festival' => PopHue.bubblegum,
  'manual' => PopHue.sky,
  _ => PopHue.grape,
};

String categoryLabel(AppLocalizations l, MessageCategory c) =>
    c == MessageCategory.marketing ? l.waTemplateMarketing : l.waTemplateUtility;

String segmentLabel(AppLocalizations l, Segment s, {List<StaffMember> trainers = const []}) => switch (s.kind) {
  'active' => l.waSegActive,
  'expiring' => l.waSegExpiring,
  'expired' => l.waSegExpired,
  'dues' => l.waSegDues,
  'trainer' =>
    s.trainerId == null
        ? l.waSegTrainer
        : l.waSegTrainerNamed(trainers.where((t) => t.id == s.trainerId).firstOrNull?.name ?? l.waSegTrainer),
  'batch' => s.batch == null ? l.waSegBatch : batchLabel(l, s.batch!),
  'members' => l.waSegMembers(s.memberIds.length),
  _ => l.waSegAll,
};

/// "Sent 3 Nov, 9:02 am" or when it is due.
String messageWhen(AppLocalizations l, QueuedMessage m) {
  final at = m.readAt ?? m.deliveredAt ?? m.sentAt;
  if (at != null) return IstDates.formatDateTime(at);
  return IstDates.formatDateTime(m.scheduledFor);
}

/// One message in the log: who, which message, when, how, and its status.
class MessageTile extends StatelessWidget {
  const MessageTile({super.key, required this.message, this.showMember = true, this.onTap});

  final QueuedMessage message;
  final bool showMember;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final m = message;
    return Padding(
      padding: const EdgeInsets.only(bottom: AbsSpace.x3),
      child: AbsCard(
        onTap: onTap,
        padding: const EdgeInsets.all(AbsSpace.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (showMember)
                  MemberPhoto(name: m.memberName, path: m.memberPhoto, size: 36)
                else
                  IconBubble(icon: messageKindIcon(m.kind), hue: messageKindHue(m.kind), size: 36),
                const SizedBox(width: AbsSpace.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        showMember ? m.memberName : messageKindLabel(l, m.kind),
                        style: t.heading,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        [
                          if (showMember) messageKindLabel(l, m.kind),
                          messageWhen(l, m),
                          m.channel == MessageChannel.api ? l.waChannelApi : l.waChannelLink,
                        ].join(' · '),
                        style: t.caption.copyWith(color: c.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AbsSpace.x2),
                PopSticker(label: messageStatusLabel(l, m.status), hue: messageStatusHue(m.status)),
              ],
            ),
            const SizedBox(height: AbsSpace.x3),
            Text(m.body, style: t.body, maxLines: 4, overflow: TextOverflow.ellipsis),
            if (m.freeWindow || (m.error != null && !m.status.isDone)) ...[
              const SizedBox(height: AbsSpace.x2),
              Text(
                m.freeWindow ? l.waFreeWindow : m.error!,
                style: t.caption.copyWith(color: m.freeWindow ? c.pop(PopHue.mint).text : c.pop(PopHue.coral).text),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Staff home: what is left to send today (front desk and owner).
class WhatsAppTodayCard extends ConsumerWidget {
  const WhatsAppTodayCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final summary = ref.watch(queueSummaryProvider);
    return AsyncView<QueueSummary>(
      value: summary,
      isEmpty: (_) => false,
      empty: const SizedBox.shrink(),
      onRetry: () => ref.invalidate(queueSummaryProvider),
      loading: const SkeletonBlock(child: SizedBox(height: 84, width: double.infinity)),
      data: (s) => AbsCard(
        key: const ValueKey('wa-today'),
        hue: s.toSend > 0 ? PopHue.mint : null,
        onTap: () => context.push(Routes.whatsApp),
        padding: const EdgeInsets.all(AbsSpace.x4),
        child: Row(
          children: [
            IconBubble(icon: PhosphorIcons.whatsappLogo(PhosphorIconsStyle.bold), hue: PopHue.mint),
            const SizedBox(width: AbsSpace.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.waTodayTitle, style: t.heading),
                  Text(
                    s.toSend == 0 ? l.waTodayAllDone : l.waTodayBody(s.toSend, s.sentToday),
                    style: t.caption.copyWith(color: c.textSecondary),
                  ),
                ],
              ),
            ),
            if (s.toSend > 0) PopSticker(label: '${s.toSend}', hue: PopHue.mint, numeric: true),
            const SizedBox(width: AbsSpace.x2),
            Icon(PhosphorIcons.caretRight(PhosphorIconsStyle.bold), size: AbsSize.iconSmall, color: c.textSecondary),
          ],
        ),
      ),
    );
  }
}
