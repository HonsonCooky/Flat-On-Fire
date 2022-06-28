import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WrapperAppPage extends StatelessWidget {
  final Widget child;

  const WrapperAppPage({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WrapperFocusShift(
      child: Scaffold(
        appBar: _appBar(context),
        drawer: const DrawerWidget(),
        body: child,
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: Text(fromPath(GoRouter.of(context).location)),
      elevation: 0,
    );
  }
}
