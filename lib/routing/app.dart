import 'package:flat_on_fire/theme_helpers/theme.dart';
import 'package:flat_on_fire/routing/routers.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

import '../common_models/view_model.dart';

class App extends StatelessWidget with GetItMixin {
  App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    watchOnly((ViewModel vm) => vm.themeMode);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: GetIt.I<ViewModel>().themeMode,
      initialRoute: GetIt.I<ViewModel>().initialRoute,
      onGenerateRoute: Routers.generateRoute,
      onUnknownRoute: Routers.unknownRoute,
    );
  }
}
