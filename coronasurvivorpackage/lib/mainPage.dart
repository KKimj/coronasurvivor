import 'dart:async';

import 'package:coronasurvivorpackage/model/coronaData.dart';
import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}


class _MainPageState extends State<MainPage> {
  StreamController ctrl = StreamController();

  List<List<dynamic>> covid_19;
  CoronaData coronaData;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    coronaData = Provider.of<CoronaData>(context);
    if(coronaData != this.coronaData)
    {
      coronaData.fetchData().then((value) => this.covid_19 = coronaData.getData());
      this.coronaData = coronaData;
      this.ctrl.add(this.covid_19);
    }
  }

  @override
  void initState() {
    super.initState();
    // TODO 4 retry
    //Provider.of<CoronaData>(context, listen: false);

    //Provider.of<CoronaData>(context).fetchData();
    Future.microtask(() => print('init..'));
//    Future.microtask(() => Provider.of<CoronaData>(context).fetchData());
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Corona Survivor'),),
        drawer: Drawer(),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: <Widget>[
              Center(child: Text('United States', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 40),), ),
              Center(
                child: Image.asset('assets/images/web-usamap.png'),
              ),
              Center(child: Text('Cases by States', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 40),), ),
              Center(
                child: Row(
                  mainAxisAlignment:  MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(child: Text('Yesterday'), onPressed: () async {
                    setState(() {
                      ctrl.add(null);
                    });
                    coronaData.setYesterday();
                    await coronaData.fetchData();
                    setState( () {
                    covid_19 = coronaData.getData();
                    ctrl.add(covid_19);
                    });},),
                  Text(coronaData.getUpdateInfo(), style: TextStyle( fontWeight: FontWeight.bold, fontSize: 40),),
                  RaisedButton(child: Text('Tomorrow'), onPressed: () async {
                    setState(() {
                      ctrl.add(null);
                    });
                    coronaData.setTomorrow();
                    await coronaData.fetchData();
                    setState( () {
                      covid_19 = coronaData.getData();
                      ctrl.add(covid_19);
                    });

                    },),
                ],
              ), ),
              coronaData.data == null ? Center(child: CircularProgressIndicator(),) : ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  // TODO covid-19 csv length가 나중에 바뀔 수 있음에 주의해야 한다.
                  //itemCount: covid_19.length,
                  itemCount:  coronaData.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    if(index == 0)
                    {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('US List view : there are '+coronaData.data.length.toString()+' datas.'),
                      );
                    }
                    else {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(index.toString() + ' 번째 주 in ' +
                              coronaData.data[index][1] + ': ' + coronaData.data[index][0] +
                              ': 확진자수 ' + coronaData.data[index][5].toString()),
                        ),
                      );
                    }
                  }
              ),

            ],
          ),
        ),
        //coronasurvivorpackage
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.compare_arrows),
          onPressed: () async
          {
            // TODO csv file이 업데이트 되지 않을 때를 고려해야 한다. -> firebase에 직접 링크를 업로드 하는 방법도 있다. 2020-10월 이후는 코드를 업데이트 해야 한다.

            await coronaData.fetchData();

            bool _testmode = true;
            if(_testmode) {
              print('test');
              print(coronaData.toString());
            }

            setState(() {
              covid_19 = coronaData.getData();
              ctrl.add(covid_19);

            });
          }
          ,
        ),
        ),
      );
  }
}
