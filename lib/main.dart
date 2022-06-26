import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate();

  // Allow emulator to pass APP CHECK
  // Whitelist environment means that this is safe to upload, as it will only allow known emulators to pass.
  if (kDebugMode) {
    const platform = MethodChannel('honsoncooky.flutter.dev/appcheck');
    await platform.invokeMethod("installDebug");
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ViewProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider(FirebaseAuth.instance)),
      ],
      child: const App(),
    ),
  );
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
