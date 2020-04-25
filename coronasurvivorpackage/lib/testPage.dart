import 'package:coronasurvivorpackage/model/coronaData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestPage extends StatefulWidget {



  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  CoronaData coronaData;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    coronaData = Provider.of<CoronaData>(context);
    if(coronaData != this.coronaData)
      {
        this.coronaData = coronaData;
      }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /*
    Provider.of<CoronaData>(context, listen: false)
     */
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text(coronaData.toString() ),
          RaisedButton(child: Text('click'), onPressed: ()
          {
            setState(() {
              coronaData.setYesterday();
            });
          }
          ,)
        ]
        ,
      ),
    );
  }
}
