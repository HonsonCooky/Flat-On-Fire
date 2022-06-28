import 'package:firebase_auth/firebase_auth.dart';
import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  late AppService appService;
  late AuthService authService;

  @override
  void initState() {
    appService = AppService();
    authService = AuthService(FirebaseAuth.instance, appService);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppService>(create: (_) => appService),
        ChangeNotifierProvider<AuthService>(create: (_) => authService),
        Provider<AppRouter>(create: (_) => AppRouter(appService: appService)),
      ],
      child: Builder(
        builder: (context) {
          var themeMode = Provider.of<AppService>(context, listen: true).themeMode;
          final GoRouter goRouter = Provider.of<AppRouter>(context, listen: false).router;
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeModel.light,
            darkTheme: ThemeModel.dark,
            themeMode: themeMode,
            routeInformationProvider: goRouter.routeInformationProvider,
            routeInformationParser: goRouter.routeInformationParser,
            routerDelegate: goRouter.routerDelegate,
          );
        },
      ),
    );
  }
}
