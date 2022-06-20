import 'package:flat_on_fire/common_widgets/colored_tabbar.dart';
import 'package:flat_on_fire/common_widgets/logo/fof_logo.dart';
import 'package:flat_on_fire/common_widgets/side_padded_widget.dart';
import 'package:flat_on_fire/features/authentication/presentation/login_widget.dart';
import 'package:flat_on_fire/features/authentication/presentation/signup_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class LandingPage extends StatefulWidget with GetItStatefulWidgetMixin {
  LandingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with GetItStateMixin {
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

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primary,
                  child: Stack(
                    children: [
                      FofLogo(
                        size: height / 2,
                        offset: Offset(MediaQuery.of(context).size.width / 3,
                            barHeight / 20 - (MediaQuery.of(context).viewInsets.bottom / 5)),
                      ),
                      Padding(
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
                      ),
                    ],
                  ),
                ),
              ),
              const ColoredTabBar(
                tabBar: TabBar(
                  tabs: [
                    Tab(text: "Login"),
                    Tab(text: "Signup"),
                  ],
                ),
              ),
              Expanded(
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overscroll) {
                    overscroll.disallowIndicator();
                    return true;
                  },
                  child: TabBarView(
                    children: [
                      SidePaddedWidget(LoginWidgets(email, password)),
                      SidePaddedWidget(SignupWidgets(email, password)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
