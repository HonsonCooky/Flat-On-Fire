import 'package:flat_on_fire/_app.dart';
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
            Text(
              "... is loading",
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            LoadingSpinner(MediaQuery.of(context).size.width / 5)
          ],
        ),
      ),
    );
  }
}
