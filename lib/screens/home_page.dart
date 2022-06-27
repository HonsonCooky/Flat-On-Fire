import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flat_on_fire/wrapper_n_mixins/wrapper_app_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ToastMixin {
  @override
  Widget build(BuildContext context) {
    return WrapperAppPage(
      child: _homeBody(),
    );
  }

  Widget _homeBody() {
    return WrapperPadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 20,
          ),
          _welcomeText(),
        ],
      ),
    );
  }

  Widget _welcomeText() {
    return FutureBuilder(
      future: getFutureUser(context),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<UserModel>> snapshot) {
        if (snapshot.hasData) {
          return Text(
            "Welcome!\n${snapshot.data!.data()!.profile.name}",
            style: Theme.of(context).textTheme.displayMedium,
          );
        }
        return Text(
          "Welcome ...",
          style: Theme.of(context).textTheme.titleLarge,
        );
      },
    );
  }
}
