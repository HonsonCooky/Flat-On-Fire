import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flat_on_fire/_app_bucket.dart';

class UserService {
// ----------------------------------------------------------------------------------------------------------------
// CONSTANT VALUES
// ----------------------------------------------------------------------------------------------------------------

  final userCollectionName = "users";
  final userProfileCollectionName = "user_profiles";

// ----------------------------------------------------------------------------------------------------------------
// PRIVATE ASSISTANT METHODS
// ----------------------------------------------------------------------------------------------------------------

  /// Get the path to a users PRIVATE information.
  String _userPath(String? uid, String exception) {
    if (uid == null) throw Exception(exception);
    return "$userCollectionName/$uid";
  }

  /// Get the path to a users PUBLIC information
  String _userProfilePath(String? uid, String exception) {
    if (uid == null) throw Exception(exception);
    return "$userProfileCollectionName/$uid";
  }

  /// Access to the PRIVATE user information

  DocumentReference<UserModel> _userModelDocument() {
    var doc = FirestoreService.getDoc(_userPath(
      FirebaseAuth.instance.currentUser?.uid,
      "Unauthorized access to user information",
    ));
    return doc.withConverter<UserModel>(
      fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
      toFirestore: (userModel, _) => userModel.toJson(),
    );
  }

  /// Access to the PUBLIC user information (given a UID, that user will be found)

  DocumentReference<UserProfileModel> userProfileDocument(String? uid) {
    var path = _userProfilePath(
      uid ?? FirebaseAuth.instance.currentUser?.uid,
      "Unauthorized access to user information",
    );
    var doc = FirestoreService.getDoc(path);
    return doc.withConverter<UserProfileModel>(
      fromFirestore: (snapshot, _) => UserProfileModel.fromJson(snapshot.data()!),
      toFirestore: (profileModel, _) => profileModel.toJson(),
    );
  }

  /// Determine if the logged in user, has existing documentation.
  Future<bool> userDocExists() async {
    var path = _userPath(
      FirebaseAuth.instance.currentUser?.uid,
      "Unauthorized access to user information",
    );
    var doc = await FirebaseFirestore.instance.doc(path).get(const GetOptions(source: Source.server));
    return doc.exists;
  }

  Future<DocumentSnapshot<UserModel>> getUser() {
    return _userModelDocument().getCacheFirst();
  }

  /// Create a new user in the Firestore
  createNewUser({
    required UserCredential uc,
    required String name,
    required String themeModeName,
    bool onBoarded = true,
  }) async {
    try {
      UserProfileModel userProfileModel = UserProfileModel(name: name);
      UserModel userModel = UserModel(
        uid: uc.user?.uid,
        isAdmin: false,
        userProfile: userProfileModel,
        userSettings: UserSettingsModel(themeMode: themeModeName, onBoarded: onBoarded),
      );

      // Batch create
      var batch = FirebaseFirestore.instance.batch();
      batch.set<UserModel>(_userModelDocument(), userModel);
      batch.set<UserProfileModel>(userProfileDocument(null), userProfileModel);
      await batch.commit();
    } catch (e) {
      // Failed attempt. Remove user from firebase authentication
      await uc.user?.delete();
      rethrow;
    }
  }

  /// Update a user + the user profile in the firestore
  updateUser({UserSettingsModel? userSettingsModel, UserProfileModel? profileModel}) async {
    var batch = FirebaseFirestore.instance.batch();
    Map<String, dynamic> userUpdate = {};
    Map<String, dynamic> profileUpdate = {};

    if (userSettingsModel != null) {
      userUpdate.putIfAbsent("userSettings", () => userSettingsModel.toJson());
    }
    if (profileModel != null) {
      userUpdate.putIfAbsent("userProfile", () => profileModel.toJson());
      profileUpdate = profileModel.toJson();
    }

    batch.update(_userModelDocument(), userUpdate);
    batch.update(userProfileDocument(null), profileUpdate);
    await batch.commit();
  }

  deleteUser() async {
    var batch = FirebaseFirestore.instance.batch();
    batch.delete(_userModelDocument());
    batch.delete(userProfileDocument(null));
    await batch.commit();
  }
}
