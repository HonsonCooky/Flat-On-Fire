import 'package:flat_on_fire/config/_configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

import 'providers/_providers.dart';

class App extends StatelessWidget with GetItMixin {
  App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeMode themeMode = watchOnly((ViewModel vm) => vm.themeMode);

    // Setup the system UI overlay components to match the theme
    bool isLightMode = themeMode == ThemeMode.light;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: isLightMode ? AppColors.lightPrimary : AppColors.darkPrimary,
        systemNavigationBarIconBrightness: isLightMode ? Brightness.light : Brightness.dark,
        statusBarColor: isLightMode ? AppColors.lightPrimary : AppColors.darkPrimary,
        statusBarBrightness: isLightMode ? Brightness.light : Brightness.dark,
        statusBarIconBrightness: isLightMode ? Brightness.light : Brightness.dark,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
    );
  }
}
