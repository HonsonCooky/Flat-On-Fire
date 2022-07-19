import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';

var appRouter = AppPageEnum.values.asNameMap().map((key, value) {
  String k = value.toPath;
  Widget v;
  switch (value) {
    case AppPageEnum.splash:
      v = const LoadingPage();
      break;
    case AppPageEnum.auth:
      v = const AuthPage();
      break;
    case AppPageEnum.home:
      v = const HomePage();
      break;
    case AppPageEnum.groups:
      v = const GroupsPage();
      break;
    case AppPageEnum.groupsCreate:
      v = const CreateGroupPage();
      break;
    case AppPageEnum.settings:
      v = const SettingsPage();
      break;
    case AppPageEnum.error:
      v = const ErrorPage();
      break;
    // case AppPageEnum.chores:
    // case AppPageEnum.tables:
    // case AppPageEnum.onBoarding:
    default:
      k = "Unknown";
      v = UnknownPageRoute(name: k);
  }
  return MapEntry(k, (context) => v);
});
