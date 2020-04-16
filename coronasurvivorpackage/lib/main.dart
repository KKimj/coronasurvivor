import 'package:coronasurvivorpackage/rootPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Corona Survivor',
      theme: ThemeData(
        accentColor: const Color(0xFFF16876),
        primaryColor: const Color(0xFFB3BFE7),
        fontFamily: 'SCDream',
        /*textTheme: TextTheme(
          title: TextStyle(fontSize: 18.0, fontStyle: FontStyle.normal),
          body1: TextStyle(fontSize: 14.0, fontStyle: FontStyle.normal)
        )*/

      ),
      home: RootPage(),
    );
  }
}

// *Done TODO 0 set application icon, splash screen
// TODO 1 implementation MainPage
// TODO 1-1 implementation Map ui
// TODO 1-2 implementation List view

// TODO 2 Design User by tracking

