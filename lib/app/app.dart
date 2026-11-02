import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/settings/application/theme_mode_controller.dart';
import 'l10n/l10n.dart';
import 'router.dart';
import 'theme/theme.dart';

class AbsApp extends ConsumerWidget {
  const AbsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appName,
      debugShowCheckedModeBanner: false,
      theme: buildAbsTheme(Brightness.light),
      darkTheme: buildAbsTheme(Brightness.dark),
      themeMode: ref.watch(themeModeControllerProvider),
      themeAnimationDuration: AbsMotion.standard.duration,
      themeAnimationCurve: AbsMotion.standard.curve,
      routerConfig: ref.watch(routerProvider),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        // Support system text scaling up to 1.3× (spec §4) and no further.
        final mq = MediaQuery.of(context);
        return MediaQuery(
          data: mq.copyWith(textScaler: mq.textScaler.clamp(maxScaleFactor: AbsTextScale.max)),
          child: child!,
        );
      },
    );
  }
}
