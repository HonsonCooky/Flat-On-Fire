import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';

/// ALL POTENTIAL APP PAGES
enum AppPageEnum {
  splash,
  auth,
  home,
  chores,
  groups,
  groupsCreate,
  tables,
  settings,
  error,
  onBoarding,
}

/// PAGE ENUMS TO STRING INTERPRETATIONS FOR DIFFERENT THINGS
extension AppPageExtension on AppPageEnum {
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
      case AppPageEnum.groupsCreate:
        return "create new group";
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
  if(ModalRoute.of(context)?.settings.name == null) return -1;
  var loc = ModalRoute.of(context)!.settings.name!;
  var page = visibleAppRoutes.firstWhere((element) => loc.startsWith(element.toName), orElse: () => AppPageEnum.splash);
  return visibleAppRoutes.indexOf(page);
}

String fromPath(String path) {
  try {
    return AppPageEnum.values.singleWhere((element) => element.toName == path).toTitle;
  } catch (_) {
    return "Unknown Route";
  }
}
