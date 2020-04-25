import 'package:coronasurvivorpackage/mainPage.dart';
import 'package:coronasurvivorpackage/testPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/coronaData.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    return
      MultiProvider(
        providers: [
          //Provider<CoronaData>(create: (_) => CoronaData.fromDateTime(DateTime.now())),
          Provider<CoronaData>(create: (_) => CoronaData(2020, 4, 23)),
        ],
          //child: TestPage(),
          child: MainPage(),
      );
  }
}
