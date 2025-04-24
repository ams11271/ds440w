// lib/widgets/prediction_chart.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/prediction_record.dart';

class PredictionChart extends StatelessWidget {
  final List<PredictionRecord> data;
  const PredictionChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(child: Text('No history available'));
    }

    // Map each record to a FlSpot(index, result)
    final spots = data
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.result.toDouble()))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          'Risk Over Time',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),

        // Chart with fixed aspect ratio
        AspectRatio(
          aspectRatio: 1.5,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: (data.length - 1).toDouble(),
              minY: 0,
              maxY: 1,

              // Grid lines
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                drawHorizontalLine: true,
                horizontalInterval: 0.5,
                verticalInterval: 1,
                getDrawingHorizontalLine: (_) =>
                    FlLine(color: Colors.grey.withOpacity(0.3), dashArray: [4, 4]),
                getDrawingVerticalLine: (_) =>
                    FlLine(color: Colors.grey.withOpacity(0.3), dashArray: [4, 4]),
              ),

              // Axis borders
              borderData: FlBorderData(show: true),

              // Axis titles & labels
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      final idx = value.toInt();
                      if (idx < 0 || idx >= data.length) return const SizedBox();
                      final date = data[idx].createdAt;
                      final txt = DateFormat('MM/dd').format(date);
                      return Text(txt, style: TextStyle(fontSize: 10));
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 0.5,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      final label = value == 1.0 ? 'High\nRisk' : 'Low\nRisk';
                      return Text(label, style: TextStyle(fontSize: 10));
                    },
                  ),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),

              // Interactive tooltips
              lineTouchData: LineTouchData(
                handleBuiltInTouches: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (spot) =>
                      Theme.of(context).primaryColor.withOpacity(0.8),
                  getTooltipItems: (spots) {
                    return spots.map((spot) {
                      final idx = spot.x.toInt();
                      final record = data[idx];
                      final dateStr =
                          DateFormat('yyyy-MM-dd').format(record.createdAt);
                      final resultStr =
                          record.result == 1 ? 'Diabetic' : 'Not Diabetic';
                      return LineTooltipItem(
                        '$dateStr\n$resultStr',
                        TextStyle(color: Colors.white),
                      );
                    }).toList();
                  },
                ),
              ),

              // The line data
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: false,
                  barWidth: 2,
                  dotData: FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
