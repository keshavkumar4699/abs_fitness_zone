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
  const env = Env.fromDefines();

  final prefs = await SharedPreferences.getInstance();
  if (env.isConfigured) {
    await Supabase.initialize(url: env.supabaseUrl, publishableKey: env.supabaseAnonKey);
  }

  void run() => runApp(
    ProviderScope(
      retry: noAutoRetry,
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs), envProvider.overrideWithValue(env)],
      child: const AbsApp(),
    ),
  );

  if (env.hasSentry) {
    await SentryFlutter.init((o) {
      o
        ..dsn = env.sentryDsn
        ..environment = env.name
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
    for (final (family, file) in [('Inter', 'OFL-Inter.txt'), ('Sora', 'OFL-Sora.txt')]) {
      yield LicenseEntryWithLineBreaks([family], await rootBundle.loadString('assets/fonts/$file'));
    }
  });
}
