import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with ToastMixin {
  final _email = TextEditingController();
  final _password = TextEditingController();
  String? emailErrMsg, passwordErrMsg;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void mandatoryCheck() {
    setState(() {
      emailErrMsg = _email.text.isEmpty ? "No Email Provided" : null;
      passwordErrMsg = _password.text.isEmpty ? "No Password Provided" : null;
    });

    if (emailErrMsg != null || passwordErrMsg != null) {
      throw Exception("Invalid User Credentials");
    }
  }

  void resetErrors() {
    setState(() {
      emailErrMsg = null;
      passwordErrMsg = null;
    });
  }

  void attempt({
    required Future<void> Function() attemptCallback,
    bool requiresCheck = true,
    VoidCallback? optionalCheck,
  }) async {
    try {
      // Don't bother checking the backend if the information is known to be wrong.
      if (requiresCheck) {
        mandatoryCheck();
        // Some screens have more than email and password, so execute their other checks
        if (optionalCheck != null) {
          optionalCheck();
        }
      }

      await attemptCallback();
    } catch (e) {
      errorToast(e.toString(), context);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double barHeight = (height - MediaQuery.of(context).viewInsets.bottom) / 3;

    return WrapperFocusShift(
      child: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              _header(height, barHeight),
              _tabBar(),
              _tabViews(),
              _googleSignIn(),
            ],
          ),
        ),
        // bottomNavigationBar: _googleSignIn(),
      ),
    );
  }

  /// An expanded container, with the Logo and Title stacked inside.
  Widget _header(double height, double barHeight) {
    return Expanded(
      flex: 10,
      child: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Stack(
          children: [
            _headerLogo(height, barHeight),
            _headerText(height, barHeight),
          ],
        ),
      ),
    );
  }

  /// An implementation of the FofLogoWidget
  Widget _headerLogo(double height, double barHeight) {
    return FofLogoWidget(
      size: barHeight,
      offset: Offset(MediaQuery.of(context).size.width - barHeight, barHeight / 10),
    );
  }

  /// A padded column that represents the title of the application.
  Widget _headerText(double height, double barHeight) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "FLAT",
            style: Theme.of(context).textTheme.headline1?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: barHeight / 3,
                ),
          ),
          Text(
            "ON",
            style: Theme.of(context).textTheme.headline1?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: barHeight / 6,
                  fontWeight: FontWeight.w400,
                ),
          ),
          Text(
            "FIRE",
            style: Theme.of(context).textTheme.headline1?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: barHeight / 3,
                ),
          ),
        ],
      ),
    );
  }

  Widget _tabBar() {
    return const ColoredTabBarWidget(
      tabBar: TabBar(
        tabs: [
          Tab(
            text: "Login",
          ),
          Tab(
            text: "Signup",
          ),
        ],
      ),
    );
  }

  Widget _tabViews() {
    return Expanded(
      flex: 12,
      child: WrapperOverflowRemoved(
        child: TabBarView(
          children: [
            WrapperPadding(
              child: LoginTabWidget(
                email: _email,
                password: _password,
                emailErrMsg: emailErrMsg,
                passwordErrMsg: passwordErrMsg,
                resetErrors: resetErrors,
                attempt: attempt,
              ),
            ),
            WrapperPadding(
              child: SignupTabWidget(
                email: _email,
                password: _password,
                emailErrMsg: emailErrMsg,
                passwordErrMsg: passwordErrMsg,
                resetErrors: resetErrors,
                attempt: attempt,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _googleSignIn() {
    final googleImage = context.read<AppService>().themeMode == ThemeMode.light
        ? 'assets/google_logo_light.png'
        : 'assets/google_logo_dark.png';

    return WrapperPadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HorizontalOrLineWidget(
            label: "OR",
            padding: 20,
            color: PaletteAssistant.alpha(Theme.of(context).colorScheme.onBackground),
          ),

          /// Google Sign In Button
          ElevatedButton.icon(
            label: const Text("SIGN IN WITH GOOGLE"),
            onPressed: () => attempt(
              requiresCheck: false,
              attemptCallback: () => context.read<AuthService>().googleSignupLogin(
                    errorToast: (str) => errorToast(str, context),
                  ),
            ),
            style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).colorScheme.tertiary)),
            icon: Image.asset(
              googleImage,
              height: (Theme.of(context).textTheme.button?.fontSize ?? 10) + 5,
              fit: BoxFit.fitHeight,
            ),
          ),
        ],
      ),
    );
  }
}
