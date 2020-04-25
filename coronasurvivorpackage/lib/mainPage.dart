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

  CoronaData coronaData;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    coronaData = Provider.of<CoronaData>(context);
    if(coronaData != this.coronaData)
    {
      coronaData.fetchData();
      this.coronaData = coronaData;

    }
  }

  @override
  void initState() {
    super.initState();
    // TODO 4 retry

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Corona Survivor'),),
        drawer: Drawer(),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: <Widget>[
                Center(child: Text('United States', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 40),), ),
                Center(
                  child: Image.asset('assets/images/web-usamap.png'),
                ),
                Center(child: Text('Cases by States', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 40),), ),
                Center(child: Text(coronaData.getUpdateInfo(), style: TextStyle( fontWeight: FontWeight.bold, fontSize: 25),),),
                Center(
                  child: Row(
                    mainAxisAlignment:  MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.arrow_back_ios),
                            Text('Yesterday'),
                          ],
                        ),
                      onPressed: () {
                        coronaData.setYesterday();coronaData.fetchData();
                      },
                    ),

                    RaisedButton(
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.arrow_forward_ios),
                          Text('Tomorrow'),
                      ],
                    ),
                      onPressed: ()  {
                      coronaData.setTomorrow();coronaData.fetchData();
                      },
                    ),
                  ],
                ), ),

                coronaData.data == null ? Center(child: CircularProgressIndicator(),) : ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    //scrollDirection: Axis.horizontal,
                    physics: NeverScrollableScrollPhysics(),
                    // TODO covid-19 csv length가 나중에 바뀔 수 있음에 주의해야 한다.
                    //itemCount: covid_19.length,
                    itemCount:  coronaData.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if(index == 0)
                      {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text('US List view : there are '+coronaData.data.length.toString()+' datas.'),
                              ListHeader(['State', 'Confirmed', 'Deaths', 'Recovered', 'Tested', 'Hospitalized']),
                            ],
                          ),
                        );
                      }
                      else {
                        return Container(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: ListItem(coronaData.data[index]),
                          ),
                        );
                      }
                    }
                ),
              ],
            ),
          ),
        ),
        //coronasurvivorpackage
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          onPressed: ()
          {
            // TODO csv file이 업데이트 되지 않을 때를 고려해야 한다. -> firebase에 직접 링크를 업로드 하는 방법도 있다. 2020-10월 이후는 코드를 업데이트 해야 한다.
            coronaData.fetchData();
          }
          ,
        ),
    );
  }
}

class ListHeader extends StatelessWidget {
  List<dynamic> data;
  ListHeader(this.data);
  double fontsize = 20;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Text(data[0].toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: fontsize),)
              ),
              Expanded(
                  flex: 1,
                  child: Text(data[1].toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: fontsize-10),)
              ),
              Expanded(
                  flex: 1,
                  child: Text(data[2].toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: fontsize-5),)
              ),
              Expanded(
                  flex: 1,
                  child: Text(data[3].toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: fontsize-5),)
              ),
              Expanded(
                  flex: 1,
                  child: Text(data[4].toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: fontsize-5),)
              ),
              Expanded(
                  flex: 1,
                  child: Text(data[5].toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: fontsize-10),)
              ),

            ],
          ),
        ),
        decoration: new BoxDecoration(
            border: new Border(
                bottom: new BorderSide()
            )
        ),
      ),
    );
  }
}


class ListItem extends StatelessWidget {
  List<dynamic> data;
  ListItem(this.data);
  double fontsize = 13;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                flex: 2,
                  child: Text(data[0].toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: fontsize),)
              ),
              Expanded(
                flex: 1,
                  child: Text(data[5].toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: fontsize),)
              ),
              Expanded(
                  flex: 1,
                  child: Text(data[6].toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: fontsize),)
              ),
              Expanded(
                  flex: 1,
                  child: Text(data[7].toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: fontsize),)
              ),
              Expanded(
                  flex: 1,
                  child: Text(data[11].toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: fontsize),)
              ),
              Expanded(
                  flex: 1,
                  child: Text(data[12].toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: fontsize),)
              ),
            ],
          ),
        ),
        decoration: new BoxDecoration(
            border: new Border(
                bottom: new BorderSide()
            )
        ),
      ),
    );
  }
}
