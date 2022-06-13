import 'package:flat_on_fire/theme_helpers/color_handler.dart';
import 'package:flutter/material.dart';

import '../theme_helpers/theme.dart';

/// When the application runs into an error, this page is shown. Usually indicates that the app check has blocked the
/// application from running.
class BadApp extends StatelessWidget {
  const BadApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      builder: (BuildContext context, Widget? widget) => Scaffold(
        backgroundColor: AppColors.lightBackground,
        body: Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: AppColors.lightError, size: 50,),
              const Text(
                "Flat On Fire Unavailable",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const Text(
                "Reason: Unable to verify application registration",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
