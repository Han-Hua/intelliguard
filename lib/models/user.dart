import 'package:flutter/material.dart';


class User with ChangeNotifier{
  String userName;
  List<String> paths;
  int contact;
  String role;


  User({
    this.userName,
    this.paths,
    this.contact,
    this.role
  });

}

class Users with ChangeNotifier{
  User newUser = new User();

  User create(){
    newUser = new User();
  }

  User getUser(){
    return newUser;
  }

  bool addPaths(List<String> paths){
    newUser.paths = new List<String>();
    newUser.paths.addAll(paths);
    return true;
  }

  void addName(name){
    newUser.userName = name;
  }

  void addDetails(name, contact){
    newUser.userName = name;
    newUser.contact = contact;
  }

  void dispose(){
    newUser.dispose();
  }
}

