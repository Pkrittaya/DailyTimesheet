class ConfigShift {
  String? configName;
  String? shift;
  String? startHalftBefore;
  String? endHalftBefore;
  String? startHalftAfter;
  String? endHalftAfter;

  ConfigShift(
      {this.configName,
      this.shift,
      this.startHalftBefore,
      this.endHalftBefore,
      this.startHalftAfter,
      this.endHalftAfter});

  ConfigShift.fromJson(Map<String, dynamic> json) {
    configName = json['config_Name'];
    shift = json['shift'];
    startHalftBefore = json['startHalftBefore'];
    endHalftBefore = json['endHalftBefore'];
    startHalftAfter = json['startHalftAfter'];
    endHalftAfter = json['endHalftAfter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['config_Name'] = this.configName;
    data['shift'] = this.shift;
    data['startHalftBefore'] = this.startHalftBefore;
    data['endHalftBefore'] = this.endHalftBefore;
    data['startHalftAfter'] = this.startHalftAfter;
    data['endHalftAfter'] = this.endHalftAfter;
    return data;
  }
}
