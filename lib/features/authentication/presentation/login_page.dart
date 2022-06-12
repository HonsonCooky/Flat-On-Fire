import 'package:flat_on_fire/common_models/view_model.dart';
import 'package:flat_on_fire/constants/fof_button_impls.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    const double fontSize = 24;
    const double smallFontSize = 18;
    const double iconMultiplier = 1.2;
    ThemeMode tm = GetIt.I<ViewModel>().themeMode;

    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// Sign In Button
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: ElevatedButton.icon(
                  style: primaryButtonStyle(context),
                  onPressed: () {},
                  icon: const Icon(
                    Icons.mail_outline,
                    size: fontSize * iconMultiplier,
                  ),
                  label: const Text(
                    "Sign In",
                    style: TextStyle(fontSize: fontSize),
                  ),
                ),
              ),

              /// Google Sign In Button
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: ElevatedButton.icon(
                  style: googleBlueButtonStyle(context),
                  onPressed: () {},
                  icon: Image.asset(
                    tm == ThemeMode.light ? 'assets/google_logo_light.png' : 'assets/google_logo_dark.png',
                    height: fontSize * iconMultiplier,
                    fit: BoxFit.fitHeight,
                  ),
                  label: const Text(
                    "Sign in with Google",
                    style: TextStyle(fontSize: fontSize),
                  ),
                ),
              ),
              Wrap(
                alignment: WrapAlignment.spaceAround,
                children: [
                  /// Signup button
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: TextButton.icon(
                        style: textButtonStyle(context),
                        onPressed: () {},
                        icon: const Icon(
                          Icons.person_add,
                          size: smallFontSize * iconMultiplier,
                        ),
                        label: const Text(
                          "Signup",
                          style: TextStyle(fontSize: smallFontSize),
                        )),
                  ),

                  /// Forgot password button
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: TextButton.icon(
                        style: textButtonStyle(context),
                        onPressed: () {},
                        icon: const Icon(
                          Icons.password_outlined,
                          size: smallFontSize * iconMultiplier,
                        ),
                        label: const Text(
                          "Forgot Password",
                          style: TextStyle(fontSize: smallFontSize),
                        )),
                  ),
                ],
              ),

              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: TextButton.icon(
                    style: textButtonStyle(context),
                    onPressed: () {
                      print("HEre");
                      GetIt.I<ViewModel>().switchTheme();
                    },
                    icon: const Icon(
                      Icons.access_alarm_outlined,
                      size: smallFontSize * iconMultiplier,
                    ),
                    label: const Text(
                      "Theme Change",
                      style: TextStyle(fontSize: smallFontSize),
                    )),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
