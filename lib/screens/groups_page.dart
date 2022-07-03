import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  @override
  Widget build(BuildContext context) {
    return WrapperAppPage(child: _groupsBody());
  }

  Widget _groupsBody() {
    var textStyle = Theme.of(context).textTheme.labelMedium;
    return Column(
      children: [
        _userGroups(textStyle),
      ],
    );
  }

  Widget _userGroups(TextStyle? textStyle) {
    return FutureBuilder(
      future: getUser(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<UserModel>> snapshot) {
        if (snapshot.hasError) return _userGroupsError(textStyle);
        if (snapshot.hasData) return _userGroupsList(snapshot.data!.data()!, textStyle);
        return _awaitingUserGroups(textStyle);
      },
    );
  }

  Widget _awaitingUserGroups(TextStyle? textStyle) {
    return LoadingTextWidget(text: "... finding group information", style: textStyle);
  }

  Widget _userGroupsError(TextStyle? textStyle) {
    return Text(
      "Unable to retrieve group information",
      style: textStyle,
    );
  }

  Widget _userGroupsList(UserModel userModel, TextStyle? textStyle) {
    return Column(
      children: [],
    );
  }
}
