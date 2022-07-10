import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingsPage> with ToastMixin {
  final _name = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  FileImage? _userImage;
  XFile? _pickedImage;

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
      future: FirestoreService().userService.getUser(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<UserModel>> snapshot) {
        if (snapshot.hasError) return _accountError(textStyle);
        if (snapshot.hasData) {
          if (snapshot.data?.data() != null) {
            UserModel um = snapshot.data!.data()!;
            _getUsersAvatar(um);
            return _accountSuccess(um, textStyle);
          } else {
            return _accountError(textStyle);
          }
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

  Widget _profilePicture(UserModel um, TextStyle? textStyle) {
    double fontSize = textStyle?.fontSize != null ? textStyle!.fontSize! * 3 : 20;
    return Stack(
      alignment: Alignment.center,
      children: [
        _profileImage(um, fontSize),
        _editProfileImage(fontSize),
      ],
    );
  }

  Widget _profileImage(UserModel um, double fontSize) {
    return GestureDetector(
      onTap: () {
        if (_pickedImage == null) return;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return FullImageDialogWidget(
              title: "Profile Picture",
              image: Image.file(File(_pickedImage!.path)),
            );
          },
        );
      },
      child: CircleAvatar(
          radius: fontSize,
          foregroundImage: _pickedImage != null ? FileImage(File(_pickedImage!.path)) : _userImage,
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Text(
            um.profile.name.initials(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontSize: fontSize,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          )),
    );
  }

  Future<void> _getUsersAvatar(UserModel um) async {
    if (um.profile.avatarPath == null) return;

    final File imageFile = File(await FirestoreService.avatarTmpLoc(um.uid!));
    setState(() {
      _userImage = FileImage(imageFile);
    });
    // if (await imageFile.exists() == false) {
    //   try {
    //     var image = await FirestoreService().storageRef.child(um.profile.avatarPath!).ge;
    //   } on Exception catch (exception) {
    //     throw 'could not write image $exception';
    //   }
    // }
  }

  Widget _editProfileImage(fontSize) {
    return Positioned(
      top: fontSize * 1.2,
      left: MediaQuery.of(context).size.width / 2 - 10,
      child: ElevatedButton(
        onPressed: () async {
          _pickedImage = await _picker.pickImage(source: ImageSource.gallery);
          setState(() {});
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
        ),
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget _accountSuccess(UserModel um, TextStyle? textStyle) {
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: [
        _profilePicture(um, textStyle),
        SizedBox(height: textStyle?.fontSize),
        TipWidget(
          explanation: "A unique identifier for your account",
          child: UneditableTextEntryWidget(
            title: "Account Number",
            value: um.uid!,
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
      future: FirestoreService().userService.getUser(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<UserModel>> snapshot) {
        if (snapshot.hasError) return _noSaveButton(textStyle);
        if (snapshot.hasData) {
          if (snapshot.data?.data() != null) {
            return _saveButton(snapshot.data!.data()!);
          } else {
            return _noSaveButton(textStyle);
          }
        }
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
          await FirestoreService().userService.updateUser({
            "themeMode": context.read<AppService>().themeMode.name,
            "onBoarded": context.read<AppService>().onBoarded,
            "profile": UserProfileModel(name: _name.text.isNotEmpty ? _name.text : um.profile.name).toJson(),
          });
          if (mounted) successToast("Save successful", context);
        } catch (e) {
          errorToast("Unable to save changes at this time", context);
        } finally {
          context.read<AppService>().viewState = ViewState.ideal;
        }
      },
      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
            backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).colorScheme.primary),
          ),
      label: Text(
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

  void _successfulAuthentication() {
    showDialog(
      context: context,
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
