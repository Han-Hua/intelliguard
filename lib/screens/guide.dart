import 'package:flutter/material.dart';
import 'package:intelliguard/screens/take_photo.dart';

class Guide extends StatelessWidget {

  static const routeName = '/guide.dart';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Column(
        children: <Widget>[
          Container(
            child: Image.asset('images/faces.gif'),
          ),
          SizedBox(height: 150,),
          Text(
            'While timer is running, tilt your face according to the guide',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18.0,
                color: Colors.grey[700]),
          ),
          Text(
            'Ensure that there is sufficient lighting around you',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18.0,
                color: Colors.grey[700]),
          ),
          FlatButton(
            child: Text(
              'Click to continue',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18.0,
                  color: Colors.grey[700]),
            ),
            onPressed: (() {
              Navigator.of(context).pushNamed(CameraScreen.routeName);
            }),
          )
        ],
      ),
    );
  }
}
