import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  static const String successfulOperation = "Success";
  static const String authErrorBackup = "Encountered an authentication error";
  static const String storeErrorBackup = "Encountered a backend storage error";
  final FirebaseAuth _firebaseAuth;
  final AppService _appService;

  AuthService(this._firebaseAuth, this._appService) {
    _initAuthSettings();
  }

  /// Access the Firebase User object
  User? get user => _firebaseAuth.currentUser;

  Future<void> _initAuthSettings() async {
    try {
      var userDocument = await getUser()!;
      var userSettings = userDocument.data()?.userSettings;
      if (userSettings != null) {
        _appService.batch(
          themeMode: userSettings.themeMode == ThemeMode.light.name ? ThemeMode.light : ThemeMode.dark,
          onBoarded: userSettings.onBoarded,
        );
      }
    } catch (_) {
      // Finally will ensure the UI components react accordingly in all scenarios
    } finally {
      _appService.batch(
        loginState: _firebaseAuth.currentUser != null,
        initialized: true,
        viewState: ViewState.ideal,
      );
    }
  }

  _failedAttempt() {
    _appService.viewState = ViewState.ideal;
  }

  /// Login with email and password
  Future<String> login({
    required String email,
    required String password,
  }) async {
    _appService.viewState = ViewState.busy;
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      await _initAuthSettings();
      return successfulOperation;
    } on FirebaseException catch (e) {
      _failedAttempt();
      return e.message ?? authErrorBackup;
    } catch (_) {
      _failedAttempt();
      return "Authentication Failed";
    }
  }

  /// Signup with email and password
  Future<String> signup({
    required String email,
    required String name,
    required String password,
  }) async {
    _appService.viewState = ViewState.busy;
    try {
      var uc = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await createNewUser(uc: uc, name: name, themeModeName: _appService.themeMode.name);
      await _initAuthSettings();
      return successfulOperation;
    } on FirebaseException catch (e) {
      _failedAttempt();
      return e.message ?? authErrorBackup;
    } catch (_) {
      _failedAttempt();
      return "Signup Failed";
    }
  }

  Future<void> _attemptGoogleSignOut() async {
    try {
      if (await GoogleSignIn().isSignedIn()) {
        await GoogleSignIn().disconnect();
      }
    } catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

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

  /// Login with Google
  Future<String> googleSignupLogin() async {
    _appService.viewState = ViewState.busy;
    await _attemptGoogleSignOut();

    try {
      OAuthCredential credential = await _getGoogleCredentials();

      // Create/Get access to the user credentials inside firebase
      var uc = await _firebaseAuth.signInWithCredential(credential);
      var userInfo = await userDocExists();

      // If this is a new user, then we should try sign them up
      if (uc.additionalUserInfo!.isNewUser || !userInfo) {
        await createNewUser(uc: uc, name: uc.user!.displayName!, themeModeName: _appService.themeMode.name);
      }

      await _initAuthSettings();
      return successfulOperation;
    } on FirebaseException catch (e) {
      _failedAttempt();
      return e.message ?? authErrorBackup;
    } catch (_) {
      _failedAttempt();
      return "Google Authentication Failed";
    } finally {
      await _initAuthSettings();
    }
  }

  Future<String> reauthenticateUser(String email, String password, bool isGoogle) async {
    _appService.viewState = ViewState.busy;
    var user = _firebaseAuth.currentUser;
    if (user == null) return "Unable to retrieve current user";

    try {
      if (!isGoogle) {
        return _reauthenticateEmail(email, password, user);
      } else {
        return _reauthenticateGoogle(user);
      }
    } catch(_){
      _failedAttempt();
      return "Something went wrong. Unable to delete user.";
    }
  }

  Future<String> _reauthenticateEmail(String email, String password, User user) async {
    var cred = EmailAuthProvider.credential(email: email, password: password);
    try {
      await user.reauthenticateWithCredential(cred);
      await _initAuthSettings();
      return successfulOperation;
    } catch (_) {
      return "Invalid user credentials";
    }
  }

  Future<String> _reauthenticateGoogle(User user) async {
    var cred = await _getGoogleCredentials();
    try {
      await user.reauthenticateWithCredential(cred);
      await _initAuthSettings();
      return successfulOperation;
    } catch (_) {
      return "Invalid user credentials";
    }
  }

  Future<String> deleteUser() async {
    _appService.viewState = ViewState.busy;
    try {
      var batch = FirebaseFirestore.instance.batch();
      batch.delete(userDocument());
      batch.delete(userProfileDocument(null));
      await batch.commit();

      await _firebaseAuth.currentUser?.delete();

      await _initAuthSettings();
      return successfulOperation;
    } catch (e, s) {
      _failedAttempt();
      await FirebaseCrashlytics.instance.recordError(e, s);
      return "Something went wrong. Unable to delete user.";
    }
  }

  /// Sign out and (attempt google sign out)
  Future<String> signOut() async {
    _appService.viewState = ViewState.busy;
    await _attemptGoogleSignOut();

    try {
      await _firebaseAuth.signOut();
      await _initAuthSettings();
      return successfulOperation;
    } catch (e, s) {
      _failedAttempt();
      await FirebaseCrashlytics.instance.recordError(e, s);
      return "Something went wrong. Unable to sign-out.";
    }
  }
}
