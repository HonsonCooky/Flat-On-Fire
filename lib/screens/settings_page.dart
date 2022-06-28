import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flat_on_fire/models/user_settings_model.dart';
import 'package:flat_on_fire/wrapper_n_mixins/wrapper_app_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingsPage> with ToastMixin {
  late TextStyle titleStyles;

  @override
  Widget build(BuildContext context) {
    titleStyles = Theme.of(context).textTheme.bodyLarge!;

    return WrapperAppPage(
      child: _settingsBody(),
    );
  }

  Widget _settingsBody() {
    return WrapperPadding(
      child: WrapperOverflowRemoved(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _accountInformation(),
                  const SizedBox(
                    height: 20,
                  ),
                  _userSettingsColumn(),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                reverse: true,
                children: [
                  _logoutBtn(),
                  _saveButton(),
                ],
              ),
            ),
            const Expanded(
              flex: 1,
              child: SizedBox(
                height: 20,
              ),
            ),
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
            "On Boarding": um.userSettings.onBoarded ? "Complete" : "In-Complete"
          },
          textStyle: titleStyles,
        ),
      ],
    );
  }

  Widget _userSettingsColumn() {
    return Column(
      children: [
        HorizontalOrLineWidget(
          label: "Settings",
          padding: MediaQuery.of(context).size.height / 20,
          color: PaletteAssistant.alpha(Theme.of(context).colorScheme.onBackground),
        ),
        _themeChanger(),
      ],
    );
  }

  Widget _themeChanger() {
    return Consumer<AppService>(builder: (context, AppService appService, child) {
      bool isDark = ThemeMode.dark == appService.themeMode;
      return SwitchListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Theme",
              style: titleStyles.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              isDark ? "(Dark)" : "(Light)",
              style: titleStyles,
            ),
          ],
        ),
        contentPadding: EdgeInsets.zero,
        value: isDark,
        onChanged: (b) => appService.switchTheme(),
      );
    });
  }

  Widget _saveButton() {
    return TextButton(
      onPressed: () async {
        await context.read<AuthService>().userInfo().update({
          "userSettings": UserSettingsModel(
            context.read<AppService>().themeMode.name,
            true,
          ).toJson(),
        });
      },
      child: const Text("Save Changes"),
    );
  }

  Widget _logoutBtn() {
    return TextButton(
      onPressed: () async {
        await context.read<AuthService>().signOut(
              errorToast: (str) => errorToast(str, context),
            );
      },
      child: const Text("Logout"),
    );
  }
}
