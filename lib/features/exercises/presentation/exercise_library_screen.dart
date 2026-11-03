import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/routes.dart';
import 'exercise_library.dart';

/// The exercise library on its own (member app).
class ExerciseLibraryScreen extends StatelessWidget {
  const ExerciseLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.exTitle)),
    body: ExerciseLibraryView(onOpen: (e) => context.push(Routes.meExercise(e.id))),
  );
}
