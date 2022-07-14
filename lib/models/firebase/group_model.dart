import 'package:flat_on_fire/_app_bucket.dart';

/// Outlines the information maintained in a Group Document.
/// This information is only available to group members.
/// The groupProfile field is a duplicate of publicly available information.
class GroupModel {
  final String groupName;

  GroupModel({required this.groupName});

  GroupModel.fromJson(Map<String, dynamic> json) : groupName = json["groupName"];

  Map<String, dynamic> toJson() => {"groupName": groupName};
}

class MemberModel {
  final String groupName;
  final Authorization role;
  final UserProfileModel user;

  MemberModel({required this.groupName, required this.role, required this.user});

  MemberModel.fromJson(Map<String, dynamic> json)
      : groupName = json["groupName"],
        role = authFromJson(json["role"]),
        user = UserProfileModel.fromJson(json["user"]);

  Map<String, dynamic> toJson() => {
        "groupName": groupName,
        "role": role.name,
        "user": user.toJson(),
      };
}
