import 'package:flat_on_fire/common_models/auth_model.dart';
import 'package:get_it/get_it.dart';

import 'view_model.dart';

void setupLocator() {
  GetIt.I.registerSingleton<AuthModel>(AuthModel());
  GetIt.I.registerSingleton<ViewModel>(ViewModel());
}
