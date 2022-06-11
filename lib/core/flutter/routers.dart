import 'package:flat_on_fire/theme_consistency_components/widgets/templates/unfocus_wrapper.dart';
import 'package:flutter/material.dart';

import '../../screens/home/home_page.dart';
import '../../screens/landing/landing_page.dart';

enum Routes {home, landing}
extension ParseToString on Routes {
  String toShortString() {
    return toString().split('.').last;
  }
}

class Routers {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    if (settings.name == Routes.home.toShortString()) {
      return MaterialPageRoute(builder: (_) => const UnFocusWrapper(child: HomePage()));
    } else if (settings.name == Routes.landing.toShortString()) {
      return MaterialPageRoute(builder: (_) => const UnFocusWrapper(child: LandingPage()));
    }
    return null;
  }
  
  static Route<dynamic> unknownRoute(RouteSettings settings){
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Text('No route defined for ${settings.name}'),
        ),
      );
    });
  }
}