import 'package:flat_on_fire/_app_bucket.dart';

class GroupModel {
  final Map<String, Authorization> users;
  final Map<String, Authorization>? tables;

  GroupModel({required this.users, this.tables});

  GroupModel.fromJson(Map<String, dynamic> json)
      : users = json["users"],
        tables = json["tables"];

  Map<String, dynamic> toJson() => {
        "users": users,
        "tables": tables,
      };
}
