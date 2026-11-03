import 'package:csv/csv.dart';

import '../../../core/utils/phone.dart';
import '../domain/models.dart';

/// Columns the importer understands (1.15).
enum ImportField { name, phone, email, gender, dob, address, joinedOn, plan, startDate, endDate, notes }

extension ImportFieldInfo on ImportField {
  bool get required => this == ImportField.name || this == ImportField.phone;

  /// Header words a gym's own spreadsheet might use for this column.
  List<String> get aliases => switch (this) {
    ImportField.name => ['name', 'full name', 'member name', 'member', 'naam'],
    ImportField.phone => ['phone', 'mobile', 'mobile no', 'phone number', 'contact', 'whatsapp', 'number', 'mob'],
    ImportField.email => ['email', 'e-mail', 'mail', 'email id'],
    ImportField.gender => ['gender', 'sex'],
    ImportField.dob => ['dob', 'date of birth', 'birthday', 'birth date'],
    ImportField.address => ['address', 'area', 'location'],
    ImportField.joinedOn => ['joined', 'joining date', 'date of joining', 'doj', 'joined on', 'admission date'],
    ImportField.plan => ['plan', 'package', 'membership', 'scheme'],
    ImportField.startDate => ['start', 'start date', 'from', 'valid from', 'membership start'],
    ImportField.endDate => ['end', 'end date', 'expiry', 'expiry date', 'valid till', 'to', 'membership end'],
    ImportField.notes => ['notes', 'remarks', 'comment', 'comments'],
  };

  String get apiKey => switch (this) {
    ImportField.joinedOn => 'joined_on',
    ImportField.startDate => 'start_date',
    ImportField.endDate => 'end_date',
    _ => name,
  };
}

/// Parses CSV text; detects comma / semicolon / tab and ignores a BOM and
/// blank lines.
List<List<String>> parseCsv(String text) {
  var t = text.startsWith('﻿') ? text.substring(1) : text;
  t = t.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
  final firstLine = t.split('\n').first;
  final delimiter = [',', ';', '\t'].reduce((a, b) => firstLine.split(a).length >= firstLine.split(b).length ? a : b);
  final rows = Csv(fieldDelimiter: delimiter, lineDelimiter: '\n', autoDetect: false).decode(t);
  return [
    for (final r in rows)
      if (r.any((c) => c.toString().trim().isNotEmpty)) [for (final c in r) c.toString().trim()],
  ];
}

String _norm(String s) => s.toLowerCase().replaceAll(RegExp(r'[^a-z ]'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();

/// Best-guess column for each field from the header row.
Map<ImportField, int?> autoMap(List<String> headers) {
  final normalized = [for (final h in headers) _norm(h)];
  final used = <int>{};
  final out = <ImportField, int?>{};
  for (final field in ImportField.values) {
    int? hit;
    for (final alias in field.aliases) {
      final i = normalized.indexWhere((h) => h == alias);
      if (i >= 0 && !used.contains(i)) {
        hit = i;
        break;
      }
    }
    hit ??= () {
      for (var i = 0; i < normalized.length; i++) {
        if (!used.contains(i) && field.aliases.any((a) => a.length > 3 && normalized[i].contains(a))) return i;
      }
      return null;
    }();
    if (hit != null) used.add(hit);
    out[field] = hit;
  }
  return out;
}

/// Reads dd/mm/yyyy, dd-mm-yyyy, dd.mm.yyyy, yyyy-mm-dd and dd/mm/yy (Indian
/// day-first order). Returns null for blank or invalid dates.
DateTime? parseIndianDate(String input) {
  final s = input.trim();
  if (s.isEmpty) return null;
  final iso = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})').firstMatch(s);
  int y, m, d;
  if (iso != null) {
    y = int.parse(iso[1]!);
    m = int.parse(iso[2]!);
    d = int.parse(iso[3]!);
  } else {
    final dm = RegExp(r'^(\d{1,2})[/.\-](\d{1,2})[/.\-](\d{2}|\d{4})$').firstMatch(s);
    if (dm == null) return null;
    d = int.parse(dm[1]!);
    m = int.parse(dm[2]!);
    y = int.parse(dm[3]!);
    if (y < 100) y += y > 50 ? 1900 : 2000;
  }
  if (m < 1 || m > 12 || d < 1 || d > 31) return null;
  final date = DateTime.utc(y, m, d);
  return date.month == m && date.day == d ? date : null;
}

String? _gender(String s) => switch (s.trim().toLowerCase()) {
  'm' || 'male' || 'man' => 'male',
  'f' || 'female' || 'woman' => 'female',
  '' => null,
  _ => 'other',
};

