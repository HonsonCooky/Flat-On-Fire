import 'package:flutter/material.dart';

enum ViewState { ideal, busy }

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
