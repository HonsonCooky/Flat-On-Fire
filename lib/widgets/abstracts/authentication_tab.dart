import 'package:flutter/material.dart';

abstract class AuthenticationTab extends StatefulWidget {
  final TextEditingController email;
  final TextEditingController password;
  final String? emailErrMsg, passwordErrMsg;
  final VoidCallback resetErrors;
  final void Function({
    required Future<String> Function() attemptCallback,
    bool requiresCheck,
    bool Function()? optionalCheck,
  }) attempt;

  const AuthenticationTab({
    Key? key,
    required this.email,
    required this.password,
    this.emailErrMsg,
    this.passwordErrMsg,
    required this.resetErrors,
    required this.attempt,
  }) : super(key: key);
}
