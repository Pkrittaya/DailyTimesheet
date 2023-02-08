class ManpowerJobDetail {
  String? _projectName;
  String? _jobNo;
  String? _reviseNo;
  String? _jobName;
  bool isExpanded = false;
  ManpowerJobDetail(
      {String? projectName, String? jobNo, String? reviseNo, String? jobName}) {
    if (projectName != null) {
      this._projectName = projectName;
    }
    if (jobNo != null) {
      this._jobNo = jobNo;
    }
    if (reviseNo != null) {
      this._reviseNo = reviseNo;
    }
    if (jobName != null) {
      this._jobName = jobName;
    }
  }

  String? get projectName => _projectName;
  set projectName(String? projectName) => _projectName = projectName;
  String? get jobNo => _jobNo;
  set jobNo(String? jobNo) => _jobNo = jobNo;
  String? get reviseNo => _reviseNo;
  set reviseNo(String? reviseNo) => _reviseNo = reviseNo;
  String? get jobName => _jobName;
  set jobName(String? jobName) => _jobName = jobName;

  ManpowerJobDetail.fromJson(Map<String, dynamic> json) {
    _projectName = json['ProjectName'];
    _jobNo = json['JobNo'];
    _reviseNo = json['Revise_No'];
    _jobName = json['JobName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProjectName'] = this._projectName;
    data['JobNo'] = this._jobNo;
    data['Revise_No'] = this._reviseNo;
    data['JobName'] = this._jobName;
    return data;
  }
}
