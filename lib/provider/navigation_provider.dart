import 'package:flutter/material.dart';
import '../screens/loading_screen.dart';
import '../screens/location_screen.dart';
import '../screens/city_screen.dart';

class NavigationProvider with ChangeNotifier {
  String _currentRoute = '/loading';

  Map<String, dynamic> _routeArguments = {};

  String get currentRoute => _currentRoute;
  Map<String, dynamic> get routeArguments => _routeArguments;

  Future<dynamic> navigateTo(
    BuildContext context,
    String routeName, {
    Map<String, dynamic>? arguments,
  }) async {
    _currentRoute = routeName;
    _routeArguments = arguments ?? {};
    notifyListeners();

    dynamic result;

    switch (routeName) {
      case '/loading':
        result = await Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Loadingscreen()),
        );
        break;
      case '/location':
        result = await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => Locationscreen(
                  locationweather: arguments?['locationweather'],
                ),
          ),
        );
        break;
      case '/city':
        result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => Cityscreen()),
        );
        break;
    }

    return result;
  }

  void goBack(BuildContext context, [dynamic result]) {
    Navigator.of(context).pop(result);
  }
}
