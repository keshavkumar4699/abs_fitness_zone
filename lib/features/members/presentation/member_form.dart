import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/utils/dates.dart';
import '../../../core/utils/phone.dart';
import '../../../core/utils/phone_input.dart';
import '../../../core/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../application/members_providers.dart';
import '../domain/models.dart';
import 'member_ui.dart';

const parqKeys = ['heart', 'chest_pain', 'dizzy', 'bone', 'bp', 'pregnant', 'other'];

String parqQuestion(AppLocalizations l, String key) => switch (key) {
  'heart' => l.parqHeart,
  'chest_pain' => l.parqChestPain,
  'dizzy' => l.parqDizzy,
  'bone' => l.parqBone,
  'bp' => l.parqBp,
  'pregnant' => l.parqPregnant,
  _ => l.parqOther,
};

/// All editable values of the member form; shared by add + edit and saved as
/// an on-device draft while adding.
class MemberFormData extends ChangeNotifier {
  MemberFormData() {
    for (final c in _controllers) {
      c.addListener(notifyListeners);
    }
  }

  factory MemberFormData.fromMember(Member m) {
    final f = MemberFormData();
    f.name.text = m.name;
    f.phone.text = Phone.local(m.phone);
    f.altPhone.text = m.altPhone == null ? '' : Phone.local(m.altPhone!);
    f.email.text = m.email ?? '';
    f.address.text = m.address ?? '';
    f.emergencyName.text = m.emergencyName ?? '';
    f.emergencyRelation.text = m.emergencyRelation ?? '';
    f.emergencyPhone.text = m.emergencyPhone == null ? '' : Phone.local(m.emergencyPhone!);
    f.source.text = m.source ?? '';
    f.notes.text = m.notes ?? '';
    f.gender = m.gender;
    f.dob = m.dob;
    f.bloodGroup = m.bloodGroup;
    f.batch = m.batch;
    f.trainerId = m.trainerId;
    f.goal = m.goal;
    f.level = m.level;
    return f;
  }

  final name = TextEditingController();
  final phone = TextEditingController();
  final altPhone = TextEditingController();
  final email = TextEditingController();
  final address = TextEditingController();
  final emergencyName = TextEditingController();
  final emergencyRelation = TextEditingController();
  final emergencyPhone = TextEditingController();
  final source = TextEditingController();
  final notes = TextEditingController();
  final height = TextEditingController();
  final weight = TextEditingController();
  final conditions = TextEditingController();
  final injuries = TextEditingController();
  final medications = TextEditingController();
  final discount = TextEditingController();
  final discountReason = TextEditingController();

  List<TextEditingController> get _controllers => [
    name, phone, altPhone, email, address, emergencyName, emergencyRelation, emergencyPhone, source, notes, //
    height, weight, conditions, injuries, medications, discount, discountReason,
  ];

  String? gender;
  DateTime? dob;
  String? bloodGroup;
  String? batch;
  String? trainerId;
  String? goal;
  String? level;
  Map<String, bool> parq = {};
  bool doctorClearance = false;
  bool consentHealth = false;
  bool consentWhatsapp = true;
  Uint8List? photo;
  String? planId;
  DateTime? startDate;
  Set<String> addonIds = {};

  void set(VoidCallback change) {
    change();
    notifyListeners();
  }

  bool get hasHealth =>
      height.text.trim().isNotEmpty ||
      weight.text.trim().isNotEmpty ||
      conditions.text.trim().isNotEmpty ||
      injuries.text.trim().isNotEmpty ||
      medications.text.trim().isNotEmpty ||
      parq.values.any((v) => v) ||
      doctorClearance;

  bool get parqFlagged => parq.values.any((v) => v);

