import 'package:flat_on_fire/core/flutter/routers.dart';
import 'package:flutter/material.dart';

enum ViewState { ideal, busy }

enum FlowState { auth, app }

class ViewModel extends ChangeNotifier {
  late ViewState _viewState;
  late FlowState _flowState;
  late ThemeMode _themeMode;
  final initialRoute = Routes.landing.toShortString();


  ViewModel(){
    _viewState = ViewState.busy;
    _flowState = FlowState.auth;
    _themeMode = ThemeMode.light;
  }

  ViewState get viewState => _viewState;

  FlowState get flowState => _flowState;

  ThemeMode get themeMode => _themeMode;

  setViewState(ViewState viewState) {
    _viewState = viewState;
    notifyListeners();
  }
  
  setFlowState(FlowState value) {
    _flowState = value;
    notifyListeners();
  }

  switchTheme() {
    _themeMode = (_themeMode == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
