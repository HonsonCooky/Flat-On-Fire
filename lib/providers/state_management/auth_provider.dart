import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

const loggedIn = 'Logged In';
const signedUp = 'Signed Up';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth;

  AuthProvider(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String?> login({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return loggedIn;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (_) {
      return "Encountered an unknown error. Try again?";
    }
  }

  Future<String?> signup({required String email, required String name, required String password}) async {
    try {
      var uc = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance.collection('users').doc("${uc.user?.uid}/public/doc").set({'name': name});
      return signedUp;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } on FirebaseException catch (e) {
      await _firebaseAuth.currentUser!.delete();
      return e.message;
    } catch (_) {
      return "Encountered an unknown error. Try again?";
    }
  }

  Future<String?> loginWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
      return loggedIn;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (_) {
      return "Encountered an unknown error. Try again?";
    }
  }

  Future<String?> signupWithGoogle({required String name}) async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      var uc = await _firebaseAuth.signInWithCredential(credential);
      await FirebaseFirestore.instance.collection('users').doc("${uc.user?.uid}/public/doc").set({'name': name});
      return signedUp;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } on FirebaseException catch (e) {
      await _firebaseAuth.currentUser!.delete();
      return e.message;
    } catch (_) {
      return "Encountered an unknown error. Try again?";
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
