import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  late bool userExists;

  @override
  void initState() {
    userExists = context.read<AuthProvider>().user != null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ViewProvider>().themeMode;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeModel.light,
      darkTheme: ThemeModel.dark,
      themeMode: themeMode,
      initialRoute: userExists ? initialAppRoute : routeAuth,
      routes: routes,
      builder: (context, child) {
        // Setup the system UI overlay components to match the theme
        var isLightMode = Theme.of(context).brightness == Brightness.light;
        var brightness = isLightMode ? Brightness.dark : Brightness.light;
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            systemNavigationBarColor: Theme.of(context).colorScheme.primary,
            statusBarColor: Theme.of(context).colorScheme.primary,
            statusBarBrightness: brightness,
            statusBarIconBrightness: brightness,
            systemNavigationBarIconBrightness: brightness,
          ),
        );

        return child!;
      },
    );
  }
}
