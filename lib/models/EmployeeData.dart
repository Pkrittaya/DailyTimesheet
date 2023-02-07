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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emp_Code'] = this.empCode;
    data['emp_Name'] = this.empName;
    data['emp_Comp_Name'] = this.empCompName;
    data['emp_Department_Name'] = this.empDepartmentName;
    data['emp_Position_Name'] = this.empPositionName;
    data['emp_Nationality'] = this.empNationality;
    return data;
  }
}
