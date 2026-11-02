import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/widgets/abs_button.dart';
import '../../../core/widgets/brand_mark.dart';
import '../../../core/widgets/states.dart';
import '../application/auth_providers.dart';

/// Shown while the session resolves; shows error + retry if the profile
/// could not be loaded (e.g. offline on first launch).
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(currentUserProvider);
    if (auth.hasError && !auth.hasValue) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ErrorState(
                  message: friendlyError(context.l10n, auth.error!),
                  onRetry: () => ref.invalidate(currentUserProvider),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(context.screenPadding),
                child: AbsButton.ghost(
                  label: context.l10n.commonSignOut,
                  onPressed: () async {
                    await ref.read(authRepositoryProvider).signOut();
                    ref.invalidate(currentUserProvider);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
    const mark = BrandMark(size: AbsSpace.x14 + AbsSpace.x6);
    return Scaffold(
      body: Center(
        child: AbsMotion.reduced(context)
            ? mark
            : mark
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scaleXY(
                    begin: 1,
                    end: 1.04,
                    duration: AbsMotion.expressive.duration * 2,
                    curve: AbsMotion.quick.curve,
                  ),
      ),
    );
  }
}
