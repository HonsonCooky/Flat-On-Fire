import 'package:flutter/material.dart';

abstract class AuthenticationTab extends StatefulWidget {
  final ScrollController scrollController;
  final TextEditingController email;
  final TextEditingController password;
  final String? emailErrMsg, passwordErrMsg;
  final VoidCallback resetErrors;
  final void Function({
    required Future<String> Function() authActionCallback,
    bool requiresCheck,
    bool Function()? optionalCheck,
  }) attemptAuthCallback;

  const AuthenticationTab({
    Key? key,
    required this.scrollController,
    required this.email,
    required this.password,
    this.emailErrMsg,
    this.passwordErrMsg,
    required this.resetErrors,
    required this.attemptAuthCallback,
  }) : super(key: key);
}
