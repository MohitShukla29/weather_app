import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_assignment/provider/city_provider.dart';
import 'package:weather_app_assignment/provider/location_provider.dart';
import 'package:weather_app_assignment/provider/navigation_provider.dart';
import 'package:weather_app_assignment/provider/weather_provider.dart';
import 'package:weather_app_assignment/screens/loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName:".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => NavigationProvider()),
          ChangeNotifierProvider(create: (_) => LocationProvider()),
          ChangeNotifierProvider(create: (_) => WeatherProvider()),
          ChangeNotifierProvider(create: (_) => CityProvider()),
    ],
      child: MaterialApp(
        theme: ThemeData(

          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: Loadingscreen()
      ),
    );
  }
}

