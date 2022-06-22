class UserModel {
  final String name;

  UserModel(this.name);

  UserModel.fromJson(Map<String, dynamic> json) : name = json['name'];

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}
