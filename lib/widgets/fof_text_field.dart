import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';

class FofTextField extends StatefulWidget {
  final String labelText;
  final String? errorText;
  final void Function()? onTap;
  final TextEditingController? controller;
  final TextStyle? style;
  final bool canObscure;
  final Color? fillColor;

  const FofTextField({
    Key? key,
    required this.labelText,
    this.errorText,
    this.onTap,
    this.controller,
    this.style,
    this.canObscure = false,
    this.fillColor,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FofTextFieldState();
}

class _FofTextFieldState extends State<FofTextField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    double iconSize = widget.style?.fontSize ?? Theme.of(context).textTheme.labelMedium?.fontSize ?? 10;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ((widget.style?.fontSize ?? Theme.of(context).textTheme.labelMedium?.fontSize) ?? 10) / 3,
      ),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextField(
            onTap: widget.onTap,
            obscureText: widget.canObscure ? _isObscure : false,
            decoration: InputDecoration(
              labelText: widget.labelText,
              errorText: widget.errorText,
            ).applyDefaults(
              Theme.of(context).inputDecorationTheme.copyWith(
                    fillColor: widget.fillColor,
                  ),
            ),
            controller: widget.controller,
            style: widget.style,
          ),
          widget.canObscure
              ? Material(
                  color: Colors.transparent,
                  child: IconButton(
                    iconSize: iconSize,
                    icon: Icon(!_isObscure ? Icons.visibility : Icons.visibility_off),
                    splashRadius: widget.style?.fontSize ?? Theme.of(context).textTheme.labelMedium?.fontSize ?? 30,
                    splashColor: PaletteAssistant.alpha(Theme.of(context).colorScheme.secondary),
                    onPressed: () {
                      setState(() => _isObscure = !_isObscure);
                    },
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
