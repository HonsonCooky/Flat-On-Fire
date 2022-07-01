import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late int selectedIndex;

  @override
  Widget build(BuildContext context) {
    selectedIndex = currentAppRouteIndex(context);
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: _drawerContent(),
    );
  }

  Widget _drawerContent() {
    List<AppPageEnum> pages = visibleAppRoutes;

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: pages.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _header();
        }
        var i = index - 1;
        return _drawerItem(pages[i], i, context);
      },
    );
  }

  Widget _header() {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
      ),
      child: _headerContent(),
    );
  }

  Widget _headerContent() {
    return Stack(
      children: [
        _headerIcon(),
        _headerText(),
      ],
    );
  }

  Widget _headerIcon() {
    return FofLogoWidget(
      offset: Offset(MediaQuery.of(context).size.width / 3, 10),
    );
  }

  Widget _headerText() {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "FLAT",
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w900,
                ),
          ),
          Text(
            "ON",
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
          Text(
            "FIRE",
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(AppPageEnum page, int i, BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.labelMedium;
    return ListTile(
      dense: true,
      title: Text(
        page.toTitle,
        style: textStyle?.copyWith(
          color:
              selectedIndex == i ? Theme.of(context).colorScheme.onSecondary : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      leading: _getLeadingIcon(page, textStyle?.fontSize),
      tileColor: selectedIndex == i ? Theme.of(context).colorScheme.secondary : null,
      iconColor:
          selectedIndex == i ? Theme.of(context).colorScheme.onSecondary : Theme.of(context).colorScheme.onSurface,
      onTap: () {
        Navigator.pop(context);
        GoRouter.of(context).go(page.toPath);
      },
    );
  }

  Widget _getLeadingIcon(AppPageEnum page, double? size) {
    late IconData icon;
    switch (page) {
      case AppPageEnum.home:
        icon = Icons.home;
        break;
      case AppPageEnum.chores:
        icon = Icons.dry_cleaning;
        break;
      case AppPageEnum.groups:
        icon = Icons.workspaces;
        break;
      case AppPageEnum.tables:
        icon = Icons.table_view;
        break;
      case AppPageEnum.settings:
        icon = Icons.settings;
        break;
      default:
        icon = Icons.perm_contact_calendar_rounded;
        break;
    }
    return Icon(
      icon,
      size: size,
    );
  }
}
