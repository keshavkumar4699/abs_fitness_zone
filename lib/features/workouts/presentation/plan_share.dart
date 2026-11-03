import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../app/l10n/l10n.dart';
import '../../exercises/domain/exercise.dart';
import '../../exercises/presentation/exercise_ui.dart' show weekdayShort;
import '../../payments/application/receipt_pdf.dart' show ReceiptFonts;
import '../domain/workout_models.dart';
import 'workout_ui.dart';

/// WhatsApp-friendly text of a program (5.12), for members without the app.
String planText(
  AppLocalizations l,
  WorkoutTemplate t,
  ExerciseIndex catalogue, {
  String? memberName,
  List<int>? weekdays,
  required String gym,
}) {
  final b = StringBuffer()
    ..writeln('*${t.name}*${memberName == null ? '' : ' · $memberName'}')
    ..writeln('${l.progWeeks(t.weeks)} · ${progressionLabel(l, t)} · $gym');
  for (final (n, d) in t.orderedDays.indexed) {
    final when = weekdays != null && n < weekdays.length ? ' (${weekdayShort(l, weekdays[n])})' : '';
    b
      ..writeln()
      ..writeln('*${l.buildDay(d.dayIndex)} · ${d.name}*$when');
    for (final i in d.ordered) {
      final ex = catalogue[i.exerciseId];
      final group = i.groupKey == null ? '' : ' [${l.superset(i.groupKey!)}]';
      b.writeln('• ${ex?.name ?? '—'}: ${itemSummary(l, i, tracking: ex?.trackingType)}$group');
      if (i.notes != null) b.writeln('  ${i.notes}');
    }
  }
  return b.toString().trim();
}

/// The same plan as a clean A4 PDF.
Future<Uint8List> planPdf(
  AppLocalizations l,
  WorkoutTemplate t,
  ExerciseIndex catalogue, {
  String? memberName,
  List<int>? weekdays,
  required String gym,
  required ReceiptFonts fonts,
}) async {
  const ink = PdfColor.fromInt(0xFF1D1638);
  const soft = PdfColor.fromInt(0xFF675E83);
  const lime = PdfColor.fromInt(0xFFC6F432);
  final doc = pw.Document(
    theme: pw.ThemeData.withFont(base: fonts.regular, bold: fonts.bold),
    title: t.name,
    author: gym,
  );
  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(36),
      build: (context) => [
        pw.Row(
          children: [
            pw.Container(
              width: 36,
              height: 36,
              alignment: pw.Alignment.center,
              decoration: pw.BoxDecoration(
                color: lime,
                borderRadius: pw.BorderRadius.circular(9),
                border: pw.Border.all(color: ink, width: 1.5),
              ),
              child: pw.Text(
                'ABS',
                style: const pw.TextStyle(fontWeight: pw.FontWeight.bold, color: ink, fontSize: 11),
              ),
            ),
            pw.SizedBox(width: 10),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    t.name,
                    style: const pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: ink),
                  ),
                  pw.Text(
                    [?memberName, l.progWeeks(t.weeks), progressionLabel(l, t), gym].join(' · '),
                    style: const pw.TextStyle(fontSize: 9, color: soft),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (t.description != null) ...[
          pw.SizedBox(height: 8),
          pw.Text(t.description!, style: const pw.TextStyle(fontSize: 10)),
        ],
        for (final (n, d) in t.orderedDays.indexed) ...[
          pw.SizedBox(height: 14),
          pw.Text(
            '${l.buildDay(d.dayIndex)} · ${d.name}${weekdays != null && n < weekdays.length ? ' (${weekdayShort(l, weekdays[n])})' : ''}',
            style: const pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: ink),
          ),
          pw.Divider(color: soft, thickness: 0.5),
          for (final i in d.ordered)
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 3),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 5,
                    child: pw.Text(
                      '${catalogue[i.exerciseId]?.name ?? '—'}${i.groupKey == null ? '' : '  (${l.superset(i.groupKey!)})'}',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ),
                  pw.Expanded(
                    flex: 5,
                    child: pw.Text(
                      itemSummary(l, i, tracking: catalogue[i.exerciseId]?.trackingType),
                      style: const pw.TextStyle(fontSize: 9, color: soft),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ],
    ),
  );
  return doc.save();
}
