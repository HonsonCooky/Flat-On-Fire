import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WrapperAppPage extends StatefulWidget {
  final Widget child;
  final bool? resizeToAvoidBottomInset;

  const WrapperAppPage({Key? key, required this.child, this.resizeToAvoidBottomInset = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WrapperAppPageState();
}

class _WrapperAppPageState extends State<WrapperAppPage> {
  dynamic _getArguments() {
    return ModalRoute.of(context)?.settings.arguments as dynamic;
  }

  String? _groupPathName() {
    try {
      String? groupName = _getArguments()?.groupName;
      return "Group: ${groupName!.title()}";
    } catch (e) {
      return null;
    }
  }

  String? _userPathName() {
    try {
      String? userName = _getArguments()["profile"]?.name;
      return "User: ${userName!.title().split(" ")[0]}";
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewState = context.watch<AppService>().viewState;
    return WrapperFocusShift(
      child: Scaffold(
        appBar: _appBar(context),
        drawer: const DrawerWidget(),
        drawerEdgeDragWidth: MediaQuery.of(context).size.width / 3,
        drawerScrimColor: Theme.of(context).colorScheme.tertiary,
        body: viewState == ViewState.busy ? _loading(context) : widget.child,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        );

    var title = _groupPathName() ?? _userPathName() ?? curAppPage(context).toTitle;
    var isBase = curAppPage(context).toPath.split("/").length <= 2;

    return AppBar(
      toolbarHeight: (textStyle?.fontSize ?? 10) * 2,
      title: WrapperOverflowRemoved(
          child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Text(title, style: textStyle))),
      leading: isBase
          ? null
          : IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (Navigator.of(context).canPop()) Navigator.of(context).pop();
              },
            ),
      elevation: 0,
    );
  }

  Widget _loading(BuildContext context) {
    return LoadingSpinnerWidget(MediaQuery.of(context).size.width / 4);
  }
}
