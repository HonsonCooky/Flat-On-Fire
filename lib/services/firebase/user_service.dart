import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flat_on_fire/_app_bucket.dart';

class UserService {
  static const userKey = "users";

// ----------------------------------------------------------------------------------------------------------------
// PRIVATE ASSISTANT METHODS
// ----------------------------------------------------------------------------------------------------------------

  /// Get the path to a users PRIVATE information.
  String _userPath(String? uid, String exception) {
    if (uid == null) throw Exception(exception);
    return "$userKey/$uid";
  }

  /// Access to the PRIVATE user information
  DocumentReference<UserModel> _userDocument() {
    var path = _userPath(FirebaseAuth.instance.currentUser?.uid, "Unauthorized access to user information");
    var doc = FirestoreService().getDoc(path);
    return doc.withConverter<UserModel>(
      fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
      toFirestore: (settingsModel, _) => settingsModel.toJson(),
    );
  }

// ----------------------------------------------------------------------------------------------------------------
// PUBLIC METHODS
// ----------------------------------------------------------------------------------------------------------------

  /// Determine if the logged in user, has existing documentation.
  Future<bool> userDocExists() async {
    var path = _userPath(
      FirebaseAuth.instance.currentUser?.uid,
      "Unauthorized access to public user information",
    );
    var doc = await FirebaseFirestore.instance.doc(path).get(const GetOptions(source: Source.server));
    return doc.exists;
  }

  String? getUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  /// Get the UserModel from Firestore
  Future<DocumentSnapshot<UserModel>?> getUser() async {
    if (FirebaseAuth.instance.currentUser == null) return null;
    return _userDocument().getCacheFirst();
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
      if (avatarFileUrl != null || avatarLocalFilePath != null) {
        await CloudStorageService().setAvatarFile(
          subFolder: userKey,
          uid: uid,
          imagePath: avatarLocalFilePath,
          imageUrl: avatarFileUrl,
        );
      }

      // Upload profile
      UserProfileModel userProfileModel = UserProfileModel(
        name: name,
        avatarPath: CloudStorageService().avatarFireStorageLoc(
          userKey,
          uid,
        ),
      );

      // Finally create the user
      UserModel userModel = UserModel(
        uid: uc.user!.uid,
        themeMode: themeModeName,
        onBoarded: onBoarded,
        profile: userProfileModel,
      );

      // Batch create
      var batch = FirebaseFirestore.instance.batch();
      batch.set<UserModel>(_userDocument(), userModel);
      await batch.commit();
    } catch (e) {
      // Failed attempt. Remove user from firebase authentication
      await uc.user?.delete();
      rethrow;
    }
  }

  /// Update a user + the user profile in the firestore
  void updateUser({
    required Map<String, dynamic> update,
    FirebaseSyncFuncs? syncFuncs,
  }) async {
    String? avatarLocalFilePath = update["profile"]["avatarPath"];
    var uid = FirebaseAuth.instance.currentUser!.uid;

    // Upload user picture
    if (avatarLocalFilePath != null) {
      await CloudStorageService().setAvatarFile(
        subFolder: userKey,
        uid: uid,
        imagePath: avatarLocalFilePath,
      );
    }

    Map<String, dynamic> userUpdate = update;
    var batch = FirebaseFirestore.instance.batch();
    batch.update(_userDocument(), userUpdate);
    batch.commit().then((_) {
      syncFuncs?.onSuccess();
    }).catchError((e) {
      syncFuncs?.onError(e);
    });

    syncFuncs?.onLocalSuccess();
  }

  /// Delete the firebase
  Future<void> deleteUser() async {
    // Delete the profile picture first
    var uid = FirebaseAuth.instance.currentUser!.uid;
    CloudStorageService().deleteAvatarFile(subFolder: userKey, uid: uid);

    var batch = FirebaseFirestore.instance.batch();
    batch.delete(_userDocument());
    await _removeFromGroups(batch);
    await batch.commit();
  }

  Future _removeFromGroups(WriteBatch batch) async {
    var memberships = await FirestoreService()
        .groupService
        .getUserReferenceGroups(userId: FirebaseAuth.instance.currentUser!.uid)
        .get();
    for (var membership in memberships.docs) {
      batch.delete(membership.reference);
      await _deleteGroupIfGoingToBeEmpty(membership.data().groupId, batch);
    }
  }

  Future _deleteGroupIfGoingToBeEmpty(String groupId, WriteBatch batch) async {
    var members = await FirestoreService().groupService.getGroupMembers(groupId: groupId);
    if (members.length == 1) {
      FirestoreService().groupService.deleteGroup(groupId: groupId, b: batch);
    }
  }
}
