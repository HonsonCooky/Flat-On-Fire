import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flat_on_fire/main.dart';
import 'package:flat_on_fire/models/user_settings_model.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth;
  final AppService _appService;
  static const String successfulOperation = "Success";
  static const String authErrorBackup = "Encountered an authentication error";
  static const String storeErrorBackup = "Encountered a backend storage error";

  AuthService(this._firebaseAuth, this._appService) {
    _initAuthSettings();
  }

  /// Access the Firebase User object
  User? get user => _firebaseAuth.currentUser;

  /// Access to the PRIVATE user information
  DocumentReference<UserModel> userInfo() {
    if (_firebaseAuth.currentUser == null) {
      throw Exception("No user to extract information from");
    }
    return FirebaseFirestore.instance
        .doc("$userCollectionName/${_firebaseAuth.currentUser!.uid}")
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
          toFirestore: (userModel, _) => userModel.toJson(),
        );
  }

  /// Access to the PUBLIC user information
  DocumentReference<ProfileModel> profileInfo(String? uid) {
    if (uid == null && _firebaseAuth.currentUser == null) {
      throw Exception("No user to extract information from");
    }
    return FirebaseFirestore.instance
        .doc("$profileCollectionName/${uid ?? _firebaseAuth.currentUser!.uid}")
        .withConverter<ProfileModel>(
          fromFirestore: (snapshot, _) => ProfileModel.fromJson(snapshot.data()!),
          toFirestore: (profileModel, _) => profileModel.toJson(),
        );
  }

  Future<void> _initAuthSettings() async {
    try {
      var userDocument = await userInfo().getCacheFirst();
      var userSettings = userDocument.data()?.userSettings;
      if (userSettings != null) {
        _appService.batch(
          themeMode: userSettings.themeMode == ThemeMode.light.name ? ThemeMode.light : ThemeMode.dark,
          onBoarded: userSettings.onBoarded,
        );
      }
    } catch (_) {
      _appService.reset();
    } finally {
      _appService.batch(
        loginState: _firebaseAuth.currentUser != null,
        initialized: true,
        viewState: ViewState.ideal,
      );
    }
  }

  /// Update the user state, and CREATE the PRIVATE and PUBLIC user information in the Firestore
  _createNewUser({required UserCredential uc, required String name, bool onBoarded = true}) async {
    try {
      ProfileModel profileModel = ProfileModel(name: name);
      UserModel userModel = UserModel(
        uid: uc.user?.uid,
        isAdmin: false,
        profile: profileModel,
        userSettings: UserSettingsModel(_appService.themeMode.name, onBoarded),
      );

      // Batch create
      var batch = FirebaseFirestore.instance.batch();
      batch.set<UserModel>(userInfo(), userModel);
      batch.set<ProfileModel>(profileInfo(null), profileModel);
      await batch.commit();
    } catch (e) {
      // Failed attempt. Remove user from firebase authentication
      await uc.user?.delete();
      rethrow;
    }
  }

  _failedAttempt(){
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
      await _createNewUser(uc: uc, name: name);
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

  /// Login with Google
  Future<String> googleSignupLogin() async {
    _appService.viewState = ViewState.busy;
    await _attemptGoogleSignOut();

    try {
      // Trigger Authentication Flow
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // Obtain the auth details
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      // Create a credential from auth request
      OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Create/Get access to the user credentials inside firebase
      var uc = await _firebaseAuth.signInWithCredential(credential);

      // If this is a new user, then we should try sign them up
      if (uc.additionalUserInfo!.isNewUser) {
        await _createNewUser(uc: uc, name: uc.user!.displayName!);
      }

      await _initAuthSettings();
      return successfulOperation;
    } on FirebaseException catch (e) {
      _failedAttempt();
      return e.message ?? authErrorBackup;
    } catch (_) {
      _failedAttempt();
      return "Google Authentication Failed";
    }
  }

  /// Sign out and (attempt google sign out)
  Future<void> signOut({required final void Function(String str) errorToast}) async {
    _appService.viewState = ViewState.busy;
    await _attemptGoogleSignOut();

    try {
      await _firebaseAuth.signOut();
      await _initAuthSettings();
    } catch (e, s) {
      _failedAttempt();
      await FirebaseCrashlytics.instance.recordError(e, s);
      errorToast("Something went wrong. Unable to sign-out.");
    }
  }
}
