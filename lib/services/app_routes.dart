import 'package:flat_on_fire/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// ALL POTENTIAL APP PAGES
enum AppPageEnum {
  splash,
  auth,
  home,
  chores,
  groups,
  tables,
  settings,
  error,
  onBoarding,
}

/// PAGE ENUMS TO STRING INTERPRETATIONS FOR DIFFERENT THINGS
extension AppPageExtension on AppPageEnum {
  String get toPath {
    switch (this) {
      case AppPageEnum.splash:
        return '/splash';
      case AppPageEnum.auth:
        return '/auth';
      case AppPageEnum.home:
        return '/home';
      case AppPageEnum.chores:
        return '/chores';
      case AppPageEnum.groups:
        return '/groups';
      case AppPageEnum.tables:
        return '/tables';
      case AppPageEnum.settings:
        return '/settings';
      case AppPageEnum.error:
        return '/error';
      case AppPageEnum.onBoarding:
        return '/start';
      default:
        return '/';
    }
  }

  String get toName {
    switch (this) {
      case AppPageEnum.splash:
        return "splash";
      case AppPageEnum.auth:
        return "auth";
      case AppPageEnum.home:
        return "home";
      case AppPageEnum.chores:
        return "chores";
      case AppPageEnum.groups:
        return "groups";
      case AppPageEnum.tables:
        return "tables";
      case AppPageEnum.settings:
        return "settings";
      case AppPageEnum.error:
        return "error";
      case AppPageEnum.onBoarding:
        return "welcome";
      default:
        return "unknown";
    }
  }

  String get toTitle {
    return toName.capitalize();
  }
}

List<AppPageEnum> get visibleAppRoutes {
  return [AppPageEnum.home, AppPageEnum.chores, AppPageEnum.groups, AppPageEnum.tables, AppPageEnum.settings];
}

List<String> routeNamesFromList(List<AppPageEnum>? from) {
  from ??= visibleAppRoutes;
  return from.map((e) => e.toTitle).toList();
}

int currentAppRouteIndex(BuildContext context) {
  var loc = GoRouter.of(context).location;
  var page = visibleAppRoutes.firstWhere((element) => element.toPath == loc, orElse: () => AppPageEnum.splash);
  return visibleAppRoutes.indexOf(page);
}
