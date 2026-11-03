import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/utils/dates.dart';
import '../../../core/widgets/widgets.dart';
import '../../members/data/members_repository.dart';

/// Today's rotating gym code, shown on a desk tablet for member self
/// check-in (1.12). The code changes every IST day.
final todaysGymCodeProvider = FutureProvider.autoDispose<String>(
  (ref) => ref.watch(membersRepositoryProvider).todaysGymCode(),
);

class GymQrScreen extends ConsumerWidget {
  const GymQrScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final code = ref.watch(todaysGymCodeProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.gymQrTitle)),
      body: PopBackground(
        hues: const [PopHue.mint, PopHue.lime, PopHue.sky],
        child: AsyncView<String>(
          value: code,
          isEmpty: (_) => false,
          empty: const SizedBox.shrink(),
          onRetry: () => ref.invalidate(todaysGymCodeProvider),
          data: (value) => Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(context.screenPadding),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AbsSpace.x5),
                    decoration: stickerDecoration(c, color: Colors.white, outline: c.ink, lip: c.ink),
                    child: QrImageView(
                      data: value,
                      size: 260,
                      backgroundColor: Colors.white,
                      semanticsLabel: l.gymQrTitle,
                      eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.circle, color: c.ink),
                      dataModuleStyle: QrDataModuleStyle(dataModuleShape: QrDataModuleShape.circle, color: c.ink),
                    ),
                  ),
                  const SizedBox(height: AbsSpace.x5),
                  Text(IstDates.formatDate(DateTime.now()), style: context.text.title),
                  const SizedBox(height: AbsSpace.x2),
                  Text(l.gymQrBody, style: context.text.body, textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
