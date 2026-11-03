import 'package:abs_fitness/app/app.dart';
import 'package:abs_fitness/app/l10n/l10n.dart';
import 'package:abs_fitness/app/providers.dart';
import 'package:abs_fitness/app/theme/theme.dart';
import 'package:abs_fitness/features/auth/application/auth_providers.dart';
import 'package:abs_fitness/features/auth/domain/app_user.dart';
import 'package:abs_fitness/features/settings/application/theme_mode_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fakes.dart';

/// Phone viewport used by widget and golden tests (Pixel-class, 1×).
const phoneSize = Size(390, 844);

Future<SharedPreferences> testPrefs([Map<String, Object> values = const {}]) async {
  SharedPreferences.setMockInitialValues(values);
  return SharedPreferences.getInstance();
}

void setViewport(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

/// Pumps a single widget inside the app theme and localisations.
Future<void> pumpThemed(
  WidgetTester tester,
  Widget child, {
  Brightness brightness = Brightness.dark,
  double textScale = 1,
  Size size = phoneSize,
  List<Override> overrides = const [],
}) async {
  setViewport(tester, size);
  final prefs = await testPrefs();
  await tester.pumpWidget(
    ProviderScope(
      retry: noAutoRetry,
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs), ...overrides],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildAbsTheme(brightness),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: MediaQuery(
          data: MediaQueryData(size: size, textScaler: TextScaler.linear(textScale)),
          child: child,
        ),
      ),
    ),
  );
}

/// Pumps the whole app (router, shells, guards) with a fake auth backend.
Future<ProviderContainer> pumpApp(
  WidgetTester tester, {
  AppUser? user,
  FakeAuthRepository? auth,
  Brightness brightness = Brightness.dark,
  Size size = phoneSize,
  Map<String, Object> prefs = const {},
  List<Override> overrides = const [],
}) async {
  setViewport(tester, size);
  final p = await testPrefs({'theme_mode': brightness == Brightness.dark ? 'dark' : 'light', ...prefs});
  final repo = auth ?? FakeAuthRepository(user);
  final container = ProviderContainer(
    retry: noAutoRetry,
    overrides: [
      sharedPreferencesProvider.overrideWithValue(p),
      authRepositoryProvider.overrideWithValue(repo),
      // Fixed clock: 3 Nov 2026, 10:00 IST.
      clockProvider.overrideWithValue(() => DateTime.utc(2026, 11, 3, 4, 30)),
      ...overrides,
    ],
  );
  addTearDown(container.dispose);
  // Touch the theme controller so it reads the saved mode.
  container.read(themeModeControllerProvider);
  await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const AbsApp()));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
  return container;
}
