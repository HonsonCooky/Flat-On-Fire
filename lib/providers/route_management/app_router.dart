import 'package:flat_on_fire/_app.dart';
import 'package:flat_on_fire/pages/app/view/settings_page.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Widget getPageFromName(String? name) {
    switch (name) {
      case routeLoading:
        return const LoadingPage();
      case routeLanding:
        return const LandingPage();
      case routeHome:
        return const HomePage();
      case routeSettings:
        return const SettingsPage();
      default:
        return UnknownPageRoute(name: name ?? "...");
    }
  }

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => getPageFromName(settings.name));
  }
}