  String? _phone(TextEditingController c) => c.text.trim().isEmpty ? null : Phone.normalize(c.text);
  String? _t(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();

  Map<String, dynamic> memberJson() => {
    'name': name.text.trim(),
    'phone': Phone.normalize(phone.text),
    'alt_phone': _phone(altPhone),
    'email': _t(email)?.toLowerCase(),
    'gender': gender,
    'dob': dateParam(dob),
    'address': _t(address),
    'emergency_name': _t(emergencyName),
    'emergency_relation': _t(emergencyRelation),
    'emergency_phone': _phone(emergencyPhone),
    'blood_group': bloodGroup,
    'batch': batch,
    'trainer_id': trainerId,
    'source': _t(source),
    'notes': _t(notes),
    'goal': goal,
    'level': level,
  };

  Map<String, dynamic>? healthJson() => !hasHealth
      ? null
      : {
          'height_cm': num.tryParse(height.text.trim()),
          'weight_kg': num.tryParse(weight.text.trim()),
          'conditions': _t(conditions),
          'injuries': _t(injuries),
          'medications': _t(medications),
          'parq': parq,
          'doctor_clearance': doctorClearance,
        };

  Map<String, dynamic> toDraft() => {
    ...memberJson(),
    'phone_raw': phone.text,
    'alt_raw': altPhone.text,
    'emergency_raw': emergencyPhone.text,
    'height': height.text,
    'weight': weight.text,
    'conditions': conditions.text,
    'injuries': injuries.text,
    'medications': medications.text,
    'parq': parq,
    'doctor_clearance': doctorClearance,
    'consent_health': consentHealth,
    'consent_whatsapp': consentWhatsapp,
    'plan_id': planId,
    'start_date': dateParam(startDate),
    'addon_ids': addonIds.toList(),
    'discount': discount.text,
    'discount_reason': discountReason.text,
  };

  void restoreDraft(Map<String, dynamic> d) {
    String s(String k) => (d[k] as String?) ?? '';
    name.text = s('name');
    phone.text = s('phone_raw');
    altPhone.text = s('alt_raw');
    email.text = s('email');
    address.text = s('address');
    emergencyName.text = s('emergency_name');
    emergencyRelation.text = s('emergency_relation');
    emergencyPhone.text = s('emergency_raw');
    source.text = s('source');
    notes.text = s('notes');
    height.text = s('height');
    weight.text = s('weight');
    conditions.text = s('conditions');
    injuries.text = s('injuries');
    medications.text = s('medications');
    discount.text = s('discount');
    discountReason.text = s('discount_reason');
    gender = d['gender'] as String?;
    dob = d['dob'] == null ? null : DateTime.tryParse(d['dob'] as String);
    bloodGroup = d['blood_group'] as String?;
    batch = d['batch'] as String?;
    trainerId = d['trainer_id'] as String?;
    goal = d['goal'] as String?;
    level = d['level'] as String?;
    parq = {for (final e in ((d['parq'] as Map?) ?? {}).entries) e.key as String: e.value == true};
    doctorClearance = d['doctor_clearance'] == true;
    consentHealth = d['consent_health'] == true;
    consentWhatsapp = d['consent_whatsapp'] != false;
    planId = d['plan_id'] as String?;
    startDate = d['start_date'] == null ? null : DateTime.tryParse(d['start_date'] as String);
    addonIds = {...((d['addon_ids'] as List?) ?? const []).cast<String>()};
    notifyListeners();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }
}

/// Photo picker: camera or gallery, resized to 400 px wide (1.1).
Future<Uint8List?> pickMemberPhoto(BuildContext context) async {
  final l = context.l10n;
  final source = await showAbsBottomSheet<ImageSource>(
    context: context,
    builder: (context, controller) => ListView(
      controller: controller,
      padding: EdgeInsets.symmetric(horizontal: context.screenPadding),
      children: [
        Text(l.fieldPhoto, style: context.text.title),
        const SizedBox(height: AbsSpace.x3),
        ListTile(
          leading: Icon(PhosphorIcons.camera(PhosphorIconsStyle.bold)),
          title: Text(l.fieldPhotoAdd),
          onTap: () => Navigator.pop(context, ImageSource.camera),
        ),
        ListTile(
          leading: Icon(PhosphorIcons.images(PhosphorIconsStyle.bold)),
          title: Text(l.fieldPhotoChange),
          onTap: () => Navigator.pop(context, ImageSource.gallery),
        ),
      ],
    ),
  );
  if (source == null) return null;
  final file = await ImagePicker().pickImage(source: source, maxWidth: 400, maxHeight: 400, imageQuality: 80);
  return file?.readAsBytes();
}

/// Step 1 — basics (1.1). Also used by the edit screen.
class MemberBasicsFields extends ConsumerWidget {
  const MemberBasicsFields({super.key, required this.data, this.existingPhotoPath});

