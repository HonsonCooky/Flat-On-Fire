import 'package:flat_on_fire/common_models/view_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class SignupWidgets extends StatefulWidget with GetItStatefulWidgetMixin {
  final TextEditingController email;
  final TextEditingController password;

  SignupWidgets(this.email, this.password, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignupWidgetsClass();
}

class _SignupWidgetsClass extends State<SignupWidgets> with GetItStateMixin {
  final _name = TextEditingController();
  final _confirm = TextEditingController();
  bool _isObscure = true;

  @override
  void dispose() {
    _name.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        /// Email Text Box
        TextField(
          decoration: const InputDecoration(labelText: "Email"),
          controller: widget.email,
        ),

        /// Name Text Box
        TextField(
          decoration: const InputDecoration(labelText: "Name (in app)"),
          controller: _name,
        ),

        /// Password Text Box
        TextField(
          controller: widget.password,
          obscureText: _isObscure,
          decoration: InputDecoration(
            labelText: 'Password',
            suffixIcon: IconButton(
              icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(
                      () {
                    _isObscure = !_isObscure;
                  },
                );
              },
            ),
          ),
        ),

        const SizedBox(
          height: 50,
        ),

        /// Sign In Button
        ElevatedButton.icon(
          onPressed: () {
            GetIt.I<ViewModel>().switchTheme();
          },
          icon: const Icon(Icons.add),
          label: const Text("Signup"),
        ),

        /// Google Sign In Button
        ElevatedButton.icon(
          label: const Text("Signup with Google"),
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) => Theme.of(context).colorScheme.secondary,
            ),
            foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) => Theme.of(context).colorScheme.onSecondary,
            ),
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
    );
  }
}
