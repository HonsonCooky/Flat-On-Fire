import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flat_on_fire/wrapper_n_mixins/wrapper_app_page.dart';
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
    return WrapperAppPage(
      child: _settingsBody(),
    );
  }

  Widget _settingsBody() {
    return WrapperPadding(
      child: WrapperOverflowRemoved(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 20),
            _accountInformation(),
            _logoutBtn(),
          ],
        ),
      ),
    );
  }

  Widget _accountInformation() {
    return FutureBuilder(
      future: getFutureUser(context),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<UserModel>> snapshot) {
        if (snapshot.hasData) {
          return _userInformationColumn(snapshot.data!.data()!);
        }
        return LoadingTextWidget(
          text: "... finding account information",
          style: Theme.of(context).textTheme.displayMedium,
        );
      },
    );
  }

  Widget _userInformationColumn(UserModel um) {
    return Column(
      children: [
        HorizontalOrLineWidget(
          label: "Account",
          padding: MediaQuery.of(context).size.height / 20,
          color: PaletteAssistant.alpha(Theme.of(context).colorScheme.onBackground),
        ),
        MapToListWidget(
          values: {
            "UID": um.uid,
            "Name": um.profile.name,
          },
          textStyle: Theme.of(context).textTheme.bodyLarge!,
        ),
      ],
    );
  }

  Widget _logoutBtn() {
    return TextButton(
      onPressed: () async {
        var signOutText = await context.read<AuthService>().signOut();

        if (!mounted) return;
        if (signOutText != signedOutText) {
          errorToast(signOutText, context);
        }
      },
      child: const Text("Logout"),
    );
  }
}
