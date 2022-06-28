class UserSettingsModel {
  final String themeMode;
  final bool onBoarded;

  UserSettingsModel(this.themeMode, this.onBoarded);

  UserSettingsModel.fromJson(Map<String, dynamic> json)
      : themeMode = json["themeMode"],
        onBoarded = json["onBoarded"];

  Map<String, dynamic> toJson() => {
        "themeMode": themeMode,
        "onBoarded": onBoarded,
      };
}
