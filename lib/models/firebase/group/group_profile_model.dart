/// Outlines the information maintained in a GroupProfile Document.
/// This information is available to everyone.
class GroupProfileModel {
  final String name;
  final List<String> memberNames;

  GroupProfileModel({required this.name, required this.memberNames});

  GroupProfileModel.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        memberNames = json["memberNames"];

  Map<String, dynamic> toJson() => {
        "name": name,
        "memberNames": memberNames,
      };
}
