import 'package:flutter/material.dart';

class FofTextField extends StatefulWidget {
  final String? labelText;
  final String? errorText;
  final void Function()? onTap;
  final TextEditingController? controller;
  final TextStyle? style;
  final bool canObscure;

  const FofTextField({
    Key? key,
    this.labelText,
    this.errorText,
    this.onTap,
    this.controller,
    this.style,
    this.canObscure = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FofTextFieldState();
}

class _FofTextFieldState extends State<FofTextField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ((widget.style?.fontSize ?? Theme.of(context).textTheme.labelMedium?.fontSize) ?? 10) / 3,
      ),
      child: TextField(
        onTap: widget.onTap,
        obscureText: widget.canObscure ? _isObscure : false,
        decoration: InputDecoration(
            labelText: widget.labelText,
            errorText: widget.errorText,
            suffixIcon: widget.canObscure
                ? IconButton(
                    iconSize: widget.style?.fontSize ?? Theme.of(context).textTheme.labelMedium?.fontSize,
                    icon: Icon(!_isObscure ? Icons.visibility : Icons.visibility_off),
                    splashRadius: widget.style?.fontSize ?? Theme.of(context).textTheme.labelMedium?.fontSize,
                    onPressed: () {
                      setState(() => _isObscure = !_isObscure);
                    },
                  )
                : null),
        controller: widget.controller,
        style: widget.style,
      ),
    );
  }
}
