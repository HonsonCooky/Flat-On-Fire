import 'package:flat_on_fire/_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupWidget extends StatefulWidget {
  final TextEditingController email;
  final TextEditingController password;

  const SignupWidget(this.email, this.password, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignupWidgetsClass();
}

class _SignupWidgetsClass extends State<SignupWidget> with ToastWrapper {
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

  void preFlightCheck() {
    setState(() {
      emailErrMsg = widget.email.text.isEmpty ? "No Email Provided" : null;
      nameErrMsg = _name.text.isEmpty ? "No Name Provided" : null;
      passwordErrMsg = widget.password.text.isEmpty ? "No Password Provided" : null;
    });

    if (emailErrMsg != null || nameErrMsg != null || passwordErrMsg != null) {
      throw Exception("Invalid User Credentials");
    }
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
          decoration: InputDecoration(
            labelText: "Email",
            errorText: emailErrMsg,
          ),
          controller: widget.email,
        ),

        /// Name Text Box
        TextField(
          decoration: InputDecoration(
            labelText: "Name",
            errorText: nameErrMsg,
          ),
          controller: _name,
        ),

        /// Password Text Box
        TextField(
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
          onPressed: () async {
            var signup = await context
                .read<AuthProvider>()
                .signup(email: widget.email.text, name: _name.text, password: widget.password.text);
            
            if (!mounted) return;
            if (signup == signedUp) {
              successToast(signedUp, context);
            } else {
              errorToast(signedUp, context);
            }
          },
        ),

        HorizontalOrLineWidget(
          label: "OR",
          padding: 20,
          color: PaletteAssistant.alpha(Theme.of(context).colorScheme.onBackground),
        ),

        /// Google Sign In Button
        ElevatedButton.icon(
          label: const Text("SIGNUP WITH GOOGLE"),
          onPressed: () {},
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
