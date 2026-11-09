import 'package:abs_fitness/features/exercises/presentation/exercise_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump.dart';
import '../helpers/workout_fakes.dart';

void main() {
  for (final back in [false, true]) {
    testWidgets('body map ${back ? 'back' : 'front'}: tapping each muscle selects it', (tester) async {
      String? picked;
      await pumpThemed(
        tester,
        Scaffold(
          body: Center(
            child: SizedBox(
              width: 320,
              child: StatefulBuilder(
                builder: (context, setState) => BodyMap(back: back, onSelect: (m) => setState(() => picked = m)),
              ),
            ),
          ),
        ),
      );
      final muscles = back ? kBodyBack : kBodyFront;
      final box = tester.getRect(find.byType(BodyMap));
      final m = bodyTransform(box.size);
      for (final e in muscles.entries) {
        for (final shape in e.value) {
          picked = null;
          final centre = MatrixUtils.transformPoint(m, smoothBodyPath(shape).getBounds().center);
          await tester.tapAt(box.topLeft + centre);
          await tester.pump();
          expect(picked, e.key, reason: '${e.key} at $centre');
        }
      }
    });
  }

  testWidgets('a tap just beside a small muscle still selects it', (tester) async {
    String? picked;
    await pumpThemed(
      tester,
      Scaffold(
        body: Center(
          child: SizedBox(width: 320, child: BodyMap(back: false, onSelect: (m) => picked = m)),
        ),
      ),
    );
    final box = tester.getRect(find.byType(BodyMap));
    final m = bodyTransform(box.size);
    // Just outside the right abductor's outer edge.
    final edge = smoothBodyPath(kBodyFront['abductors']!.first).getBounds().centerRight + const Offset(1.5, 0);
    await tester.tapAt(box.topLeft + MatrixUtils.transformPoint(m, edge));
    await tester.pump();
    expect(picked, 'abductors');
  });

  testWidgets('every muscle shape sits inside the body outline', (tester) async {
    final body = smoothBodyPath(kBodySilhouette);
    for (final e in {...kBodyFront, ...kBodyBack}.entries) {
      for (final shape in e.value) {
        expect(body.contains(smoothBodyPath(shape).getBounds().center), isTrue, reason: e.key);
      }
    }
  });

  testWidgets('exercise photos loop like a GIF; a tap pauses and plays', (tester) async {
    final squat = seedCatalogue().firstWhere((e) => e.id == 'Barbell_Squat');
    await pumpThemed(tester, Scaffold(body: ExerciseFrames(exercise: squat)));
    final fade = tester.widget<FadeTransition>(
      find.descendant(of: find.byType(ExerciseFrames), matching: find.byType(FadeTransition)).first,
    );
    expect(fade.opacity.value, 0, reason: 'starts on the start position');
    await tester.pump(const Duration(milliseconds: 1200));
    expect(fade.opacity.value, greaterThan(0.5), reason: 'cross-fading to the end position');
    await tester.pump(const Duration(milliseconds: 600));
    expect(fade.opacity.value, 1);
    await tester.tap(find.byType(ExerciseFrames));
    await tester.pump(const Duration(milliseconds: 2000));
    expect(fade.opacity.value, 1, reason: 'paused');
    expect(find.bySemanticsLabel(RegExp('Barbell Squat')), findsOneWidget);
    await tester.tap(find.byType(ExerciseFrames));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(fade.opacity.value, lessThan(1), reason: 'playing again');
  });

  testWidgets('with reduced motion the photos stay still and a tap switches them', (tester) async {
    final squat = seedCatalogue().firstWhere((e) => e.id == 'Barbell_Squat');
    await pumpThemed(
      tester,
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: Scaffold(body: ExerciseFrames(exercise: squat)),
      ),
    );
    final fade = tester.widget<FadeTransition>(
      find.descendant(of: find.byType(ExerciseFrames), matching: find.byType(FadeTransition)).first,
    );
    await tester.pump(const Duration(seconds: 3));
    expect(fade.opacity.value, 0);
    await tester.tap(find.byType(ExerciseFrames));
    await tester.pump();
    expect(fade.opacity.value, 1);
  });
}
