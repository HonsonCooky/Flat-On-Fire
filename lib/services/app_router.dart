import 'package:flat_on_fire/_app_bucket.dart';
import 'package:go_router/go_router.dart';

const String LOGIN_KEY = "5FD6G46SDF4GD64F1VG9SD68";
const String ONBOARD_KEY = "GD2G82CG9G82VDFGVD22DVG";

class AppRouter {
  final AppService appService;
  final AuthService authService;
  
  GoRouter get router => _goRouter;

  AppRouter({required this.appService, required this.authService});

  late final GoRouter _goRouter = GoRouter(
    refreshListenable: appService,
    initialLocation: AppPages.home.toPath,
    routes: [
      // SPLASH
      GoRoute(
        path: AppPages.splash.toPath,
        name: AppPages.splash.toName,
        builder: (context, state) => const LoadingPage(),
      ),
      // LOGIN
      GoRoute(
        path: AppPages.auth.toPath,
        name: AppPages.auth.toName,
        builder: (context, state) => const AuthPage(),
      ),
      // HOME
      GoRoute(
        path: AppPages.home.toPath,
        name: AppPages.home.toName,
        builder: (context, state) => const HomePage(),
      ),
      // CHORES
      GoRoute(
        path: AppPages.chores.toPath,
        name: AppPages.chores.toName,
        builder: (context, state) => const UnknownPageRoute(name: "Chores"),
      ),
      // GROUPS
      GoRoute(
        path: AppPages.groups.toPath,
        name: AppPages.groups.toName,
        builder: (context, state) => const UnknownPageRoute(name: "Groups"),
      ),
      // TABLES
      GoRoute(
        path: AppPages.tables.toPath,
        name: AppPages.tables.toName,
        builder: (context, state) => const UnknownPageRoute(name: "Tables"),
      ),
      // SETTINGS
      GoRoute(
        path: AppPages.settings.toPath,
        name: AppPages.settings.toName,
        builder: (context, state) => const SettingsPage(),
      ),
      // ERROR
      GoRoute(
        path: AppPages.error.toPath,
        name: AppPages.error.toName,
        builder: (context, state) => const UnknownPageRoute(name: "Error"),
      ),
      // START
      GoRoute(
        path: AppPages.onBoarding.toPath,
        name: AppPages.onBoarding.toName,
        builder: (context, state) => const LoadingPage(),
      ),
    ],
    redirect: (state) {
      final authLocation = state.namedLocation(AppPages.auth.toPath);
      final homeLocation = state.namedLocation(AppPages.home.toPath);
      final splashLocation = state.namedLocation(AppPages.splash.toPath);
      final onboardLocation = state.namedLocation(AppPages.onBoarding.toPath);

      final isLoggedIn = authService.user != null;
      final isInitialized = appService.initialized;
      final isOnboarded = appService.onboarding;

      final isGoingToLogin = state.subloc == authLocation;
      final isGoingToInit = state.subloc == splashLocation;
      final isGoingToOnboard = state.subloc == onboardLocation;

      // If not Initialized and not going to Initialized redirect to Splash
      if (!isInitialized && !isGoingToInit) {
        return splashLocation;
        // If not onboard and not going to onboard redirect to OnBoarding
      } else if (isInitialized && !isOnboarded && !isGoingToOnboard) {
        return onboardLocation;
        // If not logedin and not going to login redirect to Login
      } else if (isInitialized && isOnboarded && !isLoggedIn && !isGoingToLogin) {
        return authLocation;
        // If all the scenarios are cleared but still going to any of that screen redirect to Home
      } else if ((isLoggedIn && isGoingToLogin) || (isInitialized && isGoingToInit) || (isOnboarded && isGoingToOnboard)) {
        return homeLocation;
      } else {
        // Else Don't do anything
        return null;
      }
    },
  );
}
