class EmployeeData {
  String? empCode;
  String? empName;
  String? empCompName;
  String? empDepartmentName;
  String? empPositionName;
  String? empNationality;

  EmployeeData(
      {this.empCode,
      this.empName,
      this.empCompName,
      this.empDepartmentName,
      this.empPositionName,
      this.empNationality});

  EmployeeData.fromJson(Map<String, dynamic> json) {
    empCode = json['emp_Code'];
    empName = json['emp_Name'];
    empCompName = json['emp_Comp_Name'];
    empDepartmentName = json['emp_Department_Name'];
    empPositionName = json['emp_Position_Name'];
    empNationality = json['emp_Nationality'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['emp_Code'] = empCode;
    data['emp_Name'] = empName;
    data['emp_Comp_Name'] = empCompName;
    data['emp_Department_Name'] = empDepartmentName;
    data['emp_Position_Name'] = empPositionName;
    data['emp_Nationality'] = empNationality;
    return data;
  }
}
