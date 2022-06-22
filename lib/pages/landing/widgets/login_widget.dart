import 'package:flat_on_fire/_app.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class LoginWidgets extends StatefulWidget with GetItStatefulWidgetMixin, ToastWrapper {
  final TextEditingController email;
  final TextEditingController password;

  LoginWidgets(this.email, this.password, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginWidgetClass();
}

class _LoginWidgetClass extends State<LoginWidgets> with GetItStateMixin, ToastWrapper {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      clipBehavior: Clip.antiAlias,
      children: [
        /// Email Text Box
        TextField(
          decoration: const InputDecoration(
            labelText: "Email",
          ),
          controller: widget.email,
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
                setState(() => _isObscure = !_isObscure);
              },
            ),
          ),
        ),

        SizedBox(
          height: MediaQuery.of(context).size.height / 10,
        ),

        /// Sign In Button
        ElevatedButton(
          child: const Text("LOGIN"),
          onPressed: () async {
            try {
              await GetIt.I<AuthModel>().signIn(widget.email.text, widget.password.text);
            } catch (e, s) {
              print(e);
              if (e.toString().contains("firebase_auth/unknown")) {
                errorToast("Unknown user, or invalid email/password. Try signing up?", context);
              }
            }
          },
        ),

        HorizontalOrLine(
          label: "OR",
          padding: 20,
          color: PaletteAssistant.alpha(Theme.of(context).colorScheme.onBackground),
        ),

        /// Google Sign In Button
        ElevatedButton.icon(
          label: const Text("LOGIN WITH GOOGLE"),
          onPressed: () {},
          style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
              backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).colorScheme.tertiary)),
          icon: Image.asset(
            GetIt.I<ViewModel>().themeMode == ThemeMode.light
                ? 'assets/google_logo_light.png'
                : 'assets/google_logo_dark.png',
            height: (Theme.of(context).textTheme.button?.fontSize ?? 10) + 5,
            fit: BoxFit.fitHeight,
          ),
        ),

        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
