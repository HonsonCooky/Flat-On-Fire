import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginTabWidget extends AuthenticationTab {
  const LoginTabWidget({
    Key? key,
    required super.email,
    required super.password,
    required super.resetErrors,
    required super.attempt,
    super.emailErrMsg,
    super.passwordErrMsg,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginTabWidgetState();
}

class _LoginTabWidgetState extends State<LoginTabWidget> with ToastMixin {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return _loginTabContents();
  }
  
  Widget _loginTabContents(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              /// Email Text Box
              TextField(
                onTap: widget.resetErrors,
                decoration: InputDecoration(
                  labelText: "Email",
                  errorText: widget.emailErrMsg,
                ),
                controller: widget.email,
              ),

              /// Password Text Box
              TextField(
                onTap: widget.resetErrors,
                controller: widget.password,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: widget.passwordErrMsg,
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
          child: const Text("LOGIN"),
          onPressed: () => widget.attempt(
            attemptCallback: () => context.read<AuthService>().login(
              email: widget.email.text,
              password: widget.password.text,
            ),
          ),
        ),
      ],
    );
  }
}
