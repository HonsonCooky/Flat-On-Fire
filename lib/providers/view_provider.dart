import 'package:flutter/material.dart';

enum ViewState { ideal, busy }

/// A change notifier that maintains state, and state manipulations about the theme and current UI processing state.
class ViewProvider extends ChangeNotifier {
  late ViewState _viewState;
  late ThemeMode _themeMode;

  ViewProvider() {
    _viewState = ViewState.ideal;
    _themeMode = ThemeMode.light;
  }

  ViewState get viewState => _viewState;

  ThemeMode get themeMode => _themeMode;

  setViewState(ViewState viewState) {
    _viewState = viewState;
    notifyListeners();
  }

  switchTheme() {
    _themeMode = (_themeMode == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
