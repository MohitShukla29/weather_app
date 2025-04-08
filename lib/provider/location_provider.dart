import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider with ChangeNotifier {
  Position? _currentPosition;
  String? _errorMessage;
  bool _isLoading = false;

  Position? get currentPosition => _currentPosition;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  double? get latitude => _currentPosition?.latitude;
  double? get longitude => _currentPosition?.longitude;

  // Request location permission and get current location
  Future<void> determinePosition() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _errorMessage = 'Location services are disabled';
        notifyListeners();
        _isLoading = false;
        return;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _errorMessage = 'Location permissions are denied';
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _errorMessage = 'Location permissions are permanently denied, cannot request permissions.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Get the current position
      _currentPosition = await Geolocator.getCurrentPosition();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error getting location: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear the current location data
  void clearLocation() {
    _currentPosition = null;
    _errorMessage = null;
    notifyListeners();
  }
}