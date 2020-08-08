import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class News extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      SizedBox(height: 30,),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage("images/businessinsider.png"),
            ),
            title: Text("Singapore will make travelers wear electronic tags to enforce quarantine"),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage("images/metro.png"),
            ),
            title: Text("Singapore’s Universal Studios deploys facial recognition for entry"),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage("images/bloomberg.png"),
            ),
            title: Text("Singapore Plans Year-End Fintech Event Amid Virus Restrictions"),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ),
      )
    ],);
  }
}
