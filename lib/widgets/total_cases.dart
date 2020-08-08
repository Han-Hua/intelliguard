import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class LineChartCases extends StatefulWidget {
  @override
  _LineChartCasesState createState() => _LineChartCasesState();

  static List<charts.Series<DailyCases, int>> _sampleData() {
    var totalCases = [
      DailyCases(1, 13, 3),
      DailyCases(2, 102, 3),
      DailyCases(3, 926, 3),
      DailyCases(4, 16169, 3),
      DailyCases(5, 34884, 3),
      DailyCases(6, 43907, 3),
      DailyCases(7, 52205, 3),
    ];

    var recoveredCases = [
      DailyCases(1, 0, 2),
      DailyCases(2, 72, 2),
      DailyCases(3, 240, 2),
      DailyCases(4, 1244, 2),
      DailyCases(5, 21699, 2),
      DailyCases(6, 38500, 2),
      DailyCases(7, 46491, 2),
    ];

    final blue = charts.MaterialPalette.blue.makeShades(2);
    final red = charts.MaterialPalette.red.makeShades(2);

    return [
      new charts.Series<DailyCases, int>(
        id: 'Total',
        colorFn: (DailyCases sales, _) => blue[1],
        strokeWidthPxFn: (DailyCases sales, _) => sales.strokeWidthPx,
        domainFn: (DailyCases sales, _) => sales.date,
        measureFn: (DailyCases sales, _) => sales.cases,
        data: totalCases,
      ),
      new charts.Series<DailyCases, int>(
        id: 'Recovered',
        colorFn: (DailyCases sales, _) => red[1],
        strokeWidthPxFn: (DailyCases sales, _) => sales.strokeWidthPx,
        domainFn: (DailyCases sales, _) => sales.date,
        measureFn: (DailyCases sales, _) => sales.cases,
        data: recoveredCases,
      ),
    ];
  }
}

class _LineChartCasesState extends State<LineChartCases> {
  int _time;
  Map<String, num> _measures;

  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    int time;
    final measures = <String, num>{};
    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.date;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum.cases;
      });
    }

    // Request a build.
    setState(() {
      _time = time;
      _measures = measures;
    });
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      new Padding(
        padding: EdgeInsets.all(32.0),
        child: SizedBox(
          height: 200,
          child: new charts.LineChart(LineChartCases._sampleData(),
            defaultRenderer:
            new charts.LineRendererConfig(includeArea: true, stacked: true),
            animate: false,
            selectionModels: [new charts.SelectionModelConfig(
                type: charts.SelectionModelType.info,
                changedListener: _onSelectionChanged
            )],
          ),
        ),
      )
    ];

    if (_time != null) {
      children.add(new Padding(
          padding: new EdgeInsets.only(top: 5.0),
          child: new Text(_time.toString())));
    }
    _measures?.forEach((String series, num value) {
      children.add(new Text('$series: $value'));
    });
    return new Column(children: children,);
  }
}

class DailyCases {
  final int date;
  final double cases;
  final double strokeWidthPx;

  DailyCases(this.date, this.cases, this.strokeWidthPx);
}
