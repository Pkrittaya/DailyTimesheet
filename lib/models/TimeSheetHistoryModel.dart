import 'package:k2mobileapp/models/DailyTimeSheet.dart';

class TimeSheetHistoryModel {
  String? _empCode;
  String? _workDay;
  String? _record;
  List<DailyTimeSheet> lstTimesheet = [];
  bool isExpanded = false;

  TimeSheetHistoryModel({String? empCode, String? workDay, String? record}) {
    if (empCode != null) {
      this._empCode = empCode;
    }
    if (workDay != null) {
      this._workDay = workDay;
    }
    if (record != null) {
      this._record = record;
    }
  }

  String? get empCode => _empCode;
  set empCode(String? empCode) => _empCode = empCode;
  String? get workDay => _workDay;
  set workDay(String? workDay) => _workDay = workDay;
  String? get record => _record;
  set record(String? record) => _record = record;

  TimeSheetHistoryModel.fromJson(Map<String, dynamic> json) {
    _empCode = json['Emp_Code'];
    _workDay = json['Work_Day'];
    _record = json['Record'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Emp_Code'] = this._empCode;
    data['Work_Day'] = this._workDay;
    data['Record'] = this._record;
    return data;
  }
}
