import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/widgets/pop_decor.dart';

/// Off in widget tests (no camera there).
final scannerEnabledProvider = Provider<bool>((ref) => true);

/// QR payload on a member's card.
const memberQrPrefix = 'ABSM:';

String memberQrPayload(String memberId) => '$memberQrPrefix$memberId';

/// The member id inside a scanned card, or null if it isn't one.
String? memberIdFromQr(String raw) {
  final s = raw.trim();
  if (!s.startsWith(memberQrPrefix)) return null;
  final id = s.substring(memberQrPrefix.length);
  return RegExp(r'^[0-9a-f-]{36}$|^m-\d+$').hasMatch(id) ? id : null;
}

/// Rounded camera window that reports each new QR value once.
class ScannerView extends ConsumerStatefulWidget {
  const ScannerView({super.key, required this.onCode, this.hint, this.hue = PopHue.mint, this.paused = false});

  final ValueChanged<String> onCode;
  final String? hint;
  final PopHue hue;

  /// Ignore codes while a result is showing.
  final bool paused;

  @override
  ConsumerState<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends ConsumerState<ScannerView> {
  String? _last;
  DateTime _lastAt = DateTime(2000);

  void _detect(BarcodeCapture capture) {
    if (widget.paused) return;
    final value = capture.barcodes.map((b) => b.rawValue).whereType<String>().firstOrNull;
    if (value == null) return;
    final now = DateTime.now();
    // The same code is ignored for 4 seconds so one scan = one check-in.
    if (value == _last && now.difference(_lastAt) < const Duration(seconds: 4)) return;
    _last = value;
    _lastAt = now;
    widget.onCode(value);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final p = c.pop(widget.hue);
    Widget off(String text) => Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconBubble(icon: PhosphorIcons.cameraSlash(PhosphorIconsStyle.bold), hue: widget.hue, size: 56),
          const SizedBox(height: AbsSpace.x3),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AbsSpace.x5),
            child: Text(text, style: context.text.label, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: stickerDecoration(c, color: p.soft, outline: c.isDark ? p.deep : c.ink),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (ref.watch(scannerEnabledProvider))
            MobileScanner(
              onDetect: _detect,
              errorBuilder: (context, _) => off(l.checkInCameraOff),
              placeholderBuilder: (context) => const SizedBox.shrink(),
            )
          else
            off(l.checkInCameraOff),
          // Scan frame.
          IgnorePointer(
            child: Center(
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: AbsRadius.cardAll,
                  border: Border.all(color: p.fill, width: 4),
                ),
              ),
            ),
          ),
          if (widget.hint != null)
            Positioned(
              left: AbsSpace.x3,
              right: AbsSpace.x3,
              bottom: AbsSpace.x3,
              child: Text(
                widget.hint!,
                textAlign: TextAlign.center,
                style: context.text.label.copyWith(
                  color: c.textPrimary,
                  shadows: [Shadow(color: c.bg, blurRadius: 6)],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
