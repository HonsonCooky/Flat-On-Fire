import 'package:flat_on_fire/constants/theme.dart';
import 'package:flat_on_fire/routing/routers.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../common_models/view_model.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.light(),
      darkTheme: Themes.dark(),
      themeMode: GetIt.I<ViewModel>().themeMode,
      initialRoute: GetIt.I<ViewModel>().initialRoute,
      onGenerateRoute: Routers.generateRoute,
      onUnknownRoute: Routers.unknownRoute,
    );
  }
}
