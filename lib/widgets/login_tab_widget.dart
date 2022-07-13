import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginTabWidget extends StatefulWidget {
  final ScrollController scrollController;

  const LoginTabWidget({Key? key, required this.scrollController}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginTabWidgetState();
}

class _LoginTabWidgetState extends State<LoginTabWidget> with ToastMixin {
  @override
  Widget build(BuildContext context) {
    return _loginTabContents();
  }

  Widget _loginTabContents() {
    return Consumer<UserCredService>(
      builder: (BuildContext context, UserCredService content, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              controller: widget.scrollController,
              physics: const BouncingScrollPhysics(),
              children: [
                /// Email Text Box
                FofTextField(
                  onTap: content.resetErrors,
                  labelText: "Email",
                  errorText: content.emailErr,
                  controller: content.email,
                ),

                /// Password Text Box
                FofTextField(
                  onTap: content.resetErrors,
                  controller: content.pass,
                  canObscure: true,
                  labelText: 'Password',
                  errorText: content.passErr,
                ),
              ],
            ),
          ),

          /// Sign In Button
          ElevatedButton.icon(
            label: const Text("LOGIN"),
            icon: const Icon(Icons.login),
            onPressed: () => content.attemptAuth(UserCredAuthType.login, context, this),
          ),

          HorizontalOrLineWidget(
            label: "OR",
            padding: 20,
            color: PaletteAssistant.alpha(Theme.of(context).colorScheme.onBackground),
          ),

          GoogleAuthButton(
            title: "LOGIN WITH GOOGLE",
            state: this,
          ),

          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
