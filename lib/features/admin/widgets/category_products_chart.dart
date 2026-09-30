// import 'package:appecom/features/admin/models/sales.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
// import 'package:flutter/material.dart';

// class CategoryProductsChart extends StatelessWidget {
//   final List<charts.Series<Sales, String>> seriesList;
//   const CategoryProductsChart({
//     Key? key,
//     required this.seriesList,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return charts.BarChart(
//       seriesList,
//       animate: true,
//     );
//   }
// }
import 'package:appecom/features/admin/models/sales.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryProductsChart extends StatelessWidget {
  final List<Sales> salesData;

  const CategoryProductsChart({
    Key? key,
    required this.salesData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _getMaxY(),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueAccent,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String label = salesData[group.x.toInt()].label;
              return BarTooltipItem(
                '$label\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: rod.toY.round().toString(),
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: _bottomTitleWidgets,
              reservedSize: 38,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: 1,
              getTitlesWidget: _leftTitleWidgets,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: _generateBarGroups(),
        gridData: FlGridData(show: false),
      ),
    );
  }

  double _getMaxY() {
    if (salesData.isEmpty) return 10;
    double max = salesData
        .map((e) => e.earning.toDouble())
        .reduce((a, b) => a > b ? a : b);
    return max * 1.2; // Add 20% padding
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black54,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(value.toInt().toString(), style: style),
    );
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black54,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    if (value.toInt() < salesData.length) {
      String label = salesData[value.toInt()].label;
      // Truncate long labels
      if (label.length > 8) {
        label = '${label.substring(0, 6)}..';
      }
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 16,
        child: Text(label, style: style),
      );
    }
    return const Text('');
  }

  List<BarChartGroupData> _generateBarGroups() {
    return salesData.asMap().entries.map((entry) {
      int index = entry.key;
      Sales sale = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: sale.earning.toDouble(),
            color: _getBarColor(index),
            width: 16,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: _getMaxY(),
              color: Colors.grey.withOpacity(0.1),
            ),
          ),
        ],
      );
    }).toList();
  }

  Color _getBarColor(int index) {
    List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.amber,
      Colors.indigo,
    ];
    return colors[index % colors.length];
  }
}
