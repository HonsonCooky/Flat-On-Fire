import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flat_on_fire/app.dart';
import 'package:flat_on_fire/firebase_options.dart';
import 'package:flat_on_fire/providers/state_management/auth_model.dart';
import 'package:flat_on_fire/providers/state_management/view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate();

  GetIt.I.registerSingleton<AuthModel>(AuthModel());
  GetIt.I.registerSingleton<ViewModel>(ViewModel());

  // Allow emulator to pass APP CHECK
  // Whitelist environment means that this is safe to upload, as it will only allow known emulators to pass.
  if (kDebugMode) {
    const platform = MethodChannel('honsoncooky.flutter.dev/appcheck');
    await platform.invokeMethod("installDebug");
  }
  runApp(App());
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
