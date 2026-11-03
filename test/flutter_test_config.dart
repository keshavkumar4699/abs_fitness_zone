import 'dart:async';

import 'package:abs_fitness/core/utils/dates.dart';

import 'helpers/fonts.dart';

/// Runs before every test file: load the real fonts so text metrics (and
/// goldens) match the app.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  await loadAppFonts();
  // Every test runs on 3 Nov 2026, 10:00 IST so dates and days-left are stable.
  IstDates.clock = () => DateTime.utc(2026, 11, 3, 4, 30);
  await testMain();
}
