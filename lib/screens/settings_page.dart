import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingsPage> with ToastMixin {
  final _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewState = context.watch<AppService>().viewState;

    return WrapperAppPage(
      child: viewState == ViewState.busy ? _loading() : _settingsBody(),
    );
  }

  Widget _loading() {
    return LoadingSpinnerWidget(MediaQuery.of(context).size.width / 4);
  }

  Widget _settingsBody() {
    return WrapperPadding(
      child: WrapperOverflowRemoved(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _spacer(),
                  _accountInformation(Theme.of(context).textTheme.labelMedium),
                  _themeChanger(Theme.of(context).textTheme.labelMedium),
                  _spacer(),
                  _futureSaveButton(),
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

  Widget _spacer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 20,
    );
  }

  Widget _accountInformation(TextStyle? textStyle) {
    return FutureBuilder(
      future: getFutureUser(context),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<UserModel>> snapshot) {
        return snapshot.hasData
            ? _userInformationFromModel(snapshot.data!.data()!, textStyle)
            : LoadingTextWidget(
                text: "... finding account information",
                style: textStyle,
              );
      },
    );
  }

  Widget _userInformationFromModel(UserModel um, TextStyle? textStyle) {
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: [
        _uneditableTextEntry("Account Number", um.uid!, textStyle),
        SizedBox(height: textStyle?.fontSize),
        _editableTextEntry("Name", um.profile.name, _name, textStyle),
        SizedBox(height: textStyle?.fontSize),
        _onBoardedChanger(textStyle),
        SizedBox(height: textStyle?.fontSize),
      ],
    );
  }

  Widget _uneditableTextEntry(String title, String value, TextStyle? textStyle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: textStyle?.copyWith(fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textStyle?.copyWith(
                  fontWeight: FontWeight.normal,
                  color: PaletteAssistant.alpha(textStyle.color ?? Colors.black, 0.4),
                ),
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius: textStyle?.fontSize,
              iconSize: textStyle?.fontSize,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value)).then((value) => successToast("Copied Text", context));
              },
              icon: const Icon(Icons.copy),
            ),
          ],
        ),
      ],
    );
  }

  Widget _editableTextEntry(String title, String value, TextEditingController controller, TextStyle? textStyle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: textStyle?.copyWith(fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: value,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          style: textStyle?.copyWith(fontWeight: FontWeight.normal),
        ),
      ],
    );
  }

  Widget _onBoardedChanger(TextStyle? textStyle) {
    return Consumer<AppService>(
      builder: (context, AppService appService, child) {
        bool isOnboarded = appService.onBoarded;
        return _booleanSwitch(
          title: "On Boarded",
          hints: ["(Completed)", "(Redo)"],
          isOn: isOnboarded,
          explanation: "Deselecting this value, will take you back through the tutorial when you login again.",
          onChanged: (b) => appService.onBoarded = b,
          textStyle: textStyle,
        );
      },
    );
  }

  Widget _themeChanger(TextStyle? textStyle) {
    return Consumer<AppService>(
      builder: (context, AppService appService, child) {
        bool isDark = ThemeMode.dark == appService.themeMode;
        return _booleanSwitch(
          title: "Theme",
          hints: ["(Dark)", "(Light)"],
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

  Widget _booleanSwitch({
    required String title,
    required List<String> hints,
    required bool isOn,
    required String explanation,
    void Function(bool)? onChanged,
    TextStyle? textStyle,
  }) {
    assert(hints.length == 2);
    return Tooltip(
      message: explanation,
      margin: const EdgeInsets.only(left: 20, right: 20, top: 5),
      padding: const EdgeInsets.all(10),
      child: SwitchListTile(
        title: Row(
          children: [
            Text(
              title,
              style: textStyle?.copyWith(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Text(
                isOn ? hints[0] : hints[1],
                style: textStyle?.copyWith(fontWeight: FontWeight.normal),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        contentPadding: EdgeInsets.zero,
        dense: true,
        visualDensity: VisualDensity.compact,
        value: isOn,
        onChanged: onChanged,
      ),
    );
  }

  Widget _futureSaveButton() {
    return FutureBuilder(
      future: getFutureUser(context),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<UserModel>> snapshot) {
        return snapshot.hasData ? _saveButton(snapshot.data!.data()!) : _spacer();
      },
    );
  }

  Widget _saveButton(UserModel um) {
    return ElevatedButton.icon(
      onPressed: () async {
        await context.read<AuthService>().updateUser(
              userSettingsModel: UserSettingsModel(
                themeMode: context.read<AppService>().themeMode.name,
                onBoarded: context.read<AppService>().onBoarded,
              ),
              profileModel: ProfileModel(name: _name.text.isNotEmpty ? _name.text : um.profile.name),
            );
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
      icon: const Icon(Icons.save),
    );
  }

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
        "Logout",
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

  Widget _deleteBtn() {
    return ElevatedButton.icon(
      onPressed: () async {
        _deleteConfirmation();
      },
      label: const Text("Delete Account"),
      icon: const Icon(Icons.person_remove),
    );
  }

  _deleteConfirmation() {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget deleteButton = TextButton(
      child: Text(
        "Delete my account",
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onError),
      ),
      onPressed: () async {
        Navigator.of(context).pop();
        var deleteText = await context.read<AuthService>().deleteUser();
        if (mounted && deleteText != AuthService.successfulOperation) {
          errorToast(deleteText, context);
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Warning"),
      content: const Text("Are you sure you want to permanently delete your account and all it's information?"),
      actions: [
        deleteButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
