import 'dart:async';

import 'helpers/fonts.dart';

/// Runs before every test file: load the real fonts so text metrics (and
/// goldens) match the app.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  await loadAppFonts();
  await testMain();
}
