import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flat_on_fire/_app.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

const loggedInText = 'Logged In';
const signedUpText = 'Signed Up';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth;
  User? _user;
  final String authErrorBackup = "Encountered an authentication error";
  final String storeErrorBackup = "Encountered a backend storage error";
  final String unknownError = "Encountered an unknown error. Try again?";

  AuthProvider(this._firebaseAuth);

  User? get user => _user;

  DocumentReference _publicUserInfo(String uid) => FirebaseFirestore.instance.doc("publicUserInfo/$uid");

  DocumentReference _privateUserInfo(String uid) => FirebaseFirestore.instance.doc("privateUserInfo/$uid");

  onLogin(UserCredential uc) {
    _user = uc.user;
    notifyListeners();
  }

  onCreate({required UserCredential uc, required String name}) async {
    String uid = uc.user!.uid;
    await _publicUserInfo(uid).set({
      "display": {
        "name": name,
      }
    });
    await _privateUserInfo(uid).set({
      "isAdmin": true,
    });
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
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      var uc = await _firebaseAuth.signInWithCredential(credential);
      if (!(await checkIfDocExists("privateUserInfo/${uc.user!.uid}"))) {
        throw FirebaseAuthException(
            code: 'No User',
            message: 'Google user has not created account with Flat On Fire. Signup with Google account.');
      }
      onLogin(uc);
      return loggedInText;
    } on FirebaseAuthException catch (e) {
      return e.message ?? authErrorBackup;
    } catch (_) {
      return unknownError;
    }
  }

  Future<String> signupWithGoogle({required String name}) async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      var uc = await _firebaseAuth.signInWithCredential(credential);
      await onCreate(uc: uc, name: name);
      return signedUpText;
    } on FirebaseAuthException catch (e) {
      return e.message ?? authErrorBackup;
    } on FirebaseException catch (e) {
      await _firebaseAuth.currentUser!.delete();
      return e.message ?? storeErrorBackup;
    } catch (_) {
      return unknownError;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    _user = null;
    notifyListeners();
  }
}
