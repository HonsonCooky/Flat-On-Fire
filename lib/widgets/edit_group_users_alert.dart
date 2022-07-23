import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';

class EditGroupUsersAlert extends StatefulWidget {
  final String groupName;
  

  const EditGroupUsersAlert({Key? key, required this.groupName}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditGroupUsersAlertState();
}

class _EditGroupUsersAlertState extends State<EditGroupUsersAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Alter ${widget.groupName}'s members",
      ),
      titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 1.2,
        width: MediaQuery.of(context).size.width / 1.2,
        child: WrapperFocusShift(
          child: _editUsersBody(),
        ),
      ),
      actions: [
        _saveButton(),
        _cancelButton(),
      ],
    );
  }

  Widget _editUsersBody() {
    return ListView(
      children: [],
    );
  }

  // set up the buttons
  Widget _cancelButton() {
    return TextButton(
      child: const Text("CANCEL"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  // set up the buttons
  Widget _saveButton() {
    return ElevatedButton(
      child: const Text("SAVE"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}
