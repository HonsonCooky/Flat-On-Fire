import 'package:flat_on_fire/_app.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ToastWrapper {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              await GetIt.I<AuthModel>().logOut();
            } catch (e, s) {
              errorToast("Unable to logout", context);
            }
          },
          child: const Text("Logout"),
        ),
      ),
    );
  }
}
