import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flat_on_fire/_app_bucket.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingsPage> with ToastMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        elevation: 0,
      ),
      drawer: const DrawerWidget(),
      body: WrapperPadding(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 20),
              FutureBuilder(
                future: getFutureUser(context),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<UserModel>> snapshot) {
                  if (snapshot.hasData) {
                    UserModel userM = snapshot.data!.data()!;
                    return Column(
                      children: [
                        HorizontalOrLineWidget(
                          label: "Account",
                          padding: MediaQuery.of(context).size.height / 20,
                          color: PaletteAssistant.alpha(Theme.of(context).colorScheme.onBackground),
                        ),
                        MapToListWidget(
                          values: {
                            "UID": userM.uid,
                            "Name": userM.profile.name,
                          },
                          textStyle: Theme.of(context).textTheme.bodyLarge!,
                        ),
                      ],
                    );
                  }
                  return LoadingTextWidget(style: Theme.of(context).textTheme.displayMedium!);
                },
              ),
              TextButton(
                onPressed: () async {
                  var signOutText = await context.read<AuthProvider>().signOut();

                  if (!mounted) return;
                  if (signOutText != signedOutText) {
                    errorToast(signOutText, context);
                  }
                  Navigator.popUntil(context, (route) => false);
                  Navigator.pushNamed(context, routeAuth);
                },
                child: const Text("Logout"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
