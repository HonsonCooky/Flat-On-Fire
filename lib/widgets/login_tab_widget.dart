import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginTabWidget extends StatefulWidget {
  final ScrollController scrollController;

  const LoginTabWidget({Key? key, required this.scrollController}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginTabWidgetState();
}

class _LoginTabWidgetState extends State<LoginTabWidget> {
  @override
  Widget build(BuildContext context) {
    return _loginTabContents();
  }

  Widget _loginTabContents() {
    return Consumer<UserCredService>(
      builder: (BuildContext context, UserCredService content, _) => ListView(
        controller: widget.scrollController,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          _avatarIcon(),

          SizedBox(
            height: MediaQuery.of(context).size.height / 40,
          ),

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

          SizedBox(
            height: MediaQuery.of(context).size.height / 10,
          ),

          /// Sign In Button
          ElevatedButton.icon(
            label: const Text("LOGIN"),
            icon: const Icon(Icons.login),
            onPressed: () => content.attemptAuth(UserCredAuthType.login, context),
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

          SizedBox(
            height: MediaQuery.of(context).size.height / 10,
          ),
        ],
      ),
    );
  }

  Widget _avatarIcon() {
    TextStyle? textStyle = Theme.of(context).textTheme.labelMedium;
    double fontSize = textStyle?.fontSize != null ? textStyle!.fontSize! * 3 : 20;
    return CircleAvatar(
      radius: fontSize,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Icon(
        Icons.person,
        size: fontSize,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
