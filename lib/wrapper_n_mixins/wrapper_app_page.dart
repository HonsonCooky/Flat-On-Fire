import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class WrapperAppPage extends StatelessWidget {
  final Widget child;
  final bool? resizeToAvoidBottomInset;

  const WrapperAppPage({Key? key, required this.child, this.resizeToAvoidBottomInset = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewState = context.watch<AppService>().viewState;
    return WrapperFocusShift(
      child: Scaffold(
        appBar: _appBar(context),
        drawer: const DrawerWidget(),
        drawerEdgeDragWidth: MediaQuery.of(context).size.width / 3,
        drawerScrimColor: Theme.of(context).colorScheme.tertiary,
        body: viewState == ViewState.busy ? _loading(context) : child,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        );
    return AppBar(
      toolbarHeight: (textStyle?.fontSize ?? 10) * 2,
      title: Text(fromPath(GoRouter.of(context).location), style: textStyle),
      elevation: 0,
    );
  }

  Widget _loading(BuildContext context) {
    return LoadingSpinnerWidget(MediaQuery.of(context).size.width / 4);
  }
}
