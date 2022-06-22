import 'package:flat_on_fire/_app.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    late Widget page;
    // Base
    if (settings.name == routeBase) {
      page = const LoadingPage();
    }
    return unknownRoute(settings);
  }

  static Route<dynamic> unknownRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Text('No route defined for ${settings.name}'),
        ),
      );
    });
  }
}
