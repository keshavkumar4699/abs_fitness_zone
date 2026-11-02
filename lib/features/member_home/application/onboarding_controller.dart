import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/providers.dart';

part 'onboarding_controller.g.dart';

/// Whether this device has shown the 3-card member onboarding.
@Riverpod(keepAlive: true)
class OnboardingController extends _$OnboardingController {
  static const _key = 'member_onboarding_done';

  @override
  bool build() => ref.watch(sharedPreferencesProvider).getBool(_key) ?? false;

  Future<void> complete() async {
    state = true;
    await ref.read(sharedPreferencesProvider).setBool(_key, true);
  }
}
