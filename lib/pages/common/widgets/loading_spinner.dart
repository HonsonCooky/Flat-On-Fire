import 'package:flutter/material.dart';

class LoadingSpinner extends StatefulWidget {
  final double size;

  const LoadingSpinner(this.size, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoadingSpinnerState();
}

class _LoadingSpinnerState extends State<LoadingSpinner> with TickerProviderStateMixin {
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
    return Container(
      margin: EdgeInsets.all(widget.size / 5),
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
    );
  }
}
