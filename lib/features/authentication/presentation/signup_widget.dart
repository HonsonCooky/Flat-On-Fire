import 'package:flat_on_fire/common_models/view_model.dart';
import 'package:flat_on_fire/theme_helpers/color_handler.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class SignupWidgets extends StatefulWidget with GetItStatefulWidgetMixin {
  SignupWidgets({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignupWidgetsClass();
}

class _SignupWidgetsClass extends State<SignupWidgets> with GetItStateMixin {
  final email = TextEditingController();
  final name = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          /// Email Text Box
          TextField(
            decoration: const InputDecoration(labelText: "Email"),
            controller: email,
          ),
          
          /// Name Text Box
          TextField(
            decoration: const InputDecoration(labelText: "Name (in app)"),
            controller: name,
          ),

          /// Password Text Box
          TextField(
            decoration: const InputDecoration(labelText: "Password"),
            controller: password,
          ),

          /// Password Confirmation Text Box
          TextField(
            decoration: const InputDecoration(labelText: "Confirm Password"),
            controller: confirm,
          ),

          const SizedBox(
            height: 20,
          ),

          /// Sign In Button
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text("Signup"),
          ),

          /// Google Sign In Button
          ElevatedButton.icon(
            label: const Text("Signup with Google"),
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) => AppColors.googleBlue),
            ),
            icon: Image.asset(
              GetIt.I<ViewModel>().themeMode == ThemeMode.light
                  ? 'assets/google_logo_light.png'
                  : 'assets/google_logo_dark.png',
              height: (Theme.of(context).textTheme.button?.fontSize ?? 10) + 5,
              fit: BoxFit.fitHeight,
            ),
          ),
        ],
      ),
    );
  }
}
