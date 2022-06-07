

import 'package:flat_on_fire/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme_notifier.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeMode tm = Provider.of<ThemeNotifier>(context, listen: true).currentTheme();
    return MaterialApp(
      theme: Themes.light(),
      darkTheme: Themes.dark(),
      themeMode: tm,
      home: const FlowDictator(),
    );
  }
}

class FlowDictator extends StatefulWidget {
  const FlowDictator({Key? key}) : super(key: key);

  @override
  State<FlowDictator> createState() => _FlowDictatorState();
}

class _FlowDictatorState extends State<FlowDictator> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

