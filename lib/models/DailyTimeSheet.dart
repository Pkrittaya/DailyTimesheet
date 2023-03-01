class DailyTimeSheet {
  Null? jobNo;
  Null? reviseNo;
  String? type;
  String? empCode;
  String? supervisorCode;
  String? timeIn;
  String? timeOut;
  Null? locationStatus;
  String? status;
  String? remark;
  String? costCenter;
  String? jobId;
  String? workDay;
  String? createDate;
  String? createBy;
  String? projectCode;
  String? jobGroup;
  String? locationCode;
  String? jobCode;
  String? empName;
  String? dateDiffs;
  int? sumMinute;
  String? sumtimes;

  DailyTimeSheet(
      {this.jobNo,
      this.reviseNo,
      this.type,
      this.empCode,
      this.supervisorCode,
      this.timeIn,
      this.timeOut,
      this.locationStatus,
      this.status,
      this.remark,
      this.costCenter,
      this.jobId,
      this.workDay,
      this.createDate,
      this.createBy,
      this.projectCode,
      this.jobGroup,
      this.locationCode,
      this.jobCode,
      this.empName,
      this.dateDiffs,
      this.sumMinute,
      this.sumtimes});

  DailyTimeSheet.fromJson(Map<String, dynamic> json) {
    jobNo = json['JobNo'];
    reviseNo = json['Revise_No'];
    type = json['Type'];
    empCode = json['Emp_Code'];
    supervisorCode = json['Supervisor_Code'];
    timeIn = json['Time_In'];
    timeOut = json['Time_Out'];
    locationStatus = json['Location_Status'];
    status = json['Status'];
    remark = json['Remark'];
    costCenter = json['CostCenter'];
    jobId = json['Job_Id'];
    workDay = json['Work_Day'];
    createDate = json['Create_Date'];
    createBy = json['Create_By'];
    projectCode = json['Project_Code'];
    jobGroup = json['Job_Group'];
    locationCode = json['Location_Code'];
    jobCode = json['Job_Code'];
    empName = json['Emp_Name'];
    dateDiffs = json['DateDiffs'];
    sumMinute = json['SumMinute'];
    sumtimes = json['Sumtimes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['JobNo'] = this.jobNo;
    data['Revise_No'] = this.reviseNo;
    data['Type'] = this.type;
    data['Emp_Code'] = this.empCode;
    data['Supervisor_Code'] = this.supervisorCode;
    data['Time_In'] = this.timeIn;
    data['Time_Out'] = this.timeOut;
    data['Location_Status'] = this.locationStatus;
    data['Status'] = this.status;
    data['Remark'] = this.remark;
    data['CostCenter'] = this.costCenter;
    data['Job_Id'] = this.jobId;
    data['Work_Day'] = this.workDay;
    data['Create_Date'] = this.createDate;
    data['Create_By'] = this.createBy;
    data['Project_Code'] = this.projectCode;
    data['Job_Group'] = this.jobGroup;
    data['Location_Code'] = this.locationCode;
    data['Job_Code'] = this.jobCode;
    data['Emp_Name'] = this.empName;
    data['DateDiffs'] = this.dateDiffs;
    data['SumMinute'] = this.sumMinute;
    data['Sumtimes'] = this.sumtimes;
    return data;
  }
}
