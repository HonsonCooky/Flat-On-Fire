import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final ScrollController _loginScroll = ScrollController();
  final ScrollController _signupScroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    final viewState = context.watch<AppService>().viewState;
    return WrapperFocusShift(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Column(
            children: [
              _header(),
              viewState == ViewState.busy ? Expanded(child: _loading(context)) : _tabViews(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loading(BuildContext context) {
    return LoadingSpinnerWidget(MediaQuery.of(context).size.width / 4);
  }

  /// An expanded container, with the Logo and Title stacked inside.
  Widget _header() {
    double fontSize = ((MediaQuery.of(context).size.width - (MediaQuery.of(context).viewInsets.bottom / 1.7)) / 5);
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: WrapperOverflowRemoved(
        child: SafeArea(
          child: Column(
            children: [
              Stack(
                children: [
                  _headerLogo(fontSize),
                  _headerText(fontSize),
                ],
              ),
              _tabBar(),
            ],
          ),
        ),
      ),
    );
  }

  /// An implementation of the FofLogoWidget
  Widget _headerLogo(double fontSize) {
    double fs = fontSize * 3.5;
    return FofLogoWidget(
      color: Theme.of(context).colorScheme.background,
      size: fs,
      offset: Offset(MediaQuery.of(context).size.width - fs, 0),
    );
  }

  /// A padded column that represents the title of the application.
  Widget _headerText(double fontSize) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "FLAT",
            style: Theme.of(context).textTheme.headline1?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: fontSize,
                ),
          ),
          Text(
            "ON",
            style: Theme.of(context).textTheme.headline1?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: fontSize / 2,
                  fontWeight: FontWeight.w400,
                ),
          ),
          Text(
            "FIRE",
            style: Theme.of(context).textTheme.headline1?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: fontSize,
                ),
          ),
        ],
      ),
    );
  }

  Widget _tabBar() {
    return const TabBar(
      tabs: [
        Tab(
          text: "LOGIN",
        ),
        Tab(
          text: "SIGNUP",
        ),
      ],
    );
  }

  Widget _tabViews() {
    return Expanded(
      child: WrapperOverflowRemoved(
        child: TabBarView(
          children: [
            WrapperPadding(
              child: LoginTabWidget(
                scrollController: _loginScroll,
              ),
            ),
            RawScrollbar(
              thumbColor: PaletteAssistant.alpha(Theme.of(context).colorScheme.secondary),
              thickness: 5,
              thumbVisibility: true,
              radius: const Radius.circular(2),
              controller: _signupScroll,
              child: WrapperPadding(
                child: SignupTabWidget(
                  scrollController: _signupScroll,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
