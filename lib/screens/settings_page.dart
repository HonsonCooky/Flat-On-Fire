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
    final viewState = context.watch<AppService>().viewState;
    print(viewState);

    return  WrapperAppPage(
      child: viewState == ViewState.busy ? _loading() : _settingsBody(),
    );
  }
  
  Widget _loading(){
    return LoadingSpinnerWidget(MediaQuery.of(context).size.width / 4);
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
                  _spacer(),
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
                  _spacer(),
                  _logoutBtn(),
                  _saveButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _subHeader(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height / 40),
      child: Text(text, style: Theme.of(context).textTheme.displaySmall),
    );
  }

  Widget _spacer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 20,
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
          style: Theme.of(context).textTheme.bodyLarge,
        );
      },
    );
  }

  Widget _userInformationColumn(UserModel um) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _subHeader("Account"),
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _subHeader("App"),
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
        dense: true,
        visualDensity: VisualDensity.compact,
        value: isDark,
        onChanged: (b) => appService.switchTheme(),
      );
    });
  }

  Widget _saveButton() {
    return ElevatedButton(
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
    return ElevatedButton(
      onPressed: () async {
        await context.read<AuthService>().signOut(
              errorToast: (str) => errorToast(str, context),
            );
      },
      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
            backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).colorScheme.tertiary),
          ),
      child: Text(
        "Logout",
        style: Theme.of(context).elevatedButtonTheme.style?.textStyle?.resolve({})?.copyWith(
          color: Theme.of(context).colorScheme.onTertiary,
        ),
      ),
    );
  }
}
