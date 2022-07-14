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
    return WrapperAppPage(
      child: _groupsBody(),
    );
  }

  Widget _groupsBody() {
    return Column(
      children: [
        _userGroups(),
      ],
    );
  }

  Widget _userGroups() {
    return FutureBuilder(
      future: FirestoreService().userService.getUser(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<UserModel>> snapshot) {
        if (snapshot.hasData && snapshot.data?.data() != null) {
          return _userGroupsList(snapshot.data!.data()!);
        } else if (snapshot.hasData || snapshot.hasError) {
          return _userGroupsError();
        }
        return const AwaitingInformationWidget(texts: [
          "Group information loading",
          "Playing pickup 52",
          "Asking the server nicely",
        ]);
      },
    );
  }

  Widget _userGroupsError() {
    return Expanded(
      child: Center(
        child: Text(
          "Unable to retrieve information",
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ),
    );
  }

  Widget _userGroupsList(UserModel userModel) {
    // if (userModel.groups == null || userModel.groups!.isEmpty) return _noGroups();
    return const SizedBox();
  }

  Widget _noGroups() {
    return Expanded(
      child: WrapperPadding(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Oh no!",
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            Text(
              "You're not associated to any groups yet",
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 40,
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.table_view),
              label: const Text("Create Group"),
            ),
          ],
        ),
      ),
    );
  }
}
