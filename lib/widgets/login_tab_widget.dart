import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginTabWidget extends AuthenticationTab {
  const LoginTabWidget({
    Key? key,
    required super.scrollController,
    required super.email,
    required super.password,
    required super.resetErrors,
    required super.attemptAuthCallback,
    super.emailErrMsg,
    super.passwordErrMsg,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginTabWidgetState();
}

class _LoginTabWidgetState extends State<LoginTabWidget> with ToastMixin {
  @override
  Widget build(BuildContext context) {
    return _loginTabContents();
  }

  Widget _loginTabContents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            controller: widget.scrollController,
            physics: const BouncingScrollPhysics(),
            children: [
              /// Email Text Box
              FofTextField(
                onTap: widget.resetErrors,
                labelText: "Email",
                errorText: widget.emailErrMsg,
                controller: widget.email,
              ),

              /// Password Text Box
              FofTextField(
                onTap: widget.resetErrors,
                controller: widget.password,
                canObscure: true,
                labelText: 'Password',
                errorText: widget.passwordErrMsg,
              ),
            ],
          ),
        ),

        /// Sign In Button
        ElevatedButton.icon(
          label: const Text("LOGIN"),
          icon: const Icon(Icons.login),
          onPressed: () => widget.attemptAuthCallback(
            authActionCallback: () => context.read<AuthService>().login(
                  email: widget.email.text,
                  password: widget.password.text,
                ),
          ),
        ),

        HorizontalOrLineWidget(
          label: "OR",
          padding: 20,
          color: PaletteAssistant.alpha(Theme.of(context).colorScheme.onBackground),
        ),

        GoogleAuthButton(
          title: "LOGIN WITH GOOGLE",
          attemptAuthCallback: widget.attemptAuthCallback,
        ),

        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
