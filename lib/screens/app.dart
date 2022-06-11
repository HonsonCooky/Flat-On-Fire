import 'package:flat_on_fire/core/flutter/routers.dart';
import 'package:flat_on_fire/core/flutter/view_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../theme_consistency_components/objects/theme.dart';

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
