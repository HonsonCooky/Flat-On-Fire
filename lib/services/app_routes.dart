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
  groupOverview,
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
      case AppPageEnum.groupsCreate:
        return '/groups/create';
      case AppPageEnum.groupOverview:
        return '/groups/overview';
      case AppPageEnum.tables:
        return '/tables';
      case AppPageEnum.settings:
        return '/settings';
      case AppPageEnum.error:
        return '/err';
      case AppPageEnum.onBoarding:
        return '/onBoarding';
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
      case AppPageEnum.groupsCreate:
        return "create new group";
      case AppPageEnum.groupOverview:
        return "group overview";
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
    return toName.title();
  }
}

List<AppPageEnum> get visibleAppRoutes {
  return [AppPageEnum.home, AppPageEnum.chores, AppPageEnum.groups, AppPageEnum.tables, AppPageEnum.settings];
}

int curBaseRouteIndex(BuildContext context) {
  if (ModalRoute.of(context)?.settings.name == null) return -1;
  var curPage = curAppPage(context);
  var baseName = "/${curPage.toPath.split("/")[1]}";
  return visibleAppRoutes.indexWhere((element) => element.toPath.startsWith(baseName));
}

AppPageEnum curAppPage(BuildContext context) {
  if (ModalRoute.of(context)?.settings.name == null) return AppPageEnum.splash;
  var name = ModalRoute.of(context)!.settings.name!;
  return AppPageEnum.values.singleWhere((element) => element.toPath == name);
}
