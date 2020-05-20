import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intelliguard/screens/guest_register.dart';
import 'dart:convert' as convert;

import '../screens/show_entries.dart';
import '../screens/guest_register.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<String> authenticateUser(id, password) async {
    //TODO: Change to SecureTempWeb
    String url = 'https://securetempweb.azurewebsites.net/api/login/$id/$password';
    var response = await http.get(url);
    var body = convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (body['result'] == true) {
        Navigator.of(context).pushNamed(ShowEntries.routeName);
        return '';
      } else {
        return 'Wrong User ID or Password!';
      }
    } else {
      return 'Error Logging in, Please try again';
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = TextEditingController();
    final userPw = TextEditingController();

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
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
          Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                Image.asset(
                  'images/white_logo.png',
                  height: 200,
                  width: 200,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(height: 48.0),
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
                      Navigator.of(context).pushNamed(ShowEntries.routeName);
                      //authenticateUser(userId.text.trim(), userPw.text.trim());
                    },
                    padding: EdgeInsets.all(12),
                    color: Colors.white,
                    child:
                        Text('Log In', style: TextStyle(color: Color(0xFF79A7D3))),
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
