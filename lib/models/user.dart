import 'package:flutter/material.dart';


class User with ChangeNotifier{
  String userName;
  String photoPath;
  int contact;
  String role;

  User({
    this.userName,
    this.photoPath,
    this.contact,
    this.role
  });

}

class Users with ChangeNotifier{
  User newUser = new User();

  User getUser(){
    return newUser;
  }

  bool addImage(String path){
    newUser.photoPath = path;
    return true;
  }

  void addDetails(name, contact){
    newUser.userName = name;
    newUser.contact = contact;
  }
}