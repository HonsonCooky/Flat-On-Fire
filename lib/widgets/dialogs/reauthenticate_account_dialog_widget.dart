import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReauthenticateAccountDialogWidget extends StatefulWidget {
  final void Function() successfulAuthentication;

  const ReauthenticateAccountDialogWidget({Key? key, required this.successfulAuthentication}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReauthenticateAccountDialogWidgetState();
}

class _ReauthenticateAccountDialogWidgetState extends State<ReauthenticateAccountDialogWidget> {
  var email = TextEditingController();
  var password = TextEditingController();
  String? emailErr;
  String? passwordErr;
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Account Deletion"),
      titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      content: SingleChildScrollView(
        child: WrapperFocusShift(
          child: _authenticationComponents(),
        ),
      ),
      actions: [
        _cancelButton(),
      ],
    );
  }

  // set up the buttons
  Widget _cancelButton() {
    return TextButton(
      child: const Text("CANCEL"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _authenticationComponents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("You must reauthenticate your account before deleting"),
        SizedBox(height: MediaQuery.of(context).size.height / 20),
        _authenticationTextFields(),
        SizedBox(height: MediaQuery.of(context).size.height / 20),
        _reAuthButton(),
        HorizontalOrLineWidget(
          label: "OR",
          padding: 20,
          color: PaletteAssistant.alpha(Theme.of(context).colorScheme.onBackground),
        ),
        _googleReAuthButton(),
        errorText == null
            ? const SizedBox()
            : Text(
                errorText!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onError,
                    ),
              ),
      ],
    );
  }

  Widget _authenticationTextFields() {
    double fontSize = 18;
    return Column(
      children: [
        FofTextField(
          controller: email,
          fillColor: Theme.of(context).colorScheme.background,
          onTap: () {
            setState(() {
              emailErr = null;
              passwordErr = null;
              errorText = null;
            });
          },
          labelText: "Email",
          style: TextStyle(fontSize: fontSize),
          errorText: emailErr,
        ),
        FofTextField(
          controller: password,
          fillColor: Theme.of(context).colorScheme.background,
          onTap: () {
            setState(() {
              emailErr = null;
              passwordErr = null;
              errorText = null;
            });
          },
          canObscure: true,
          labelText: "Password",
          style: TextStyle(fontSize: fontSize),
          errorText: passwordErr,
        ),
      ],
    );
  }

  Widget _reAuthButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        if (email.text.isEmpty) setState(() => emailErr = "No email supplied");
        if (password.text.isEmpty) setState(() => passwordErr = "No password supplied");
        if (emailErr != null || passwordErr != null) return;

        var authenticateText = await context.read<AuthService>().reauthenticateUser(
              email.text,
              password.text,
              false,
            );
        if (authenticateText != AuthService.successfulOperation) {
          setState(() => errorText = authenticateText);
        } else if (mounted) {
          Navigator.of(context).pop();
          widget.successfulAuthentication();
        }
      },
      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
            backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).colorScheme.secondary),
          ),
      label: Text(
        "AUTHENTICATE",
        style: Theme.of(context).elevatedButtonTheme.style?.textStyle?.resolve({})?.copyWith(
            color: Theme.of(context).colorScheme.onSecondary,
            fontSize: (Theme.of(context).elevatedButtonTheme.style?.textStyle?.resolve({})?.fontSize ?? 20) - 7),
      ),
      icon: Icon(
        Icons.logout,
        color: Theme.of(context).colorScheme.onSecondary,
      ),
    );
  }

  Widget _googleReAuthButton() {
    final googleImage = context.read<AppService>().themeMode == ThemeMode.light
        ? 'assets/google_logo_light.png'
        : 'assets/google_logo_dark.png';

    return ElevatedButton.icon(
      onPressed: () async {
        var authenticateText = await context.read<AuthService>().reauthenticateUser(
              email.text,
              password.text,
              true,
            );
        if (authenticateText != AuthService.successfulOperation) {
          setState(() => errorText = authenticateText);
        } else if (mounted) {
          Navigator.of(context).pop();
          widget.successfulAuthentication();
        }
      },
      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
            backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).colorScheme.tertiary),
          ),
      label: Text(
        "GOOGLE AUTHENTICATE",
        style: Theme.of(context).elevatedButtonTheme.style?.textStyle?.resolve({})?.copyWith(
            color: Theme.of(context).colorScheme.onTertiary,
            fontSize: (Theme.of(context).elevatedButtonTheme.style?.textStyle?.resolve({})?.fontSize ?? 20) - 7),
      ),
      icon: Image.asset(
        googleImage,
        height: (Theme.of(context).textTheme.button?.fontSize ?? 10) + 5,
        fit: BoxFit.fitHeight,
      ),
    );
  }
}