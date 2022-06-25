import 'package:flat_on_fire/_app.dart';
import 'package:flat_on_fire/pages/common/widgets/drawer.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    late Widget page;
    switch (settings.name) {
      case routeLoading:
        page = const LoadingPage();
        break;
      case routeLanding:
        page = const LandingPage();
        break;
      case routeHome:
        page = const HomePage();
        break;
      default:
        return MaterialPageRoute(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(title: const Text('Oh no!'), elevation: 0,),
            drawer: const AppDrawer(),
            body: Center(
              child: Text(
                'No route defined for "${settings.name}"',
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.center,
              ),
            ),
          );
        });
    }
    return MaterialPageRoute(builder: (_) => page);
  }
}
