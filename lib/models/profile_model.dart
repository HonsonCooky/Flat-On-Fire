/// Profile outlines the public information of a user
class ProfileModel {
  final String name;

  ProfileModel({required this.name});

  ProfileModel.fromJson(Map<String, dynamic> json): name = json["name"];
  Map<String, dynamic> toJson() => {
    "name": name,
  };
}
