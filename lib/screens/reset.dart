import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class Reset extends StatelessWidget {
  static const routeName = '/reset';

  @override
  Widget build(BuildContext context) {
    final contact = TextEditingController();

    Future<void> resetPassword() async {
      int c = int.parse(contact.text.trim());
      String url =
          "https://intelliguardsg.azurewebsites.net/api/mobile/reset/${c}";
      final response = await http.post(url);
      print(response.statusCode);
      if (response.body == "success") {
        Navigator.pop(context);
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text('Forget Password?'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.asset(
              'images/Intelliguard.jpg',
              height: 400,
              width: 300,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: TextFormField(
                controller: contact,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Your contact',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                ),
              ),
            ),
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: RaisedButton(
                color: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  'Reset Password',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  resetPassword();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
