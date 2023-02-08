import 'DailyTimeSheet.dart';

class ManpowerEmpData {
  String? _projectName;
  String? _jobNo;
  String? _jobName;
  String? _supervisorCode;
  String? _supervisorName;
  String? _startDate;
  String? _finishDate;
  String? _target;
  String? _costCenter;
  String? _createDate;
  String? _createBy;
  String? _reviseNo;
  String? _status;
  String? _empCode;
  String? _empName;
  bool isExpanded = false;
  String? SumTime;
  List<DailyTimeSheet> lstDaily = [];

  ManpowerEmpData(
      {String? projectName,
      String? jobNo,
      String? jobName,
      String? supervisorCode,
      String? supervisorName,
      String? startDate,
      String? finishDate,
      String? target,
      String? costCenter,
      String? createDate,
      String? createBy,
      String? reviseNo,
      String? status,
      String? empCode,
      String? empName}) {
    if (projectName != null) {
      this._projectName = projectName;
    }
    if (jobNo != null) {
      this._jobNo = jobNo;
    }
    if (jobName != null) {
      this._jobName = jobName;
    }
    if (supervisorCode != null) {
      this._supervisorCode = supervisorCode;
    }
    if (supervisorName != null) {
      this._supervisorName = supervisorName;
    }
    if (startDate != null) {
      this._startDate = startDate;
    }
    if (finishDate != null) {
      this._finishDate = finishDate;
    }
    if (target != null) {
      this._target = target;
    }
    if (costCenter != null) {
      this._costCenter = costCenter;
    }
    if (createDate != null) {
      this._createDate = createDate;
    }
    if (createBy != null) {
      this._createBy = createBy;
    }
    if (reviseNo != null) {
      this._reviseNo = reviseNo;
    }
    if (status != null) {
      this._status = status;
    }
    if (empCode != null) {
      this._empCode = empCode;
    }
    if (empName != null) {
      this._empName = empName;
    }
  }

  String? get projectName => _projectName;
  set projectName(String? projectName) => _projectName = projectName;
  String? get jobNo => _jobNo;
  set jobNo(String? jobNo) => _jobNo = jobNo;
  String? get jobName => _jobName;
  set jobName(String? jobName) => _jobName = jobName;
  String? get supervisorCode => _supervisorCode;
  set supervisorCode(String? supervisorCode) =>
      _supervisorCode = supervisorCode;
  String? get supervisorName => _supervisorName;
  set supervisorName(String? supervisorName) =>
      _supervisorName = supervisorName;
  String? get startDate => _startDate;
  set startDate(String? startDate) => _startDate = startDate;
  String? get finishDate => _finishDate;
  set finishDate(String? finishDate) => _finishDate = finishDate;
  String? get target => _target;
  set target(String? target) => _target = target;
  String? get costCenter => _costCenter;
  set costCenter(String? costCenter) => _costCenter = costCenter;
  String? get createDate => _createDate;
  set createDate(String? createDate) => _createDate = createDate;
  String? get createBy => _createBy;
  set createBy(String? createBy) => _createBy = createBy;
  String? get reviseNo => _reviseNo;
  set reviseNo(String? reviseNo) => _reviseNo = reviseNo;
  String? get status => _status;
  set status(String? status) => _status = status;
  String? get empCode => _empCode;
  set empCode(String? empCode) => _empCode = empCode;
  String? get empName => _empName;
  set empName(String? empName) => _empName = empName;

  ManpowerEmpData.fromJson(Map<String, dynamic> json) {
    _projectName = json['ProjectName'];
    _jobNo = json['JobNo'];
    _jobName = json['JobName'];
    _supervisorCode = json['Supervisor_Code'];
    _supervisorName = json['Supervisor_Name'];
    _startDate = json['Start_Date'];
    _finishDate = json['Finish_Date'];
    _target = json['Target'];
    _costCenter = json['CostCenter'];
    _createDate = json['Create_Date'];
    _createBy = json['Create_By'];
    _reviseNo = json['Revise_No'];
    _status = json['Status'];
    _empCode = json['Emp_Code'];
    _empName = json['Emp_Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProjectName'] = this._projectName;
    data['JobNo'] = this._jobNo;
    data['JobName'] = this._jobName;
    data['Supervisor_Code'] = this._supervisorCode;
    data['Supervisor_Name'] = this._supervisorName;
    data['Start_Date'] = this._startDate;
    data['Finish_Date'] = this._finishDate;
    data['Target'] = this._target;
    data['CostCenter'] = this._costCenter;
    data['Create_Date'] = this._createDate;
    data['Create_By'] = this._createBy;
    data['Revise_No'] = this._reviseNo;
    data['Status'] = this._status;
    data['Emp_Code'] = this._empCode;
    data['Emp_Name'] = this._empName;
    return data;
  }
}
