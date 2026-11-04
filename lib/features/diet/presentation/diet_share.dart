import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:phosphor_icons/phosphor_icons.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/widgets/widgets.dart';
import '../../payments/application/receipt_pdf.dart' show ReceiptFonts;
import '../../settings/data/gym_settings_repository.dart';
import '../application/diet_providers.dart';
import '../domain/diet_models.dart';
import '../domain/nutrition.dart';
import 'diet_ui.dart';

/// WhatsApp-friendly text of a plan (members without the app).
String dietPlanText(AppLocalizations l, DietTemplate t, FoodLookup lookup, {String? memberName, required String gym}) {
  final total = dayTotals(t, lookup);
  final b = StringBuffer()
    ..writeln('*${t.name}*${memberName == null ? '' : ' · $memberName'}')
    ..writeln('${kcalText(total.kcal)} · ${macroLine(l, total)} · $gym');
  for (final m in t.orderedMeals) {
    b
      ..writeln()
      ..writeln('*${[mealSlotLabel(l, m.slot), ?m.hhmm].join(' · ')}*');
    for (final i in m.main) {
      b.writeln('• ${foodOf(i, lookup)?.name ?? '—'}: ${qtyText(l, foodOf(i, lookup), i.qty)}');
    }
    for (final g in m.options) {
      b.writeln(
        '  ${l.dietOr(g)}: ${m.group(g).map((i) => '${foodOf(i, lookup)?.name ?? '—'} ${qtyText(l, foodOf(i, lookup), i.qty)}').join(', ')}',
      );
    }
    if (m.notes != null) b.writeln('  ${m.notes}');
  }
  if (t.supplements.isNotEmpty) {
    b
      ..writeln()
      ..writeln('${l.dietSupplements}: ${t.supplements.join(', ')}');
  }
  b
    ..writeln()
    ..writeln('_${l.dietDisclaimer}_');
  return b.toString().trim();
}

/// The week's shopping (6.12), WhatsApp-ready.
String groceryText(AppLocalizations l, DietTemplate t, FoodLookup lookup, {required String gym}) {
  final b = StringBuffer()
    ..writeln('*${l.groceryTitle}* · ${t.name}')
    ..writeln(l.groceryFor7Days)
    ..writeln();
  for (final g in groceryList(t, lookup)) {
    b.writeln('• ${g.item}: ${groceryAmount(g)}');
  }
  b
    ..writeln()
    ..writeln(gym);
  return b.toString().trim();
}

/// A clean A4 PDF of the plan (6.13).
Future<Uint8List> dietPdf(
  AppLocalizations l,
  DietTemplate t,
  FoodLookup lookup, {
  String? memberName,
  required String gym,
  required ReceiptFonts fonts,
}) async {
  const ink = PdfColor.fromInt(0xFF1D1638);
  const soft = PdfColor.fromInt(0xFF675E83);
  const mint = PdfColor.fromInt(0xFF4BE3AC);
  final total = dayTotals(t, lookup);
  final doc = pw.Document(
    theme: pw.ThemeData.withFont(base: fonts.regular, bold: fonts.bold),
    title: t.name,
    author: gym,
  );
  pw.Widget foodRow(DietItem i, {bool option = false}) {
    final f = foodOf(i, lookup);
    final m = itemMacros(i, lookup);
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        children: [
          pw.Expanded(
            flex: 6,
            child: pw.Text(f?.name ?? '—', style: pw.TextStyle(fontSize: 10, color: option ? soft : ink)),
          ),
          pw.Expanded(
            flex: 3,
            child: pw.Text(qtyText(l, f, i.qty), style: const pw.TextStyle(fontSize: 9, color: soft)),
          ),
          pw.Expanded(
            flex: 2,
            child: pw.Text(
              '${m.kcal.round()} kcal',
              textAlign: pw.TextAlign.right,
              style: const pw.TextStyle(fontSize: 9, color: soft),
            ),
          ),
        ],
      ),
    );
  }

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
                color: mint,
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
                    [?memberName, kcalText(total.kcal), macroLine(l, total), gym].join(' · '),
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
        for (final m in t.orderedMeals) ...[
          pw.SizedBox(height: 12),
          pw.Text(
            '${[mealSlotLabel(l, m.slot), ?m.hhmm].join(' · ')}  ·  ${kcalText(mealTotals(m, lookup).kcal)}',
            style: const pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: ink),
          ),
          pw.Divider(color: soft, thickness: 0.5),
          for (final i in m.main) foodRow(i),
          for (final g in m.options) ...[
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 3),
              child: pw.Text(l.dietOr(g), style: const pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
            ),
            for (final i in m.group(g)) foodRow(i, option: true),
          ],
          if (m.notes != null) pw.Text(m.notes!, style: const pw.TextStyle(fontSize: 9, color: soft)),
        ],
        if (t.supplements.isNotEmpty) ...[
          pw.SizedBox(height: 12),
          pw.Text(
            '${l.dietSupplements}: ${t.supplements.join(', ')}',
            style: const pw.TextStyle(fontSize: 10, color: ink),
          ),
        ],
        pw.SizedBox(height: 16),
        pw.Text(l.dietDisclaimer, style: const pw.TextStyle(fontSize: 8, color: soft)),
      ],
    ),
  );
  return doc.save();
}

