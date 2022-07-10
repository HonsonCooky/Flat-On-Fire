/// UserProfileModel outlines the public information of a user
class UserProfileModel {
  final String name;
  final String? avatarPath;

  UserProfileModel({required this.name, this.avatarPath});

  UserProfileModel.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        avatarPath = json["avatarPath"];

  Map<String, dynamic> toJson() => {
        "name": name,
        "avatarPath": avatarPath,
      };
}
