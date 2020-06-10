import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import 'take_photo.dart';
import '../models/user.dart';

class GuestSU extends StatefulWidget {
  static const routeName = '/guest_signup';
  @override
  _GuestSUState createState() => _GuestSUState();
}

class _GuestSUState extends State<GuestSU> {
  final userId = TextEditingController();
  final userPw = TextEditingController();
  final contact = TextEditingController();

  List<String> fileName = new List<String>();

  Future<String> uploadPhoto(String path) async {
    var url = 'https://intelliguard-sg.azurewebsites.net/api/UploadOnePhoto';
    List<int> byteData = await File(path).readAsBytes();
    FormData data = FormData.fromMap({
      'photo': MultipartFile.fromBytes(
        byteData,
        filename: "image.jpeg",
        contentType: MediaType("image", "jpeg"),
      ),
    });

    Dio dio = new Dio();
    Response response = await dio.post(url, data: data);
    print("Response: ${response.toString()}");

    return response.data["filename"];
  }

  Future<String> createUser(String file) async {
    var url = 'http://intelliguard-sg.azurewebsites.net/api/Data/Users';
    final response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
      body: convert.jsonEncode({
        "UserName": userId.text,
        "UserPw":userPw.text,
        "UPhotoPath": file,
        "UserContact": int.parse(contact.text)
      })
    );
    print("Create User Status: ${response.statusCode}");
    return (response.body);
  }

  Future<bool> multiFaceSignup(String id) async {
    String path = fileName[0];
    for (int i = 1; i < fileName.length; i++) {
      path += ",${fileName[i]}";
    }
    print(path);

    var url =
        'http://intelliguard-sg.azurewebsites.net/api/multifacesignup?id=$id&PathInURL=$path';
    print(url);
    Dio dio = new Dio();
    Response response = await dio.post(url);
    if (response.statusCode == 200) {
      print("Face Added!");
      return true;
    } else {
      return false;
    }
  }

  void register() async {
    final provider = Provider.of<Users>(context, listen: false);
    User user = provider.getUser();
    for (String path in user.paths) {
      String guid = await uploadPhoto(path);
      fileName.add(guid);
    }
    //String id = await createUser(fileName[0]);
    bool success = await multiFaceSignup('5');
  }

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
                  hintText: 'User ID',
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
                    register();
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
