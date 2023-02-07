class TimesheetData {
  String? empCode;
  String? timesheetDate;
  String? timesheetEndDate;
  String? timeSheetDateShow;
  String? shift;
  String? inTime;
  String? outTime;
  String? status;
  String? remark;
  String? projectName;
  String? jobDetail;
  String? jobCode;
  String? docType;
  String? docNo;
  String? jobTypeCode;
  String? jobDetailCode;
  String? jobDetailValues;
  String? totalHourItemData;
  String? totalHourDataDay;
  String? departmentCode;
  String? createDate;
  String? updateDate;
  bool isExpanded = false;

  TimesheetData(
      {this.empCode,
      this.timesheetDate,
      this.timesheetEndDate,
      this.timeSheetDateShow,
      this.shift,
      this.inTime,
      this.outTime,
      this.status,
      this.remark,
      this.projectName,
      this.jobDetail,
      this.jobCode,
      this.docType,
      this.docNo,
      this.jobTypeCode,
      this.jobDetailCode,
      this.jobDetailValues,
      this.totalHourItemData,
      this.totalHourDataDay,
      this.departmentCode,
      this.createDate,
      this.updateDate});

  TimesheetData.fromJson(Map<String, dynamic> json) {
    empCode = json['emp_Code'];
    timesheetDate = json['timesheetDate'];
    timesheetEndDate = json['timesheetEndDate'];
    timeSheetDateShow = json['timeSheetDateShow'];
    shift = json['shift'];
    inTime = json['in_Time'];
    outTime = json['out_Time'];
    status = json['status'];
    remark = json['remark'];
    projectName = json['project_Name'];
    jobDetail = json['job_Detail'];
    jobCode = json['job_Code'];
    docType = json['docType'];
    docNo = json['doc_No'];
    jobTypeCode = json['job_Type_code'];
    jobDetailCode = json['job_Detail_code'];
    jobDetailValues = json['job_Detail_Values'];
    totalHourItemData = json['totalHourItemData'];
    totalHourDataDay = json['totalHourDataDay'];
    departmentCode = json['department_Code'];
    createDate = json['create_Date'];
    updateDate = json['update_Date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emp_Code'] = this.empCode;
    data['timesheetDate'] = this.timesheetDate;
    data['timesheetEndDate'] = this.timesheetEndDate;
    data['timeSheetDateShow'] = this.timeSheetDateShow;
    data['shift'] = this.shift;
    data['in_Time'] = this.inTime;
    data['out_Time'] = this.outTime;
    data['status'] = this.status;
    data['remark'] = this.remark;
    data['project_Name'] = this.projectName;
    data['job_Detail'] = this.jobDetail;
    data['job_Code'] = this.jobCode;
    data['docType'] = this.docType;
    data['doc_No'] = this.docNo;
    data['job_Type_code'] = this.jobTypeCode;
    data['job_Detail_code'] = this.jobDetailCode;
    data['job_Detail_Values'] = this.jobDetailValues;
    data['totalHourItemData'] = this.totalHourItemData;
    data['totalHourDataDay'] = this.totalHourDataDay;
    data['department_Code'] = this.departmentCode;
    data['create_Date'] = this.createDate;
    data['update_Date'] = this.updateDate;
    return data;
  }
}
