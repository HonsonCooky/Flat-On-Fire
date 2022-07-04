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
  final _name = TextEditingController();

  // ----------------------------------------------------------------------------------------------------------------
  // MAIN
  // ----------------------------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return WrapperAppPage(
      child: _settingsBody(),
    );
  }

  Widget _settingsBody() {
    var textStyle = Theme.of(context).textTheme.labelMedium;
    return WrapperPadding(
      child: WrapperOverflowRemoved(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _spacer(),
                  _accountSettings(textStyle),
                  _appSettings(textStyle),
                  _spacer(),
                  _futureSaveButton(textStyle),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _deleteBtn(),
                _logoutBtn(),
                _spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------------------------------------------------
  // HELPERS
  // ----------------------------------------------------------------------------------------------------------------

  Widget _spacer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 20,
    );
  }

  // ----------------------------------------------------------------------------------------------------------------
  // ACCOUNT SETTINGS
  // ----------------------------------------------------------------------------------------------------------------

  Widget _accountSettings(TextStyle? textStyle) {
    return FutureBuilder(
      future: getUser(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<UserModel>> snapshot) {
        if (snapshot.hasError) return _accountError(textStyle);
        if (snapshot.hasData) return _accountSuccess(snapshot.data!.data()!, textStyle);
        return _awaitingAccountInformation(textStyle);
      },
    );
  }

  Widget _accountError(TextStyle? textStyle) {
    return Text(
      "Unable to retrieve account information at this time",
      style: textStyle,
    );
  }

  Widget _awaitingAccountInformation(TextStyle? textStyle) {
    return LoadingTextWidget(
      text: "... finding account information",
      style: textStyle,
    );
  }

  Widget _accountSuccess(UserModel um, TextStyle? textStyle) {
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: [
        UneditableTextEntryWidget(title: "Account Number", value: um.uid!, textStyle: textStyle),
        SizedBox(height: textStyle?.fontSize),
        EditableTextEntryWidget(title: "Name", value: um.userProfile.name, controller: _name, textStyle: textStyle),
        SizedBox(height: textStyle?.fontSize),
        _onBoardedChanger(textStyle),
        SizedBox(height: textStyle?.fontSize),
      ],
    );
  }

  Widget _onBoardedChanger(TextStyle? textStyle) {
    return Consumer<AppService>(
      builder: (context, AppService appService, child) {
        bool isOnboarded = appService.onBoarded;
        return BooleanSwitcherWidget(
          title: "On Boarded",
          hints: const ["(Completed)", "(Redo)"],
          isOn: isOnboarded,
          explanation: "Deselecting this value, will take you back through the tutorial when you login again.",
          onChanged: (b) => appService.onBoarded = b,
          textStyle: textStyle,
        );
      },
    );
  }

  // ----------------------------------------------------------------------------------------------------------------
  // APP SETTINGS
  // ----------------------------------------------------------------------------------------------------------------

  Widget _appSettings(TextStyle? textStyle) {
    return Column(
      children: [_themeChanger(textStyle)],
    );
  }

  Widget _themeChanger(TextStyle? textStyle) {
    return Consumer<AppService>(
      builder: (context, AppService appService, child) {
        bool isDark = ThemeMode.dark == appService.themeMode;
        return BooleanSwitcherWidget(
          title: "Theme",
          hints: const ["(Dark)", "(Light)"],
          explanation:
              "The theme sets the user interface colors. Dark mode uses dark colors. Light mode used light colors. "
              "Currently, your are in ${isDark ? "dark" : "light"} mode.",
          isOn: isDark,
          onChanged: (b) => appService.themeMode = b ? ThemeMode.dark : ThemeMode.light,
          textStyle: textStyle,
        );
      },
    );
  }

  // ----------------------------------------------------------------------------------------------------------------
  // SAVE FEATURE
  // ----------------------------------------------------------------------------------------------------------------

  Widget _futureSaveButton(TextStyle? textStyle) {
    return FutureBuilder(
      future: getUser(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<UserModel>> snapshot) {
        if (snapshot.hasError) return _noSaveButton(textStyle);
        if (snapshot.hasData) return _saveButton(snapshot.data!.data()!);
        return LoadingSpinnerWidget(textStyle?.fontSize ?? 20);
      },
    );
  }

  Widget _noSaveButton(TextStyle? textStyle) {
    return Text(
      "Cannot save without account information",
      style: textStyle,
    );
  }

  Widget _saveButton(UserModel um) {
    return ElevatedButton.icon(
      onPressed: () async {
        try {
          context.read<AppService>().viewState = ViewState.busy;
          await updateUser(
            userSettingsModel: UserSettingsModel(
              themeMode: context.read<AppService>().themeMode.name,
              onBoarded: context.read<AppService>().onBoarded,
            ),
            profileModel: UserProfileModel(name: _name.text.isNotEmpty ? _name.text : um.userProfile.name),
          );
          if (mounted) successToast("Save successful", context);
        } catch (_) {
          errorToast("Unable to save changes at this time", context);
        } finally {
          context.read<AppService>().viewState = ViewState.ideal;
        }
      },
      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
            backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).colorScheme.primary),
          ),
      label: Text(
        "Save Changes",
        style: Theme.of(context).elevatedButtonTheme.style?.textStyle?.resolve({})?.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      icon: Icon(
        Icons.save,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  // ----------------------------------------------------------------------------------------------------------------
  // ACCOUNT SESSION MANAGEMENT
  // ----------------------------------------------------------------------------------------------------------------

  Widget _logoutBtn() {
    return ElevatedButton.icon(
      onPressed: () async {
        var signOutText = await context.read<AuthService>().signOut();
        if (mounted && signOutText != AuthService.successfulOperation) {
          errorToast(signOutText, context);
        }
      },
      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
            backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).colorScheme.tertiary),
          ),
      label: Text(
        "LOGOUT",
        style: Theme.of(context).elevatedButtonTheme.style?.textStyle?.resolve({})?.copyWith(
          color: Theme.of(context).colorScheme.onTertiary,
        ),
      ),
      icon: Icon(
        Icons.logout,
        color: Theme.of(context).colorScheme.onTertiary,
      ),
    );
  }

  void _successfulAuthentication(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const DeleteAccountAlertWidget();
      },
    );
  }

  Widget _deleteBtn() {
    return ElevatedButton.icon(
      onPressed: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ReauthenticateAccountAlertWidget(successfulAuthentication: _successfulAuthentication);
          },
        );
      },
      label: const Text("DELETE ACCOUNT"),
      icon: const Icon(Icons.person_remove),
    );
  }
}
