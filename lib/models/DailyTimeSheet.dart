class DailyTimeSheet {
  String? _jobNo;
  String? _reviseNo;
  String? _type;
  String? _empCode;
  String? _supervisorCode;
  String? _timeIn;
  String? _timeOut;
  String? _locationStatus;
  String? _status;
  String? _remark;
  String? _costCenter;
  String? _jobCode;
  String? _workDay;
  String? _createDate;
  String? _createBy;
  String? _empName;
  String? _dateDiffs;
  String? _sumtimes;

  DailyTimeSheet(
      {String? jobNo,
      String? reviseNo,
      String? type,
      String? empCode,
      String? supervisorCode,
      String? timeIn,
      String? timeOut,
      String? locationStatus,
      String? status,
      String? remark,
      String? costCenter,
      String? jobCode,
      String? workDay,
      String? createDate,
      String? createBy,
      String? empName,
      String? dateDiffs,
      String? sumtimes}) {
    if (jobNo != null) {
      this._jobNo = jobNo;
    }
    if (reviseNo != null) {
      this._reviseNo = reviseNo;
    }
    if (type != null) {
      this._type = type;
    }
    if (empCode != null) {
      this._empCode = empCode;
    }
    if (supervisorCode != null) {
      this._supervisorCode = supervisorCode;
    }
    if (timeIn != null) {
      this._timeIn = timeIn;
    }
    if (timeOut != null) {
      this._timeOut = timeOut;
    }
    if (locationStatus != null) {
      this._locationStatus = locationStatus;
    }
    if (status != null) {
      this._status = status;
    }
    if (remark != null) {
      this._remark = remark;
    }
    if (costCenter != null) {
      this._costCenter = costCenter;
    }
    if (jobCode != null) {
      this._jobCode = jobCode;
    }
    if (workDay != null) {
      this._workDay = workDay;
    }
    if (createDate != null) {
      this._createDate = createDate;
    }
    if (createBy != null) {
      this._createBy = createBy;
    }
    if (empName != null) {
      this._empName = empName;
    }
    if (dateDiffs != null) {
      this._dateDiffs = dateDiffs;
    }
    if (sumtimes != null) {
      this._sumtimes = sumtimes;
    }
  }

  String? get jobNo => _jobNo;
  set jobNo(String? jobNo) => _jobNo = jobNo;
  String? get reviseNo => _reviseNo;
  set reviseNo(String? reviseNo) => _reviseNo = reviseNo;
  String? get type => _type;
  set type(String? type) => _type = type;
  String? get empCode => _empCode;
  set empCode(String? empCode) => _empCode = empCode;
  String? get supervisorCode => _supervisorCode;
  set supervisorCode(String? supervisorCode) =>
      _supervisorCode = supervisorCode;
  String? get timeIn => _timeIn;
  set timeIn(String? timeIn) => _timeIn = timeIn;
  String? get timeOut => _timeOut;
  set timeOut(String? timeOut) => _timeOut = timeOut;
  String? get locationStatus => _locationStatus;
  set locationStatus(String? locationStatus) =>
      _locationStatus = locationStatus;
  String? get status => _status;
  set status(String? status) => _status = status;
  String? get remark => _remark;
  set remark(String? remark) => _remark = remark;
  String? get costCenter => _costCenter;
  set costCenter(String? costCenter) => _costCenter = costCenter;
  String? get jobCode => _jobCode;
  set jobCode(String? jobCode) => _jobCode = jobCode;
  String? get workDay => _workDay;
  set workDay(String? workDay) => _workDay = workDay;
  String? get createDate => _createDate;
  set createDate(String? createDate) => _createDate = createDate;
  String? get createBy => _createBy;
  set createBy(String? createBy) => _createBy = createBy;
  String? get empName => _empName;
  set empName(String? empName) => _empName = empName;
  String? get dateDiffs => _dateDiffs;
  set dateDiffs(String? dateDiffs) => _dateDiffs = dateDiffs;
  String? get sumtimes => _sumtimes;
  set sumtimes(String? sumtimes) => _sumtimes = sumtimes;

  DailyTimeSheet.fromJson(Map<String, dynamic> json) {
    _jobNo = json['JobNo'];
    _reviseNo = json['Revise_No'];
    _type = json['Type'];
    _empCode = json['Emp_Code'];
    _supervisorCode = json['Supervisor_Code'];
    _timeIn = json['Time_In'];
    _timeOut = json['Time_Out'];
    _locationStatus = json['Location_Status'];
    _status = json['Status'];
    _remark = json['Remark'];
    _costCenter = json['CostCenter'];
    _jobCode = json['Job_Code'];
    _workDay = json['Work_Day'];
    _createDate = json['Create_Date'];
    _createBy = json['Create_By'];
    _empName = json['Emp_Name'];
    _dateDiffs = json['DateDiffs'];
    _sumtimes = json['Sumtimes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['JobNo'] = this._jobNo;
    data['Revise_No'] = this._reviseNo;
    data['Type'] = this._type;
    data['Emp_Code'] = this._empCode;
    data['Supervisor_Code'] = this._supervisorCode;
    data['Time_In'] = this._timeIn;
    data['Time_Out'] = this._timeOut;
    data['Location_Status'] = this._locationStatus;
    data['Status'] = this._status;
    data['Remark'] = this._remark;
    data['CostCenter'] = this._costCenter;
    data['Job_Code'] = this._jobCode;
    data['Work_Day'] = this._workDay;
    data['Create_Date'] = this._createDate;
    data['Create_By'] = this._createBy;
    data['Emp_Name'] = this._empName;
    data['DateDiffs'] = this._dateDiffs;
    data['Sumtimes'] = this._sumtimes;
    return data;
  }
}
