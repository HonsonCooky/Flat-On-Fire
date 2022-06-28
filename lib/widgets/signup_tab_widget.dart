import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupTabWidget extends AuthenticationTab {
  const SignupTabWidget({
    Key? key,
    required super.email,
    required super.password,
    required super.resetErrors,
    required super.attempt,
    super.emailErrMsg,
    super.passwordErrMsg,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignupTabWidgetState();
}

class _SignupTabWidgetState extends State<SignupTabWidget> with ToastMixin {
  final _name = TextEditingController();
  String? emailErrMsg, nameErrMsg, passwordErrMsg;
  bool _isObscure = true;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void preFlightCheck() {
    setState(() {
      nameErrMsg = _name.text.isEmpty ? "No Name Provided" : null;
    });

    if (nameErrMsg != null) {
      throw Exception("Invalid User Credentials");
    }
  }

  void resetErrors() {
    setState(() {
      nameErrMsg = null;
    });
    widget.resetErrors();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
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

              const SizedBox(
                height: 100,
              )
            ],
          ),
        ),

        /// Sign In Button
        ElevatedButton(
          child: const Text("CREATE ACCOUNT"),
          onPressed: () => widget.attempt(
            attemptCallback: () => context.read<AuthService>().signup(
                  email: widget.email.text,
                  name: _name.text,
                  password: widget.password.text,
                  errorToast: (str) => errorToast(str, context),
                ),
          ),
        ),
      ],
    );
  }
}
