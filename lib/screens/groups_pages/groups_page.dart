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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _userGroups(),
      ],
    );
  }

  Widget _userGroups() {
    var userId = FirestoreService().userService.getUserId();
    if (userId != null) {
      return _userGroupsList(userId);
    }
    return _userGroupsError();
  }

  Widget _userGroupsError() {
    return Expanded(
      child: Center(
        child: Text(
          "Unable to retrieve user information",
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ),
    );
  }

  Widget _userGroupsList(String userId) {
    return FutureBuilder(
      future: FirestoreService().groupService.getUsersGroups(userId: userId),
      builder: (BuildContext context, AsyncSnapshot<List<MemberModel>?> snapshot) {
        if (snapshot.hasData) {
          return Container(
            height: 100,
            color: Colors.blue,
          );
        } else if (snapshot.hasData || snapshot.hasError) {
          return _noGroups();
        }
        return const AwaitingInformationWidget(
          texts: [
            "Group information loading",
            "Playing pickup 52",
            "Asking the server nicely",
          ],
        );
      },
    );
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
            _createGroupButton(),
          ],
        ),
      ),
    );
  }

  Widget _createGroupButton() {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.of(context).pushNamed(AppPageEnum.groupsCreate.toPath);
      },
      icon: const Icon(Icons.table_view),
      label: const Text("Create New Group"),
    );
  }
}
