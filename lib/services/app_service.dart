import 'package:flutter/material.dart';

const loggedInText = 'Logged In';
const signedUpText = 'Signed Up';
const signedOutText = 'Signed Out';

enum ViewState { ideal, busy }

/// A change notifier that maintains state, and state manipulations about the user.
class AppService extends ChangeNotifier {
  late ViewState _viewState;
  late ThemeMode _themeMode;
  final bool _loginState = false;
  final bool _initialized = false;
  final bool _onboarding = false;

  AppService() {
    _viewState = ViewState.ideal;
    _themeMode = ThemeMode.light;
  }

  ViewState get viewState => _viewState;

  ThemeMode get themeMode => _themeMode;

  bool get loginState => _loginState;

  bool get initialized => _initialized;

  bool get onboarding => _onboarding;

  /// Set the current state of the application
  setViewState(ViewState viewState) {
    _viewState = viewState;
    notifyListeners();
  }

  /// Set the theme of the application
  switchTheme() {
    _themeMode = (_themeMode == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
