import 'package:flat_on_fire/routing/routers.dart';
import 'package:flutter/material.dart';

enum ViewState { ideal, busy }

class ViewModel extends ChangeNotifier {
  late ViewState _viewState;
  late ThemeMode _themeMode;
  final initialRoute = Routes.landing.toShortString();

  ViewModel() {
    _viewState = ViewState.busy;
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
