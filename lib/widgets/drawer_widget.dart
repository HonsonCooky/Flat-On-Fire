import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';

// Is there a better way to maintain this state?
// int selectedIndex = indexOfDefaultRoute();

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      // child: _drawerContent(),
    );
  }

  // Widget _drawerContent() {
  //   return ListView.builder(
  //     padding: EdgeInsets.zero,
  //     itemCount: appRoutesList.length + 1,
  //     itemBuilder: (context, index) {
  //       if (index == 0) {
  //         return _header();
  //       }
  //       var name = appRoutesList[index - 1];
  //       var i = index - 1;
  //       return _drawerItem(name, i);
  //     },
  //   );
  // }

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
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "FLAT",
            style: Theme.of(context).textTheme.headline2?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w900,
                ),
          ),
          Text(
            "ON",
            style: Theme.of(context).textTheme.headline3?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
          Text(
            "FIRE",
            style: Theme.of(context).textTheme.headline2?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }

  // Widget _drawerItem(String name, int i) {
  //   return ListTile(
  //     title: Text(
  //       name,
  //       style: Theme.of(context).textTheme.labelMedium?.copyWith(
  //             color: selectedIndex == i
  //                 ? Theme.of(context).colorScheme.onSecondary
  //                 : Theme.of(context).colorScheme.onSurface,
  //           ),
  //     ),
  //     leading: _getLeadingIcon(name),
  //     tileColor: selectedIndex == i ? Theme.of(context).colorScheme.secondary : null,
  //     iconColor:
  //         selectedIndex == i ? Theme.of(context).colorScheme.onSecondary : Theme.of(context).colorScheme.onSurface,
  //     onTap: () {
  //       setState(() {
  //         selectedIndex = i;
  //       });
  //       Navigator.of(context).pop();
  //       Navigator.of(context).popAndPushNamed(name);
  //     },
  //   );
  // }
  //
  // Widget _getLeadingIcon(String name) {
  //   var icon = Icons.perm_contact_calendar_rounded;
  //   if (name == appRoutesList[0]) {
  //     icon = Icons.home;
  //   } else if (name == appRoutesList[1]) {
  //     icon = Icons.dry_cleaning;
  //   } else if (name == appRoutesList[2]) {
  //     icon = Icons.workspaces;
  //   } else if (name == appRoutesList[3]) {
  //     icon = Icons.table_view;
  //   } else if (name == appRoutesList[4]) {
  //     icon = Icons.settings;
  //   }
  //   return Icon(icon);
  // }
}
