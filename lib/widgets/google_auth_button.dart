import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoogleAuthButton extends StatelessWidget {
  final void Function({
    required Future<String> Function() authActionCallback,
    bool requiresCheck,
    bool Function()? optionalCheck,
  }) attemptAuthCallback;

  final String title;

  const GoogleAuthButton({Key? key, required this.attemptAuthCallback, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final googleImage = context.read<AppService>().themeMode == ThemeMode.light
        ? 'assets/google_logo_light.png'
        : 'assets/google_logo_dark.png';

    return ElevatedButton.icon(
      label: Text(
        title,
        style: Theme.of(context).elevatedButtonTheme.style?.textStyle?.resolve({})?.copyWith(
          color: Theme.of(context).colorScheme.onTertiary,
        ),
      ),
      onPressed: () => attemptAuthCallback(
        requiresCheck: false,
        authActionCallback: () => context.read<AuthService>().googleSignupLogin(),
      ),
      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
          backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).colorScheme.tertiary)),
      icon: Image.asset(
        googleImage,
        height: (Theme.of(context).textTheme.button?.fontSize ?? 10) + 5,
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
