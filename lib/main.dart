import 'package:firebase_core/firebase_core.dart';
import 'package:flat_on_fire/core/flutter/locator.dart';
import 'package:flat_on_fire/firebase_options.dart';
import 'package:flat_on_fire/screens/app.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupLocator();
  runApp(const App());
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
