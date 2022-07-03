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

  bool _mandatoryCheck() {
    setState(() {
      emailErrMsg = _email.text.isEmpty ? "No Email Provided" : null;
      passwordErrMsg = _password.text.isEmpty ? "No Password Provided" : null;
    });
    return emailErrMsg == null && passwordErrMsg == null;
  }

  void resetErrors() {
    setState(() {
      emailErrMsg = null;
      passwordErrMsg = null;
    });
  }

  void attempt({
    required Future<String> Function() attemptCallback,
    bool requiresCheck = true,
    bool Function()? optionalCheck,
  }) async {
    // Don't bother checking the backend if the information is known to be wrong.
    bool checkPass = true;
    if (requiresCheck) {
      checkPass &= _mandatoryCheck();
      // Some screens have more than email and password, so execute their other checks
      if (optionalCheck != null) {
        checkPass &= optionalCheck();
      }
    }

    if (!checkPass) {
      errorToast("Invalid user credentials", context);
      return;
    }

    var res = await attemptCallback();
    if (mounted && res != AuthService.successfulOperation) {
      errorToast(res, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewState = context.watch<AppService>().viewState;
    double fontSize = (MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom) / 3;
    return WrapperFocusShift(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Column(
            children: [
              _header(fontSize),
              viewState == ViewState.busy ? Expanded(child: _loading(context)) : _tabViews(),
              viewState == ViewState.busy ? const SizedBox() : _googleSignIn(),
            ],
          ),
        ),
        // bottomNavigationBar: _googleSignIn(),
      ),
    );
  }

  Widget _loading(BuildContext context) {
    return LoadingSpinnerWidget(MediaQuery.of(context).size.width / 4);
  }

  /// An expanded container, with the Logo and Title stacked inside.
  Widget _header(double fontSize) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: WrapperOverflowRemoved(
        child: SafeArea(
          child: Column(
            children: [
              Stack(
                children: [
                  _headerLogo(fontSize),
                  _headerText(fontSize),
                ],
              ),
              _tabBar(),
            ],
          ),
        ),
      ),
    );
  }

  /// An implementation of the FofLogoWidget
  Widget _headerLogo(double fontSize) {
    double alpha = fontSize / (MediaQuery.of(context).size.height / 3) - 0.01;

    return FofLogoWidget(
      color: PaletteAssistant.alpha(
        Theme.of(context).colorScheme.background,
        alpha,
      ),
      size: fontSize,
      offset: Offset(MediaQuery.of(context).size.width - fontSize, 0),
    );
  }

  /// A padded column that represents the title of the application.
  Widget _headerText(double fontSize) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      width: (fontSize + MediaQuery.of(context).viewInsets.bottom),
      alignment: Alignment.bottomLeft,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runAlignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            "FLAT",
            style: Theme.of(context).textTheme.headline1?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: fontSize / 3.5,
                ),
          ),
          Text(
            "ON",
            style: Theme.of(context).textTheme.headline1?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: fontSize / 6,
                  fontWeight: FontWeight.w400,
                ),
          ),
          Text(
            "FIRE",
            style: Theme.of(context).textTheme.headline1?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: fontSize / 3.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _tabBar() {
    return const TabBar(
      tabs: [
        Tab(
          text: "Login",
        ),
        Tab(
          text: "Signup",
        ),
      ],
    );
  }

  Widget _tabViews() {
    return Expanded(
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
            label: Text(
              "SIGN IN WITH GOOGLE",
              style: Theme.of(context).elevatedButtonTheme.style?.textStyle?.resolve({})?.copyWith(
                color: Theme.of(context).colorScheme.onTertiary,
              ),
            ),
            onPressed: () => attempt(
              requiresCheck: false,
              attemptCallback: () => context.read<AuthService>().googleSignupLogin(),
            ),
            style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).colorScheme.tertiary)),
            icon: Image.asset(
              googleImage,
              height: (Theme.of(context).textTheme.button?.fontSize ?? 10) + 5,
              fit: BoxFit.fitHeight,
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height / 20,
          ),
        ],
      ),
    );
  }
}
