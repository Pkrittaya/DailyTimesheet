class ConfigLeaveData {
  String? configName;
  int? configBefore;
  int? configAfter;
  int? configMaxDay;

  ConfigLeaveData(
      {this.configName,
      this.configBefore,
      this.configAfter,
      this.configMaxDay});

  ConfigLeaveData.fromJson(Map<String, dynamic> json) {
    configName = json['config_Name'];
    configBefore = json['config_Before'];
    configAfter = json['config_After'];
    configMaxDay = json['config_MaxDay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['config_Name'] = this.configName;
    data['config_Before'] = this.configBefore;
    data['config_After'] = this.configAfter;
    data['config_MaxDay'] = this.configMaxDay;
    return data;
  }
}
