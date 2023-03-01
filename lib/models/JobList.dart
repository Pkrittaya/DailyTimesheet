class JobMaster {
  String? projectCode;
  String? jobGroupCode;
  String? jobCode;
  String? jobName;
  String? jobDesc;
  String? createBy;
  String? createDate;
  String? updateBy;
  String? updateDate;

  JobMaster(
      {this.projectCode,
      this.jobGroupCode,
      this.jobCode,
      this.jobName,
      this.jobDesc,
      this.createBy,
      this.createDate,
      this.updateBy,
      this.updateDate});

  JobMaster.fromJson(Map<String, dynamic> json) {
    projectCode = json['ProjectCode'];
    jobGroupCode = json['JobGroupCode'];
    jobCode = json['JobCode'];
    jobName = json['JobName'];
    jobDesc = json['JobDesc'];
    createBy = json['Create_By'];
    createDate = json['Create_Date'];
    updateBy = json['Update_By'];
    updateDate = json['Update_Date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProjectCode'] = this.projectCode;
    data['JobGroupCode'] = this.jobGroupCode;
    data['JobCode'] = this.jobCode;
    data['JobName'] = this.jobName;
    data['JobDesc'] = this.jobDesc;
    data['Create_By'] = this.createBy;
    data['Create_Date'] = this.createDate;
    data['Update_By'] = this.updateBy;
    data['Update_Date'] = this.updateDate;
    return data;
  }
}
