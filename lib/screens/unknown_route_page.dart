import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';

class UnknownPageRoute extends StatelessWidget {
  final String name;

  const UnknownPageRoute({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oh no!'),
        elevation: 0,
      ),
      drawer: const DrawerWidget(),
      body: Center(
        child: Text(
          'No route defined for "$name"',
          style: Theme.of(context).textTheme.labelMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
