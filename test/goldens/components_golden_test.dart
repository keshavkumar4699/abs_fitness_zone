@Tags(['golden'])
library;

import 'package:abs_fitness/features/gallery/presentation/gallery_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump.dart';

/// Every core component, light/dark, at 1.0× and 1.3× text (spec §8).
void main() {
  const size = Size(390, 2300);
  for (final brightness in Brightness.values) {
    for (final scale in [1.0, 1.3]) {
      final tag = '${brightness.name}_${scale == 1 ? '1x' : '1_3x'}';

      testWidgets('gallery components $tag', (tester) async {
        await pumpThemed(
          tester,
          const Scaffold(body: GalleryContent()),
          brightness: brightness,
          textScale: scale,
          size: size,
        );
        for (var i = 0; i < 20; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }
        await expectLater(find.byType(GalleryContent), matchesGoldenFile('components/gallery_components_$tag.png'));
      });

      testWidgets('gallery lists and states $tag', (tester) async {
        await pumpThemed(
          tester,
          const Scaffold(body: GalleryStatesContent()),
          brightness: brightness,
          textScale: scale,
          size: const Size(390, 1700),
        );
        for (var i = 0; i < 20; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }
        await expectLater(find.byType(GalleryStatesContent), matchesGoldenFile('components/gallery_states_$tag.png'));
      });
    }
  }
}
