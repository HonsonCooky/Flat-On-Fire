import 'package:flat_on_fire/_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthenticationDecider extends StatelessWidget {
  const AuthenticationDecider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    if (user != null) {
      return HomePage();
    }

    return const LandingPage();
  }
}
