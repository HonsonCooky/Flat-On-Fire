import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flat_on_fire/_app_bucket.dart';
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
          _welcomeTextFuture(),
        ],
      ),
    );
  }

  Widget _welcomeTextFuture() {
    return FutureBuilder(
      future: getUser(context),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<UserModel>> snapshot) {
        if (snapshot.hasData) {
          UserModel? userModel = snapshot.data!.data()!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _welcomeText(userModel),
            ],
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

  Widget _welcomeText(UserModel userModel) {
    return Text(
      "Welcome\n${userModel.profile.name}!",
      style: Theme.of(context).textTheme.displayMedium,
    );
  }
}
