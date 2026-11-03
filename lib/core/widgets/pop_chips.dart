import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/theme.dart';

/// Wrap of selectable sticker chips (multi-select).
class PopChoiceChips<T> extends StatelessWidget {
  const PopChoiceChips({
    super.key,
    required this.options,
    required this.labelOf,
    required this.selected,
    required this.onChanged,
    this.hue = PopHue.grape,
  });

  final List<T> options;
  final String Function(T) labelOf;
  final Set<T> selected;
  final ValueChanged<Set<T>> onChanged;
  final PopHue hue;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: AbsSpace.x2,
    runSpacing: AbsSpace.x2,
    children: [
      for (final o in options)
        PopChip(
          label: labelOf(o),
          selected: selected.contains(o),
          hue: hue,
          onTap: () => onChanged(selected.contains(o) ? ({...selected}..remove(o)) : {...selected, o}),
        ),
    ],
  );
}

/// Single-choice sticker chips; tapping the selected chip clears it when
/// [allowEmpty].
class PopSingleChips<T> extends StatelessWidget {
  const PopSingleChips({
    super.key,
    required this.options,
    required this.labelOf,
    required this.value,
    required this.onChanged,
    this.hue = PopHue.grape,
    this.allowEmpty = true,
  });

  final List<T> options;
  final String Function(T) labelOf;
  final T? value;
  final ValueChanged<T?> onChanged;
  final PopHue hue;
  final bool allowEmpty;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: AbsSpace.x2,
    runSpacing: AbsSpace.x2,
    children: [
      for (final o in options)
        PopChip(
          label: labelOf(o),
          selected: value == o,
          hue: hue,
          onTap: () => onChanged(value == o ? (allowEmpty ? null : o) : o),
        ),
    ],
  );
}

class PopChip extends StatelessWidget {
  const PopChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.hue = PopHue.grape,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final PopHue hue;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final p = c.pop(hue);
    final fg = selected ? p.onFill : c.textPrimary;
    return Semantics(
      selected: selected,
      button: true,
      label: label,
      onTap: onTap,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: AnimatedContainer(
          duration: AbsMotion.quick.duration,
          curve: AbsMotion.quick.curve,
          constraints: const BoxConstraints(minHeight: 40),
          padding: const EdgeInsets.symmetric(horizontal: AbsSpace.x4, vertical: AbsSpace.x2),
          decoration: BoxDecoration(
            color: selected ? p.fill : c.surface,
            borderRadius: AbsRadius.pill,
            border: Border.all(color: selected ? (c.isDark ? p.deep : c.ink) : c.border, width: AbsDepth.outline),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: AbsSize.iconSmall, color: fg),
                const SizedBox(width: AbsSpace.x1 + 2),
              ],
              Text(label, style: context.text.label.copyWith(color: fg)),
            ],
          ),
        ),
      ),
    );
  }
}
