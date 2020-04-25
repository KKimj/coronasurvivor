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
                    RaisedButton(child: Text('Yesterday'), onPressed: () {

                      coronaData.setYesterday();
                      coronaData.fetchData();
                    },),
                    Padding(padding: EdgeInsets.all(12),),
                    RaisedButton(child: Text('Tomorrow'), onPressed: ()  {
                      coronaData.setTomorrow();
                      coronaData.fetchData();
                      },),
                  ],
                ), ),

                coronaData.data == null ? Center(child: CircularProgressIndicator(),) : Center(
                  child: ListView.builder(
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
                                Text('State Confirmed Deaths Recovered Tested Hospitalized')
                              ],
                            ),
                          );
                        }
                        else {
                          return Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: ListTile(
                              title: Column(
                                children: <Widget>[
                                  ListItem(coronaData.data[index]),
                                ],
                              ),
                            ),
                          );
                        }
                      }
                  ),
                ),
              ],
            ),
          ),
        ),
        //coronasurvivorpackage
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.compare_arrows),
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

class ListItem extends StatelessWidget {
  List<dynamic> data;
  ListItem(this.data);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: <Widget>[
          SizedBox(
            width: 100,
              child: Text(data[0].toString())
          ),
          SizedBox(
            width: 60,
              child: Text(data[5].toString())
          ),
          SizedBox(
              width: 60,
              child: Text(data[6].toString())
          ),
          SizedBox(
              width: 60,
              child: Text(data[7].toString())
          ),
          SizedBox(
              width: 60,
              child: Text(data[11].toString())
          ),
          SizedBox(
              width: 60,
              child: Text(data[12].toString())
          ),
        ],
      ),
    );
  }
}
