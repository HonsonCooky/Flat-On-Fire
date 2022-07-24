import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupOverviewPage extends StatefulWidget {
  const GroupOverviewPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GroupOverviewPageState();
}

class _GroupOverviewPageState extends State<GroupOverviewPage> {
  final _name = TextEditingController();
  final List<String> _profileTitles = [
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
  bool _editMode = false;
  bool _changesMade = false;
  List<MemberModel> removedUsers = [];
  List<MemberModel> addedUsers = [];

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments as dynamic;
    var groupId = args?.groupId;
    var role = args?.role;

    _name.addListener(() {
      if (_name.text.isNotEmpty && !_changesMade) {
        setState(() {
          _changesMade = true;
        });
      }
    });

    return WrapperAppPage(
      child: _groupBody(groupId, role),
    );
  }

  Widget _groupBody(String groupId, Authorization role) {
    return FutureBuilder(
      future: FirestoreService().groupService.getGroup(groupId: groupId),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<GroupModel>> snapshot) {
        if (snapshot.hasData) {
          return _groupSnapshot(snapshot.data?.data(), role);
        } else if (snapshot.hasData || snapshot.hasError) {
          return _groupError();
        }

        return const AwaitingInformationWidget(
          texts: [
            "Finding group information",
            "I'm sure I left it somewhere around here",
          ],
        );
      },
    );
  }

  Widget _groupError() {
    return Center(
      child: Text(
        "Unable to retrieve group information",
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }

  Widget _groupSnapshot(GroupModel? groupModel, Authorization role) {
    if (groupModel == null) return _groupError();
    return _groupInformation(groupModel, role);
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

  Widget _profileBanner(GroupModel groupModel, Authorization role, TextStyle? textStyle) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        _profilePicture(groupModel, textStyle),
        _editPageButton(role),
      ],
    );
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

  Widget _editPageButton(Authorization role) {
    if (!(role == Authorization.owner || role == Authorization.write)) {
      return const SizedBox();
    }
    return EditPageButtonWidget(
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
      editMode: _editMode,
    );
  }

  Widget _profilePicture(GroupModel groupModel, TextStyle? textStyle) {
    return ProfilePicture(
      options: ProfileOptions(
          profileTitles: _profileTitles,
          editMode: _editMode ? ProfileEditMode.fullScreen : null,
          imageRef: ProfileImageRef(
            subLoc: GroupService.groupKey,
            uid: groupModel.uid!,
          )),
      currentImage: _currentImage,
      updateCurrentImage: _updateCurrentImage,
      placeholder: Text(
        groupModel.groupName.initials(),
        style: textStyle?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: Theme.of(context).textTheme.labelMedium?.fontSize != null
              ? Theme.of(context).textTheme.labelMedium!.fontSize! * 3
              : 20,
        ),
      ),
    );
  }

  Widget _groupInformation(GroupModel groupModel, Authorization role) {
    return WrapperPadding(
      child: WrapperOverflowRemoved(
        child: RawScrollbar(
          thumbColor: PaletteAssistant.alpha(Theme.of(context).colorScheme.secondary),
          thickness: 5,
          thumbVisibility: true,
          radius: const Radius.circular(2),
          child: _groupContent(groupModel, role),
        ),
      ),
    );
  }

  Widget _groupContent(GroupModel groupModel, Authorization role) {
    var textStyle = Theme.of(context).textTheme.labelMedium;
    return ListView(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 40,
        ),
        _profileBanner(groupModel, role, textStyle),
        SizedBox(
          height: MediaQuery.of(context).size.height / 40,
        ),
        HorizontalOrLineWidget(
          label: "Group Info",
          padding: 30,
          color: PaletteAssistant.alpha(Theme.of(context).colorScheme.onBackground),
        ),
        TipWidget(
          explanation: "A unique identifier for your group",
          child: TextEntryWidget(
            title: "Uuid",
            value: groupModel.uid!,
            textStyle: textStyle,
            editMode: false,
          ),
        ),
        SizedBox(height: textStyle?.fontSize),
        TipWidget(
          explanation: "The name that others in this app will see",
          child: TextEntryWidget(
            title: "Name",
            value: groupModel.groupName,
            controller: _name,
            textStyle: textStyle,
            editMode: _editMode,
          ),
        ),
        _members(groupModel.uid!, textStyle),
        _editButtons(groupModel, role),
      ],
    );
  }

  Widget _members(String groupId, TextStyle? textStyle) {
    return FutureBuilder(
        future: FirestoreService().groupService.getGroupMembers(groupId: groupId),
        builder: (BuildContext context, AsyncSnapshot<List<MemberModel>?> snapshot) {
          Widget child;
          List<MemberModel>? data;
          if (snapshot.hasData && snapshot.data != null) {
            data = snapshot.data!;
            if (data.isEmpty) {
              child = const Text("No Users");
            } else {
              child = _membersList(data);
            }
          } else if (snapshot.hasData || snapshot.hasError) {
            child = _memberError();
          } else {
            child = const AwaitingInformationWidget(texts: [
              "Gathering the troops",
              "Uniform inspection",
              "Taking hits, and taking names",
            ]);
          }
          return Column(
            children: [
              SizedBox(height: textStyle?.fontSize),
              HorizontalOrLineWidget(
                label: "Members",
                padding: 30,
                color: PaletteAssistant.alpha(Theme.of(context).colorScheme.onBackground),
              ),
              child,
            ],
          );
        });
  }

  Widget _membersList(List<MemberModel> data) {
    data.sort((a, b) => a.role.index - b.role.index);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, i) {
        return ListTile(
          tileColor: addedUsers.any((element) => element.userId == data[i].userId)
              ? PaletteAssistant.alpha(Theme.of(context).colorScheme.tertiary)
              : removedUsers.any((element) => element.userId == data[i].userId)
                  ? PaletteAssistant.alpha(Theme.of(context).colorScheme.onError)
                  : null,
          title: AutoScrollText(
            text: data[i].userProfile.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            data[i].role.name,
            style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          leading: FutureBuilder(
            future: CloudStorageService().getAvatarFile(
              subFolder: UserService.userKey,
              uid: data[i].userId,
            ),
            builder: (context, AsyncSnapshot<File?> snapshot) {
              return CircleAvatar(
                radius: Theme.of(context).textTheme.labelMedium?.fontSize,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundImage: snapshot.hasData && snapshot.data != null ? FileImage(snapshot.data!) : null,
                child: Text(
                  data[i].userProfile.name.initials(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              );
            },
          ),
          trailing: !_editMode
              ? null
              : IconButton(
                  onPressed: () {
                    if (removedUsers.any((element) => element.userId == data[i].userId)) {
                      setState(() {
                        removedUsers.removeWhere((element) => element.userId == data[i].userId);
                      });
                    } else {
                      setState(() {
                        removedUsers.add(data[i]);
                      });
                    }
                  },
                  icon: const Icon(Icons.delete),
                  splashRadius: Theme.of(context).textTheme.labelMedium?.fontSize ?? 30,
                ),
          dense: true,
          contentPadding: const EdgeInsets.all(5),
        );
      },
    );
  }

  Widget _memberError() {
    return Center(
      child: Text(
        "Unable to retrieve member information",
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }

  Widget _editButtons(GroupModel gm, Authorization role) {
    return (role == Authorization.owner || role == Authorization.write) && _editMode
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 20,
              ),
              _saveButton(gm),
              _deleteBtn(gm.uid!),
            ],
          )
        : const SizedBox();
  }

  void _onSaveFinish() {
    setState(() => _saving = false);
  }

  Widget _saveButton(GroupModel gm) {
    return ElevatedButton.icon(
      onPressed: () async {
        try {
          setState(() => _saving = true);
          FirestoreService().groupService.updateGroup(
                groupId: gm.uid!,
                update: {
                  "group": GroupModel(
                    uid: gm.uid,
                    groupName: _name.text.isEmpty ? gm.groupName : _name.text,
                    avatarPath: _newImage ? _currentImage?.path : gm.avatarPath,
                  ).toJson(),
                  "addedMembers": <String, MemberModel>{},
                  "removedMembers": <String, MemberModel>{},
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
                  (e) =>
                      ToastManager.instance.errorToast("Unable to save changes at this time.\n$e", Theme.of(context)),
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

  Widget _deleteBtn(String groupId) {
    return ElevatedButton.icon(
      onPressed: () async {
        context.read<AppService>().viewState = ViewState.busy;
        FirestoreService().groupService.deleteGroup(groupId: groupId).then((value) {
          context.read<AppService>().viewState = ViewState.ideal;
          Navigator.of(context).pop();
        }).catchError(
          (e) {
            context.read<AppService>().viewState = ViewState.ideal;
            ToastManager.instance.errorToast(e, Theme.of(context));
          },
        );
      },
      label: const Text("DELETE GROUP"),
      icon: const Icon(Icons.delete),
    );
  }
}
