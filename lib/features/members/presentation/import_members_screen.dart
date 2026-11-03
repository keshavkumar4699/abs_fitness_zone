import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/widgets/widgets.dart';
import '../application/member_csv.dart';
import '../application/members_providers.dart';
import '../data/members_repository.dart';
import '../domain/models.dart';

/// Import members from the gym's existing spreadsheet (1.15): pick a CSV,
/// map columns, preview problems, import, then share an error report.
class ImportMembersScreen extends ConsumerStatefulWidget {
  const ImportMembersScreen({super.key, this.pickFile});

  /// Injectable for tests; defaults to the platform file picker.
  final Future<String?> Function()? pickFile;

  @override
  ConsumerState<ImportMembersScreen> createState() => _ImportMembersScreenState();
}

enum _Stage { pick, map, running, done }

class _ImportMembersScreenState extends ConsumerState<ImportMembersScreen> {
  _Stage _stage = _Stage.pick;
  List<String> _headers = [];
  List<List<String>> _data = [];
  Map<ImportField, int?> _mapping = {};
  List<ImportRow> _rows = [];
  List<ImportRowResult> _results = [];
  int _done = 0;

  Future<String?> _defaultPick() async {
    final files = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: ['csv', 'txt']);
    if (files.isEmpty) return null;
    return utf8.decode(await files.first.readAsBytes(), allowMalformed: true);
  }

  Future<void> _pick() async {
    final l = context.l10n;
    try {
      final text = await (widget.pickFile ?? _defaultPick)();
      if (text == null) return;
      final rows = parseCsv(text);
      if (rows.length < 2) throw const FormatException();
      setState(() {
        _headers = rows.first;
        _data = rows.skip(1).toList();
        _mapping = autoMap(_headers);
        _rows = buildImportRows(_data, _mapping);
        _stage = _Stage.map;
      });
    } catch (_) {
      if (mounted) showAbsSnackbar(context, l.importFileError, tone: SnackTone.error);
    }
  }

  void _remap(ImportField f, int? column) => setState(() {
    _mapping = {..._mapping, f: column};
    _rows = buildImportRows(_data, _mapping);
  });

  Future<void> _import() async {
    final l = context.l10n;
    final valid = _rows.where((r) => r.isValid).map((r) => r.toApi()).toList();
    setState(() {
      _stage = _Stage.running;
      _done = 0;
    });
    try {
      final results = await ref
          .read(membersRepositoryProvider)
          .importRows(valid, onProgress: (n) => mounted ? setState(() => _done = n) : null);
      ref
        ..invalidate(memberListProvider)
        ..invalidate(dashboardProvider);
      setState(() {
        _results = results;
        _stage = _Stage.done;
      });
    } catch (e) {
      if (!mounted) return;
      showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
      setState(() => _stage = _Stage.map);
    }
  }

  Future<void> _shareReport() async {
    final report = importErrorReport(_rows, _results);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile.fromData(utf8.encode(report), mimeType: 'text/csv', name: 'import-errors.csv')],
      ),
    );
  }

  String _fieldLabel(AppLocalizations l, ImportField f) => switch (f) {
    ImportField.name => l.fieldName,
    ImportField.phone => l.fieldPhone,
    ImportField.email => l.fieldEmail,
    ImportField.gender => l.fieldGender,
    ImportField.dob => l.fieldDob,
    ImportField.address => l.fieldAddress,
    ImportField.joinedOn => l.infoJoined,
    ImportField.plan => l.filterPlan,
    ImportField.startDate => l.startDate,
    ImportField.endDate => l.endsOn('').trim(),
    ImportField.notes => l.fieldNotes,
  };

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.importTitle)),
      body: AnimatedSwitcher(
        duration: AbsMotion.standard.duration,
        child: KeyedSubtree(
          key: ValueKey(_stage),
          child: switch (_stage) {
            _Stage.pick => EmptyState(
              title: l.importPick,
              message: l.importPickBody,
              actionLabel: l.importPick,
              onAction: _pick,
              illustration: EmptyIllustration.people,
              hue: PopHue.tangerine,
            ),
            _Stage.map => _mapView(context),
            _Stage.running => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProgressRing(
                    progress: _rows.isEmpty ? 0 : _done / _rows.where((r) => r.isValid).length,
                    hue: PopHue.tangerine,
                    child: Icon(PhosphorIcons.fileArrowUp(PhosphorIconsStyle.bold)),
                  ),
                  const SizedBox(height: AbsSpace.x4),
                  Text(l.importRunning(_done, _rows.where((r) => r.isValid).length), style: context.text.heading),
                ],
              ),
            ),
            _Stage.done => _doneView(context),
          },
        ),
      ),
    );
  }

  Widget _mapView(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final valid = _rows.where((r) => r.isValid).length;
    final problems = _rows.length - valid;
    final ready = _mapping[ImportField.name] != null && _mapping[ImportField.phone] != null;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(context.screenPadding),
            children: [
              Text(l.importMapTitle, style: t.title),
              const SizedBox(height: AbsSpace.x3),
              for (final f in ImportField.values)
                Padding(
                  padding: const EdgeInsets.only(bottom: AbsSpace.x2),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          f.required ? '${_fieldLabel(l, f)} (${l.importRequired})' : _fieldLabel(l, f),
                          style: t.body,
                        ),
                      ),
                      Expanded(
                        child: DropdownButtonFormField<int?>(
                          initialValue: _mapping[f],
                          isExpanded: true,
                          items: [
                            DropdownMenuItem(value: null, child: Text(l.importNotMapped)),
                            for (var i = 0; i < _headers.length; i++)
                              DropdownMenuItem(
                                value: i,
                                child: Text(_headers[i], overflow: TextOverflow.ellipsis),
                              ),
                          ],
                          onChanged: (v) => _remap(f, v),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: AbsSpace.x4),
              Text(l.importPreview, style: t.title),
              const SizedBox(height: AbsSpace.x2),
              Wrap(
                spacing: AbsSpace.x2,
                runSpacing: AbsSpace.x2,
                children: [
                  PopSticker(label: l.importReady(valid), hue: PopHue.mint),
                  if (problems > 0) PopSticker(label: l.importProblems(problems), hue: PopHue.coral),
                ],
              ),
              const SizedBox(height: AbsSpace.x3),
              for (final r in _rows.where((r) => !r.isValid).take(20))
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: IconBubble(
                    icon: PhosphorIcons.warning(PhosphorIconsStyle.bold),
                    hue: PopHue.coral,
                    size: 34,
                  ),
                  title: Text('#${r.rowNumber} ${r.values['name'] ?? ''}'),
                  subtitle: Text(
                    r.duplicateInFile ? l.memberDuplicatePhone : r.errors.join('; '),
                    style: t.caption.copyWith(color: c.danger),
                  ),
                ),
              if (!ready) Text(l.importNeedNamePhone, style: t.label.copyWith(color: c.danger)),
            ],
          ),
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x2, context.screenPadding, AbsSpace.x3),
            child: AbsButton(
              label: l.importStart(valid),
              hue: PopHue.tangerine,
              icon: PhosphorIcons.fileArrowUp(PhosphorIconsStyle.bold),
              onPressed: ready && valid > 0 ? _import : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _doneView(BuildContext context) {
    final l = context.l10n;
    final imported = _results.where((r) => r.status == 'imported').length;
    final dups = _results.where((r) => r.status == 'duplicate').length;
    final errors = _results.where((r) => r.status == 'error').length + _rows.where((r) => !r.isValid).length;
    return Stack(
      children: [
        Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(context.screenPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StickerIllustration(icon: PhosphorIcons.checkCircle(PhosphorIconsStyle.bold), hue: PopHue.mint),
                const SizedBox(height: AbsSpace.x4),
                Text(l.importDone, style: context.text.title),
                const SizedBox(height: AbsSpace.x3),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: AbsSpace.x2,
                  runSpacing: AbsSpace.x2,
                  children: [
                    PopSticker(label: l.importImported(imported), hue: PopHue.mint),
                    if (dups > 0) PopSticker(label: l.importDuplicates(dups), hue: PopHue.tangerine),
                    if (errors > 0) PopSticker(label: l.importErrors(errors), hue: PopHue.coral),
                  ],
                ),
                const SizedBox(height: AbsSpace.x6),
                if (dups + errors > 0)
                  AbsButton(
                    label: l.importShareReport,
                    hue: PopHue.tangerine,
                    icon: PhosphorIcons.shareNetwork(PhosphorIconsStyle.bold),
                    onPressed: _shareReport,
                  ),
                const SizedBox(height: AbsSpace.x2),
                AbsButton.secondary(
                  label: l.importAnother,
                  onPressed: () => setState(() {
                    _stage = _Stage.pick;
                    _rows = [];
                    _results = [];
                  }),
                ),
              ],
            ),
          ),
        ),
        if (imported > 0) const Positioned.fill(child: ConfettiBurst()),
      ],
    );
  }
}
