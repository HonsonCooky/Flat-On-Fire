import 'dart:io';

import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final _name = TextEditingController();
  File? _currentImage;
  String? _errorText;


  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WrapperAppPage(
      child: WrapperPadding(child: _createGroupBody()),
    );
  }

  Widget _createGroupBody() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _profilePicture(),
          SizedBox(
            height: MediaQuery.of(context).size.height / 40,
          ),
          FofTextField(
            onTap: () => setState(() => _errorText = null),
            labelText: "Group Name",
            controller: _name,
            errorText: _errorText,
          ),
          _createGroupButton(),
        ],
      ),
    );
  }

  void _updateCurrentImage(File? file) {
    setState(() => _currentImage = file);
  }

  Widget _profilePicture() {
    return ProfilePicture(
      currentImage: _currentImage,
      updateCurrentImage: _updateCurrentImage,
      placeholder: Icon(
        Icons.image,
        color: Theme.of(context).colorScheme.onSurface,
        size: (Theme.of(context).textTheme.labelMedium?.fontSize ?? 20) * 3,
      ),
    );
  }

  Widget _createGroupButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.group_add),
      label: const Text("CREATE GROUP"),
      onPressed: () async {
        if (_name.text.isEmpty) {
          setState(() => _errorText = "Group name required");
          return;
        }

        context.read<AppService>().viewState = ViewState.busy;
        try {
          await FirestoreService().groupService.createNewGroup(
                name: _name.text,
                syncFuncs: FirebaseSyncFuncs(
                  () {
                    ToastManager.instance.successToast("Save successful", Theme.of(context));
                  },
                  () {
                    ToastManager.instance.successToast("Local save successful", Theme.of(context));
                  },
                  () {
                    ToastManager.instance.errorToast("Unable to create group at this time", Theme.of(context));
                  },
                  () {},
                ),
              );
        } catch (e) {
          ToastManager.instance.errorToast("Unable to save changes at this time", Theme.of(context));
        } finally {
          if (mounted) context.read<AppService>().viewState = ViewState.ideal;
        }
      },
    );
  }
}
