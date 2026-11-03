import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../members/domain/models.dart';
import '../../members/presentation/member_ui.dart';
import '../../members/presentation/widgets/member_photo.dart';

/// Full-screen result: a happy tick that closes itself after 1.2 s, or a
/// warning (expired, frozen, cancelled, no plan) that needs a tap.
Future<void> showCheckInResult(BuildContext context, CheckInResult r) {
  if (r.needsAttention) {
    HapticFeedback.heavyImpact();
  } else {
    HapticFeedback.mediumImpact();
  }
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: context.l10n.checkInOk,
    transitionDuration: AbsMotion.standard.duration,
    pageBuilder: (context, _, _) => _ResultView(result: r),
    transitionBuilder: (context, anim, _, child) => FadeTransition(
      opacity: anim,
      child: ScaleTransition(
        scale: Tween(begin: 0.9, end: 1.0).animate(CurvedAnimation(parent: anim, curve: AbsMotion.bouncy.curve)),
        child: child,
      ),
    ),
  );
}

class _ResultView extends StatefulWidget {
  const _ResultView({required this.result});

  final CheckInResult result;

  @override
  State<_ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<_ResultView> {
  Timer? _close;

  @override
  void initState() {
    super.initState();
    if (!widget.result.needsAttention) {
      _close = Timer(const Duration(milliseconds: 1200), () {
        if (mounted) Navigator.of(context).maybePop();
      });
    }
  }

  @override
  void dispose() {
    _close?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final r = widget.result;
    final warn = r.needsAttention;
    final hue = warn ? (r.status == MemberStatus.frozen ? PopHue.sky : PopHue.coral) : PopHue.mint;
    final p = c.pop(hue);
    final warning = switch (r.status) {
      MemberStatus.frozen => l.checkInWarnFrozen,
      MemberStatus.cancelled => l.checkInWarnCancelled,
      MemberStatus.expired => l.checkInWarnExpired,
      _ => l.checkInWarnInactive,
    };
    return Material(
      color: p.fill,
      child: Stack(
        children: [
          SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(context.screenPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: c.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: c.ink, width: 3),
                      ),
                      child: Icon(
                        warn
                            ? PhosphorIcons.warning(PhosphorIconsStyle.bold)
                            : PhosphorIcons.check(PhosphorIconsStyle.bold),
                        size: 56,
                        color: c.pop(hue).text,
                      ),
                    ),
                    const SizedBox(height: AbsSpace.x5),
                    MemberPhoto(name: r.name, path: r.photoPath, size: 72),
                    const SizedBox(height: AbsSpace.x3),
                    Text(
                      l.checkInWelcome(r.name.split(' ').first),
                      style: t.displayL.copyWith(color: p.onFill),
                      textAlign: TextAlign.center,
                    ),
                    Text(r.memberCode, style: t.numericOf(t.label).copyWith(color: p.onFill)),
                    const SizedBox(height: AbsSpace.x4),
                    if (warn)
                      Text(
                        warning,
                        style: t.title.copyWith(color: p.onFill),
                        textAlign: TextAlign.center,
                      )
                    else if (r.daysLeft != null)
                      Text(l.checkInDaysLeft(r.daysLeft!), style: t.title.copyWith(color: p.onFill)),
                    if (r.already) ...[
                      const SizedBox(height: AbsSpace.x2),
                      PopSticker(label: l.checkInAlready, hue: PopHue.grape),
                    ],
                    if (r.planName != null) Text(r.planName!, style: t.body.copyWith(color: p.onFill)),
                    if (warn) ...[
                      const SizedBox(height: AbsSpace.x6),
                      AbsButton.secondary(
                        label: l.checkInOk,
                        onPressed: () => Navigator.of(context).pop(),
                        expand: false,
                      ),
                    ],
                    if (!warn)
                      Text(
                        statusLabel(l, r.status, days: r.daysLeft ?? 0),
                        style: t.label.copyWith(color: p.onFill),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (!warn) const Positioned.fill(child: ConfettiBurst()),
        ],
      ),
    );
  }
}
