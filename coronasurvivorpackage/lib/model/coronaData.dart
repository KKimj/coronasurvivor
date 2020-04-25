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
}