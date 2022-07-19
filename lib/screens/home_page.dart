import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return WrapperAppPage(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 40,
          ),
          _homeBody(),
        ],
      ),
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
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<UserModel>?> snapshot) {
        if (snapshot.hasData && snapshot.data?.data() != null) {
          return _homePageBodyWithUserInformation(snapshot.data!.data()!);
        } else if (snapshot.hasData || snapshot.hasError) {
          return _errorWelcomeText(Theme.of(context).textTheme.titleLarge);
        }
        return const AwaitingInformationWidget(
            texts: ["Favourites Loading", "Advanced AI at work", "Patience, you must have, Padawan"]);
      },
    );
  }

  Widget _errorWelcomeText(TextStyle? textStyle) {
    return Text(
      "Unable to retrieve user information at this time",
      style: textStyle,
    );
  }

  Widget _homePageBodyWithUserInformation(UserModel userModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _welcomeText(userModel),
      ],
    );
  }

  Widget _welcomeText(UserModel userModel) {
    return Text(
      "Welcome\n${userModel.profile.name}!",
      style: Theme.of(context).textTheme.displayMedium,
    );
  }

// Widget _favouritePages(UserModel userModel) {
//
// }
}
