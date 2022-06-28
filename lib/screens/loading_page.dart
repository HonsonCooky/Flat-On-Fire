import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Flat On Fire",
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            LoadingTextWidget(
              text: "... is loading",
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ],
        ),
      ),
    );
  }
}
