import 'dart:math';

import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';

class AwaitingInformationWidget extends StatefulWidget {
  final List<String> texts;

  const AwaitingInformationWidget({Key? key, required this.texts}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AwaitingInformationWidgetState();
}

class _AwaitingInformationWidgetState extends State<AwaitingInformationWidget> {
  int random = 0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: LoadingTextWidget(
          onNext: (i, b) {
            int newRand = Random().nextInt(widget.texts.length);
            if (newRand == random) newRand = (newRand + 1) % widget.texts.length;
            setState(() => random = newRand);
          },
          text: "... ${widget.texts[random]}",
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ),
    );
  }
}
