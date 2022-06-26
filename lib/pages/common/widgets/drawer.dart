import 'package:flat_on_fire/_app.dart';
import 'package:flutter/material.dart';

// Is there a better way to maintain this state?
int selectedIndex = indexOfDefaultRoute();

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  Widget getLeadingIcon(String name) {
    var icon = Icons.perm_contact_calendar_rounded;
    if (name == appRoutes[0]) {
      icon = Icons.home;
    } else if (name == appRoutes[1]) {
      icon = Icons.dry_cleaning;
    } else if (name == appRoutes[2]) {
      icon = Icons.workspaces;
    } else if (name == appRoutes[3]) {
      icon = Icons.table_view;
    } else if (name == appRoutes[4]) {
      icon = Icons.settings;
    }
    return Icon(icon);
  }

  @override
  Widget build(BuildContext context) {    
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: appRoutes.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return DrawerHeader(
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Stack(
                children: [
                  FofLogo(
                    offset: Offset(MediaQuery.of(context).size.width / 3, 10),
                  ),
                  Padding(
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
                  ),
                ],
              ),
            );
          }
          var name = appRoutes[index - 1];
          var i = index - 1;
          return ListTile(
            title: Text(
              name,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: selectedIndex == i
                        ? Theme.of(context).colorScheme.onSecondary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            leading: getLeadingIcon(name),
            tileColor: selectedIndex == i ? Theme.of(context).colorScheme.secondary : null,
            iconColor: selectedIndex == i
                ? Theme.of(context).colorScheme.onSecondary
                : Theme.of(context).colorScheme.onSurface,
            onTap: () {
              setState(() {
                selectedIndex = i;
              });
              Navigator.popUntil(context, (route) => false);
              Navigator.pushNamed(context, name);
            },
          );
        },
      ),
    );
  }
}
