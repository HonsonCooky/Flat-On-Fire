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
  final List<String> _profileTitles = [
    "Dis you?",
    "Ya so handsome",
    "Felt cute...",
    "This is me!",
    "(ﾉ◕ヮ◕)ﾉ*:･ﾟ✧",
    "(◕‿◕✿)",
    "This dude! (☞ﾟ∀ﾟ)☞",
    "So pretty! (;´༎ຶД༎ຶ`)"
  ];
  File? _currentImage;
  bool _newImage = false;
  bool _saving = false;
  bool _editMode = false;
  bool _changesMade = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------------------------------------------------------------
  // MAIN
  // ----------------------------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    _name.addListener(() {
      if (_name.text.isNotEmpty && !_changesMade) {
        setState(() {
          _changesMade = true;
        });
      }
    });

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
          children: [
            _spacer(),
            _settingsContent(textStyle),
            _spacer(),
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

  Widget _settingsContent(TextStyle? textStyle) {
    return FutureBuilder(
      future: FirestoreService().userService.getUser(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<UserModel>?> snapshot) {
        if (snapshot.hasData && snapshot.data?.data() != null) {
          UserModel um = snapshot.data!.data()!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _accountSuccess(um, textStyle),
              _appSettings(textStyle),
              _editMode ? _editButtons(um) : const SizedBox(),
            ],
          );
        } else if (snapshot.hasData || snapshot.hasError) {
          return _accountError(textStyle);
        }
        return const AwaitingInformationWidget(
          texts: [
            "Finding account information",
            "Looking for you",
            "Where you at?",
          ],
        );
      },
    );
  }

  Widget _accountError(TextStyle? textStyle) {
    return Text(
      "Unable to retrieve account information at this time",
      style: textStyle,
    );
  }

  Widget _accountSuccess(UserModel um, TextStyle? textStyle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _profileBanner(um, textStyle),
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
            editMode: _editMode,
          ),
        ),
        SizedBox(height: textStyle?.fontSize),
      ],
    );
  }

  void _updateCurrentImage(File? file, bool delete, bool isNew) {
    if (file != null || delete) {
      setState(() {
        _currentImage = file;
        _newImage = isNew;
        _changesMade = isNew;
      });
    }
  }

  Widget _imSureCancel() {
    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          _editMode = false;
        });
        Navigator.of(context).pop();
        _name.clear();
        context.read<AppService>().viewState = ViewState.busy;
        Future.delayed(const Duration(milliseconds: 500)).then((_) => context.read<AuthService>().establishSettings());
      },
      label: const Text("Remove changes"),
      icon: const Icon(Icons.delete),
    );
  }

  Widget _cancel() {
    return TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel"));
  }

  Widget _profileBanner(UserModel userModel, TextStyle? textStyle) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        _profilePicture(userModel, textStyle),
        EditPageButtonWidget(
            editFn: (editMode) async {
              if (_changesMade && !editMode) {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Unsaved changes"),
                        content: const Text("You haven't saved some changes you made. Are you sure you want to exit "
                            "editing. All unsaved changes will take no effect."),
                        actions: [
                          _imSureCancel(),
                          _cancel(),
                        ],
                      );
                    });
              } else {
                setState(() {
                  _editMode = editMode;
                });
              }
            },
            editMode: _editMode),
      ],
    );
  }

  Widget _profilePicture(UserModel userModel, TextStyle? textStyle) {
    return ProfilePicture(
      options: ProfileOptions(
          profileTitles: _profileTitles,
          editMode: _editMode ? ProfileEditMode.fullScreen : null,
          imageRef: ProfileImageRef(
            subLoc: UserService.userKey,
            uid: userModel.uid!,
          )),
      currentImage: _currentImage,
      updateCurrentImage: _updateCurrentImage,
      placeholder: Text(
        userModel.profile.name.initials(),
        style: textStyle?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: Theme.of(context).textTheme.labelMedium?.fontSize != null
              ? Theme.of(context).textTheme.labelMedium!.fontSize! * 3
              : 20,
        ),
      ),
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
          onChanged: (b) {
            appService.onBoarded = b;
            setState(() {
              _changesMade = true;
            });
          },
          textStyle: textStyle,
          editMode: _editMode,
        );
      },
    );
  }

  // ----------------------------------------------------------------------------------------------------------------
  // APP SETTINGS
  // ----------------------------------------------------------------------------------------------------------------

  Widget _appSettings(TextStyle? textStyle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HorizontalOrLineWidget(
          label: "App",
          padding: 30,
          color: PaletteAssistant.alpha(Theme.of(context).colorScheme.onBackground),
        ),
        _onBoardedChanger(textStyle),
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
          onChanged: (b) {
            appService.themeMode = b ? ThemeMode.dark : ThemeMode.light;
          },
          textStyle: textStyle,
          editMode: _editMode,
        );
      },
    );
  }

  // ----------------------------------------------------------------------------------------------------------------
  // SAVE FEATURE
  // ----------------------------------------------------------------------------------------------------------------

  void _onSaveFinish() {
    setState(() {
      _saving = false;
      _changesMade = false;
    });
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
              () {
                ToastManager.instance.successToast("Save successful", Theme.of(context));
                setState(() {
                  _name.text = "";
                });
              },
              () {
                ToastManager.instance.infoToast("Local save successful", Theme.of(context));
                setState(() {
                  _name.text = "";
                });
              },
              (e) => ToastManager.instance.errorToast("Unable to save changes at this time.\n$e", Theme.of(context)),
              _onSaveFinish,
            ),
          );
        } catch (e) {
          ToastManager.instance.errorToast("Unable to save changes at this time", Theme.of(context));
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

  Widget _editButtons(UserModel um) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _spacer(),
        _saveButton(um),
        _deleteBtn(),
      ],
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
