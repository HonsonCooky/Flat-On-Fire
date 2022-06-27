import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

const loggedInText = 'Logged In';
const signedUpText = 'Signed Up';
const signedOutText = 'Signed Out';

/// A change notifier that maintains state, and state manipulations about the user.
class AuthProvider extends ChangeNotifier {
  User? _user;
  final FirebaseAuth _firebaseAuth;
  final String authErrorBackup = "Encountered an authentication error";
  final String storeErrorBackup = "Encountered a backend storage error";
  final String unknownError = "Encountered an unknown error. Try again?";

  AuthProvider(this._firebaseAuth) {
    _user = _firebaseAuth.currentUser;
  }

  /// Access the Firebase User object
  User? get user => _user;
  
  /// Access to the firebase auth state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Access to the PRIVATE user information
  DocumentReference userInfo(String uid) => FirebaseFirestore.instance.doc("$userCollectionName/$uid");

  /// Access to the PUBLIC user information
  DocumentReference profileInfo(String uid) => FirebaseFirestore.instance.doc("$profileCollectionName/$uid");

  /// Update the user state, and notify listeners
  _setUser(UserCredential uc) {
    _user = uc.user;
    notifyListeners();
  }

  /// Update the user state, and CREATE the PRIVATE and PUBLIC user information in the Firestore
  _setNewUser({required UserCredential uc, required String name}) async {
    String uid = uc.user!.uid;
    ProfileModel profileModel = ProfileModel(name);
    UserModel userModel = UserModel(uid, false, profileModel);
    var batch = FirebaseFirestore.instance.batch();
    batch.set(userInfo(uid), userModel.toJson());
    batch.set(profileInfo(uid), profileModel.toJson());
    await batch.commit();
    _setUser(uc);
  }

  /// Login with email and password
  Future<String> login({required String email, required String password}) async {
    try {
      var uc = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      _setUser(uc);
      return loggedInText;
    } on FirebaseAuthException catch (e) {
      return e.message ?? authErrorBackup;
    } catch (_) {
      return unknownError;
    }
  }

  /// Signup with email and password
  Future<String> signup({required String email, required String name, required String password}) async {
    try {
      var uc = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await _setNewUser(uc: uc, name: name);
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

  /// Handles google authentication (signup and login) actions
  /// [shouldExist] determines if the user should already exist (login) or not (signup).
  Future<UserCredential> _googleAccountSelection(bool shouldExist) async {
    try {
      if (await GoogleSignIn().isSignedIn()) {
        await GoogleSignIn().disconnect();
      }
    } catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(e, s);
    }
    
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    
    var uc = await _firebaseAuth.signInWithCredential(credential);
    
    // If the user should exist (login) and the uc indicates this is a new user, throw an error (deleting the account)
    if (shouldExist && uc.additionalUserInfo!.isNewUser) {
      await _firebaseAuth.currentUser!.delete();
      throw FirebaseAuthException(
          code: 'No User', message: 'You have not registered up with your Google account. Try "Signup".');
    }
    // If the user should NOT exist (signup) and the uc indicates this is an existing user, throw an error (deleting 
    // the account)
    else if (!shouldExist && uc.additionalUserInfo!.isNewUser){
      await _firebaseAuth.currentUser!.delete();
      throw FirebaseAuthException(
          code: 'No User', message: 'You have not registered up with your Google account. Try "Signup".');
      
    }
    
    // Everything went well, we are good to go.
    return uc;
  }

  /// Login with Google
  Future<String> loginWithGoogle() async {
    try {
      var uc = await _googleAccountSelection(true);
      _setUser(uc);
      return loggedInText;
    } on FirebaseAuthException catch (e) {
      return e.message ?? authErrorBackup;
    } catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(e, s);
      return unknownError;
    }
  }

  /// Signup with Google
  Future<String> signupWithGoogle({required String name}) async {
    try {
      var uc = await _googleAccountSelection(true);
      await _setNewUser(uc: uc, name: uc.user!.displayName!);
      return signedUpText;
    } on FirebaseAuthException catch (e) {
      return e.message ?? authErrorBackup;
    } on FirebaseException catch (e) {
      await _firebaseAuth.currentUser!.delete();
      return e.message ?? storeErrorBackup;
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
      return unknownError;
    }
  }

  /// Sign out and (attempt google sign out)
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
