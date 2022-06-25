import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flat_on_fire/_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ToastMixin {
  @override
  Widget build(BuildContext context) {
    var user = context.read<AuthProvider>().user!;
    var displayName = context.read<AuthProvider>().profileInfo(user.uid).withConverter<ProfileModel>(
          fromFirestore: (snapshot, _) => ProfileModel.fromJson(snapshot.data()!),
          toFirestore: (ProfileModel userModel, _) => userModel.toJson(),
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        elevation: 0,
      ),
      drawer: const AppDrawer(),
      body: SidePaddedWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FutureBuilder(
              future: displayName.get(const GetOptions(source: Source.cache)),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<ProfileModel>> snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    "Welcome ${snapshot.data!.data()!.name}",
                    style: Theme.of(context).textTheme.titleLarge,
                  );
                }
                return Text(
                  "Welcome ...",
                  style: Theme.of(context).textTheme.titleLarge,
                );
              },
            ),
            ElevatedButton(
              onPressed: () async {
                var signOutText = await context.read<AuthProvider>().signOut();

                if (!mounted) return;
                if (signOutText != signedOutText) {
                  errorToast(signOutText, context);
                }
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
