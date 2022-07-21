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
  DocumentReference<GroupModel> groupDocument(String uid) {
    var path = _groupPath(uid);
    var doc = FirestoreService().getDoc(path);
    return doc.withConverter<GroupModel>(
      fromFirestore: (snapshot, _) => GroupModel.fromJson(snapshot.data()!),
      toFirestore: (settingsModel, _) => settingsModel.toJson(),
    );
  }

  DocumentReference<MemberModel> memberDocument(String uid, String member) {
    var path = _memberPath(uid, member);
    var doc = FirestoreService().getDoc(path);
    return doc.withConverter<MemberModel>(
      fromFirestore: (snapshot, _) => MemberModel.fromJson(snapshot.data()!),
      toFirestore: (settingsModel, _) => settingsModel.toJson(),
    );
  }

  CollectionReference<MemberModel> _members(String uid) {
    var path = "${_groupPath(uid)}/$memberKey";
    return FirestoreService().getCol(path).withConverter(
          fromFirestore: (snapshot, _) => MemberModel.fromJson(snapshot.data()!),
          toFirestore: (settingsModel, _) => settingsModel.toJson(),
        );
  }

// ----------------------------------------------------------------------------------------------------------------
// PUBLIC METHODS
// ----------------------------------------------------------------------------------------------------------------

  Future<DocumentSnapshot<GroupModel>> getGroup({required String groupId}) {
    return groupDocument(groupId).getCacheFirst();
  }

  Query<MemberModel> getUserReferenceGroups({
    required String userId,
  }) {
    return FirebaseFirestore.instance
        .collectionGroup(memberKey)
        .where("userId", isEqualTo: userId)
        .withConverter<MemberModel>(
          fromFirestore: (snapshot, _) => MemberModel.fromJson(snapshot.data()!),
          toFirestore: (settingsModel, _) => settingsModel.toJson(),
        );
  }

  Future<List<MemberModel>> getUsersGroups({
    required String userId,
  }) async {
    var groupsQuery = getUserReferenceGroups(userId: userId).limit(10);
    var queryRes = await AppService.networkConnected() ? await groupsQuery.get() : await groupsQuery.getCacheFirst();
    return queryRes.docs.map((e) => e.data()).toList();
  }

  Future<List<MemberModel>> getGroupMembers({required String groupId}) async {
    var members =
        await AppService.networkConnected() ? await _members(groupId).get() : await _members(groupId).getCacheFirst();
    return members.docs.map((e) => e.data()).toList();
  }

// ----------------------------------------------------------------------------------------------------------------
// CREATE METHODS
// ----------------------------------------------------------------------------------------------------------------
  Future<void> createNewGroup({
    required String name,
    String? avatarLocalFilePath,
    FirebaseSyncFuncs? syncFuncs,
  }) async {
    var user = await FirestoreService().userService.getUser();
    if (user == null || user.data() == null) {
      syncFuncs?.onError(null);
      return;
    }

    UserModel userModel = user.data()!;
    String uid = FirestoreService().genUuidForCollection(groupKey);

    var batch = FirebaseFirestore.instance.batch();

    batch.set(
      groupDocument(uid),
      GroupModel(
        uid: uid,
        groupName: name,
        avatarPath: CloudStorageService().avatarFireStorageLoc(groupKey, uid),
      ),
    );

    batch.set(
      memberDocument(uid, user.data()!.uid!),
      MemberModel(
        groupName: name,
        groupId: uid,
        role: Authorization.owner,
        userProfile: userModel.profile,
        userId: userModel.uid!,
      ),
    );

    batch.commit().then((_) async {
      if (avatarLocalFilePath != null) {
        await CloudStorageService().setAvatarFile(
          subFolder: groupKey,
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

// ----------------------------------------------------------------------------------------------------------------
// UPDATE METHODS
// ----------------------------------------------------------------------------------------------------------------

  void updateGroup({
    required String groupId,
    required Map<String, dynamic> update,
    FirebaseSyncFuncs? syncFuncs,
  }) async {
    var groupUpdate = update["group"];
    var batch = FirebaseFirestore.instance.batch();
    batch.update(groupDocument(groupId), groupUpdate);
    _addMembers(groupId: groupId, update: update, batch: batch);
    _removeMembers(groupId: groupId, update: update, batch: batch);
    await _updateMembersGroupDetails(groupId: groupId, update: update, batch: batch);
    batch
        .commit()
        .then((_) => _updateProfilePictureSeg(groupId: groupId, update: update, syncFuncs: syncFuncs))
        .catchError((e) => syncFuncs?.onError(e));
    syncFuncs?.onLocalSuccess();
  }

  void _updateProfilePictureSeg({
    required String groupId,
    required Map<String, dynamic> update,
    FirebaseSyncFuncs? syncFuncs,
  }) {
    String? avatarLocalFilePath = update["group"]["avatarPath"];
    if (avatarLocalFilePath != null) {
      CloudStorageService()
          .setAvatarFile(subFolder: groupKey, uid: groupId, imagePath: avatarLocalFilePath)
          .then((value) => syncFuncs?.onSuccess())
          .catchError((e) => syncFuncs?.onError(e));
    } else {
      syncFuncs?.onSuccess();
    }
  }

  void _addMembers({
    required String groupId,
    required Map<String, dynamic> update,
    required WriteBatch batch,
  }) {
    var added = update["addedMembers"];
    added.forEach((key, value) {
      batch.set(memberDocument(groupId, key), value);
    });
  }

  void _removeMembers({
    required String groupId,
    required Map<String, dynamic> update,
    required WriteBatch batch,
  }) {
    var removed = update["removedMembers"];
    removed.forEach((key, value) {
      batch.delete(memberDocument(groupId, key));
    });
  }

  Future<void> _updateMembersGroupDetails({
    required String groupId,
    required Map<String, dynamic> update,
    required WriteBatch batch,
  }) async {
    var groupName = update["groupName"];
    if (groupName == null) return;

    var members = await FirestoreService()
        .getCol("${_groupPath(groupId)}/$memberKey")
        .withConverter<MemberModel>(
          fromFirestore: (snapshot, _) => MemberModel.fromJson(snapshot.data()!),
          toFirestore: (settingsModel, _) => settingsModel.toJson(),
        )
        .get();

    for (var element in members.docs) {
      batch.update(element.reference, {
        "groupName": groupName,
      });
    }
  }

// ----------------------------------------------------------------------------------------------------------------
// DELETE METHODS
// ----------------------------------------------------------------------------------------------------------------
  Future<void> deleteGroup({required String groupId, WriteBatch? b}) async {
    await CloudStorageService().deleteAvatarFile(subFolder: groupKey, uid: groupId);

    if (b != null) {
      b.delete(groupDocument(groupId));
      return;
    }

    var members = await _members(groupId).get();
    var batch = FirebaseFirestore.instance.batch();
    for (var element in members.docs) {
      batch.delete(element.reference);
    }
    batch.delete(groupDocument(groupId));
    await batch.commit();
  }
}
