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

  // ----------------------------------------------------------------------------------------------------------------
  // MAIN
  // ----------------------------------------------------------------------------------------------------------------

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

  // ----------------------------------------------------------------------------------------------------------------
  // WELCOME TEXT
  // ----------------------------------------------------------------------------------------------------------------

  Widget _welcomeTextFuture() {
    return FutureBuilder(
      future: FirestoreService().userService.getUser(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<UserModel>> snapshot) {
        if (snapshot.hasError) return _errorWelcomeText(Theme.of(context).textTheme.titleLarge);
        if (snapshot.hasData) return _welcomeText(snapshot.data!.data()!, Theme.of(context).textTheme.displayMedium);
        return _awaitingWelcomeText(Theme.of(context).textTheme.titleLarge);
      },
    );
  }

  Widget _awaitingWelcomeText(TextStyle? textStyle) {
    return LoadingTextWidget(
      text: "Loading home page ...",
      style: textStyle,
    );
  }

  Widget _errorWelcomeText(TextStyle? textStyle) {
    return Text(
      "Unable to retrieve user information at this time",
      style: textStyle,
    );
  }

  Widget _welcomeText(UserModel userModel, TextStyle? textStyle) {
    return Text(
      "Welcome\n${userModel.profile.name}!",
      style: textStyle,
    );
  }
}
