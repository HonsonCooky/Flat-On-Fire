import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum UserCredAuthType {
  login,
  signup,
  google,
}

class UserCredService extends ChangeNotifier with ToastMixin {
  final TextEditingController email = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController conf = TextEditingController();
  String? emailErr, nameErr, passErr, confErr;

  void resetErrors() {
    emailErr = null;
    nameErr = null;
    passErr = null;
    confErr = null;
    notifyListeners();
  }

  bool _preflightChecks(bool optionals) {
    emailErr = email.text.isEmpty ? "No Email Provided" : null;
    passErr = pass.text.isEmpty ? "No Password Provided" : null;
    if (optionals) {
      nameErr = name.text.isEmpty ? "No Name Provided" : null;
      confErr = conf.text.isEmpty
          ? "No Confirmation Password Provided"
          : conf.text != pass.text
              ? "Passwords do not match"
              : null;
    }

    return emailErr != null && nameErr != null && passErr != null && confErr != null;
  }

  void attemptAuth(UserCredAuthType authType, BuildContext context, State state) async {
    switch (authType) {
      case UserCredAuthType.login:
        var check = _preflightChecks(false);
        if (check) {
          var authVal = await context.read<AuthService>().login(
                email: email.text,
                password: pass.text,
              );
          if (state.mounted && authVal != AuthService.successfulOperation) {
            errorToast(authVal, context);
          }
        }
        break;
      case UserCredAuthType.signup:
        var check = _preflightChecks(true);
        if (check) {
          var authVal = await context.read<AuthService>().signup(
                email: email.text,
                name: name.text,
                password: pass.text,
              );
          if (state.mounted && authVal != AuthService.successfulOperation) {
            errorToast(authVal, context);
          }
        }
        break;
      case UserCredAuthType.google:
        var authVal = await context.read<AuthService>().googleSignupLogin();
        if (state.mounted && authVal != AuthService.successfulOperation) {
          errorToast(authVal, context);
        }
        break;
    }
    notifyListeners();
  }
}
