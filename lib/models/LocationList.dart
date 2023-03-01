class LocationMaster {
  String? projectCode;
  String? locationCode;
  String? locationName;
  String? createBy;
  String? createDate;
  String? updateBy;
  String? updateDate;

  LocationMaster(
      {this.projectCode,
      this.locationCode,
      this.locationName,
      this.createBy,
      this.createDate,
      this.updateBy,
      this.updateDate});

  LocationMaster.fromJson(Map<String, dynamic> json) {
    projectCode = json['ProjectCode'];
    locationCode = json['LocationCode'];
    locationName = json['LocationName'];
    createBy = json['Create_By'];
    createDate = json['Create_Date'];
    updateBy = json['Update_By'];
    updateDate = json['Update_Date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProjectCode'] = this.projectCode;
    data['LocationCode'] = this.locationCode;
    data['LocationName'] = this.locationName;
    data['Create_By'] = this.createBy;
    data['Create_Date'] = this.createDate;
    data['Update_By'] = this.updateBy;
    data['Update_Date'] = this.updateDate;
    return data;
  }
}
