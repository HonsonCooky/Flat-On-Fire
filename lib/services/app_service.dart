import 'package:flutter/material.dart';

const loggedInText = 'Logged In';
const signedUpText = 'Signed Up';
const signedOutText = 'Signed Out';

enum ViewState { ideal, busy }

/// A change notifier that maintains state, and state manipulations about the user.
class AppService extends ChangeNotifier {
  late ViewState _viewState;
  late ThemeMode _themeMode;
  late bool _loginState = false;
  late bool _initialized = false;
  late bool _onBoarded = false;

  AppService() {
    _viewState = ViewState.ideal;
    _themeMode = ThemeMode.light;
  }

  ViewState get viewState => _viewState;

  ThemeMode get themeMode => _themeMode;

  bool get loginState => _loginState;

  bool get initialized => _initialized;

  bool get onBoarded => _onBoarded;

  reset() {
    _viewState = ViewState.ideal;
    _themeMode = ThemeMode.light;
    _loginState = false;
    _initialized = false;
    _onBoarded = false;
    notifyListeners();
  }

  batch({ViewState? viewState, ThemeMode? themeMode, bool? loginState, bool? initialized, bool? onBoarded}) {
    _viewState = viewState ?? _viewState;
    _themeMode = themeMode ?? _themeMode;
    _loginState = loginState ?? _loginState;
    _initialized = initialized ?? _initialized;
    _onBoarded = onBoarded ?? _onBoarded;
    notifyListeners();
  }

  /// Set the theme of the application
  switchTheme() {
    _themeMode = (_themeMode == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  set themeMode(ThemeMode value) {
    _themeMode = value;
    notifyListeners();
  }

  set onBoarded(bool value) {
    _onBoarded = value;
    notifyListeners();
  }

  set viewState(ViewState viewState) {
    _viewState = viewState;
    notifyListeners();
  }

  set initialized(bool value) {
    _initialized = value;
    notifyListeners();
  }

  set onboarding(bool value) {
    _onBoarded = value;
    notifyListeners();
  }

  set loginState(bool value) {
    _loginState = value;
    notifyListeners();
  }
}
