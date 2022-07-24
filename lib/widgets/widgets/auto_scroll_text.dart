import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';

class AutoScrollText extends StatefulWidget {
  final String text;
  final TextStyle? style;

  const AutoScrollText({Key? key, required this.text, this.style}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AutoScrollTextState();
}

class _AutoScrollTextState extends State<AutoScrollText> {
  final ScrollController scrollController = ScrollController();
  final int multiplier = 100;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.offset == scrollController.position.maxScrollExtent) {
        Future.delayed(const Duration(seconds: 2)).then(
          (value) => scrollController.animateTo(
            scrollController.position.minScrollExtent,
            duration: Duration(milliseconds: widget.text.length * multiplier),
            curve: Curves.easeInOut,
          ),
        );
      } else if (scrollController.offset == scrollController.position.minScrollExtent) {
        Future.delayed(const Duration(seconds: 2)).then(
          (value) => scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: widget.text.length * multiplier),
            curve: Curves.easeInOut,
          ),
        );
      }
    });
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: widget.text.length * multiplier),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WrapperOverflowRemoved(
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        child: Text(
          widget.text,
          style: widget.style,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
