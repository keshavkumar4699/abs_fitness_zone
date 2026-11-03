import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'app/env.dart';
import 'app/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _registerFontLicenses();

  var env = const Env.fromDefines();
  final prefs = await SharedPreferences.getInstance();
  if (env.isConfigured) {
    try {
      await Supabase.initialize(url: env.supabaseUrl, publishableKey: env.supabaseAnonKey);
    } catch (e) {
      // A bad URL or key must not crash the app on launch: open without a
      // backend and explain on the welcome screen.
      debugPrint('Supabase init failed: $e');
      env = env.withError('$e');
    }
  }
  final appEnv = env;

  void run() => runApp(
    ProviderScope(
      retry: noAutoRetry,
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs), envProvider.overrideWithValue(appEnv)],
      child: const AbsApp(),
    ),
  );

  if (appEnv.hasSentry) {
    await SentryFlutter.init((o) {
      o
        ..dsn = appEnv.sentryDsn
        ..environment = appEnv.name
        // Never attach personal data (names, phones) to crash reports.
        ..sendDefaultPii = false
        ..tracesSampleRate = 0.1;
    }, appRunner: run);
  } else {
    run();
  }
}

/// Bundled fonts are SIL OFL 1.1; show their licences on the licence page.
void _registerFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    for (final (family, file) in [('Baloo 2', 'OFL-baloo-2.txt'), ('Nunito', 'OFL-nunito.txt')]) {
      yield LicenseEntryWithLineBreaks([family], await rootBundle.loadString('assets/fonts/$file'));
    }
  });
}
