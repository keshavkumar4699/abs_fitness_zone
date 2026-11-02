import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../app/l10n/l10n.dart';
import '../../app/theme/theme.dart';
import 'abs_button.dart';

/// Small line illustration, one sentence, one primary action.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.illustration = EmptyIllustration.dumbbell,
  });

  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final EmptyIllustration illustration;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.screenPadding),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox.square(
                dimension: AbsSize.emptyIllustration,
                child: CustomPaint(painter: _LineIllustration(illustration, c.textSecondary, c.accent)),
              ),
              const SizedBox(height: AbsSpace.x5),
              Text(title, style: t.title, textAlign: TextAlign.center),
              const SizedBox(height: AbsSpace.x2),
              Text(
                message,
                style: t.body.copyWith(color: c.textSecondary),
                textAlign: TextAlign.center,
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: AbsSpace.x6),
                AbsButton(label: actionLabel!, onPressed: onAction, expand: false),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Message plus retry.
class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.screenPadding),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(PhosphorIcons.warningCircle(), size: AbsSpace.x10, color: c.danger),
              const SizedBox(height: AbsSpace.x4),
              Text(message, style: context.text.body, textAlign: TextAlign.center),
              const SizedBox(height: AbsSpace.x5),
              AbsButton.secondary(
                label: context.l10n.commonRetry,
                icon: PhosphorIcons.arrowClockwise(),
                onPressed: onRetry,
                expand: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum EmptyIllustration { dumbbell, people, search, clock }

/// Simple original line drawings (no third-party artwork).
class _LineIllustration extends CustomPainter {
  _LineIllustration(this.kind, this.line, this.accent);

  final EmptyIllustration kind;
  final Color line;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = AbsSize.iconStroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = line;
    final a = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = AbsSize.iconStroke * 1.5
      ..strokeCap = StrokeCap.round
      ..color = accent;

    // Soft ground line shared by every illustration.
    canvas.drawLine(Offset(s * .15, s * .86), Offset(s * .85, s * .86), p);

    switch (kind) {
      case EmptyIllustration.dumbbell:
        final bar = s * .5;
        canvas.drawLine(Offset(s * .22, bar), Offset(s * .78, bar), a);
        for (final x in [.18, .26, .74, .82]) {
          final h = (x == .18 || x == .82) ? s * .14 : s * .22;
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(center: Offset(s * x, bar), width: s * .06, height: h),
              const Radius.circular(3),
            ),
            p,
          );
        }
      case EmptyIllustration.people:
        canvas.drawCircle(Offset(s * .4, s * .38), s * .1, p);
        canvas.drawArc(
          Rect.fromCenter(center: Offset(s * .4, s * .72), width: s * .36, height: s * .3),
          3.4,
          2.6,
          false,
          p,
        );
        canvas.drawCircle(Offset(s * .64, s * .42), s * .08, a);
        canvas.drawArc(
          Rect.fromCenter(center: Offset(s * .64, s * .72), width: s * .26, height: s * .22),
          3.4,
          2.6,
          false,
          a,
        );
      case EmptyIllustration.search:
        canvas.drawCircle(Offset(s * .44, s * .44), s * .2, p);
        canvas.drawLine(Offset(s * .59, s * .59), Offset(s * .74, s * .74), a);
      case EmptyIllustration.clock:
        canvas.drawCircle(Offset(s * .5, s * .48), s * .26, p);
        canvas.drawLine(Offset(s * .5, s * .48), Offset(s * .5, s * .32), a);
        canvas.drawLine(Offset(s * .5, s * .48), Offset(s * .62, s * .54), a);
    }
  }

  @override
  bool shouldRepaint(_LineIllustration old) => old.kind != kind || old.line != line || old.accent != accent;
}
