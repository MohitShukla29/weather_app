import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'Location.dart';
import 'Networking.dart';

// ${dotenv.env['APIKEY']}
class WeatherModel {
  Future<dynamic> getcity(String cityname)async{
    String uri='https://api.openweathermap.org/data/2.5/weather?q=$cityname&appid=${dotenv.env['APIKEY']}&units=metric';
    Networkhelper networkhelper=Networkhelper(uri);
    var weatherdata=await networkhelper.getdata();
    return weatherdata;
  }
  Future<dynamic> getlocationweather() async{
    Location location = Location();
    await location.getcurrentlocation();

    String uri =
        'https://api.openweathermap.org/data/2.5/weather?lat=${location.latitude}&lon=${location.longitude}&appid=${dotenv.env['APIKEY']}&units=metric';
    Networkhelper networkhelper=Networkhelper(uri);

    var weatherdata=await networkhelper.getdata();
    return weatherdata;
  }
  Future<List<dynamic>> getFiveDayForecast(String cityName) async {
    final uri =
        'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=${dotenv.env['APIKEY']}&units=metric';
    Networkhelper networkhelper=Networkhelper(uri);
    var weatherdata=await networkhelper.getdata();
    if (weatherdata != null && weatherdata['list'] != null) {
      return weatherdata['list'];
    } else {
      throw Exception('Failed to load forecast data');
    }
  }
  List<Map<String, dynamic>> getDailyForecasts(List<dynamic> list) {
    final dailyData = <Map<String, dynamic>>[];

    for (var entry in list) {
      final dtTxt = entry['dt_txt'];
      if (dtTxt.contains("12:00:00")) {
        dailyData.add(entry);
      }
    }

    return dailyData;
  }


  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}