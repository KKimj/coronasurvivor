import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CoronaData {
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
  }

  CoronaData(this.year, this.month, this.day)
  {
    this._dateTime = DateTime(this.year, this.month, this.day);
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

  Future<void> fetchData ()
  async {
    // TODO 5
    var dio = Dio();
    Response response =  await dio.get(this.getUrl());
    var d = new FirstOccurrenceSettingsDetector(eols: ['\r\n', '\n'], textDelimiters: ['"', "'"]);
    this.setData(CsvToListConverter(csvSettingsDetector: d).convert(response.toString()));
  }

}