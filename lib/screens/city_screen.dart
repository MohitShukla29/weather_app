import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/city_provider.dart';
import '../provider/navigation_provider.dart';

class Cityscreen extends StatefulWidget {
  @override
  State<Cityscreen> createState() => _CityscreenState();
}

class _CityscreenState extends State<Cityscreen> {
  List<String> searchHistory = [];

  @override
  void initState() {
    super.initState();
    loadSearchHistory();
  }

  Future<void> loadSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      searchHistory = prefs.getStringList('searchHistory') ?? [];
    });
  }

  Future<void> saveToSearchHistory(String city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    searchHistory.remove(city);
    searchHistory.insert(0, city);

    // Limit to 5 recent
    if (searchHistory.length > 5) {
      searchHistory = searchHistory.sublist(0, 5);
    }

    await prefs.setStringList('searchHistory', searchHistory);
  }
  Future<void> removeFromSearchHistory(String city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    searchHistory.remove(city);
    await prefs.setStringList('searchHistory', searchHistory);
    setState(() {});
  }
  void handleCitySubmit(String selectedCity) async {
    if (selectedCity.trim().isEmpty) return;
    await saveToSearchHistory(selectedCity.trim());
    Provider.of<NavigationProvider>(
      context,
      listen: false,
    ).goBack(context, selectedCity.trim());
  }

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/city_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.03,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () {
                      navigationProvider.goBack(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: screenWidth * 0.06,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                TextField(
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.location_city,
                      color: Colors.white,
                      size: screenWidth * 0.07,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    hintText: 'Enter City Name',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    Provider.of<CityProvider>(
                      context,
                      listen: false,
                    ).setCityName(value);
                  },

                  onSubmitted: handleCitySubmit,
                  style: TextStyle(fontSize: screenWidth * 0.045),
                ),

                Consumer<CityProvider>(
                  builder: (context, cityProvider, child) {
                    if (cityProvider.suggestions.isEmpty) return SizedBox.shrink();

                    return Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: cityProvider.suggestions.length,
                        itemBuilder: (context, index) {
                          final suggestion = cityProvider.suggestions[index];
                          return ListTile(
                            title: Text(suggestion),
                            onTap: () {
                              Provider.of<CityProvider>(context, listen: false)
                                  .selectSuggestion(suggestion);
                              handleCitySubmit(suggestion);
                            },
                          );
                        },
                      ),
                    );
                  },
                ),

                SizedBox(height: screenHeight * 0.02),

                // 👇 Recent search list
                if (searchHistory.isNotEmpty) ...[
                  Text(
                    'Recent Searches:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Column(
                    children: searchHistory.map((city) {
                      return Card(
                        child: ListTile(
                          title: Text(city),
                          onTap: () => handleCitySubmit(city),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => removeFromSearchHistory(city),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                ],

                SizedBox(height: screenHeight * 0.04),
                Center(
                  child: TextButton(
                    onPressed: () {
                      final cityname =
                          Provider.of<CityProvider>(
                            context,
                            listen: false,
                          ).cityName;
                      handleCitySubmit(cityname);
                    },
                    child: Text(
                      'Get Weather',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.05,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.1,
                        vertical: screenHeight * 0.015,
                      ),
                      backgroundColor: Colors.black45,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
