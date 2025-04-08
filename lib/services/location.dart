import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Location{
  late double latitude;
  late double longitude;
  late double temp;

  Future<void> getcurrentlocation() async {
    try{
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      latitude=position.latitude;
      longitude=position.longitude;
    }
    catch(e){
      print(e);
    }
  }
}
