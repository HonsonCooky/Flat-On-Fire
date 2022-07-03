/// Profile outlines the public information of a user
class UserProfileModel {
  final String name;

  UserProfileModel({required this.name});

  UserProfileModel.fromJson(Map<String, dynamic> json) : name = json["name"];

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
