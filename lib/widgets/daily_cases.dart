import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var data = [
      YearlySpending('29 July', 334, Colors.blue),
      YearlySpending('30 July', 278, Colors.blue),
      YearlySpending('31 July', 396, Colors.blue),
      YearlySpending('1 Aug', 307, Colors.blue),
      YearlySpending('2 Aug', 313, Colors.blue),
      YearlySpending('3 Aug', 226, Colors.blue),
      YearlySpending('4 Aug', 295, Colors.blue),
    ];

    var series = [
      charts.Series(
        domainFn: (YearlySpending data, _) => data.month,
        measureFn: (YearlySpending data, _) => data.amount,
        colorFn: (YearlySpending data, _) => data.color,
        labelAccessorFn: (YearlySpending data, _) => '${data.amount}',
        id: 'Spending',
        data: data,
      ),
    ];

    var chart = charts.BarChart(
      series,
      animate: false,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      domainAxis: new charts.OrdinalAxisSpec(),
    );

    var chartWidget = Padding(
      padding: EdgeInsets.all(32.0),
      child: SizedBox(
        height: 200.0,
        child: chart,
      ),
    );

    return chartWidget;
  }
}

class YearlySpending {
  final String month;
  final int amount;
  final charts.Color color;

  YearlySpending(this.month, this.amount, Color color)
      : this.color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
