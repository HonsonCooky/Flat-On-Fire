import 'package:flat_on_fire/routing/routers.dart';
import 'package:flat_on_fire/theme_helpers/color_handler.dart';
import 'package:flat_on_fire/theme_helpers/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

import '../common_models/view_model.dart';

class App extends StatelessWidget with GetItMixin {
  App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeMode themeMode = watchOnly((ViewModel vm) => vm.themeMode);
    bool isLightMode = themeMode == ThemeMode.light;

    // Setup the system UI overlay components to match the theme
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
      initialRoute: GetIt.I<ViewModel>().initialRoute,
      onGenerateRoute: Routers.generateRoute,
    );
  }
}
