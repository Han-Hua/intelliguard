import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intelliguard/widgets/daily_cases.dart';
import 'dart:convert';

import 'package:intelliguard/widgets/total_cases.dart';

class Chart extends StatefulWidget {
  static const routeName = '/charts';

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List data;

  Future<void> getCases() async {
    var url = "http://maddintelliguard.azurewebsites.net/api/multifacesignup?id=99009&PathInURL=hy.JPEG,ff5c54cd-0c26-4cf3-afea-44163b0c8d89.jpeg";
    var response = await http.post(url, headers: {
      "Accept": "application/json",
    });

    print(response.body);

    /*
    if (response.statusCode == 200) {
      this.setState(() {
        data = json.decode(response.body);
      });
    }

     */
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getCases();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Card(
            elevation: 5,
            shadowColor: Colors.grey,
            child: Column(
              children: <Widget>[
                Text("Total Confirmed Cases - By Month"),
                SizedBox(
                  height: 10,
                ),
                Container(child: LineChartCases(),margin: EdgeInsets.symmetric(vertical: 40),),
              ],
            ),
          ),
          SizedBox(),
          Card(
            elevation: 5,
            shadowColor: Colors.grey,
            child: Column(
              children: <Widget>[
                Text("Cases within the past week"),
                SizedBox(
                  height: 10,
                ),
                Container(child: BarChart()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
