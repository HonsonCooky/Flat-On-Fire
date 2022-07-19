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

  Future<List<MemberModel>> getUsersGroups({
    required String userId,
  }) async {
    try {
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
    } catch (e) {
      // print(e);
      rethrow;
    }
  }

  Future<void> createNewGroup({
    required String name,
    String? avatarLocalFilePath,
    FirebaseSyncFuncs? syncFuncs,
  }) async {
    var user = await FirestoreService().userService.getUser();
    if (user == null || user.data() == null) {
      syncFuncs?.onError();
      return;
    }
    UserModel userModel = user.data()!;
    String uid = FirestoreService().genUuidForCollection(groupKey);
    var batch = FirebaseFirestore.instance.batch();
    batch.set(_groupDocument(uid), GroupModel(uid: uid, groupName: name));
    batch.set(
      _memberDocument(uid, user.data()!.uid!),
      MemberModel(
        groupName: name,
        role: Authorization.owner,
        userProfile: userModel.profile,
        userId: userModel.uid!,
      ),
    );
    batch.commit().then((_) {
      syncFuncs?.onSuccess();
    }).catchError((_) {
      syncFuncs?.onError();
    });

    syncFuncs?.onLocalSuccess();
  }
}
