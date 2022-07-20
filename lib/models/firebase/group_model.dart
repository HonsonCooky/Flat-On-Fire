import 'package:flat_on_fire/_app_bucket.dart';

/// Outlines the information maintained in a Group Document.
/// This information is only available to group members.
/// The groupProfile field is a duplicate of publicly available information.
class GroupModel {
  final String? uid;
  final String groupName;
  final String? avatarPath;

  GroupModel({required this.uid, required this.groupName, this.avatarPath});

  GroupModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        groupName = json["groupName"],
        avatarPath = json["avatarPath"];

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "groupName": groupName,
        "avatarPath": avatarPath,
      };
}

class MemberModel {
  final String groupName;
  final String groupId;
  final Authorization role;
  final UserProfileModel userProfile;
  final String userId;

  MemberModel({
    required this.groupName,
    required this.groupId,
    required this.role,
    required this.userProfile,
    required this.userId,
  });

  MemberModel.fromJson(Map<String, dynamic> json)
      : groupName = json["groupName"],
        groupId = json["groupId"],
        role = authFromJson(json["role"]),
        userId = json["userId"],
        userProfile = UserProfileModel.fromJson(json["userProfile"]);

  Map<String, dynamic> toJson() => {
        "groupName": groupName,
        "groupId": groupId,
        "role": role.name,
        "userProfile": userProfile.toJson(),
        "userId": userId,
      };
}
