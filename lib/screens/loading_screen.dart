import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../provider/navigation_provider.dart';
import '../services/weather.dart';

class Loadingscreen extends StatefulWidget {
  @override
  State<Loadingscreen> createState() => _LoadingscreenState();
}

class _LoadingscreenState extends State<Loadingscreen> {
  void initState() {
    super.initState();
    initializeData();
    print("Loaded API Key: ${dotenv.env['APIKEY']}");

  }

  void initializeData() async {
    await getlocation();
  }

  Future<void> getlocation() async {
    var status = await Permission.location.request();
    if (!status.isGranted) {
      print("Location permission not granted");
      return;
    }

    try {
      WeatherModel weatherModel = WeatherModel();
      var weatherdata = await weatherModel.getlocationweather();
      if (!mounted) return;

      Provider.of<NavigationProvider>(context, listen: false).navigateTo(
        context,
        '/location',
        arguments: {'locationweather': weatherdata},
      );
    } catch (e) {
      print("Error getting location weather: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: SpinKitFadingFour(color: Colors.white, size: 100.0)),
    );
  }
}
