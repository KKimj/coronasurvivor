import 'dart:async';

import 'package:csv/csv.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

List init_()
{
  Response response = init();
  return CsvToListConverter().convert(response.toString());
}

dynamic init() async {

  var dio = Dio();
  Response response = await dio.get('https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports_us/04-14-2020.csv');

  return response;
}

class _MainPageState extends State<MainPage> {
  List covid_19;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //covid_19 = init_();
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
              Center(child: Text('Live COVID 19 Maps', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 40),), ),
              Center(
                child: Image.asset('assets/images/web-usamap.png'),
              ),
              covid_19 == null? Center(child: CircularProgressIndicator(),) : ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                itemCount: covid_19.length,
                  itemBuilder: (BuildContext context, int index) {

                    return index==0? Text('US List view') : Text(index.toString()+'번째 주:'+ covid_19[index][0]+': 확진자수 '+covid_19[index][5].toString());
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
            var now = DateTime.now();
            final yesterday = new DateTime(now.year, now.month, now.day - 1);
            print(yesterday.toString());
            var year = yesterday.year, month = yesterday.year, day = yesterday.day;
            var dio = Dio();
            //Response response = await dio.get('https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports_us/04-16-2020.csv');
            Response response = await dio.get('https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports_us/04-16-2020.csv');
            String k = response.toString();
            List tmp =CsvToListConverter().convert(k);

            int i=0;
            print(tmp[0]);
            for(i=1;i<tmp.length;i++)
              {
                print(tmp[i][0]+': 확진자수 '+tmp[i][5].toString());
              }

            setState(() {
              covid_19 = tmp;

            });
          }
          ,
        ),
        ),
      );
  }
}
