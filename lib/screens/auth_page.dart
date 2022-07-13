import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with ToastMixin {
  final ScrollController _loginScroll = ScrollController();
  final ScrollController _signupScroll = ScrollController();

  final _email = TextEditingController();
  final _password = TextEditingController();
  String? emailErrMsg, passwordErrMsg;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool _emailPasswordCheck() {
    setState(() {
      emailErrMsg = _email.text.isEmpty ? "No Email Provided" : null;
      passwordErrMsg = _password.text.isEmpty ? "No Password Provided" : null;
    });
    return emailErrMsg == null && passwordErrMsg == null;
  }

  void _resetErrors() {
    setState(() {
      emailErrMsg = null;
      passwordErrMsg = null;
    });
  }

  void _attemptAuthAction({
    required Future<String> Function() authActionCallback,
    bool requiresCheck = true,
    bool Function()? optionalCheck,
  }) async {
    // Don't bother checking the backend if the information is known to be wrong.
    bool checkPass = true;
    if (requiresCheck) {
      checkPass &= _emailPasswordCheck();
      // Some screens have more than email and password, so execute their other checks
      if (optionalCheck != null) {
        checkPass &= optionalCheck();
      }
    }

    if (!checkPass) {
      errorToast("Invalid user credentials", context);
      return;
    }

    var res = await authActionCallback();
    if (mounted && res != AuthService.successfulOperation) {
      errorToast(res, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewState = context.watch<AppService>().viewState;
    return WrapperFocusShift(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Column(
            children: [
              _header(),
              viewState == ViewState.busy ? Expanded(child: _loading(context)) : _tabViews(),
              viewState == ViewState.busy ? const SizedBox() : _googleSignIn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loading(BuildContext context) {
    return LoadingSpinnerWidget(MediaQuery.of(context).size.width / 4);
  }

  /// An expanded container, with the Logo and Title stacked inside.
  Widget _header() {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: WrapperOverflowRemoved(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom == 0 ? 20 : 0,
              ),
              Stack(
                children: [
                  _headerLogo(),
                  _headerText(),
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
  Widget _headerLogo() {
    double fontSize = MediaQuery.of(context).size.height / 3;
    return FofLogoWidget(
      color: Theme.of(context).colorScheme.background,
      size: fontSize,
      offset: Offset(MediaQuery.of(context).size.width - fontSize, 0),
    );
  }

  /// A padded column that represents the title of the application.
  Widget _headerText() {
    double fontSize = (MediaQuery.of(context).size.width / 5) - MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "FLAT",
            style: Theme.of(context).textTheme.headline1?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: fontSize,
                ),
          ),
          Text(
            "ON",
            style: Theme.of(context).textTheme.headline1?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: fontSize / 2,
                  fontWeight: FontWeight.w400,
                ),
          ),
          Text(
            "FIRE",
            style: Theme.of(context).textTheme.headline1?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: fontSize,
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
          text: "LOGIN",
        ),
        Tab(
          text: "SIGNUP",
        ),
      ],
    );
  }

  Widget _tabViews() {
    return Expanded(
      child: WrapperOverflowRemoved(
        child: TabBarView(
          children: [
            RawScrollbar(
              thumbColor: PaletteAssistant.alpha(Theme.of(context).colorScheme.secondary),
              thickness: 5,
              thumbVisibility: true,
              radius: const Radius.circular(2),
              controller: _loginScroll,
              child: WrapperPadding(
                child: LoginTabWidget(
                  scrollController: _loginScroll,
                  email: _email,
                  password: _password,
                  emailErrMsg: emailErrMsg,
                  passwordErrMsg: passwordErrMsg,
                  resetErrors: _resetErrors,
                  attemptAuthCallback: _attemptAuthAction,
                ),
              ),
            ),
            RawScrollbar(
              thumbColor: PaletteAssistant.alpha(Theme.of(context).colorScheme.secondary),
              thickness: 5,
              thumbVisibility: true,
              radius: const Radius.circular(2),
              controller: _signupScroll,
              child: WrapperPadding(
                child: SignupTabWidget(
                  scrollController: _signupScroll,
                  email: _email,
                  password: _password,
                  emailErrMsg: emailErrMsg,
                  passwordErrMsg: passwordErrMsg,
                  resetErrors: _resetErrors,
                  attemptAuthCallback: _attemptAuthAction,
                ),
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
            onPressed: () => _attemptAuthAction(
              requiresCheck: false,
              authActionCallback: () => context.read<AuthService>().googleSignupLogin(),
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
