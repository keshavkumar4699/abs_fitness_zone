import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../app/l10n/l10n.dart';
import '../../app/theme/theme.dart';
import 'abs_card.dart';
import 'segmented_tabs.dart';

enum ChartPeriod { d7, d30, m3, m12 }

enum ChartKind { line, bar }

/// fl_chart line/bar with a one-time draw-in, touch tooltip and a period
/// switcher (7D / 30D / 3M / 12M).
class ChartCard extends StatefulWidget {
  const ChartCard({
    super.key,
    required this.title,
    required this.values,
    required this.period,
    required this.onPeriodChanged,
    this.kind = ChartKind.line,
    this.formatValue,
  });

  final String title;
  final List<double> values;
  final ChartPeriod period;
  final ValueChanged<ChartPeriod> onPeriodChanged;
  final ChartKind kind;
  final String Function(double value)? formatValue;

  @override
  State<ChartCard> createState() => _ChartCardState();
}

class _ChartCardState extends State<ChartCard> {
  // Start flat and grow on the first frame: the draw-in happens once.
  bool _drawn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _drawn = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final l = context.l10n;
    final values = _drawn || AbsMotion.reduced(context) ? widget.values : List<double>.filled(widget.values.length, 0);
    final maxY = widget.values.isEmpty ? 1.0 : widget.values.reduce((a, b) => a > b ? a : b) * 1.15;
    final fmt = widget.formatValue ?? (v) => v.toStringAsFixed(0);

    final tooltipStyle = t.numericOf(t.label).copyWith(color: c.textPrimary);

    final Widget chart = switch (widget.kind) {
      ChartKind.line => LineChart(
        LineChartData(
          minY: 0,
          maxY: maxY <= 0 ? 1 : maxY,
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: maxY <= 0 ? 1 : maxY / 4,
            getDrawingHorizontalLine: (_) => FlLine(color: c.border, strokeWidth: AbsSize.hairline),
          ),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => c.surfaceRaised,
              getTooltipItems: (spots) => [for (final s in spots) LineTooltipItem(fmt(s.y), tooltipStyle)],
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [for (var i = 0; i < values.length; i++) FlSpot(i.toDouble(), values[i])],
              isCurved: true,
              preventCurveOverShooting: true,
              color: c.chart.first,
              barWidth: 2.5,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [c.chart.first.withValues(alpha: 0.24), c.chart.first.withValues(alpha: 0)],
                ),
              ),
            ),
          ],
        ),
        duration: AbsMotion.expressive.duration,
        curve: AbsMotion.standard.curve,
      ),
      ChartKind.bar => BarChart(
        BarChartData(
          maxY: maxY <= 0 ? 1 : maxY,
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: maxY <= 0 ? 1 : maxY / 4,
            getDrawingHorizontalLine: (_) => FlLine(color: c.border, strokeWidth: AbsSize.hairline),
          ),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => c.surfaceRaised,
              getTooltipItem: (group, _, rod, _) => BarTooltipItem(fmt(rod.toY), tooltipStyle),
            ),
          ),
          barGroups: [
            for (var i = 0; i < values.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: values[i],
                    color: c.chart.first,
                    width: AbsSpace.x2,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(AbsSpace.x1)),
                  ),
                ],
              ),
          ],
        ),
        duration: AbsMotion.expressive.duration,
        curve: AbsMotion.standard.curve,
      ),
    };

    return AbsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.title, style: t.heading),
          const SizedBox(height: AbsSpace.x3),
          SegmentedTabs(
            dense: true,
            labels: [l.period7d, l.period30d, l.period3m, l.period12m],
            selected: widget.period.index,
            onChanged: (i) => widget.onPeriodChanged(ChartPeriod.values[i]),
          ),
          const SizedBox(height: AbsSpace.x4),
          SizedBox(
            height: AbsSize.chartHeight,
            child: RepaintBoundary(child: chart),
          ),
        ],
      ),
    );
  }
}
