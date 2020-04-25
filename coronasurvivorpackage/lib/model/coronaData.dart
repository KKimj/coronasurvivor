import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CoronaData with ChangeNotifier{
  int day, month, year;
  String url;

  DateTime _dateTime;

  List<List<dynamic>> data;

  CoronaData.fromDateTime(DateTime __dateTime)
  {
    this._dateTime = __dateTime;

    this.year = _dateTime.year;
    this.month = _dateTime.month;
    this.day = _dateTime.day;
    this.setYesterday();
    this.setYesterday();
    this._initFetchData();
  }

  CoronaData(this.year, this.month, this.day)
  {
    this._dateTime = DateTime(this.year, this.month, this.day);

    this._initFetchData();
  }

  @override
  String toString() => 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports_us/0$month-$day-$year.csv';

  String getUrl() => 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports_us/0$month-$day-$year.csv';

  String getUpdateInfo() => 'Update : $year-$month-$day';

  void setTomorrow()
  {
    this._dateTime = DateTime(this.year, this.month, this.day+1);

    this.year = _dateTime.year;
    this.month = _dateTime.month;
    this.day = _dateTime.day;
  }

  void setYesterday()
  {
    this._dateTime = DateTime(this.year, this.month, this.day-1);

    this.year = _dateTime.year;
    this.month = _dateTime.month;
    this.day = _dateTime.day;
  }

  List<List<dynamic>> getData()
  {
    return this.data;
  }

  void setData( List<List<dynamic>> _data) =>  this.data = _data;

  Future<int> fetchData ()
  async {
    // TODO 5
    //print('fetching..');
    var dio = Dio();
    Response response;
    dio.options.connectTimeout = 5000; //5s
    dio.options.receiveTimeout = 3000;

    //response = await dio.get(this.getUrl());
    this.data = null;
    notifyListeners();
    try {
      //404
      response = await dio.get(this.getUrl());
    } on DioError catch(e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if(e.response != null) {
        print('brach1' + response.statusCode.toString());
        return response.statusCode;
      } else{
        // Something happened in setting up or sending the request that triggered an Error
        print('brach2' + response.statusCode.toString());
        return response.statusCode;
      }
    }

    var d = new FirstOccurrenceSettingsDetector(eols: ['\r\n', '\n'], textDelimiters: ['"', "'"]);
    this.setData(CsvToListConverter(csvSettingsDetector: d).convert(response.toString()));

    //print('fetch is done'+response.statusCode.toString());
    notifyListeners();
    return response.statusCode;

  }

  void _initFetchData () async
  {
    int _statusCode;
    do {
      _statusCode = await this.fetchData();
      if(_statusCode!= 200)
      {
        //print('set to yesterday');
        this.setYesterday();
      }
    }
    while(_statusCode != 200);
  }

}