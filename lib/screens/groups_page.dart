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
    return Column(
      children: [],
    );
  }

  Widget _groupsFuture() {
    return FutureBuilder(
      future: getUser(context),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<UserModel>> snapshot) {
        if (snapshot.hasData) {
          UserModel? userModel = snapshot.data!.data();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [],
          );
        } else if (snapshot.hasError) {
          return Text(
            "Unable to retrieve user information at this time",
            style: Theme.of(context).textTheme.titleLarge,
          );
        }
        return LoadingTextWidget(
          text: "Loading home page ...",
          style: Theme.of(context).textTheme.titleLarge,
        );
      },
    );
  }
}
