import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// A change notifier used for authentication based functionality
class AuthService extends ChangeNotifier {
  // ----------------------------------------------------------------------------------------------------------------
  // CONSTANTS
  // ----------------------------------------------------------------------------------------------------------------
  static const String successfulOperation = "Success";
  static const String authErrorBackup = "Encountered an authentication error";
  static const String storeErrorBackup = "Encountered a backend storage error";
  final AppService _appService;

  User? get user => FirebaseAuth.instance.currentUser;

  // ----------------------------------------------------------------------------------------------------------------
  // CONSTRUCTION
  // ----------------------------------------------------------------------------------------------------------------

  AuthService(this._appService) {
    establishSettings();
  }

  // ----------------------------------------------------------------------------------------------------------------
  // PRIVATE HELPER METHODS
  // ----------------------------------------------------------------------------------------------------------------

  /// Establish the baseline settings given the current environment
  Future<void> establishSettings() async {
    bool failed = true;
    try {
      // Attempt to setup app settings based on the user
      var userDocument = await FirestoreService().userService.getUser();
      if (userDocument != null) {
        var user = userDocument.data();
        if (user != null) {
          _appService.batch(
            themeMode: user.themeMode == ThemeMode.light.name ? ThemeMode.light : ThemeMode.dark,
            onBoarded: user.onBoarded,
          );
          failed = false;
        }
      }
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
    } finally {
      // Finally will ensure the UI components react accordingly in all scenarios
      _appService.batch(
        loginState: FirebaseAuth.instance.currentUser != null && !failed,
        initialized: true,
        viewState: ViewState.ideal,
        themeMode: failed ? ThemeMode.light : null,
      );
    }
  }

  /// On a failed attempt, recover using this method
  void _failedAttempt() {
    // Reset application state to ideal (remove loading components)
    _appService.viewState = ViewState.ideal;
  }

  /// Attempt a google sign-out (which ensures the user has an option of which account to sign-in with)
  Future<void> _attemptGoogleSignOut() async {
    try {
      if (await GoogleSignIn().isSignedIn()) {
        await GoogleSignIn().disconnect();
      }
    } catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  /// Get the google authentication credentials
  Future<OAuthCredential> _getGoogleCredentials() async {
    // Trigger Authentication Flow
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    // Create a credential from auth request
    return GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
  }

  /// Reauthentication via email and password
  Future<String> _reauthenticateEmail(String email, String password, User user) async {
    var cred = EmailAuthProvider.credential(email: email, password: password);
    try {
      await user.reauthenticateWithCredential(cred);
      await establishSettings();
      return successfulOperation;
    } catch (_) {
      return "Invalid user credentials";
    }
  }

  /// Reauthentication via google
  Future<String> _reauthenticateGoogle(User user) async {
    var cred = await _getGoogleCredentials();
    try {
      await user.reauthenticateWithCredential(cred);
      await establishSettings();
      return successfulOperation;
    } catch (_) {
      return "Invalid user credentials";
    }
  }

  // ----------------------------------------------------------------------------------------------------------------
  // INTERFACE METHODS
  // ----------------------------------------------------------------------------------------------------------------

  /// Login with email and password
  Future<String> login({
    required String email,
    required String password,
  }) async {
    if (!(await AppService.networkConnected())) {
      return "No internet connection. Unable to authenticate without a network connection.";
    }
    _appService.viewState = ViewState.busy;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      if (!await FirestoreService().userService.userDocExists()) {
        await FirebaseAuth.instance.currentUser?.delete();
        throw FirebaseException(
          message: "Unable to find user information. Signup again?",
          plugin: 'FOF',
        );
      }
      return successfulOperation;
    } on FirebaseException catch (e) {
      _failedAttempt();
      return e.message ?? authErrorBackup;
    } catch (_) {
      _failedAttempt();
      return "Authentication Failed";
    } finally {
      await establishSettings();
    }
  }

  /// Signup with email and password
  Future<String> signup({
    required String email,
    required String name,
    required String password,
    String? avatarLocalFilePath,
  }) async {
    if (!(await AppService.networkConnected())) {
      return "No internet connection. Unable to authenticate without a network connection.";
    }
    _appService.viewState = ViewState.busy;
    try {
      var uc = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      await FirestoreService().userService.createNewUser(
            uc: uc,
            name: name,
            themeModeName: _appService.themeMode.name,
            avatarLocalFilePath: avatarLocalFilePath,
          );
      return successfulOperation;
    } on FirebaseException catch (e) {
      _failedAttempt();
      return e.message ?? authErrorBackup;
    } catch (e) {
      _failedAttempt();
      return "Signup Failed";
    } finally {
      await establishSettings();
    }
  }

  /// Login with Google
  Future<String> googleSignupLogin() async {
    if (!(await AppService.networkConnected())) {
      return "No internet connection. Unable to authenticate without a network connection.";
    }
    _appService.viewState = ViewState.busy;
    await _attemptGoogleSignOut();

    try {
      OAuthCredential credential = await _getGoogleCredentials();

      // Create/Get access to the user credentials inside firebase
      var uc = await FirebaseAuth.instance.signInWithCredential(credential);
      var existingUser = !uc.additionalUserInfo!.isNewUser && await FirestoreService().userService.userDocExists();

      if (!existingUser) {
        var name = uc.user!.displayName!;
        var themeModeName = _appService.themeMode.name;
        await FirestoreService().userService.createNewUser(
              uc: uc,
              name: name,
              themeModeName: themeModeName,
              avatarFileUrl: uc.user?.photoURL,
            );
      }

      return successfulOperation;
    } on FirebaseException catch (e) {
      _failedAttempt();
      return e.message ?? authErrorBackup;
    } catch (e) {
      _failedAttempt();
      return "Google Authentication Failed";
    } finally {
      await establishSettings();
    }
  }

  /// Sign out and (attempt google sign out)
  Future<String> signOut() async {
    _appService.viewState = ViewState.busy;
    await _attemptGoogleSignOut();

    try {
      await FirebaseAuth.instance.signOut();
      await establishSettings();
      return successfulOperation;
    } catch (e, s) {
      _failedAttempt();
      await FirebaseCrashlytics.instance.recordError(e, s);
      return "Something went wrong. Unable to sign-out.";
    }
  }

  /// A special login function which doesn't attempt a new login, but rather, the authentication of the current user.
  Future<String> reauthenticateUser(String email, String password, bool isGoogle) async {
    if (!(await AppService.networkConnected())) {
      return "No internet connection. Unable to authenticate without a network connection.";
    }
    _appService.viewState = ViewState.busy;
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) return "Unable to retrieve current user";

    try {
      if (!isGoogle) {
        return _reauthenticateEmail(email, password, user);
      } else {
        return _reauthenticateGoogle(user);
      }
    } catch (_) {
      _failedAttempt();
      return "Something went wrong. Unable to delete user.";
    }
  }

  /// Delete the users account
  Future<String> deleteAccount() async {
    if (!(await AppService.networkConnected())) {
      return "No internet connection. Unable to authenticate without a network connection.";
    }
    _appService.viewState = ViewState.busy;
    try {
      await FirestoreService().userService.deleteUser();
      await FirebaseAuth.instance.currentUser?.delete();

      await establishSettings();
      return successfulOperation;
    } catch (e, s) {
      _failedAttempt();
      await FirebaseCrashlytics.instance.recordError(e, s);
      return "Unable to delete user.\n$e";
    }
  }
}
