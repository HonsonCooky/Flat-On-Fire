import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flat_on_fire/_app.dart';
import 'package:flat_on_fire/domain/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

const loggedInText = 'Logged In';
const signedUpText = 'Signed Up';
const signedOutText = 'Signed Out';

class AuthProvider extends ChangeNotifier {
  User? _user;
  final FirebaseAuth _firebaseAuth;
  final String authErrorBackup = "Encountered an authentication error";
  final String storeErrorBackup = "Encountered a backend storage error";
  final String unknownError = "Encountered an unknown error. Try again?";

  AuthProvider(this._firebaseAuth) {
    _user = _firebaseAuth.currentUser;
  }

  User? get user => _user;

  DocumentReference userInfo(String uid) => FirebaseFirestore.instance.doc("$userCollectionName/$uid");

  DocumentReference profileInfo(String uid) => FirebaseFirestore.instance.doc("$profileCollectionName/$uid");

  onLogin(UserCredential uc) {
    _user = uc.user;
    notifyListeners();
  }

  onCreate({required UserCredential uc, required String name}) async {
    String uid = uc.user!.uid;
    ProfileModel profileModel = ProfileModel(name);
    UserModel userModel = UserModel(uid, false, profileModel);
    var batch = FirebaseFirestore.instance.batch();
    batch.set(userInfo(uid), userModel.toJson());
    batch.set(profileInfo(uid), profileModel.toJson());
    await batch.commit();
    _user = uc.user;
    notifyListeners();
  }

  Future<String> login({required String email, required String password}) async {
    try {
      var uc = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      onLogin(uc);
      return loggedInText;
    } on FirebaseAuthException catch (e) {
      return e.message ?? authErrorBackup;
    } catch (_) {
      return unknownError;
    }
  }

  Future<String> signup({required String email, required String name, required String password}) async {
    try {
      var uc = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await onCreate(uc: uc, name: name);
      return signedUpText;
    } on FirebaseAuthException catch (e) {
      return e.message ?? authErrorBackup;
    } on FirebaseException catch (e) {
      await _firebaseAuth.currentUser!.delete();
      return e.message ?? storeErrorBackup;
    } catch (_) {
      await _firebaseAuth.currentUser!.delete();
      return unknownError;
    }
  }

  Future<String> loginWithGoogle() async {
    try {
      if (await GoogleSignIn().isSignedIn()) {
        await GoogleSignIn().disconnect();
      }
    } catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(e, s);
    }

    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      var uc = await _firebaseAuth.signInWithCredential(credential);
      if (uc.additionalUserInfo!.isNewUser) {
        throw FirebaseAuthException(
            code: 'No User', message: 'You have not registered up with your Google account. Try "Signup".');
      }
      onLogin(uc);
      return loggedInText;
    } on FirebaseAuthException catch (e) {
      // Delete account if it has not been signed up first
      await _firebaseAuth.currentUser!.delete();
      return e.message ?? authErrorBackup;
    } catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(e, s);
      return unknownError;
    }
  }

  Future<String> signupWithGoogle({required String name}) async {
    try {
      if (await GoogleSignIn().isSignedIn()) {
        await GoogleSignIn().disconnect();
      }
    } catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(e, s);
    }
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      var uc = await _firebaseAuth.signInWithCredential(credential);
      if (!uc.additionalUserInfo!.isNewUser) {
        throw FirebaseAuthException(
            code: 'Existing User',
            message: 'Google user has already created account with Flat On Fire. Login with Google account.');
      }
      await onCreate(uc: uc, name: uc.user!.displayName!);
      return signedUpText;
    } on FirebaseAuthException catch (e) {
      await _firebaseAuth.currentUser!.delete();
      return e.message ?? authErrorBackup;
    } on FirebaseException catch (e) {
      await _firebaseAuth.currentUser!.delete();
      return e.message ?? storeErrorBackup;
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
      return unknownError;
    }
  }

  Future<String> signOut() async {
    try {
      if (await GoogleSignIn().isSignedIn()) {
        await GoogleSignIn().disconnect();
      }
    } catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(e, s);
    }

    try {
      await _firebaseAuth.signOut();
      _user = null;
      notifyListeners();
      return signedOutText;
    } catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(e, s);
      return "Something went wrong. Unable to sign-out.";
    }
  }
}
