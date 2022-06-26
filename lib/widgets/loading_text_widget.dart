import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class LoadingTextWidget extends StatelessWidget {
  final TextStyle style;
  const LoadingTextWidget({Key? key, required this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: style,
      child: AnimatedTextKit(
        repeatForever: true,
        pause: const Duration(milliseconds: 100),
        animatedTexts: [
          TyperAnimatedText('Loading ...', speed: const Duration(milliseconds: 200)),
          TyperAnimatedText('...', speed: const Duration(milliseconds: 200)),
        ],
      ),
    );
  }
  
}