import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flat_on_fire/screens/groups_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final AppService appService;

  GoRouter get router => _goRouter;

  AppRouter(this.appService);

  late final GoRouter _goRouter = GoRouter(
    refreshListenable: appService,
    initialLocation: AppPageEnum.auth.toPath,
    routes: [
      // SPLASH
      GoRoute(
        path: AppPageEnum.splash.toPath,
        name: AppPageEnum.splash.toName,
        pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: const LoadingPage()),
      ),
      // LOGIN
      GoRoute(
        path: AppPageEnum.auth.toPath,
        name: AppPageEnum.auth.toName,
        pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: const AuthPage()),
      ),
      // HOME
      GoRoute(
        path: AppPageEnum.home.toPath,
        name: AppPageEnum.home.toName,
        pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: const HomePage()),
      ),
      // CHORES
      GoRoute(
        path: AppPageEnum.chores.toPath,
        name: AppPageEnum.chores.toName,
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const UnknownPageRoute(name: "Chores")),
      ),
      // GROUPS
      GoRoute(
        path: AppPageEnum.groups.toPath,
        name: AppPageEnum.groups.toName,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const GroupsPage(),
        ),
      ),
      // TABLES
      GoRoute(
        path: AppPageEnum.tables.toPath,
        name: AppPageEnum.tables.toName,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const UnknownPageRoute(name: "Tables"),
        ),
      ),
      // SETTINGS
      GoRoute(
        path: AppPageEnum.settings.toPath,
        name: AppPageEnum.settings.toName,
        pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: const SettingsPage()),
      ),
      // START
      GoRoute(
        path: AppPageEnum.onBoarding.toPath,
        name: AppPageEnum.onBoarding.toName,
        pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: const LoadingPage()),
      ),
    ],
    errorBuilder: (context, state) => ErrorPage(error: state.error.toString()),
    redirect: (state) {
      // If the app is not initialized, then run loading screen
      final initialized = appService.initialized;
      final splashPage = AppPageEnum.splash.toPath;
      if (!initialized && state.location != splashPage) {
        return splashPage;
      } else if (!initialized) {
        return null;
      }

      final loggedIn = appService.loginState;
      final authPagePath = AppPageEnum.auth.toPath;

      if (!loggedIn && state.location != authPagePath) return authPagePath;
      if (loggedIn && (state.location == authPagePath || state.location == splashPage)) {
        return AppPageEnum.groups.toPath;
      }
      return null;
    },
  );
}
