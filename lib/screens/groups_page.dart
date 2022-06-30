import 'package:flat_on_fire/wrapper_n_mixins/wrapper_app_page.dart';
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
}
