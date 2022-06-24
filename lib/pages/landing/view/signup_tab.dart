import 'package:flat_on_fire/_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupTab extends StatefulWidget {
  final TextEditingController email;
  final TextEditingController password;

  const SignupTab(this.email, this.password, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignupTabState();
}

class _SignupTabState extends State<SignupTab> with ToastMixin {
  final _name = TextEditingController();
  final _confirm = TextEditingController();
  String? emailErrMsg, nameErrMsg, passwordErrMsg;
  bool _isObscure = true;

  @override
  void dispose() {
    _name.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void preFlightCheck([bool isBasic = true]) {
    setState(() {
      emailErrMsg = (isBasic && widget.email.text.isEmpty) ? "No Email Provided" : null;
      nameErrMsg = _name.text.isEmpty ? "No Name Provided" : null;
      passwordErrMsg = (isBasic && widget.password.text.isEmpty) ? "No Password Provided" : null;
    });

    if (emailErrMsg != null || nameErrMsg != null || passwordErrMsg != null) {
      throw Exception("Invalid User Credentials");
    }
  }

  void signup(Future<String> Function() cb, [bool isBasic = true]) async {
    try {
      preFlightCheck(isBasic);
    } catch (e) {
      errorToast(e.toString(), context);
      return;
    }

    var signupText = await cb();

    if (!mounted) return;
    if (signupText != signedUpText) {
      errorToast(signupText, context);
    }
  }

  void resetErrors() {
    emailErrMsg = null;
    nameErrMsg = null;
    passwordErrMsg = null;
  }

  @override
  Widget build(BuildContext context) {
    final googleImage = context.read<ViewProvider>().themeMode == ThemeMode.light
        ? 'assets/google_logo_light.png'
        : 'assets/google_logo_dark.png';

    return ListView(
      physics: const BouncingScrollPhysics(),
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

        /// Name Text Box
        TextField(
          onTap: resetErrors,
          decoration: InputDecoration(
            labelText: "Name",
            errorText: nameErrMsg,
          ),
          controller: _name,
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
          height: MediaQuery.of(context).size.height / 19.2,
        ),

        /// Sign In Button
        ElevatedButton(
          child: const Text("CREATE ACCOUNT"),
          onPressed: () => signup(
            () => context
                .read<AuthProvider>()
                .signup(email: widget.email.text, name: _name.text, password: widget.password.text),
          ),
        ),

        HorizontalOrLineWidget(
          label: "OR",
          padding: 20,
          color: PaletteAssistant.alpha(Theme.of(context).colorScheme.onBackground),
        ),

        /// Google Sign In Button
        ElevatedButton.icon(
          label: const Text("SIGNUP WITH GOOGLE"),
          onPressed: () => signup(
            () => context.read<AuthProvider>().signupWithGoogle(name: _name.text),
            false,
          ),
          style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
              backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).colorScheme.tertiary)),
          icon: Image.asset(
            googleImage,
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
