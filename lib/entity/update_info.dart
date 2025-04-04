class UpdateInfo {
  String lastVersion;
  String version;
  String fileName;
  String time;
  List<String> upgradeInstructions;

  UpdateInfo(this.lastVersion, this.version, this.fileName, this.time,
      this.upgradeInstructions);

  factory UpdateInfo.fromJson(Map<String, dynamic> json) {
    var upgradeInstructions = List<String>.from(json['upgradeInstructions']);
    return UpdateInfo(json['lastVersion'], json['version'], json['fileName'],
        json['time'], upgradeInstructions);
  }

  Map<String, dynamic> toJson() {
    return {
      'lastVersion': lastVersion,
      'version': version,
      'fileName': fileName,
      'time': time,
      'upgradeInstructions': upgradeInstructions
    };
  }
}