/// One spreadsheet row after client-side checks.
class ImportRow {
  ImportRow({required this.rowNumber, required this.values, required this.errors, this.duplicateInFile = false});

  /// 1-based line number in the file (header is line 1).
  final int rowNumber;
  final Map<String, dynamic> values;
  final List<String> errors;
  final bool duplicateInFile;

  bool get isValid => errors.isEmpty && !duplicateInFile;

  Map<String, dynamic> toApi() => {'row': rowNumber, ...values};
}

/// Builds rows from the data lines using [mapping]; validates name, phone
/// and dates and flags phones repeated inside the file.
List<ImportRow> buildImportRows(List<List<String>> dataRows, Map<ImportField, int?> mapping) {
  final seen = <String>{};
  final out = <ImportRow>[];
  for (var r = 0; r < dataRows.length; r++) {
    final cells = dataRows[r];
    String cell(ImportField f) {
      final i = mapping[f];
      return i == null || i >= cells.length ? '' : cells[i].trim();
    }

    final errors = <String>[];
    final values = <String, dynamic>{};
    final name = cell(ImportField.name);
    if (name.isEmpty) errors.add('name is missing');
    values['name'] = name;

    final phone = Phone.normalize(cell(ImportField.phone));
    if (phone == null) errors.add('phone "${cell(ImportField.phone)}" is not a valid Indian mobile number');
    values['phone'] = phone;

    final email = cell(ImportField.email);
    if (email.isNotEmpty) {
      if (RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
        values['email'] = email.toLowerCase();
      } else {
        errors.add('email "$email" looks wrong');
      }
    }
    final gender = _gender(cell(ImportField.gender));
    if (gender != null) values['gender'] = gender;
    for (final f in [ImportField.dob, ImportField.joinedOn, ImportField.startDate, ImportField.endDate]) {
      final raw = cell(f);
      if (raw.isEmpty) continue;
      final d = parseIndianDate(raw);
      if (d == null) {
        errors.add('${f.apiKey.replaceAll('_', ' ')} "$raw" is not a date (use dd/mm/yyyy)');
      } else {
        values[f.apiKey] = dateParam(d);
      }
    }
    for (final f in [ImportField.address, ImportField.plan, ImportField.notes]) {
      final v = cell(f);
      if (v.isNotEmpty) values[f.apiKey] = v;
    }
    final dup = phone != null && !seen.add(phone);
    out.add(ImportRow(rowNumber: r + 2, values: values, errors: errors, duplicateInFile: dup));
  }
  return out;
}

String _csvLine(List<Object?> cells) => [
  for (final c in cells)
    () {
      final s = c?.toString() ?? '';
      return s.contains(RegExp('[",\n]')) ? '"${s.replaceAll('"', '""')}"' : s;
    }(),
].join(',');

/// Downloadable report of rows that were not imported.
String importErrorReport(List<ImportRow> local, List<ImportRowResult> server) {
  final lines = [
    _csvLine(['row', 'name', 'phone', 'status', 'reason']),
  ];
  final byRow = {for (final r in local) r.rowNumber: r};
  for (final r in local.where((r) => !r.isValid)) {
    lines.add(
      _csvLine([
        r.rowNumber,
        r.values['name'],
        r.values['phone'],
        r.duplicateInFile ? 'duplicate' : 'error',
        r.duplicateInFile ? 'phone repeated in this file' : r.errors.join('; '),
      ]),
    );
  }
  for (final s in server.where((s) => s.status != 'imported')) {
    final r = byRow[s.row];
    lines.add(_csvLine([s.row, r?.values['name'], r?.values['phone'], s.status, s.message]));
  }
  return '${lines.join('\n')}\n';
}

/// Members list export (1.13 / 1.15).
String membersToCsv(List<Member> members) {
  final lines = [
    _csvLine([
      'member_id',
      'name',
      'phone',
      'email',
      'gender',
      'dob',
      'status',
      'plan',
      'start_date',
      'end_date',
      'batch',
      'joined_on',
    ]),
  ];
  for (final m in members) {
    lines.add(
      _csvLine([
        m.memberCode,
        m.name,
        m.phone,
        m.email,
        m.gender,
        dateParam(m.dob),
        m.status.name,
        m.planName,
        dateParam(m.membershipStart),
        dateParam(m.membershipEnd),
        m.batch,
        dateParam(m.joinedOn),
      ]),
    );
  }
  return '${lines.join('\n')}\n';
}
