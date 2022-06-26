import 'package:flutter/material.dart';

class LoadingSpinnerWidget extends StatefulWidget {
  final double size;

  const LoadingSpinnerWidget(this.size, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoadingSpinnerWidgetState();
}

class _LoadingSpinnerWidgetState extends State<LoadingSpinnerWidget> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 5), vsync: this);
    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: CircularProgressIndicator(
          strokeWidth: widget.size / 7,
          valueColor: _controller.drive(
            ColorTween(
              begin: Theme.of(context).colorScheme.primary,
              end: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ),
    );
  }
}
