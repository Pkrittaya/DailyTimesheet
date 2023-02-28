class EmpDailyEmployee {
  String? empCode;
  String? empName;
  String? empCompName;
  String? empUnitName;
  String? empSectionName;
  String? empDepartmentName;
  String? empPositionName;
  String? supervisorCode;
  String? supervisorName;

  EmpDailyEmployee(
      {this.empCode,
      this.empName,
      this.empCompName,
      this.empUnitName,
      this.empSectionName,
      this.empDepartmentName,
      this.empPositionName,
      this.supervisorCode,
      this.supervisorName});

  EmpDailyEmployee.fromJson(Map<String, dynamic> json) {
    empCode = json['Emp_Code'];
    empName = json['Emp_Name'];
    empCompName = json['Emp_Comp_Name'];
    empUnitName = json['Emp_Unit_Name'];
    empSectionName = json['Emp_Section_Name'];
    empDepartmentName = json['Emp_Department_Name'];
    empPositionName = json['Emp_Position_Name'];
    supervisorCode = json['Supervisor_Code'];
    supervisorName = json['Supervisor_Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Emp_Code'] = this.empCode;
    data['Emp_Name'] = this.empName;
    data['Emp_Comp_Name'] = this.empCompName;
    data['Emp_Unit_Name'] = this.empUnitName;
    data['Emp_Section_Name'] = this.empSectionName;
    data['Emp_Department_Name'] = this.empDepartmentName;
    data['Emp_Position_Name'] = this.empPositionName;
    data['Supervisor_Code'] = this.supervisorCode;
    data['Supervisor_Name'] = this.supervisorName;
    return data;
  }
}
