import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_assignment/widgets/info_widget.dart';
import '../provider/location_provider.dart';
import '../provider/navigation_provider.dart';
import '../provider/weather_provider.dart';
import '../services/weather.dart';


class Locationscreen extends StatefulWidget {
  final dynamic locationweather;

  Locationscreen({required this.locationweather});

  @override
  State<Locationscreen> createState() => _LocationscreenState();
}

class _LocationscreenState extends State<Locationscreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final weatherProvider = Provider.of<WeatherProvider>(
        context,
        listen: false,
      );
      weatherProvider.updateWeatherData(widget.locationweather);
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.2),
              Colors.black.withOpacity(0.4),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: screenHeight * 0.02,
                left: screenWidth * 0.05,
                child: IconButton(
                  icon: Icon(Icons.near_me, size: screenWidth * 0.1),
                  color: Colors.white,
                  onPressed: () async {
                    final locationProvider = Provider.of<LocationProvider>(
                      context,
                      listen: false,
                    );
                    await locationProvider.determinePosition();
                    if (locationProvider.currentPosition != null) {
                      WeatherModel weather = WeatherModel();
                      var weatherdata = await weather.getlocationweather();
                      await weatherProvider.updateWeatherData(weatherdata);
                    }
                  },
                ),
              ),
              Positioned(
                top: screenHeight * 0.02,
                right: screenWidth * 0.05,
                child: IconButton(
                  icon: Icon(Icons.location_city, size: screenWidth * 0.1),
                  color: Colors.white,
                  onPressed: () async {
                    var typedname = await navigationProvider.navigateTo(
                      context,
                      '/city',
                    );
                    if (typedname != null) {
                      WeatherModel weather = WeatherModel();
                      var weatherdata = await weather.getcity(typedname);
                      await weatherProvider.updateWeatherData(weatherdata);
                    }
                  },
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Temperature and Weather Icon
                      FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${weatherProvider.temperature}°',
                              style: TextStyle(
                                fontFamily: 'Spartan MB',
                                fontSize: screenWidth * 0.25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    blurRadius: 5,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Text(
                              weatherProvider.weatherIcon,
                              style: TextStyle(
                                fontSize: screenWidth * 0.15,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.01),

                      Text(
                        '${weatherProvider.cityName}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.07,
                          fontWeight: FontWeight.w500,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          weatherProvider.message,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Spartan MB',
                            fontSize: screenWidth * 0.065,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.04),

                      // Additional Weather Info
                      Card(
                        color: Colors.black.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.05),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: InfoTile(
                                      icon: Icons.water_drop,
                                      label: 'Humidity',
                                      value: '${weatherProvider.humidity}%',
                                      iconcolor: Colors.blue.shade300,
                                    ),
                                  ),
                                  Expanded(
                                    child: InfoTile(
                                      icon: Icons.air,
                                      label: 'Wind',
                                      value:
                                      '${weatherProvider.windSpeed.toStringAsFixed(1)} m/s',
                                      iconcolor: Colors.teal.shade300,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.015),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: InfoTile(
                                      icon: Icons.water,
                                      label: "Precipitation",
                                      value: "${weatherProvider.precipitation}",
                                      iconcolor: Colors.indigo.shade300,
                                    ),
                                  ),
                                  Expanded(
                                    child: InfoTile(
                                      icon: Icons.wb_sunny_outlined,
                                      label: "Sunrise",
                                      value: "${weatherProvider.sunrise}",
                                      iconcolor: Colors.amber.shade300,
                                    ),
                                  ),
                                  Expanded(
                                    child: InfoTile(
                                      icon: Icons.nights_stay_outlined,
                                      label: "Sunset",
                                      value: "${weatherProvider.sunset}",
                                      iconcolor: Colors.deepPurple.shade300,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.05),

                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "5-Day Forecast",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 120,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: weatherProvider.dailyForecasts.length,
                                itemBuilder: (context, index) {
                                  final day = weatherProvider.dailyForecasts[index];
                                  final date = DateTime.parse(day['dt_txt']);
                                  final temp = day['main']['temp'].toInt();
                                  final iconCode = day['weather'][0]['id'];
                                  final icon = WeatherModel().getWeatherIcon(
                                    iconCode,
                                  );

                                  // Get day name
                                  final dayName = _getDayName(date.weekday);

                                  return Container(
                                    width: 100,
                                    margin: EdgeInsets.symmetric(horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.1),
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          dayName,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "${date.day}/${date.month}",
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.8),
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(icon, style: TextStyle(fontSize: 24)),
                                        Text(
                                          "$temp°C",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'Mon';
      case 2: return 'Tue';
      case 3: return 'Wed';
      case 4: return 'Thu';
      case 5: return 'Fri';
      case 6: return 'Sat';
      case 7: return 'Sun';
      default: return '';
    }
  }
}