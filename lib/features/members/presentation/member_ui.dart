import 'package:flutter/widgets.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/utils/dates.dart';
import '../../../core/widgets/status_pill.dart';
import '../domain/models.dart';

PillStatus pillFor(MemberStatus s) => switch (s) {
  MemberStatus.active => PillStatus.active,
  MemberStatus.expiring => PillStatus.expiring,
  MemberStatus.expired => PillStatus.expired,
  MemberStatus.frozen => PillStatus.frozen,
  MemberStatus.cancelled => PillStatus.cancelled,
  MemberStatus.inactive => PillStatus.inactive,
  MemberStatus.pending => PillStatus.pending,
  MemberStatus.upcoming => PillStatus.upcoming,
};

PopHue hueForStatus(MemberStatus s) => StatusPill.hueFor(pillFor(s));

String statusLabel(AppLocalizations l, MemberStatus s, {int days = 0}) => switch (s) {
  MemberStatus.active => l.statusActive,
  MemberStatus.expiring => l.statusExpiring(days),
  MemberStatus.expired => l.statusExpired,
  MemberStatus.frozen => l.statusFrozen,
  MemberStatus.cancelled => l.statusCancelled,
  MemberStatus.inactive => l.statusInactive,
  MemberStatus.pending => l.statusPending,
  MemberStatus.upcoming => l.statusUpcoming,
};

String genderLabel(AppLocalizations l, String g) => switch (g) {
  'male' => l.genderMale,
  'female' => l.genderFemale,
  _ => l.genderOther,
};

String batchLabel(AppLocalizations l, String b) => b == 'evening' ? l.batchEvening : l.batchMorning;

String goalLabel(AppLocalizations l, String g) => switch (g) {
  'fat_loss' => l.goalFatLoss,
  'muscle_gain' => l.goalMuscleGain,
  'strength' => l.goalStrength,
  'rehab' => l.goalRehab,
  _ => l.goalGeneral,
};

String levelLabel(AppLocalizations l, String v) => switch (v) {
  'intermediate' => l.levelIntermediate,
  'advanced' => l.levelAdvanced,
  _ => l.levelBeginner,
};

String dateLabel(DateTime? d) => d == null ? '—' : IstDates.formatDate(d, isDateOnly: true);

/// Friendly pre-filled WhatsApp text for a member, by situation.
String reminderText(AppLocalizations l, Member m, String gym) {
  final first = m.name.split(' ').first;
  return switch (m.status) {
    MemberStatus.expired ||
    MemberStatus.inactive ||
    MemberStatus.cancelled => l.whatsappExpiredText(first, gym, dateLabel(m.membershipEnd)),
    _ when m.membershipEnd != null => l.whatsappReminderText(first, m.planName ?? '', gym, dateLabel(m.membershipEnd)),
    _ => l.whatsappAbsentText(first, gym),
  };
}

/// Days-left text for a member row ("12 days left", status otherwise).
Widget memberStatusSticker(BuildContext context, Member m) {
  final days = m.daysLeft();
  if (m.status.isCurrent && days != null && days >= 0) {
    return PopSticker(label: context.l10n.daysLeft(days), hue: hueForStatus(m.status), numeric: true);
  }
  return StatusPill(status: pillFor(m.status), days: days ?? 0);
}
