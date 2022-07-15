import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingsPage> {
  final _name = TextEditingController();
  final List<String> profileTitles = [
    "Dis you?",
    "Ya so handsome",
    "Felt cute...",
    "This is me!",
    "(ﾉ◕ヮ◕)ﾉ*:･ﾟ✧",
    "(◕‿◕✿)",
    "This dude! \n(☞ﾟ∀ﾟ)☞",
    "So pretty! \n(;´༎ຶД༎ຶ`)"
  ];
  File? _currentImage;
  bool _newImage = false;
  bool _saving = false;

  // ----------------------------------------------------------------------------------------------------------------
  // MAIN
  // ----------------------------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return WrapperAppPage(
      child: RawScrollbar(
        thumbColor: PaletteAssistant.alpha(Theme.of(context).colorScheme.secondary),
        thickness: 5,
        thumbVisibility: true,
        radius: const Radius.circular(2),
        child: _settingsBody(),
      ),
    );
  }

  Widget _settingsBody() {
    var textStyle = Theme.of(context).textTheme.labelMedium;
    return WrapperPadding(
      child: WrapperOverflowRemoved(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            _spacer(),
            _accountSettings(textStyle),
            _appSettings(textStyle),
            _spacer(),
            _futureSaveButton(textStyle),
            _spacer(),
            _deleteBtn(),
            _logoutBtn(),
            _spacer(),
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
      future: FirestoreService().userService.getUser(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<UserModel>> snapshot) {
        if (snapshot.hasData && snapshot.data?.data() != null) {
          UserModel um = snapshot.data!.data()!;
          return _accountSuccess(um, textStyle);
        } else if (snapshot.hasData || snapshot.hasError) {
          return _accountError(textStyle);
        }
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
        _profilePicture(um, textStyle),
        SizedBox(height: textStyle?.fontSize),
        HorizontalOrLineWidget(
          label: "Account",
          padding: 30,
          color: PaletteAssistant.alpha(Theme.of(context).colorScheme.onBackground),
        ),
        TipWidget(
          explanation: "A unique identifier for your account",
          child: UneditableTextEntryWidget(
            title: "Uuid",
            value: um.uid!,
            textStyle: textStyle,
          ),
        ),
        SizedBox(height: textStyle?.fontSize),
        TipWidget(
          explanation: "The email you signed up with",
          child: UneditableTextEntryWidget(
            title: "Email",
            value: FirebaseAuth.instance.currentUser?.email ?? "N/A",
            textStyle: textStyle,
          ),
        ),
        SizedBox(height: textStyle?.fontSize),
        TipWidget(
          explanation: "The name that others in this app will see",
          child: EditableTextEntryWidget(
            title: "Name",
            value: um.profile.name,
            controller: _name,
            textStyle: textStyle,
          ),
        ),
        SizedBox(height: textStyle?.fontSize),
      ],
    );
  }

  void _updateCurrentImage(File? file) {
    if (file != null) {
      setState(() {
        _currentImage = file;
        _newImage = true;
      });
    }
  }

  Widget _profilePicture(UserModel userModel, TextStyle? textStyle) {
    return ProfilePicture(
      profileTitles: profileTitles,
      currentImage: _currentImage,
      updateCurrentImage: _updateCurrentImage,
      placeholder: Text(
        userModel.profile.name.initials(),
        style: textStyle?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: textStyle.fontSize != null ? textStyle.fontSize! * 3 : 20,
        ),
      ),
      subLoc: UserService.userKey,
      uid: userModel.uid,
      textStyle: textStyle,
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
      children: [
        HorizontalOrLineWidget(
          label: "App",
          padding: 30,
          color: PaletteAssistant.alpha(Theme.of(context).colorScheme.onBackground),
        ),
        _onBoardedChanger(textStyle),
        SizedBox(height: textStyle?.fontSize),
        _themeChanger(textStyle),
      ],
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
      future: FirestoreService().userService.getUser(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<UserModel>> snapshot) {
        if (snapshot.hasData && snapshot.data?.data() != null) {
          return _saveButton(snapshot.data!.data()!);
        } else if (snapshot.hasData || snapshot.hasError) {
          return const SizedBox();
        }
        return LoadingSpinnerWidget(textStyle?.fontSize ?? 20);
      },
    );
  }

  void _onSaveFinish() {
    setState(() => _saving = false);
  }

  Widget _saveButton(UserModel um) {
    return ElevatedButton.icon(
      onPressed: () async {
        try {
          setState(() => _saving = true);
          FirestoreService().userService.updateUser(
            update: {
              "themeMode": context.read<AppService>().themeMode.name,
              "onBoarded": context.read<AppService>().onBoarded,
              "profile": UserProfileModel(
                name: _name.text.isNotEmpty ? _name.text : um.profile.name,
                avatarPath: _newImage ? _currentImage?.path : um.profile.avatarPath,
              ).toJson(),
            },
            syncFuncs: FirebaseSyncFuncs(
              () => ToastManager.instance.successToast("Save successful", Theme.of(context)),
              () => ToastManager.instance.infoToast("Local save successful", Theme.of(context)),
              () => ToastManager.instance.errorToast("Unable to save changes at this time", Theme.of(context)),
              _onSaveFinish,
            ),
          );
        } catch (e) {
          ToastManager.instance.errorToast("Unable to save changes at this time", Theme.of(context));
        } finally {
          context.read<AppService>().viewState = ViewState.ideal;
        }
      },
      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
            backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).colorScheme.primary),
          ),
      label: _saving
          ? LoadingSpinnerWidget(
              20,
              color: Theme.of(context).colorScheme.onPrimary,
            )
          : Text(
              "SAVE CHANGES",
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
        var theme = Theme.of(context); // Get before async gap
        var signOutText = await context.read<AuthService>().signOut();
        if (signOutText != AuthService.successfulOperation) {
          ToastManager.instance.errorToast(signOutText, theme);
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

  void _successfulAuthentication() {
    showDialog(
      context: context,
      barrierColor: Theme.of(context).colorScheme.tertiary,
      builder: (BuildContext context) {
        return const DeleteAccountAlertWidget();
      },
    );
  }

  Widget _deleteBtn() {
    return ElevatedButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          barrierColor: Theme.of(context).colorScheme.tertiary,
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
