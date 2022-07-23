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

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments as dynamic;
    var groupId = args?.groupId;

    return WrapperAppPage(
      child: _groupBody(groupId),
    );
  }

  Widget _groupBody(String groupId) {
    return FutureBuilder(
      future: FirestoreService().groupService.getGroup(groupId: groupId),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<GroupModel>> snapshot) {
        if (snapshot.hasData) {
          return _groupSnapshot(snapshot.data?.data());
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

  Widget _groupSnapshot(GroupModel? groupModel) {
    if (groupModel == null) return _groupError();
    return _groupInformation(groupModel);
  }

  void _updateCurrentImage(File? file) {
    if (file != null) {
      setState(() {
        _currentImage = file;
        _newImage = true;
      });
    } else {
      setState(() {});
    }
  }

  Widget _profilePicture(GroupModel groupModel, TextStyle? textStyle) {
    return ProfilePicture(
      profileTitles: _profileTitles,
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
      subLoc: GroupService.groupKey,
      uid: groupModel.uid,
    );
  }

  Widget _groupInformation(GroupModel groupModel) {
    return WrapperPadding(
      child: WrapperOverflowRemoved(
        child: RawScrollbar(
          thumbColor: PaletteAssistant.alpha(Theme.of(context).colorScheme.secondary),
          thickness: 5,
          thumbVisibility: true,
          radius: const Radius.circular(2),
          child: _groupContent(groupModel),
        ),
      ),
    );
  }

  Widget _groupContent(GroupModel groupModel) {
    var textStyle = Theme.of(context).textTheme.labelMedium;
    return ListView(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 40,
        ),
        _profilePicture(groupModel, textStyle),
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
          child: UneditableTextEntryWidget(
            title: "Uuid",
            value: groupModel.uid!,
            textStyle: textStyle,
          ),
        ),
        SizedBox(height: textStyle?.fontSize),
        TipWidget(
          explanation: "The name that others in this app will see",
          child: EditableTextEntryWidget(
            title: "Name",
            value: groupModel.groupName,
            controller: _name,
            textStyle: textStyle,
          ),
        ),
        _members(groupModel.uid!, textStyle),
        SizedBox(
          height: MediaQuery.of(context).size.height / 20,
        ),
        _saveButton(groupModel),
        SizedBox(
          height: MediaQuery.of(context).size.height / 10,
        ),
        _deleteBtn(groupModel.uid!),
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
          dense: true,
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
