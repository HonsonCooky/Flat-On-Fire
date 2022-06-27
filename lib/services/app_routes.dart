enum AppPages {
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
extension AppPageExtension on AppPages {
  String get toPath {
    switch (this){
      case AppPages.splash:
        return '/splash';
      case AppPages.auth:
        return '/auth';
      case AppPages.home:
        return '/home';
      case AppPages.chores:
        return '/chores';
      case AppPages.groups:
        return '/groups';
      case AppPages.tables:
        return '/tables';
      case AppPages.settings:
        return '/settings';
      case AppPages.error:
        return '/error';
      case AppPages.onBoarding:
        return '/start';
      default:
        return '/';
    }
  }
  
  String get toName {
    switch (this) {
      case AppPages.splash:
        return "SPLASH";
      case AppPages.auth:
        return "AUTH";
      case AppPages.home:
        return "HOME";
      case AppPages.chores:
        return "CHORES";
      case AppPages.groups:
        return "GROUPS";
      case AppPages.tables:
        return "TABLES";
      case AppPages.settings:
        return "SETTINGS";
      case AppPages.error:
        return "ERROR";
      case AppPages.onBoarding:
        return "WELCOME";
      default:
        return "UNKNOWN";
    }
  }
}