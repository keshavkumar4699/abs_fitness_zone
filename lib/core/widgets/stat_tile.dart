import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../app/theme/theme.dart';
import 'abs_card.dart';
import 'count_up.dart';
import 'pop_decor.dart';

/// Colourful stat: icon bubble, label, big count-up value, delta sticker and
/// an optional sparkline.
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.label,
    required this.value,
    this.hue = PopHue.sky,
    this.icon,
    this.format,
    this.deltaPercent,
    this.sparkline,
    this.onTap,
  });

  final String label;
  final num value;
  final PopHue hue;
  final IconData? icon;
  final String Function(num value)? format;

  /// Change vs previous period in percent; null hides the sticker.
  final double? deltaPercent;
  final List<double>? sparkline;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return AbsCard(
      hue: hue,
      onTap: onTap,
      padding: const EdgeInsets.all(AbsSpace.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (icon != null) ...[IconBubble(icon: icon!, hue: hue, size: 32), const SizedBox(width: AbsSpace.x2)],
              Expanded(
                child: Text(
                  label,
                  style: t.label.copyWith(color: c.textSecondary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AbsSpace.x2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: CountUp(value: value, format: format, style: t.numericOf(t.displayL).copyWith(fontSize: 32)),
                ),
              ),
              if (deltaPercent != null) ...[const SizedBox(width: AbsSpace.x2), DeltaPill(percent: deltaPercent!)],
            ],
          ),
          if (sparkline != null && sparkline!.length > 1) ...[
            const SizedBox(height: AbsSpace.x2),
            SizedBox(
              height: AbsSize.sparklineHeight,
              child: Sparkline(values: sparkline!, color: c.pop(hue).text),
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
    final p = c.pop(up ? PopHue.mint : PopHue.coral);
    final text = '${percent.abs().toStringAsFixed(percent.abs() < 10 ? 1 : 0)}%';
    return Semantics(
      label: '${up ? '+' : '-'}$text',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AbsSpace.x2, vertical: 2),
        decoration: BoxDecoration(
          color: p.fill,
          borderRadius: AbsRadius.pill,
          border: Border.all(color: c.isDark ? p.deep : c.ink, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              up ? PhosphorIcons.arrowUp(PhosphorIconsStyle.bold) : PhosphorIcons.arrowDown(PhosphorIconsStyle.bold),
              size: AbsSpace.x3,
              color: p.onFill,
            ),
            const SizedBox(width: 2),
            Text(text, style: context.text.numericOf(context.text.caption).copyWith(color: p.onFill)),
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
    final line = color ?? context.colors.accentText;
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
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [line.withValues(alpha: 0.3), line.withValues(alpha: 0)],
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
