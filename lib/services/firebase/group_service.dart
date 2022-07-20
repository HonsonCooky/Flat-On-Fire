import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flat_on_fire/_app_bucket.dart';

class GroupService {
  static const groupKey = "groups";
  static const memberKey = "members";

// ----------------------------------------------------------------------------------------------------------------
// PRIVATE ASSISTANT METHODS
// ----------------------------------------------------------------------------------------------------------------

  String _groupPath(String uid) {
    return "$groupKey/$uid";
  }

  String _memberPath(String uid, String member) {
    return "${_groupPath(uid)}/$memberKey/$member";
  }

  /// Access to the PRIVATE group information
  DocumentReference<GroupModel> _groupDocument(String uid) {
    var path = _groupPath(uid);
    var doc = FirestoreService().getDoc(path);
    return doc.withConverter<GroupModel>(
      fromFirestore: (snapshot, _) => GroupModel.fromJson(snapshot.data()!),
      toFirestore: (settingsModel, _) => settingsModel.toJson(),
    );
  }

  DocumentReference<MemberModel> _memberDocument(String uid, String member) {
    var path = _memberPath(uid, member);
    var doc = FirestoreService().getDoc(path);
    return doc.withConverter<MemberModel>(
      fromFirestore: (snapshot, _) => MemberModel.fromJson(snapshot.data()!),
      toFirestore: (settingsModel, _) => settingsModel.toJson(),
    );
  }

// ----------------------------------------------------------------------------------------------------------------
// PUBLIC METHODS
// ----------------------------------------------------------------------------------------------------------------

  Future<DocumentSnapshot<GroupModel>> getGroup({required String groupId}) {
    return _groupDocument(groupId).getCacheFirst();
  }

  Future<List<MemberModel>> getUsersGroups({
    required String userId,
  }) async {
    var groupsQuery = FirebaseFirestore.instance
        .collectionGroup(memberKey)
        .where("userId", isEqualTo: userId)
        .withConverter<MemberModel>(
          fromFirestore: (snapshot, _) => MemberModel.fromJson(snapshot.data()!),
          toFirestore: (settingsModel, _) => settingsModel.toJson(),
        )
        .limit(10);
    var queryRes = await groupsQuery.get();
    return queryRes.docs.map((e) => e.data()).toList();
  }

  Future<void> createNewGroup({
    required String name,
    String? avatarLocalFilePath,
    FirebaseSyncFuncs? syncFuncs,
  }) async {
    // Get owner (current user)
    var user = await FirestoreService().userService.getUser();
    if (user == null || user.data() == null) {
      syncFuncs?.onError(null);
      return;
    }
    UserModel userModel = user.data()!;

    // Setup a new UID for the group (needs to be in the group document)
    String uid = FirestoreService().genUuidForCollection(groupKey);

    if (avatarLocalFilePath != null) {
      await CloudStorageService().setAvatarFile(
        subFolder: groupKey,
        uid: uid,
        imagePath: avatarLocalFilePath,
      );
    }

    var batch = FirebaseFirestore.instance.batch();
    batch.set(
        _groupDocument(uid),
        GroupModel(
          uid: uid,
          groupName: name,
          avatarPath: CloudStorageService().avatarFireStorageLoc(
            groupKey,
            uid,
          ),
        ));
    batch.set(
      _memberDocument(uid, user.data()!.uid!),
      MemberModel(
        groupName: name,
        groupId: uid,
        role: Authorization.owner,
        userProfile: userModel.profile,
        userId: userModel.uid!,
      ),
    );
    batch.commit().then((_) {
      syncFuncs?.onSuccess();
    }).catchError((e) {
      syncFuncs?.onError(e);
    });

    syncFuncs?.onLocalSuccess();
  }

  /// Update a user + the user profile in the firestore
  void updateGroup({
    required String groupId,
    required Map<String, dynamic> update,
    FirebaseSyncFuncs? syncFuncs,
  }) async {
    String? avatarLocalFilePath = update["group"]["avatarPath"];

    if (avatarLocalFilePath != null) {
      CloudStorageService().setAvatarFile(
        subFolder: groupKey,
        uid: groupId,
        imagePath: avatarLocalFilePath,
      );
    }

    Map<String, dynamic> groupUpdate = update["group"];
    Map<String, dynamic> added = update["addedMembers"];
    Map<String, dynamic> removed = update["removedMembers"];
    var batch = FirebaseFirestore.instance.batch();
    batch.update(_groupDocument(groupId), groupUpdate);
    added.forEach((key, value) {
      batch.set(_memberDocument(groupId, key), value);
    });
    removed.forEach((key, value) {
      batch.delete(_memberDocument(groupId, key));
    });
    batch.commit().then((_) {
      syncFuncs?.onSuccess();
    }).catchError((e) {
      syncFuncs?.onError(e);
    });

    syncFuncs?.onLocalSuccess();
  }
}
