import 'package:flat_on_fire/_app_bucket.dart';

/// Outlines the information maintained in a Group Document.
/// This information is only available to group members.
/// The groupProfile field is a duplicate of publicly available information.
class GroupModel {
  final String? uid;
  final String groupName;

  GroupModel({required this.uid, required this.groupName});

  GroupModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        groupName = json["groupName"];

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "groupName": groupName,
      };
}

class MemberModel {
  final String groupName;
  final Authorization role;
  final UserProfileModel userProfile;
  final String userId;

  MemberModel({
    required this.groupName,
    required this.role,
    required this.userProfile,
    required this.userId,
  });

  MemberModel.fromJson(Map<String, dynamic> json)
      : groupName = json["groupName"],
        role = authFromJson(json["role"]),
        userId = json["userId"],
        userProfile = UserProfileModel.fromJson(json["userProfile"]);
  
  Map<String, dynamic> toJson() => {
        "groupName": groupName,
        "role": role.name,
        "userProfile": userProfile.toJson(),
        "userId": userId,
      };
}
