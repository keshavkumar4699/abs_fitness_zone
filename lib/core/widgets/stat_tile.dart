import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../app/theme/theme.dart';
import 'abs_card.dart';
import 'count_up.dart';

/// Label, big count-up value, delta pill (▲ green / ▼ red vs previous period)
/// and an optional sparkline.
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.label,
    required this.value,
    this.format,
    this.deltaPercent,
    this.sparkline,
    this.onTap,
  });

  final String label;
  final num value;
  final String Function(num value)? format;

  /// Change vs previous period in percent; null hides the pill.
  final double? deltaPercent;
  final List<double>? sparkline;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return AbsCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AbsSpace.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: t.label.copyWith(color: c.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AbsSpace.x2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: CountUp(value: value, format: format, style: t.numericOf(t.title)),
                ),
              ),
              if (deltaPercent != null) ...[const SizedBox(width: AbsSpace.x2), DeltaPill(percent: deltaPercent!)],
            ],
          ),
          if (sparkline != null && sparkline!.length > 1) ...[
            const SizedBox(height: AbsSpace.x3),
            SizedBox(
              height: AbsSize.sparklineHeight,
              child: Sparkline(values: sparkline!),
            ),
          ],
        ],
      ),
    );
  }
}

class DeltaPill extends StatelessWidget {
  const DeltaPill({super.key, required this.percent});

  final double percent;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final up = percent >= 0;
    final color = up ? c.success : c.danger;
    final text = '${percent.abs().toStringAsFixed(percent.abs() < 10 ? 1 : 0)}%';
    return Semantics(
      label: '${up ? '+' : '-'}$text',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AbsSpace.x2, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: AbsOpacity.subtleFill),
          borderRadius: AbsRadius.pill,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              up ? PhosphorIcons.caretUp(PhosphorIconsStyle.fill) : PhosphorIcons.caretDown(PhosphorIconsStyle.fill),
              size: AbsSpace.x3,
              color: color,
            ),
            const SizedBox(width: 2),
            Text(text, style: context.text.numericOf(context.text.caption).copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}

/// Minimal line without axes, used inside tiles.
class Sparkline extends StatelessWidget {
  const Sparkline({super.key, required this.values, this.color});

  final List<double> values;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final line = color ?? context.colors.accent;
    return RepaintBoundary(
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: const LineTouchData(enabled: false),
          lineBarsData: [
            LineChartBarData(
              spots: [for (var i = 0; i < values.length; i++) FlSpot(i.toDouble(), values[i])],
              isCurved: true,
              preventCurveOverShooting: true,
              color: line,
              barWidth: 2,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    line.withValues(alpha: AbsOpacity.subtleFill * 2),
                    line.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ],
        ),
        duration: AbsMotion.standard.duration,
        curve: AbsMotion.standard.curve,
      ),
    );
  }
}
