import 'package:flutter/material.dart';

class LoadingSpinnerWidget extends StatefulWidget {
  final double size;
  final Color? color;

  const LoadingSpinnerWidget(this.size, {Key? key, this.color}) : super(key: key);

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
          color: widget.color,
          valueColor: widget.color != null
              ? null
              : _controller.drive(
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
