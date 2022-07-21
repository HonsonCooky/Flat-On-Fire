import 'dart:io';

import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  bool _initialClick = true;

  _navigateToCreatePage() {
    Navigator.of(context).pushNamed(AppPageEnum.groupsCreate.toPath).then(
      (value) {
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WrapperAppPage(
      child: _groupsBody(),
    );
  }

  Widget _groupsBody() {
    var userId = FirestoreService().userService.getUserId();
    if (userId != null) {
      return _userGroupsList(userId);
    }
    return _userGroupsError();
  }

  Widget _userGroupsError() {
    return Center(
      child: Text(
        "Unable to retrieve user information",
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }

  Widget _userGroupsList(String userId) {
    return FutureBuilder(
      future: FirestoreService().groupService.getUsersGroups(userId: userId),
      builder: (BuildContext context, AsyncSnapshot<List<MemberModel>?> snapshot) {
        if (snapshot.hasData) {
          return _groupsList(userId, snapshot.data);
        } else if (snapshot.hasData || snapshot.hasError) {
          return _userGroupsError();
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

  void _goToGroup(String userId, MemberModel membership) {
    setState(() => _initialClick = false);
    Navigator.of(context)
        .pushNamed(AppPageEnum.groupOverview.toPath, arguments: membership)
        .then((value) => FirestoreService().groupService.getUsersGroups(userId: userId));
  }

  Widget _groupsList(String userId, List<MemberModel>? groupMemberships) {
    if (groupMemberships == null || groupMemberships.isEmpty) return _noGroups();
    if (groupMemberships.length == 1 && _initialClick) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _goToGroup(userId, groupMemberships[0]));
    }
    groupMemberships.sort((a, b) => a.groupName.compareTo(b.groupName));
    return _listGroups(userId, groupMemberships);
  }

  Widget _listGroups(String userId, List<MemberModel> groupMemberships) {
    return RefreshIndicator(
      onRefresh: () {
        return FirestoreService().groupService.getUsersGroups(userId: userId);
      },
      child: WrapperOverflowRemoved(
        child: Stack(
          children: [
            RawScrollbar(
              thumbColor: PaletteAssistant.alpha(Theme.of(context).colorScheme.secondary),
              thickness: 5,
              thumbVisibility: true,
              radius: const Radius.circular(2),
              child: ListView.builder(
                itemCount: groupMemberships.length,
                itemBuilder: (context, i) => ListTile(
                  onTap: () => _goToGroup(userId, groupMemberships[i]),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  title: Text(
                    groupMemberships[i].groupName,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    groupMemberships[i].role.name,
                    style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: FutureBuilder(
                    future: CloudStorageService()
                        .getAvatarFile(subFolder: GroupService.groupKey, uid: groupMemberships[i].groupId),
                    builder: (context, AsyncSnapshot<File?> snapshot) {
                      return CircleAvatar(
                        radius: Theme.of(context).textTheme.displayMedium?.fontSize,
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        foregroundImage: snapshot.hasData && snapshot.data != null ? FileImage(snapshot.data!) : null,
                        child: Text(
                          groupMemberships[i].groupName.initials(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            WrapperPadding(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 40),
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: _navigateToCreatePage,
                  child: const Icon(Icons.add),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _noGroups() {
    return WrapperPadding(
      child: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () {
              return Future(() => setState(() {}));
            },
            child: WrapperOverflowRemoved(child: ListView()),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Oh no!",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                "You're not associated to any groups yet.",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 80,
              ),
              Text(
                "(Drag down to refresh page)",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 40,
              ),
              ElevatedButton.icon(
                onPressed: _navigateToCreatePage,
                icon: const Icon(Icons.table_view),
                label: const Text("CREATE NEW GROUP"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
