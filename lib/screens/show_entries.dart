import 'package:flutter/material.dart';
import 'package:intelliguard/screens/login_screen.dart';

import '../widgets/display_entry.dart';

class ShowEntries extends StatefulWidget {
  static const routeName = '/showEntries';

  @override
  _ShowEntriesState createState() => _ShowEntriesState();

  final String id;

  ShowEntries({this.id});
}

class _ShowEntriesState extends State<ShowEntries> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState.openDrawer();
  }

  void _closeDrawer() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Entry Records"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4f74c2),
                  Color(0xFF6883BC),
                  Color(0xFF79A7D3)
                ]),
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                _openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Display(),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    bottom: 12.0,
                    left: 16.0,
                    child: Text(
                      'Features',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0),
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF4f74c2),
                      Color(0xFF6883BC),
                      Color(0xFF79A7D3)
                    ]),
              ),
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.list),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text('Display Entries'),
                  )
                ],
              ),
              onTap: () {
                Navigator.of(context).pushNamed(ShowEntries.routeName);
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.person_pin_circle),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text('Contact Tracing'),
                  )
                ],
              ),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.arrow_back),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text('Logout'),
                  )
                ],
              ),
              onTap: () {
                Navigator.of(context).pushNamed(LoginPage.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
