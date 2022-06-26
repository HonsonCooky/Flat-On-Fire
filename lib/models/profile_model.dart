class ProfileModel {
  final String name;

  ProfileModel(this.name);

  ProfileModel.fromJson(Map<String, dynamic> json): name = json["name"];
  Map<String, dynamic> toJson() => {
    "name": name,
  };
}