  final MemberFormData data;
  final String? existingPhotoPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final v = Validators(l);
    final trainers = ref.watch(trainersProvider).value ?? const [];
    String? optionalPhone(String? s) => (s == null || s.isEmpty) ? null : v.phone(s);
    const gap = SizedBox(height: AbsSpace.x4);
    return ListenableBuilder(
      listenable: data,
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: GestureDetector(
              onTap: () async {
                final bytes = await pickMemberPhoto(context);
                if (bytes != null) data.set(() => data.photo = bytes);
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  if (data.photo != null)
                    CircleAvatar(radius: 44, backgroundImage: MemoryImage(data.photo!))
                  else
                    AbsAvatar(name: data.name.text.isEmpty ? '?' : data.name.text, size: 88, hue: PopHue.sky),
                  Positioned(
                    right: -4,
                    bottom: -4,
                    child: IconBubble(
                      icon: PhosphorIcons.camera(PhosphorIconsStyle.bold),
                      hue: PopHue.tangerine,
                      size: 34,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AbsSpace.x5),
          AbsTextField(
            label: l.fieldName,
            controller: data.name,
            validator: v.required,
            textInputAction: TextInputAction.next,
          ),
          gap,
          AbsTextField(
            label: l.fieldPhone,
            controller: data.phone,
            prefixText: '+91',
            numeric: true,
            keyboardType: TextInputType.phone,
            inputFormatters: const [IndianMobileInputFormatter()],
            validator: v.phone,
          ),
          gap,
          AbsTextField(
            label: l.fieldEmail,
            controller: data.email,
            keyboardType: TextInputType.emailAddress,
            validator: (s) => (s == null || s.trim().isEmpty) ? null : v.email(s),
          ),
          gap,
          Text(l.fieldGender, style: context.text.label),
          const SizedBox(height: AbsSpace.x2),
          PopSingleChips<String>(
            options: const ['male', 'female', 'other'],
            labelOf: (g) => genderLabel(l, g),
            value: data.gender,
            hue: PopHue.sky,
            onChanged: (g) => data.set(() => data.gender = g),
          ),
          gap,
          DateField(
            label: l.fieldDob,
            value: data.dob,
            last: IstDates.today(),
            onChanged: (d) => data.set(() => data.dob = d),
          ),
          gap,
          Text(l.fieldBatch, style: context.text.label),
          const SizedBox(height: AbsSpace.x2),
          PopSingleChips<String>(
            options: const ['morning', 'evening'],
            labelOf: (b) => batchLabel(l, b),
            value: data.batch,
            hue: PopHue.lime,
            onChanged: (b) => data.set(() => data.batch = b),
          ),
          if (trainers.isNotEmpty) ...[
            gap,
            Text(l.fieldTrainer, style: context.text.label),
            const SizedBox(height: AbsSpace.x2),
            PopSingleChips<String>(
              options: [for (final t in trainers) t.id],
              labelOf: (id) => trainers.firstWhere((t) => t.id == id).name,
              value: data.trainerId,
              hue: PopHue.bubblegum,
              onChanged: (id) => data.set(() => data.trainerId = id),
            ),
          ],
          gap,
          AbsTextField(
            label: l.fieldAltPhone,
            controller: data.altPhone,
            prefixText: '+91',
            numeric: true,
            keyboardType: TextInputType.phone,
            inputFormatters: const [IndianMobileInputFormatter()],
            validator: optionalPhone,
          ),
          gap,
          AbsTextField(label: l.fieldAddress, controller: data.address),
          gap,
          AbsTextField(label: l.fieldEmergencyName, controller: data.emergencyName),
          gap,
          Row(
            children: [
              Expanded(
                child: AbsTextField(label: l.fieldEmergencyRelation, controller: data.emergencyRelation),
              ),
              const SizedBox(width: AbsSpace.x3),
              Expanded(
                flex: 2,
                child: AbsTextField(
                  label: l.fieldEmergencyPhone,
                  controller: data.emergencyPhone,
                  prefixText: '+91',
                  numeric: true,
                  keyboardType: TextInputType.phone,
                  inputFormatters: const [IndianMobileInputFormatter()],
                  validator: optionalPhone,
                ),
              ),
            ],
          ),
          gap,
          Text(l.fieldBloodGroup, style: context.text.label),
          const SizedBox(height: AbsSpace.x2),
          PopSingleChips<String>(
            options: const ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
            labelOf: (b) => b,
            value: data.bloodGroup,
            hue: PopHue.coral,
            onChanged: (b) => data.set(() => data.bloodGroup = b),
          ),
          gap,
          AbsTextField(label: l.fieldSource, controller: data.source),
          gap,
          AbsTextField(label: l.fieldNotes, controller: data.notes),
        ],
      ),
    );
  }
}

/// Step 2 — health and body profile (1.2) with PAR-Q style questions.
class MemberHealthFields extends StatelessWidget {
  const MemberHealthFields({super.key, required this.data, this.showConsent = true});