/// Share a plan as a PDF or WhatsApp text, or its grocery list.
class DietShareMenu extends ConsumerWidget {
  const DietShareMenu({super.key, required this.template, this.memberName});

  final DietTemplate template;
  final String? memberName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return PopupMenuButton<String>(
      key: const ValueKey('share-diet'),
      tooltip: l.progShare,
      icon: Icon(PhosphorIcons.shareNetwork(PhosphorIconsStyle.bold)),
      onSelected: (kind) async {
        try {
          final lookup = lookupIn(ref.read(foodCatalogueProvider).value);
          final gym = ref.read(publicGymProfileProvider).value?['gym_name'] as String? ?? l.gymName;
          switch (kind) {
            case 'grocery':
              await showGrocerySheet(context, template);
            case 'text':
              await SharePlus.instance.share(
                ShareParams(
                  text: dietPlanText(l, template, lookup, memberName: memberName, gym: gym),
                ),
              );
            default:
              final bytes = await dietPdf(
                l,
                template,
                lookup,
                memberName: memberName,
                gym: gym,
                fonts: await ReceiptFonts.load(),
              );
              final name = template.name.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '-').toLowerCase();
              await Printing.sharePdf(bytes: bytes, filename: 'abs-diet-$name.pdf');
          }
        } catch (e) {
          if (context.mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(value: 'pdf', child: Text(l.progSharePdf)),
        PopupMenuItem(value: 'text', child: Text(l.progShareText)),
        PopupMenuItem(value: 'grocery', child: Text(l.groceryTitle)),
      ],
    );
  }
}

/// The week's grocery list with a share button.
Future<void> showGrocerySheet(BuildContext context, DietTemplate template) => showAbsBottomSheet<void>(
  context: context,
  builder: (context, controller) => _GrocerySheet(template: template, controller: controller),
);

class _GrocerySheet extends ConsumerWidget {
  const _GrocerySheet({required this.template, required this.controller});

  final DietTemplate template;
  final ScrollController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final t = context.text;
    final c = context.colors;
    final lookup = lookupIn(ref.watch(foodCatalogueProvider).value);
    final items = groceryList(template, lookup);
    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: controller,
            padding: EdgeInsets.symmetric(horizontal: context.screenPadding),
            children: [
              Text(l.groceryTitle, style: t.title),
              Text(l.groceryFor7Days, style: t.caption.copyWith(color: c.textSecondary)),
              const SizedBox(height: AbsSpace.x3),
              for (final g in items)
                Padding(
                  key: ValueKey('grocery-${g.item}'),
                  padding: const EdgeInsets.symmetric(vertical: AbsSpace.x1),
                  child: Row(
                    children: [
                      Icon(
                        PhosphorIcons.basket(PhosphorIconsStyle.bold),
                        size: AbsSize.iconSmall,
                        color: c.textSecondary,
                      ),
                      const SizedBox(width: AbsSpace.x2),
                      Expanded(child: Text(g.item, style: t.body)),
                      Text(groceryAmount(g), style: t.numericOf(t.label)),
                    ],
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x2, context.screenPadding, AbsSpace.x4),
          child: AbsButton(
            key: const ValueKey('grocery-share'),
            label: l.groceryShare,
            icon: PhosphorIcons.whatsappLogo(PhosphorIconsStyle.bold),
            hue: PopHue.mint,
            onPressed: () {
              final gym = ref.read(publicGymProfileProvider).value?['gym_name'] as String? ?? l.gymName;
              SharePlus.instance.share(ShareParams(text: groceryText(l, template, lookup, gym: gym)));
            },
          ),
        ),
      ],
    );
  }
}
