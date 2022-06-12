import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'view_model.dart';

enum AuthState { signIn, signUp }

class AuthModel extends ViewModel {
  late AuthState _authState;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  /// -----------------------------------------------------------------------------------------------------
  /// Authentication Methods
  /// -----------------------------------------------------------------------------------------------------
  AuthState get authState => _authState;

  User? get user => firebaseAuth.currentUser;

  setAuthState(AuthState authState) {
    _authState = authState;
    notifyListeners();
  }

  createNewUser(String email, String password) async {
    setViewState(ViewState.busy);
    await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    setViewState(ViewState.ideal);
  }

  signIn(String email, String password) async {
    setViewState(ViewState.busy);
    await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    setViewState(ViewState.ideal);
  }

  signInWithGoogle() async {
    setViewState(ViewState.busy);
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    await firebaseAuth.signInWithCredential(credential);
    setViewState(ViewState.ideal);
  }

  bool signedIn() {
    return user != null;
  }

  logOut() async {
    setViewState(ViewState.busy);
    await firebaseAuth.signOut();
    setViewState(ViewState.ideal);
  }

  /// -----------------------------------------------------------------------------------------------------
  /// State Management Methods
  /// -----------------------------------------------------------------------------------------------------
  switchAuthenticationState() {
    authState == AuthState.signIn ? setAuthState(AuthState.signUp) : setAuthState(AuthState.signIn);
    notifyListeners();
  }

  runAuthenticationMethod(TextEditingController emailController, TextEditingController passwordController) {
    authState == AuthState.signIn
        ? signIn(emailController.text, passwordController.text)
        : createNewUser(emailController.text, passwordController.text);
    notifyListeners();
  }

  switchAuthenticationText(AuthModel authModel) {
    return authModel.authState == AuthState.signIn ? "Sign In" : "Sign Up";
  }

  switchAuthenticationOption(AuthModel authModel) {
    return authModel.authState == AuthState.signIn ? "Create account" : "Already registered";
  }
}