  final MemberFormData data;
  final bool showConsent;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    const gap = SizedBox(height: AbsSpace.x4);
    String? number(String? s) =>
        (s == null || s.trim().isEmpty || num.tryParse(s.trim()) != null) ? null : l.commonRequired;
    return ListenableBuilder(
      listenable: data,
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: AbsTextField(
                  label: l.fieldHeight,
                  controller: data.height,
                  numeric: true,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: number,
                ),
              ),
              const SizedBox(width: AbsSpace.x3),
              Expanded(
                child: AbsTextField(
                  label: l.fieldWeight,
                  controller: data.weight,
                  numeric: true,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: number,
                ),
              ),
            ],
          ),
          gap,
          Text(l.fieldGoal, style: context.text.label),
          const SizedBox(height: AbsSpace.x2),
          PopSingleChips<String>(
            options: const ['fat_loss', 'muscle_gain', 'strength', 'general_fitness', 'rehab'],
            labelOf: (g) => goalLabel(l, g),
            value: data.goal,
            hue: PopHue.mint,
            onChanged: (g) => data.set(() => data.goal = g),
          ),
          gap,
          Text(l.fieldLevel, style: context.text.label),
          const SizedBox(height: AbsSpace.x2),
          PopSingleChips<String>(
            options: const ['beginner', 'intermediate', 'advanced'],
            labelOf: (v) => levelLabel(l, v),
            value: data.level,
            hue: PopHue.grape,
            onChanged: (v) => data.set(() => data.level = v),
          ),
          gap,
          AbsTextField(label: l.fieldConditions, controller: data.conditions),
          gap,
          AbsTextField(label: l.fieldInjuries, controller: data.injuries),
          gap,
          AbsTextField(label: l.fieldMedications, controller: data.medications),
          const SizedBox(height: AbsSpace.x5),
          Text(l.parqTitle, style: context.text.heading),
          const SizedBox(height: AbsSpace.x2),
          for (final k in parqKeys)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(parqQuestion(l, k), style: context.text.body),
              value: data.parq[k] ?? false,
              onChanged: (v) => data.set(() => data.parq = {...data.parq, k: v}),
            ),
          if (data.parqFlagged)
            Container(
              margin: const EdgeInsets.only(top: AbsSpace.x2),
              padding: const EdgeInsets.all(AbsSpace.x3),
              decoration: stickerDecoration(
                c,
                color: c.pop(PopHue.tangerine).soft,
                lipDepth: 0,
                borderRadius: AbsRadius.buttonAll,
              ),
              child: Row(
                children: [
                  Icon(PhosphorIcons.firstAid(PhosphorIconsStyle.bold), color: c.warning),
                  const SizedBox(width: AbsSpace.x3),
                  Expanded(child: Text(l.parqWarning, style: context.text.label)),
                ],
              ),
            ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l.fieldDoctorClearance, style: context.text.body),
            value: data.doctorClearance,
            onChanged: (v) => data.set(() => data.doctorClearance = v),
          ),
          if (showConsent) ...[
            const Divider(),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(l.fieldConsentHealth, style: context.text.body),
              value: data.consentHealth,
              onChanged: (v) => data.set(() => data.consentHealth = v ?? false),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(l.fieldConsentWhatsapp, style: context.text.body),
              value: data.consentWhatsapp,
              onChanged: (v) => data.set(() => data.consentWhatsapp = v ?? false),
            ),
          ],
        ],
      ),
    );
  }
}
