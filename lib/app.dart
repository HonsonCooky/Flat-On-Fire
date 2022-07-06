import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  late AppService _appService;
  late AuthService _authService;
  
  // Firestore
  late UserService _userService;

  @override
  void initState() {
    _appService = AppService();
    _authService = AuthService(FirebaseAuth.instance, _appService);
    _userService = UserService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppService>(create: (_) => _appService),
        ChangeNotifierProvider<AuthService>(create: (_) => _authService),
        Provider<AppRouter>(create: (_) => AppRouter(appService: _appService)),
        // Firestore
        Provider<UserService>(create: (_) => _userService),
      ],
      child: Builder(
        builder: (context) {
          var themeMode = Provider.of<AppService>(context, listen: true).themeMode;
          final GoRouter goRouter = Provider.of<AppRouter>(context, listen: false).router;
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeModel.light,
            darkTheme: ThemeModel.dark,
            themeMode: themeMode,
            routeInformationProvider: goRouter.routeInformationProvider,
            routeInformationParser: goRouter.routeInformationParser,
            routerDelegate: goRouter.routerDelegate,
          );
        },
      ),
    );
  }
}

// ----------------------------------------------------------------------------------------------------------------
// APP EXTENSIONS
// ----------------------------------------------------------------------------------------------------------------


extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
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