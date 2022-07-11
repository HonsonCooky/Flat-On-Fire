import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flat_on_fire/_app_bucket.dart';

class UserService {
// ----------------------------------------------------------------------------------------------------------------
// PRIVATE ASSISTANT METHODS
// ----------------------------------------------------------------------------------------------------------------

  /// Get the path to a users PRIVATE information.
  String _userPath(String? uid, String exception) {
    if (uid == null) throw Exception(exception);
    return "users/$uid";
  }

  /// Get the path to a users PUBLIC information
  String _userProfileSubDocPath(String? uid, String exception) {
    return "${_userPath(uid, exception)}/${FirestoreService().profileSubDocPath}";
  }

  static const String userAvatarSubLoc = "users";

  /// Access to the PRIVATE user information
  DocumentReference<UserModel> _userDocument() {
    var path = _userPath(FirebaseAuth.instance.currentUser?.uid, "Unauthorized access to user information");
    var doc = FirestoreService().getDoc(path);
    return doc.withConverter<UserModel>(
      fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
      toFirestore: (settingsModel, _) => settingsModel.toJson(),
    );
  }

  /// Access to the PROFILE user information (given a UID, that user will be found)
  DocumentReference<UserProfileModel> _userProfileDocument(String? uid) {
    var path = _userProfileSubDocPath(
      uid ?? FirebaseAuth.instance.currentUser?.uid,
      "Unauthorized access to user information",
    );
    var doc = FirestoreService().getDoc(path);
    return doc.withConverter<UserProfileModel>(
      fromFirestore: (snapshot, _) => UserProfileModel.fromJson(snapshot.data()!),
      toFirestore: (profileModel, _) => profileModel.toJson(),
    );
  }

  /// Determine if the logged in user, has existing documentation.
  Future<bool> userDocExists() async {
    var path = _userPath(
      FirebaseAuth.instance.currentUser?.uid,
      "Unauthorized access to public user information",
    );
    var doc = await FirebaseFirestore.instance.doc(path).get(const GetOptions(source: Source.server));
    return doc.exists;
  }

  /// Get the UserModel from Firestore
  Future<DocumentSnapshot<UserModel>> getUser() {
    return _userDocument().getCacheFirst();
  }

  /// Get the UserProfileModel from Firestore
  Future<DocumentSnapshot<UserProfileModel>> getUserProfile(String? uid) {
    return _userProfileDocument(uid).getCacheFirst();
  }

  /// Create a new user in the Firestore
  Future<void> createNewUser({
    required UserCredential uc,
    required String name,
    required String themeModeName,
    bool onBoarded = true,
    String? avatarFileUrl,
    String? avatarLocalFilePath,
  }) async {
    try {
      var uid = uc.user!.uid;

      // Upload user picture
      CloudStorageService().setAvatarFile(
        subFolder: UserService.userAvatarSubLoc,
        uid: uid,
        imagePath: avatarLocalFilePath,
        imageUrl: avatarFileUrl,
      );

      // Upload profile
      UserProfileModel userProfileModel = UserProfileModel(name: name, avatarPath: 'fof_avatars/${uc.user?.uid}.jpg');

      // Finally create the user
      UserModel userModel = UserModel(
        uid: uc.user!.uid,
        isAdmin: false,
        themeMode: themeModeName,
        onBoarded: onBoarded,
        profile: userProfileModel,
      );

      // Batch create
      var batch = FirebaseFirestore.instance.batch();
      batch.set<UserModel>(_userDocument(), userModel);
      batch.set<UserProfileModel>(_userProfileDocument(null), userProfileModel);
      await batch.commit();
    } catch (e) {
      // Failed attempt. Remove user from firebase authentication
      await uc.user?.delete();
      rethrow;
    }
  }

  /// Update a user + the user profile in the firestore
  Future<void> updateUser(Map<String, dynamic> update) async {
    String? avatarLocalFilePath = update["profile"]["avatarPath"];
    var uid = FirebaseAuth.instance.currentUser!.uid;

    // Upload user picture
    if (avatarLocalFilePath != null) {
      CloudStorageService().setAvatarFile(
        subFolder: UserService.userAvatarSubLoc,
        uid: uid,
        imagePath: avatarLocalFilePath,
      );
    }

    var batch = FirebaseFirestore.instance.batch();
    Map<String, dynamic> userUpdate = update;
    Map<String, dynamic> profileUpdate = update["profile"] ?? {};
    batch.update(_userDocument(), userUpdate);
    batch.update(_userProfileDocument(null), profileUpdate);
    await batch.commit();
  }

  /// Delete the firebase
  Future<void> deleteUser() async {
    // Delete the profile picture first
    var uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      CloudStorageService().deleteAvatarFile(subFolder: UserService.userAvatarSubLoc, uid: uid);
    } catch (_) {}

    var batch = FirebaseFirestore.instance.batch();
    batch.delete(_userDocument());
    batch.delete(_userProfileDocument(null));
    await batch.commit();
  }
}
