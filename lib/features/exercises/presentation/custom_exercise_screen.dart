import 'package:flutter/foundation.dart' show Uint8List;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/widgets/widgets.dart';
import '../application/exercise_providers.dart';
import '../domain/exercise.dart';
import 'exercise_ui.dart';

/// Trainers add the gym's own exercises (4.5): name, Hindi name, muscles,
/// equipment, how it's logged, steps, tips, a photo and a YouTube link.
class CustomExerciseScreen extends ConsumerStatefulWidget {
  const CustomExerciseScreen({super.key, this.exerciseId});

  final String? exerciseId;

  @override
  ConsumerState<CustomExerciseScreen> createState() => _CustomExerciseScreenState();
}

class _CustomExerciseScreenState extends ConsumerState<CustomExerciseScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _local = TextEditingController();
  final _steps = TextEditingController();
  final _tips = TextEditingController();
  final _mistakes = TextEditingController();
  final _video = TextEditingController();
  Set<String> _primary = {};
  Set<String> _secondary = {};
  String? _equipment = 'body only';
  String? _level = 'beginner';
  String? _category = 'strength';
  TrackingType _tracking = TrackingType.reps;
  Uint8List? _photo;
  List<String> _images = const [];
  bool _loaded = false;
  bool _busy = false;

  @override
  void dispose() {
    for (final c in [_name, _local, _steps, _tips, _mistakes, _video]) {
      c.dispose();
    }
    super.dispose();
  }

  void _load(Exercise e) {
    _loaded = true;
    _name.text = e.name;
    _local.text = e.localName ?? '';
    _steps.text = e.instructions.join('\n');
    _tips.text = e.tips ?? '';
    _mistakes.text = e.mistakes ?? '';
    _video.text = e.videoUrl ?? '';
    _primary = e.primaryMuscles.toSet();
    _secondary = e.secondaryMuscles.toSet();
    _equipment = e.equipment;
    _level = e.level;
    _category = e.category;
    _tracking = e.trackingType;
    _images = e.images;
  }

  Future<void> _pickPhoto(ImageSource source) async {
    final file = await ImagePicker().pickImage(source: source, maxWidth: 1000, maxHeight: 1000, imageQuality: 80);
    final bytes = await file?.readAsBytes();
    if (bytes != null && mounted) setState(() => _photo = bytes);
  }

  Future<void> _save() async {
    final l = context.l10n;
    if (!_form.currentState!.validate()) return;
    if (_primary.isEmpty) {
      showAbsSnackbar(context, l.exNeedsMuscle, tone: SnackTone.error);
      return;
    }
    setState(() => _busy = true);
    try {
      await ref.saveCustomExercise(
        ExerciseDraft(
          id: widget.exerciseId,
          name: _name.text,
          localName: _local.text,
          primaryMuscles: _primary.toList(),
          secondaryMuscles: _secondary.difference(_primary).toList(),
          equipment: _equipment,
          level: _level,
          category: _category,
          trackingType: _tracking,
          instructions: _steps.text.split('\n'),
          tips: _tips.text,
          mistakes: _mistakes.text,
          videoUrl: _video.text,
          images: _images,
        ),
        photo: _photo,
      );
      if (!mounted) return;
      showAbsSnackbar(context, l.exSaved, tone: SnackTone.success);
      context.pop();
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.text;
    final c = context.colors;
    if (widget.exerciseId != null && !_loaded) {
      final e = ref.watch(exerciseCatalogueProvider).value?[widget.exerciseId!];
      if (e != null) _load(e);
    }
    Widget label(String s) => Padding(
      padding: const EdgeInsets.only(top: AbsSpace.x4, bottom: AbsSpace.x2),
      child: Text(s, style: t.label.copyWith(color: c.textSecondary)),
    );
    const gap = SizedBox(height: AbsSpace.x3);
    return Scaffold(
      appBar: AppBar(title: Text(widget.exerciseId == null ? l.exNewTitle : l.exEditTitle)),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x2, context.screenPadding, AbsSpace.x2),
          child: AbsButton(
            key: const ValueKey('exercise-save'),
            label: l.commonSave,
            hue: PopHue.lime,
            isLoading: _busy,
            onPressed: _save,
          ),
        ),
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x2, context.screenPadding, AbsSpace.x10),
          children: [
            AbsTextField(
              key: const ValueKey('exercise-name'),
              label: l.exFieldName,
              controller: _name,
              validator: (s) => (s == null || s.trim().length < 2) ? l.commonRequired : null,
            ),
            gap,
            AbsTextField(label: l.exFieldLocalName, controller: _local),
            label(l.exFieldPrimary),
            PopChoiceChips<String>(
              options: kMuscles,
              labelOf: (m) => muscleLabel(l, m),
              selected: _primary,
              hue: PopHue.lime,
              onChanged: (v) => setState(() => _primary = v),
            ),
            label(l.exFieldSecondary),
            PopChoiceChips<String>(
              options: kMuscles.where((m) => !_primary.contains(m)).toList(),
              labelOf: (m) => muscleLabel(l, m),
              selected: _secondary,
              hue: PopHue.sky,
              onChanged: (v) => setState(() => _secondary = v),
            ),
            label(l.exEquipment),
            PopSingleChips<String>(
              options: kEquipment,
              labelOf: (e) => equipmentLabel(l, e),
              value: _equipment,
              hue: PopHue.mint,
              onChanged: (v) => setState(() => _equipment = v),
            ),
            label(l.exFieldTracking),
            PopSingleChips<TrackingType>(
              options: TrackingType.values,
              labelOf: (v) => trackingLabel(l, v),
              value: _tracking,
              allowEmpty: false,
              hue: PopHue.grape,
              onChanged: (v) => setState(() => _tracking = v ?? TrackingType.reps),
            ),
            label(l.exLevel),
            PopSingleChips<String>(
              options: kExerciseLevels,
              labelOf: (v) => exerciseLevelLabel(l, v),
              value: _level,
              hue: PopHue.sky,
              onChanged: (v) => setState(() => _level = v),
            ),
            label(l.exCategory),
            PopSingleChips<String>(
              options: kExerciseCategories,
              labelOf: (v) => categoryLabel(l, v),
              value: _category,
              hue: PopHue.bubblegum,
              onChanged: (v) => setState(() => _category = v),
            ),
            const SizedBox(height: AbsSpace.x4),
            TextFormField(
              controller: _steps,
              minLines: 3,
              maxLines: 8,
              decoration: InputDecoration(labelText: l.exFieldInstructions),
            ),
            gap,
            AbsTextField(label: l.exFieldTips, controller: _tips),
            gap,
            AbsTextField(label: l.exFieldMistakes, controller: _mistakes),
            gap,
            AbsTextField(
              label: l.exFieldVideo,
              controller: _video,
              keyboardType: TextInputType.url,
              validator: (s) => (s == null || s.trim().isEmpty || ExerciseDraft.isYoutube(s)) ? null : l.exBadVideo,
            ),
            label(l.exFieldPhoto),
            Row(
              children: [
                if (_photo != null)
                  ClipRRect(
                    borderRadius: AbsRadius.chipAll,
                    child: Image.memory(_photo!, width: 72, height: 72, fit: BoxFit.cover),
                  ),
                if (_photo != null) const SizedBox(width: AbsSpace.x3),
                AbsButton.ghost(
                  label: _photo == null && _images.isEmpty ? l.exPhotoAdd : l.exPhotoChange,
                  icon: PhosphorIcons.camera(PhosphorIconsStyle.bold),
                  onPressed: () => _pickPhoto(ImageSource.gallery),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
