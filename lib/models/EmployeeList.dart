class Employeelist {
  String? suppervisorCode;
  String? empCode;
  String? empName;
  String? empPositionName;
  String? empSectionName;
  String? empDepartmentName;
  String? empCompName;
  String? types;

  Employeelist(
      {this.suppervisorCode,
      this.empCode,
      this.empName,
      this.empPositionName,
      this.empSectionName,
      this.empDepartmentName,
      this.empCompName,
      this.types});

  Employeelist.fromJson(Map<String, dynamic> json) {
    suppervisorCode = json['Suppervisor_Code'];
    empCode = json['Emp_Code'];
    empName = json['Emp_Name'];
    empPositionName = json['Emp_Position_Name'];
    empSectionName = json['Emp_Section_Name'];
    empDepartmentName = json['Emp_Department_Name'];
    empCompName = json['Emp_Comp_Name'];
    types = json['Types'];
  }

  set isExpanded(bool isExpanded) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Suppervisor_Code'] = this.suppervisorCode;
    data['Emp_Code'] = this.empCode;
    data['Emp_Name'] = this.empName;
    data['Emp_Position_Name'] = this.empPositionName;
    data['Emp_Section_Name'] = this.empSectionName;
    data['Emp_Department_Name'] = this.empDepartmentName;
    data['Emp_Comp_Name'] = this.empCompName;
    data['Types'] = this.types;
    return data;
  }
}
