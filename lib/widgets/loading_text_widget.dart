import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class LoadingTextWidget extends StatelessWidget {
  final TextStyle? style;
  final String text;
  final void Function(int, bool)? onNext;

  const LoadingTextWidget({Key? key, required this.style, this.text = "... Loading", this.onNext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      onNext: onNext,
      repeatForever: true,
      pause: const Duration(milliseconds: 500),
      animatedTexts: [
        TyperAnimatedText(text, speed: const Duration(milliseconds: 100), textStyle: style),
      ],
    );
  }
}
