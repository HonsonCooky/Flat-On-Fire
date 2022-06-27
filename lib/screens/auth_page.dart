import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double barHeight = (height / 2.6) - (MediaQuery.of(context).viewInsets.bottom / 2.5);

    return WrapperFocusShift(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _header(height, barHeight),
              _tabBar(),
              _tabPages(),
            ],
          ),
        ),
      ),
    );
  }

  /// An expanded container, with the Logo and Title stacked inside.
  Widget _header(double height, double barHeight) {
    return Expanded(
      child: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Stack(
          children: [
            _headerLogo(height, barHeight),
            _headerText(height, barHeight),
          ],
        ),
      ),
    );
  }

  /// An implementation of the FofLogoWidget
  Widget _headerLogo(double height, double barHeight) {
    return FofLogoWidget(
      size: height / 2.5,
      offset: Offset(MediaQuery.of(context).size.width / 2.5, barHeight / 10),
    );
  }

  /// A padded column that represents the title of the application.
  Widget _headerText(double height, double barHeight) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "FLAT",
            style: Theme.of(context).textTheme.headline1?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: barHeight / 3,
                ),
          ),
          Text(
            "ON",
            style: Theme.of(context).textTheme.headline1?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: barHeight / 6,
                  fontWeight: FontWeight.w400,
                ),
          ),
          Text(
            "FIRE",
            style: Theme.of(context).textTheme.headline1?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: barHeight / 3,
                ),
          ),
        ],
      ),
    );
  }

  Widget _tabBar() {
    return const ColoredTabBarWidget(
      tabBar: TabBar(
        tabs: [
          Tab(
            text: "Login",
          ),
          Tab(
            text: "Signup",
          ),
        ],
      ),
    );
  }

  Widget _tabPages() {
    return Expanded(
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: TabBarView(
          children: [
            WrapperPadding(child: LoginTabWidget(email, password)),
            WrapperPadding(child: SignupTabWidget(email, password)),
          ],
        ),
      ),
    );
  }
}
