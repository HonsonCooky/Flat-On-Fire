import 'package:firebase_core/firebase_core.dart';
import 'package:flat_on_fire/common_models/auth_model.dart';
import 'package:flat_on_fire/common_models/view_model.dart';
import 'package:flat_on_fire/firebase_options.dart';
import 'package:flat_on_fire/routing/app.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  GetIt.I.registerSingleton<AuthModel>(AuthModel());
  GetIt.I.registerSingleton<ViewModel>(ViewModel());
  runApp(App());
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
