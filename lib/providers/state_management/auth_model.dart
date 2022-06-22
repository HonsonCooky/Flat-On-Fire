import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthState { signIn, signUp }

class AuthModel extends ChangeNotifier {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  /// -----------------------------------------------------------------------------------------------------
  /// Authentication Methods
  /// -----------------------------------------------------------------------------------------------------
  User? get user => firebaseAuth.currentUser;

  createNewUser(String email, String name, String password) async {
    UserCredential uc = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    await FirebaseFirestore.instance.collection('users-public').doc("${uc.user?.uid}").set({
      'name': name,
    });
  }

  signIn(String email, String password) async {
    await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    await firebaseAuth.signInWithCredential(credential);
  }

  bool signedIn() {
    return user != null;
  }

  logOut() async {
    await firebaseAuth.signOut();
    notifyListeners();
  }
}
