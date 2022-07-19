import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return _drawerItem(pages[index], index, context);
            },
          ),
        ),
      ],
    );
  }

  Widget _header() {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: SafeArea(child: WrapperPadding(child: _headerContent())),
    );
  }

  Widget _headerContent() {
    return Container(
      decoration: FofLogoDecoration(
        color: Theme.of(context).colorScheme.background,
        offset: Offset((Theme.of(context).textTheme.displayMedium?.fontSize ?? 20) * 1.8, 0),
      ),
      child: _headerText(),
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
        Navigator.of(context).pop();
        Navigator.of(context).popAndPushNamed(page.toName);
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
