import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flat_on_fire/models/user_settings_model.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth;
  final AppService _appService;
  final String authErrorBackup = "Encountered an authentication error";
  final String storeErrorBackup = "Encountered a backend storage error";

  AuthService(this._firebaseAuth, this._appService) {
    _appService.loginState = _firebaseAuth.currentUser != null;
  }

  /// Access the Firebase User object
  User? get user => _firebaseAuth.currentUser;

  void setLoginState() {
    _appService.loginState = _firebaseAuth.currentUser != null;
  }

  void errorToastExecutor({final void Function(String str)? errorToast, required String str}) {
    if (errorToast != null) {
      errorToast(str);
    }
  }

  /// Access to the PRIVATE user information
  DocumentReference userInfo() {
    if (_firebaseAuth.currentUser == null) {
      throw Exception("No user to extract information from");
    }
    return FirebaseFirestore.instance.doc("$userCollectionName/${_firebaseAuth.currentUser!.uid}");
  }

  /// Access to the PUBLIC user information
  DocumentReference profileInfo() {
    if (_firebaseAuth.currentUser == null) {
      throw Exception("No user to extract information from");
    }
    return FirebaseFirestore.instance.doc("$profileCollectionName/${_firebaseAuth.currentUser!.uid}");
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
      batch.set(userInfo(), userModel.toJson());
      batch.set(profileInfo(), profileModel.toJson());
      await batch.commit();
    } catch (_){
      // Failed attempt. Remove user from firebase authentication
      await uc.user?.delete();
    }
  }

  /// Login with email and password
  Future<void> login({
    required String email,
    required String password,
    final void Function(String str)? errorToast,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      setLoginState();
    } on FirebaseException catch (e) {
      errorToastExecutor(errorToast: errorToast, str: e.message ?? authErrorBackup);
    } catch (_) {
      errorToastExecutor(errorToast: errorToast, str: "Authentication Failed");
    }
  }

  /// Signup with email and password
  Future<void> signup({
    required String email,
    required String name,
    required String password,
    final void Function(String str)? errorToast,
  }) async {
    try {
      var uc = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await _createNewUser(uc: uc, name: name);
      setLoginState();
    } on FirebaseException catch (e) {
      errorToastExecutor(errorToast: errorToast, str: e.message ?? authErrorBackup);
    } catch (_) {
      errorToastExecutor(errorToast: errorToast, str: "Signup Failed");
    }
  }

  /// Login with Google
  Future<void> googleSignupLogin({final void Function(String str)? errorToast}) async {
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
        _createNewUser(uc: uc, name: uc.user!.displayName!);
      }
      
      setLoginState();
    } on FirebaseException catch (e) {
      if (errorToast != null) errorToast(e.message ?? authErrorBackup);
    } catch (_) {
      if (errorToast != null) errorToast("Google Authentication Failed");
    }
  }

  /// Sign out and (attempt google sign out)
  Future<void> signOut({required final void Function(String str) errorToast}) async {
    try {
      if (await GoogleSignIn().isSignedIn()) {
        await GoogleSignIn().disconnect();
      }
    } catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(e, s);
    }

    try {
      await _firebaseAuth.signOut();
      setLoginState();
    } catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(e, s);
      errorToast("Something went wrong. Unable to sign-out.");
    }
  }
}
