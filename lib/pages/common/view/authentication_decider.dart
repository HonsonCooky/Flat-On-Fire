import 'package:flat_on_fire/_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthenticationDecider extends StatelessWidget {
  const AuthenticationDecider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context.watch<AuthProvider>().user != null) {
      return AppRouter.getPageFromName(initialAppRoute);
    }
    return const LandingPage();
  }
}
