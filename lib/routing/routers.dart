import 'package:flat_on_fire/common_widgets/unfocus_wrapper.dart';
import 'package:flat_on_fire/features/authentication/presentation/landing_page.dart';
import 'package:flat_on_fire/features/home/presentation/home_page.dart';
import 'package:flutter/material.dart';

enum Routes { home, landing }

extension ParseToString on Routes {
  String routeName() {
    return toString().split('.').last;
  }
}

class Routers {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    // Home
    if (settings.name == Routes.home.routeName()) {
      return MaterialPageRoute(builder: (_) => const UnFocusWrapper(child: HomePage()));
    }
    // Login
    else if (settings.name == Routes.landing.routeName()) {
      return MaterialPageRoute(builder: (_) => UnFocusWrapper(child: LandingPage()));
    }
    return null;
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
