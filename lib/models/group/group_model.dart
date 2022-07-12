import 'package:flat_on_fire/_app_bucket.dart';

/// Outlines the information maintained in a Group Document.
/// This information is only available to group members.
/// The groupProfile field is a duplicate of publicly available information.
class GroupModel {
  final Map<String, Authorization>? users;
  final Map<String, Authorization>? tables;
  final GroupProfileModel groupProfile;

  GroupModel({
    required this.groupProfile,
    this.users,
    this.tables,
  });

  GroupModel.fromJson(Map<String, dynamic> json)
      : users = json["users"],
        tables = json["tables"],
        groupProfile = GroupProfileModel.fromJson(json["groupProfile"]);

  Map<String, dynamic> toJson() => {
        "users": users,
        "tables": tables,
        "groupProfile": groupProfile.toJson(),
      };
}
