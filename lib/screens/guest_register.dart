import 'package:camera/new/camera.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:camera/camera.dart';

import 'take_photo.dart';

class GuestSU extends StatefulWidget {
  static const routeName = '/guest_signup';
  @override
  _GuestSUState createState() => _GuestSUState();
}

class _GuestSUState extends State<GuestSU> {
  final userId = TextEditingController();
  final userPw = TextEditingController();
  final contact = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
            padding: EdgeInsets.only(left: 30, right: 30),
            children: <Widget>[
              Image.asset(
                'images/white_logo.png',
                height: 200,
                width: 200,
                fit: BoxFit.fitWidth,
              ),
              SizedBox(
                height: 36.0,
              ),
              RaisedButton(
                child: Text("Register Face"),
                onPressed: () async {
                  Navigator.of(context).pushNamed(CameraScreen.routeName);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                color: Colors.blueGrey[200],
              ),
              SizedBox(height: 36.0),
              TextFormField(
                controller: userId,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Name',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                ),
              ),
              SizedBox(height: 16.0),
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
              TextFormField(
                controller: contact,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Contact No.',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  onPressed: () {
                    /*
                    checkCredentials(staffName.text.trim(), staffPw.text.trim(),
                        staffContact.text.trim());
                     */
                  },
                  padding: EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                  color: Colors.blueAccent,
                  child:
                      Text('Sign Up!', style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          )),
        ],
      ),
    );
  }
}
