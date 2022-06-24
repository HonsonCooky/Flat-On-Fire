import 'package:flat_on_fire/_app.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    late Widget page;
    switch (settings.name) {
      case routeBase:
        page = const LoadingPage();
        break;
      case routeLanding:
        page = LandingPage();
        break;
      case routeHome:
        page = HomePage();
        break;
    }
    return MaterialPageRoute(builder: (_) => page);
  }

  static Route<dynamic> unknownRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
        body: Center(
          child: Text(
            'No route defined for "${settings.name}"',
            style: Theme.of(context).textTheme.headline1,
            textAlign: TextAlign.center,
          ),
        ),
      );
    });
  }
}
