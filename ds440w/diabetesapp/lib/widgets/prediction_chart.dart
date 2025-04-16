// widgets/prediction_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/prediction_record.dart';

class PredictionChart extends StatelessWidget {
  final List<PredictionRecord> data;
  PredictionChart({required this.data});

  @override
  Widget build(BuildContext c) {
    if (data.isEmpty) return Text('No history');
    final spots = data
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.result.toDouble()))
        .toList();
    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 1,
        titlesData: FlTitlesData(show: true, bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false))),
        lineBarsData: [LineChartBarData(spots: spots, isCurved: false, dotData: FlDotData(show: true))],
      ),
    );
  }
}
