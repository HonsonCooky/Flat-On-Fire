import 'package:flat_on_fire/common_widgets/logo/fof_logo.dart';
import 'package:flat_on_fire/features/authentication/presentation/login_widget.dart';
import 'package:flat_on_fire/features/authentication/presentation/signup_widget.dart';
import 'package:flat_on_fire/theme_helpers/color_handler.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class LandingPage extends StatefulWidget with GetItStatefulWidgetMixin {
  LandingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with GetItStateMixin {
  @override
  Widget build(BuildContext context) {
    String title = "FLAT ON FIRE";
    double childHorSpace = 30;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverSafeArea(
                  top: true,
                  sliver: SliverAppBar(
                    pinned: true,
                    primary: true,
                    forceElevated: innerBoxIsScrolled,
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    expandedHeight: MediaQuery.of(context).size.height / 2,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Stack(
                        children: [
                          Text(
                            title,
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                ?.copyWith(color: Theme.of(context).colorScheme.primary),
                          ),
                          Text(
                            title,
                            style: Theme.of(context).textTheme.headline2?.copyWith(
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 2
                                    ..color = Theme.of(context).colorScheme.onBackground,
                                ),
                          ),
                        ],
                      ),
                      titlePadding: EdgeInsets.only(
                          left: 10, right: 40, bottom: Theme.of(context).textTheme.headline1?.fontSize ?? 50),
                      background: FofLogo(
                        color: Theme.of(context).colorScheme.secondary,
                        offset: Offset(MediaQuery.of(context).size.width / 3, MediaQuery.of(context).size.height / 15),
                        size: MediaQuery.of(context).size.height / 3,
                      ),
                    ),
                    bottom: TabBar(
                      labelPadding: EdgeInsets.zero,
                      labelColor: Theme.of(context).colorScheme.onTertiary,
                      labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: (Theme.of(context).textTheme.labelMedium?.fontSize ?? 10) + 4),
                      unselectedLabelColor: ColorAlter.darken(Theme.of(context).colorScheme.onTertiary, 0.1),
                      unselectedLabelStyle: Theme.of(context).textTheme.labelMedium,
                      tabs: const [
                        Tab(text: "Login"),
                        Tab(text: "Signup"),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Container(
            padding: EdgeInsets.only(top: 20, left: childHorSpace, right: childHorSpace),
            color: Theme.of(context).colorScheme.background,
            child: TabBarView(
                // These are the contents of the tab views, below the tabs.
                children: [LoginWidgets(), SignupWidgets()]),
          ),
        ),
      ),
    );
  }
}
