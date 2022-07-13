import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoogleAuthButton extends StatelessWidget {
  final String title;
  final State state;

  const GoogleAuthButton({Key? key, required this.title, required this.state}) : super(key: key);

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
      onPressed: () => context.read<UserCredService>().attemptAuth(UserCredAuthType.google, context, state),
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
