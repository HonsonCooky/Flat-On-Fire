import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flat_on_fire/_app_bucket.dart';

class UserService {
  static const userKey = "users";
  static const publicKey = "public";
  static const profileKey = "profile";

// ----------------------------------------------------------------------------------------------------------------
// PRIVATE ASSISTANT METHODS
// ----------------------------------------------------------------------------------------------------------------

  /// Get the path to a users PRIVATE information.
  String _userPath(String? uid) {
    if (uid == null) throw Exception("Unauthorized access to user information");
    return "$userKey/$uid";
  }

  String _userProfilePath(String? uid) {
    if (uid == null) throw Exception("Unauthorized access to user information");
    return "$userKey/$uid/$publicKey/$profileKey";
  }

  /// Access to the PRIVATE user information
  DocumentReference<UserModel> _userDocument() {
    var path = _userPath(FirebaseAuth.instance.currentUser?.uid);
    var doc = FirestoreService().getDoc(path);
    return doc.withConverter<UserModel>(
      fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
      toFirestore: (model, _) => model.toJson(),
    );
  }

  DocumentReference<UserProfileModel> _userProfileDocument() {
    var path = _userProfilePath(FirebaseAuth.instance.currentUser?.uid);
    var doc = FirestoreService().getDoc(path);
    return doc.withConverter<UserProfileModel>(
      fromFirestore: (snapshot, _) => UserProfileModel.fromJson(snapshot.data()!),
      toFirestore: (model, _) => model.toJson(),
    );
  }

// ----------------------------------------------------------------------------------------------------------------
// PUBLIC METHODS
// ----------------------------------------------------------------------------------------------------------------

  /// Determine if the logged in user, has existing documentation.
  Future<bool> userDocExists() async {
    var path = _userPath(FirebaseAuth.instance.currentUser?.uid);
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
      batch.set(_userProfileDocument(), userProfileModel);
      await batch.commit().then(
        (value) async {
          if (avatarFileUrl != null || avatarLocalFilePath != null) {
            await CloudStorageService().setAvatarFile(
              subFolder: userKey,
              uid: uid,
              imagePath: avatarLocalFilePath,
              imageUrl: avatarFileUrl,
            );
          }
        },
      );
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

    var batch = FirebaseFirestore.instance.batch();
    batch.update(_userDocument(), update);
    batch.update(_userProfileDocument(), update["profile"]);

    await _updateMyMemberships(update["profile"], batch);

    batch.commit().then((_) async {
      if (avatarLocalFilePath != null) {
        await CloudStorageService().setAvatarFile(
          subFolder: userKey,
          uid: uid,
          imagePath: avatarLocalFilePath,
        );
      }
      syncFuncs?.onSuccess();
    }).catchError((e) {
      syncFuncs?.onError(e);
    });

    syncFuncs?.onLocalSuccess();
  }

  Future<void> _updateMyMemberships(dynamic profile, WriteBatch batch) async {
    if (profile == null) return;

    var memberships = await FirestoreService()
        .groupService
        .getUserReferenceGroups(userId: FirebaseAuth.instance.currentUser!.uid)
        .get();

    for (var membership in memberships.docs) {
      batch.update(
        membership.reference,
        {"userProfile": profile},
      );
    }
  }

  /// Delete the firebase
  Future<void> deleteUser() async {
    // Delete the profile picture first
    var uid = FirebaseAuth.instance.currentUser!.uid;
    CloudStorageService().deleteAvatarFile(subFolder: userKey, uid: uid);

    var batch = FirebaseFirestore.instance.batch();
    batch.delete(_userDocument());
    batch.delete(_userProfileDocument());
    await _removeFromGroups(batch);
    await batch.commit();
  }

  Future _removeFromGroups(WriteBatch batch) async {
    var memberships = await FirestoreService()
        .groupService
        .getUserReferenceGroups(userId: FirebaseAuth.instance.currentUser!.uid)
        .get();
    for (var membership in memberships.docs) {
      if (await _handleMemberDelete(membership.data().groupId, batch)) {
        batch.delete(membership.reference);
      }
    }
  }

  Future<bool> _handleMemberDelete(String groupId, WriteBatch batch) async {
    var members = await FirestoreService().groupService.getGroupMembers(groupId: groupId);
    if (members.length == 1) {
      FirestoreService().groupService.deleteGroup(groupId: groupId);
      return false;
    } else {
      _handoverOwnershipCheck(members);
      return true;
    }
  }

  Future _handoverOwnershipCheck(List<MemberModel> members) async {
    try {
      var me = members.firstWhere((element) => element.userId == FirebaseAuth.instance.currentUser!.uid);
      if (me.role == Authorization.owner) {
        // Get number of owners
        var ownerCount =
            members.where((element) => element.role == Authorization.owner && element.userId != me.userId).length;

        // If no other owners, throw error
        if (ownerCount == 0) {
          throw Exception("You have not passed ownership of group(s) over to others yet.");
        }
      }
    } catch (_) {}
  }
}
