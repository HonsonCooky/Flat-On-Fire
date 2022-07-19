import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String? error;

  const ErrorPage({
    Key? key,
    this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WrapperAppPage(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Error: $error"),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppPageEnum.home.toName);
              },
              child: const Text("Back to Home"),
            ),
          ],
        ),
      ),
    );
  }
}
