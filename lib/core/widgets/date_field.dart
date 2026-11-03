import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../app/l10n/l10n.dart';
import '../../app/theme/theme.dart';
import '../utils/dates.dart';

/// Tappable field that opens a date picker. Dates are calendar dates (IST).
class DateField extends StatelessWidget {
  const DateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.first,
    this.last,
    this.allowClear = true,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final DateTime? first;
  final DateTime? last;
  final bool allowClear;

  Future<void> _pick(BuildContext context) async {
    final today = IstDates.today();
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? today,
      firstDate: first ?? DateTime(1930),
      lastDate: last ?? DateTime(today.year + 5),
      helpText: label,
    );
    if (picked != null) onChanged(DateTime.utc(picked.year, picked.month, picked.day));
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      label: '$label, ${value == null ? context.l10n.dateNotSet : IstDates.formatDate(value!, isDateOnly: true)}',
      excludeSemantics: true,
      child: InkWell(
        borderRadius: AbsRadius.buttonAll,
        onTap: () => _pick(context),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: value != null && allowClear
                ? IconButton(
                    tooltip: context.l10n.commonClose,
                    icon: Icon(PhosphorIcons.x(PhosphorIconsStyle.bold)),
                    onPressed: () => onChanged(null),
                  )
                : Icon(PhosphorIcons.calendarBlank(PhosphorIconsStyle.bold), color: c.textSecondary),
          ),
          child: Text(
            value == null ? context.l10n.pickDate : IstDates.formatDate(value!, isDateOnly: true),
            style: context.text.body.copyWith(color: value == null ? c.textSecondary : c.textPrimary),
          ),
        ),
      ),
    );
  }
}
