import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intelliguard/models/entry.dart';
import 'package:intelliguard/screens/guest_register.dart';
import 'package:intelliguard/screens/show_entries.dart';
import 'package:intelliguard/screens/take_photo.dart';
import 'package:provider/provider.dart';
import 'package:intelliguard/models/user.dart';

import 'screens/login_screen.dart';
import 'screens/guest_register.dart';
import 'screens/show_entries.dart';
import 'screens/startup_screen.dart';
import 'screens/take_photo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: EntryHistory()
        ),
        ChangeNotifierProvider.value(value: Users())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: LoginPage(),
        ),
        routes: {
          LoginPage.routeName: (ctx) => LoginPage(),
          ShowEntries.routeName:  (ctx) => ShowEntries(),
          GuestSU.routeName: (ctx) => GuestSU(),
          Startup.routeName: (ctx) => Startup(),
          CameraScreen.routeName: (ctx) => CameraScreen(),
        },
      ),
    );
  }
}
