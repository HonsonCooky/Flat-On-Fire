import 'package:flat_on_fire/_app_bucket.dart';

class FirebaseSyncFuncs {
  final void Function()? _onSuccess;
  final void Function()? _onLocalSuccess;
  final void Function()? _onError;
  final void Function() _onFinish;

  FirebaseSyncFuncs(this._onSuccess, this._onLocalSuccess, this._onError, this._onFinish);

  void onSuccess() async {
    // Run a success, IFF we are connected
    bool connected = await AppService.networkConnected();
    if (connected && _onSuccess != null) {
      _onSuccess!();
      _onFinish();
    }
  }

  void onLocalSuccess() async {
    // Run a local success, IFF we are not connected
    bool connected = await AppService.networkConnected();
    if (!connected && _onLocalSuccess != null) {
      _onLocalSuccess!();
      _onFinish();
    }
  }

  void onError() {
    if (_onError != null) _onError!();
    _onFinish();
  }
}
