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
  List<List<dynamic>> covid_19;
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
    super.initState();

    //Provider.of<CoronaData>(context, listen: false);
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

              covid_19 == null? Center(child: CircularProgressIndicator(),) : ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                // TODO covid-19 csv length가 나중에 바뀔 수 있음에 주의해야 한다.
                //itemCount: covid_19.length,
                  itemCount: 59,
                  itemBuilder: (BuildContext context, int index) {
                    if(index == 0)
                    {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('US List view : there are '+covid_19.length.toString()+' datas.'),
                        );
                    }
                    else {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(index.toString() + ' 번째 주 in ' +
                            covid_19[index][1] + ': ' + covid_19[index][0] +
                            ': 확진자수 ' + covid_19[index][5].toString()),
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
            var dio = Dio();

            coronaData.setYesterday();
            coronaData.setYesterday();
            Response response =  await dio.get(coronaData.getUrl());
            var d = new FirstOccurrenceSettingsDetector(eols: ['\r\n', '\n'], textDelimiters: ['"', "'"]);
            coronaData.setData(CsvToListConverter(csvSettingsDetector: d).convert(response.toString()));



            bool _testmode = true;
            if(_testmode) {
              print('test');
              print(coronaData.toString());
            }

            setState(() {
              covid_19 = coronaData.getData();

            });
          }
          ,
        ),
        ),
      );
  }
}
