import 'package:flutter/material.dart';

import 'openWeather.dart';

class WeatherWidget extends StatelessWidget {
  final Future<List<Weather>> weatherFuture;
  final String datum;
  WeatherWidget(
    this.datum,{
    Key key,
  })  : this.weatherFuture = _loadWeather(),
        super(key: key);



  static Future<List<Weather>> _loadWeather() {
    WeatherStation weatherStation =
        WeatherStation("4b62a945622a3c28596f5a03a346a0a9");
    return weatherStation.fiveDayForecast();
  }

  Weather getWeatherForDate(List<Weather> weathers, String date) {
    var result = null;
    weathers.forEach((current)  {
      if(current.date.toIso8601String()==date){
        result=current;
      };
    }
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Weather>>(
      future: weatherFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Weather>> list) {
        switch (list.connectionState) {
          case ConnectionState.done:
            if (list.hasError) return Text('Error: ${list.error}');
            Weather weather = getWeatherForDate(list.data,datum);
            return weather==null?Container():Card(
                child: Container(
                height: 40,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                  Text(
                      "${weather.temperature.celsius.toStringAsFixed(1)}°C  ${weather.weatherDescription}"),
                  Image.network(
                      "http://openweathermap.org/img/wn/${weather.weatherIcon}@2x.png"),
                ])),
            );
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
          default:
            return Container();
        }
      },
    );
  }
}
