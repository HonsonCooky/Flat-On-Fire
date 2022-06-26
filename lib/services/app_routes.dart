import 'package:flat_on_fire/_app_bucket.dart';

import 'package:flutter/material.dart';

const routeLoading = 'Loading';
const routeAuth = 'Auth';
const routeHome = 'Home';
const routeChores = 'Chores';
const routeGroups = 'Groups';
const routeTables = 'Tables';
const routeSettings = 'Settings';

const initialAppRoute = routeSettings;
const appRoutes = [
  routeHome,
  routeChores,
  routeGroups,
  routeTables,
  routeSettings,
];

Map<String, Widget Function(BuildContext)> routes = {
  routeLoading: (context) => const LoadingPage(),
  routeAuth: (context) => const AuthPage(),
  routeHome: (context) => const HomePage(),
  routeSettings: (context) => const SettingsPage(),
};

indexOfDefaultRoute () => appRoutes.indexOf(initialAppRoute);