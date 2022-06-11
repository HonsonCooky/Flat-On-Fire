import 'package:flat_on_fire/theme_consistency_components/objects/fof_buttons/fof_button_impls.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LandingPageState();
}

const double _fontSize = 24;
const double _iconMultiplier = 1.2;

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: ElevatedButton.icon(
                  style: primaryButtonStyle(context),
                  onPressed: () {},
                  icon: const Icon(Icons.mail_outline, size:  _fontSize * _iconMultiplier,),
                  label: const Text(
                    "Sign In",
                    style: TextStyle(fontSize: _fontSize),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: ElevatedButton.icon(
                  style: googleBlueButtonStyle(context),
                  onPressed: () {},
                  icon: Image.asset(
                    'assets/google_logo.png',
                    height: _fontSize * _iconMultiplier,
                    fit: BoxFit.fitHeight,
                  ),
                  label: const Text(
                    "Sign in with Google",
                    style: TextStyle(fontSize: _fontSize),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: TextButton.icon(
                    style: textButtonStyle(context),
                    onPressed: () {},
                    icon: const Icon(
                      Icons.person_add,
                      size: _fontSize * _iconMultiplier,
                    ),
                    label: const Text(
                      "Signup",
                      style: TextStyle(fontSize: _fontSize),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
