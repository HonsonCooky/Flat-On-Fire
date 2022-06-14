import 'package:flat_on_fire/common_models/view_model.dart';
import 'package:flat_on_fire/common_widgets/logo/fof_logo.dart';
import 'package:flat_on_fire/theme_helpers/color_handler.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class LoginPage extends StatefulWidget with GetItStatefulWidgetMixin {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with GetItStateMixin {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double fontSize = 24;
    const double smallFontSize = 18;
    const double iconMultiplier = 1.2;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 20),
            sliver: SliverAppBar(
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              expandedHeight: MediaQuery.of(context).size.height / 2,
              pinned: true,
              flexibleSpace: const FlexibleSpaceBar(
                title: Text(
                  'FLAT ON FIRE',
                ),
                centerTitle: true,
                background: FofLogo(),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  /// Email Text Box
                  TextField(
                    decoration: const InputDecoration(labelText: "Email", contentPadding: EdgeInsets.all(5)),
                    style: const TextStyle(fontSize: fontSize),
                    controller: email,
                  ),

                  /// Password Text Box
                  TextField(
                    decoration: const InputDecoration(labelText: "Password", contentPadding: EdgeInsets.all(5)),
                    style: const TextStyle(fontSize: fontSize),
                    controller: password,
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  /// Sign In Button
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.mail_outline,
                      size: fontSize * iconMultiplier,
                    ),
                    label: const Text(
                      "Sign In",
                      style: TextStyle(fontSize: fontSize),
                    ),
                  ),

                  /// Google Sign In Button
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) => AppColors.googleBlue),
                    ),
                    onPressed: () {},
                    icon: Image.asset(
                      GetIt.I<ViewModel>().themeMode == ThemeMode.light
                          ? 'assets/google_logo_light.png'
                          : 'assets/google_logo_dark.png',
                      height: fontSize * iconMultiplier,
                      fit: BoxFit.fitHeight,
                    ),
                    label: const Text(
                      "Sign in with Google",
                      style: TextStyle(fontSize: fontSize),
                    ),
                  ),

                  const SizedBox(height: 15),
                  Wrap(
                    alignment: WrapAlignment.spaceAround,
                    children: [
                      /// Signup button
                      TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.person_add,
                            size: smallFontSize * iconMultiplier,
                          ),
                          label: const Text(
                            "Signup",
                            style: TextStyle(fontSize: smallFontSize),
                          )),

                      /// Forgot password button
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.password_outlined,
                          size: smallFontSize * iconMultiplier,
                        ),
                        label: const Text(
                          "Forgot Password",
                          style: TextStyle(fontSize: smallFontSize),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
