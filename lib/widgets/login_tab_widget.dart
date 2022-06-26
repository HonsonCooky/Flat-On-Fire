import 'package:flat_on_fire/_app_bucket.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginTabWidget extends StatefulWidget {
  final TextEditingController email;
  final TextEditingController password;

  const LoginTabWidget(this.email, this.password, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginTabWidgetState();
}

class _LoginTabWidgetState extends State<LoginTabWidget> with ToastMixin {
  bool _isObscure = true;
  String? emailErrMsg, passwordErrMsg;
  bool _loading = false;

  void preFlightCheck([bool isBasic = true]) {
    setState(() {
      emailErrMsg = (isBasic && widget.email.text.isEmpty) ? "No Email Provided" : null;
      passwordErrMsg = (isBasic && widget.password.text.isEmpty) ? "No Password Provided" : null;
    });

    if (emailErrMsg != null || passwordErrMsg != null) {
      throw Exception("Invalid User Credentials");
    }
  }

  void login(Future<String> Function() cb, [bool isBasic = true]) async {
    setState(() => _loading = true);
    try {
      preFlightCheck(isBasic);

      var login = await cb();

      if (!mounted) return;
      if (login != loggedInText) {
        errorToast(login, context);
      } else {
        Navigator.popUntil(context, (route) => false);
        Navigator.pushNamed(context, initialAppRoute);
      }
    } catch (e) {
      errorToast(e.toString(), context);
      return;
    } finally {
      setState(() => _loading = false);
    }
  }

  void resetErrors() {
    emailErrMsg = null;
    passwordErrMsg = null;
  }

  @override
  Widget build(BuildContext context) {
    final googleImage = context.read<ViewProvider>().themeMode == ThemeMode.light
        ? 'assets/google_logo_light.png'
        : 'assets/google_logo_dark.png';

    return ListView(
      physics: const BouncingScrollPhysics(),
      clipBehavior: Clip.antiAlias,
      children: [
        /// Email Text Box
        TextField(
          onTap: resetErrors,
          decoration: InputDecoration(
            labelText: "Email",
            errorText: emailErrMsg,
          ),
          controller: widget.email,
        ),

        /// Password Text Box
        TextField(
          onTap: resetErrors,
          controller: widget.password,
          obscureText: _isObscure,
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: passwordErrMsg,
            suffixIcon: IconButton(
              icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() => _isObscure = !_isObscure);
              },
            ),
          ),
        ),

        SizedBox(
          height: MediaQuery.of(context).size.height / 8,
        ),

        /// Sign In Button
        _loading
            ? LoadingSpinnerWidget(MediaQuery.of(context).size.width / 5)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    child: const Text("LOGIN"),
                    onPressed: () => login(
                      () =>
                          context.read<AuthProvider>().login(email: widget.email.text, password: widget.password.text),
                    ),
                  ),

                  HorizontalOrLineWidget(
                    label: "OR",
                    padding: 20,
                    color: PaletteAssistant.alpha(Theme.of(context).colorScheme.onBackground),
                  ),

                  /// Google Sign In Button
                  ElevatedButton.icon(
                    label: const Text("LOGIN WITH GOOGLE"),
                    onPressed: () => login(
                      () => context.read<AuthProvider>().loginWithGoogle(),
                      false,
                    ),
                    style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) => Theme.of(context).colorScheme.tertiary)),
                    icon: Image.asset(
                      googleImage,
                      height: (Theme.of(context).textTheme.button?.fontSize ?? 10) + 5,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ],
              ),

        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
