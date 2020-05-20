import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intelliguard/dummydata.dart';

import '../models/entry.dart';
import '../widgets/entry_item.dart';

class Display extends StatefulWidget {

  static const routeName = '/display';
  @override
  _DisplayState createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  List data;

  Future<void> getEntries() async {
    var response = await http.get(
        ("https://maddapp.azurewebsites.net/api/entryrecords"),
        headers: {"Accept": "application/json"});
    print(response.statusCode);
    this.setState(() {
      data = json.decode(response.body);
    });

    final entryData = Provider.of<EntryHistory>(context, listen: false);
    for (int i = 0; i < data.length; i++) {
      Entry e = Entry(
          entryID: data[i]['entryID'],
          temperature: data[i]['temperature'],
          entryDateTime: data[i]['entryTime']);

      entryData.addEntry(e);
    }
    print(entryData.entry[0].entryID);
    print(entryData.entry[0].temperature);
    print(entryData.entry[0].entryDateTime);

    return 'Success!';
  }

  @override
  void initState() {
    super.initState();
    //getEntries();
    final entryProvider = Provider.of<EntryHistory>(context, listen: false);
    entryProvider.clearEntries();
    for(Entry e in entryList){
      entryProvider.addEntry(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final entryProvider = Provider.of<EntryHistory>(context, listen: false);

    return Stack(
      children: <Widget>[
        Container(
          color: Colors.white,
        ),
        GridView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount:
              entryProvider.entry == null ? 0 : entryProvider.entry.length,
          itemBuilder: (BuildContext context, int i) =>
              ChangeNotifierProvider.value(
                  value: entryProvider,
                  child: EntryItem(
                    name: entryProvider.entry[i].name,
                    temperature: entryProvider.entry[i].temperature,
                    entryDateTime: entryProvider.entry[i].entryDateTime,
                  )),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 3/1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
        ),
      ],
    );
  }
}
