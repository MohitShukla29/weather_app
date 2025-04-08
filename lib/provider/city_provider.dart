import 'package:flutter/material.dart';

class CityProvider extends ChangeNotifier {
  String _cityName = '';
  List<String> _suggestions = [];

  String get cityName => _cityName;
  List<String> get suggestions => _suggestions;


  void setCityName(String name) {
    _cityName = name;
    _updateSuggestions(name);
    notifyListeners();
  }
  void _updateSuggestions(String query) {
    // Mocked city list, replace this with API call if needed
    List<String> allCities = ['Mumbai', 'Delhi', 'Bangalore', 'Kolkata', 'Chennai', 'Pune', 'Ahmedabad'];

    if (query.isEmpty) {
      _suggestions = [];
    } else {
      _suggestions = allCities
          .where((city) => city.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
  void selectSuggestion(String selectedCity) {
    _cityName = selectedCity;
    _suggestions = [];
    notifyListeners();
  }

}
