import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class Reset extends StatelessWidget {
  static const routeName = '/reset';

  @override
  Widget build(BuildContext context) {
    final contact = TextEditingController();

    Future<void> resetPassword() async{
      int c = int.parse(contact.text.trim());
      String url = "https://intelliguardsg.azurewebsites.net/api/mobile/reset/${c}";
      final response = await http.post(url);
      print(response.statusCode);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text('Forget Password?'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 150.0),
          TextFormField(
            controller: contact,
            autofocus: false,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Your contact',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: FlatButton(
              child: Text(
                'Reset Password',
                style: TextStyle(color: Colors.black54),
              ),
              onPressed: () {
                resetPassword();
              },
            ),
          )
        ],
      ),
    );
  }
}
