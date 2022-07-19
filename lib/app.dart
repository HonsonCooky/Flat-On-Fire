import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  late AppService _appService;
  late AuthService _authService;
  late UserCredService _userCredService;
  final GlobalKey<NavigatorState> _navigator = GlobalKey<NavigatorState>();

  @override
  void initState() {
    _appService = AppService();
    _authService = AuthService(_appService);
    _userCredService = UserCredService();

    _appService.addListener(() => _loginListener());
    super.initState();
  }

  @override
  void dispose() {
    _authService.dispose();
    _appService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppService>(create: (_) => _appService),
        ChangeNotifierProvider<AuthService>(create: (_) => _authService),
        ChangeNotifierProvider<UserCredService>(create: (_) => _userCredService),
      ],
      child: Builder(
        builder: (context) {
          var themeMode = Provider.of<AppService>(context, listen: true).themeMode;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeModel.light,
            darkTheme: ThemeModel.dark,
            themeMode: themeMode,
            initialRoute: AppPageEnum.splash.toName,
            routes: appRouter,
            navigatorKey: _navigator,
            scaffoldMessengerKey: ToastManager.instance.rootScaffoldMessengerKey,
          );
        },
      ),
    );
  }

  void _loginListener() {
    if (_navigator.currentContext == null) return;

    if (_appService.loginState) {
      _navigator.currentState!.popAndPushNamed(AppPageEnum.home.toName);
    } else if (!_appService.loginState) {
      _navigator.currentState!.popAndPushNamed(AppPageEnum.auth.toName);
    }
  }
}

// ----------------------------------------------------------------------------------------------------------------
// APP EXTENSIONS
// ----------------------------------------------------------------------------------------------------------------

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
  
  String title(){
    return split(" ").map((e) => e.capitalize()).toList().join(" ");
  }

  String initials() => isNotEmpty ? trim().split(' ').map((l) => l[0]).take(2).join() : '';
}

extension FirestoreDocumentExtension<T> on DocumentReference<T> {
  Future<DocumentSnapshot<T>> getCacheFirst() async {
    try {
      var ds = await get(const GetOptions(source: Source.cache));
      if (ds.exists) return ds;
      return get(const GetOptions(source: Source.server));
    } catch (_) {
      return get();
    }
  }
}

extension FirestoreQueryExtension<T> on Query<T> {
  Future<QuerySnapshot<T>> getCacheFirst() async {
    try {
      var qs = await get(const GetOptions(source: Source.cache));
      if (qs.docs.isNotEmpty) return qs;
      return get(const GetOptions(source: Source.server));
    } catch (_) {
      return get();
    }
  }
}
