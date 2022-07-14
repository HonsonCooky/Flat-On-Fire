import 'package:flat_on_fire/_app_bucket.dart';

/// Outlines the information maintained in a Group Document.
/// This information is only available to group members.
/// The groupProfile field is a duplicate of publicly available information.
class GroupModel {
  final Map<String, ModelConnection<GroupProfileModel>>? users;
  final Map<String, ModelConnection<GroupProfileModel>>? tables;
  final GroupProfileModel groupProfile;

  GroupModel({
    required this.groupProfile,
    this.users,
    this.tables,
  });

  GroupModel.fromJson(Map<String, dynamic> json)
      : users = json["users"]?.map((key, value) => MapEntry(key, ModelConnection.fromJson(value))),
        tables = json["tables"]?.map((key, value) => MapEntry(key, ModelConnection.fromJson(value))),
        groupProfile = GroupProfileModel.fromJson(json["groupProfile"]);

  Map<String, dynamic> toJson() => {
        "users": users?.map((key, value) => MapEntry(key, value.toJson())),
        "tables": tables?.map((key, value) => MapEntry(key, value.toJson())),
        "groupProfile": groupProfile.toJson(),
      };
}
