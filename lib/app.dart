import 'package:firebase_auth/firebase_auth.dart';
import 'package:flat_on_fire/_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ViewProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider(FirebaseAuth.instance)),
        ],
        builder: (context, child) {
          final themeMode = context.watch<ViewProvider>().themeMode;

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            onGenerateRoute: AppRouter.generateRoute,
            onUnknownRoute: AppRouter.unknownRoute,
            home: const AuthenticationDecider(),
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
        });
  }
}
