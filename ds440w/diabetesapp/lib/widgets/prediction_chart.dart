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
      return Center(child: Text('No history'));
    }

    final spots = data
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.result.toDouble()))
        .toList();

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (data.length - 1).toDouble(),
        minY: 0,
        maxY: 1,
        backgroundColor: Colors.blue.shade50,

        // Grid
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          horizontalInterval: 0.5,
          verticalInterval: 1,
          getDrawingHorizontalLine: (_) =>
              FlLine(color: Colors.grey.withOpacity(0.3), dashArray: [5, 5]),
          getDrawingVerticalLine: (_) =>
              FlLine(color: Colors.grey.withOpacity(0.3), dashArray: [5, 5]),
        ),

        borderData: FlBorderData(show: true),

        // Axis titles & labels
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            axisNameWidget:
                Text('Date', style: TextStyle(fontWeight: FontWeight.w600)),
            axisNameSize: 16,
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= data.length) return SizedBox();
                return Text(
                  DateFormat.Md().format(data[idx].createdAt),
                  style: TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            axisNameWidget: RotatedBox(
              quarterTurns: -1,
              child: Text('Risk',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            axisNameSize: 16,
            sideTitles: SideTitles(
              showTitles: true,
              interval: 0.5,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                if (value == 1) {
                  return Text('High', style: TextStyle(fontSize: 10));
                }
                if (value == 0) {
                  return Text('Low', style: TextStyle(fontSize: 10));
                }
                return SizedBox();
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),

        // Threshold at 0.5
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: 0.5,
              color: Colors.redAccent,
              strokeWidth: 1,
              dashArray: [4, 4],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.topLeft,
                labelResolver: (_) => 'Threshold',
                style: TextStyle(color: Colors.redAccent, fontSize: 10),
              ),
            ),
          ],
        ),

        // Touch & tooltip
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => Theme.of(context).primaryColor,
            getTooltipItems: (spots) {
              return spots.map((spot) {
                final rec = data[spot.x.toInt()];
                return LineTooltipItem(
                  '${DateFormat.yMMMd().format(rec.createdAt)}\n${rec.result == 1 ? 'Diabetic' : 'Not Diabetic'}',
                  TextStyle(color: Colors.white),
                );
              }).toList();
            },
          ),
        ),

        // Line + gradient fill
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 3,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColorLight,
              ],
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.4),
                  Colors.transparent,
                ],
              ),
            ),
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}
