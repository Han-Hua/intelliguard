import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intelliguard/screens/guest_register.dart';
import 'package:intelliguard/screens/homepage.dart';
import 'dart:convert' as convert;
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../screens/show_entries.dart';
import '../screens/guest_register.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final userId = TextEditingController();
    final userPw = TextEditingController();

    Future<void> authenticateUser(id, password) async {
      String url = 'https://maddintelliguard.azurewebsites.net/api/login/?name=$id&pass=$password';
      var response = await http.get(url);
      var body = convert.jsonDecode(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final provider = Provider.of<Users>(context, listen: false);
        provider.dispose();
        provider.create();
        //provider.addName(id);
        print("Next page...");
        Navigator.of(context).pushNamed(ShowEntries.routeName);
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Wrong User ID or Password!')));
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
          ),
          Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                Image.asset(
                  'images/Intelliguard.jpg',
                  height: 350 ,
                  width: 200,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: userId,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'Staff Name',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                  ),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  controller: userPw,
                  autofocus: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                  ),
                ),
                SizedBox(height: 24.0),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pushNamed(Homepage.routeName);
                      //authenticateUser(userId.text.trim(), userPw.text.trim());
                    },
                    padding: EdgeInsets.all(12),
                    color: Colors.lightBlue,
                    child:
                        Text('Log In', style: TextStyle(color: Colors.white)),
                  ),
                ),
                FlatButton(
                  child: Text(
                    'Sign up as guest',
                    style: TextStyle(color: Colors.black54),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(GuestSU.routeName);
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
