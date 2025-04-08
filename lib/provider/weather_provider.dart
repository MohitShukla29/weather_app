import 'package:flutter/material.dart';
import '../services/weather.dart';

class WeatherProvider with ChangeNotifier {
  int _temperature = 0;
  int _condition = 0;
  String _weatherIcon = '';
  String _message = '';
  String _cityName = '';
  int _humidity = 0;
  double _windSpeed = 0.0;
  String _sunrise = '';
  String _sunset = '';
  String _precipitation = "0%";
  List<Map<String, dynamic>> _dailyForecasts = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  int get temperature => _temperature;
  int get condition => _condition;
  String get weatherIcon => _weatherIcon;
  String get message => _message;
  String get cityName => _cityName;
  int get humidity => _humidity;
  double get windSpeed => _windSpeed;
  String get sunrise => _sunrise;
  String get sunset => _sunset;
  String get precipitation => _precipitation;
  List<Map<String, dynamic>> get dailyForecasts => _dailyForecasts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final WeatherModel _weatherService = WeatherModel();

  Future<void> updateWeatherData(dynamic weatherData) async {
    if (weatherData == null) {
      _setError('Unable to get Weather data');
      _resetData();
      return;
    }

    try {
      _setLoading(true);

      String fetchedCityName = weatherData['name'];
      List<dynamic> forecastList = await _weatherService.getFiveDayForecast(
        fetchedCityName,
      );
      List<Map<String, dynamic>> daily = _weatherService.getDailyForecasts(
        forecastList,
      );

      final sunriseTimestamp = weatherData['sys']['sunrise'] * 1000;
      final sunsetTimestamp = weatherData['sys']['sunset'] * 1000;

      _temperature = weatherData['main']['temp'].toInt();
      _condition = weatherData['weather'][0]['id'];
      _weatherIcon = _weatherService.getWeatherIcon(_condition);
      _message = _weatherService.getMessage(_temperature);
      _cityName = fetchedCityName;
      _humidity = weatherData['main']['humidity'];
      _windSpeed = weatherData['wind']['speed'].toDouble();
      _sunrise = DateTime.fromMillisecondsSinceEpoch(
        sunriseTimestamp,
      ).toLocal().toString().split(' ')[1].substring(0, 5);
      _sunset = DateTime.fromMillisecondsSinceEpoch(
        sunsetTimestamp,
      ).toLocal().toString().split(' ')[1].substring(0, 5);
      _dailyForecasts = daily;
      _errorMessage = null;

      notifyListeners();
    } catch (e) {
      _setError('Error updating weather data: $e');
      _resetData();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getLocationWeather() async {
    try {
      _setLoading(true);
      var weatherData = await _weatherService.getlocationweather();
      await updateWeatherData(weatherData);
    } catch (e) {
      _setError('Error getting location weather: $e');
      _resetData();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getCityWeather(String cityName) async {
    if (cityName.isEmpty) return;

    try {
      _setLoading(true);
      var weatherData = await _weatherService.getcity(cityName);
      await updateWeatherData(weatherData);
    } catch (e) {
      _setError('Error getting weather for $cityName: $e');
      _resetData();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _resetData() {
    _temperature = 0;
    _weatherIcon = 'Error';
    _message = _errorMessage ?? 'Unable to get Weather data';
    _cityName = '';
    _humidity = 0;
    _windSpeed = 0.0;
    _sunrise = '';
    _sunset = '';
    _dailyForecasts = [];
    notifyListeners();
  }
}
