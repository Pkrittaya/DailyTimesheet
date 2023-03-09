import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:k2mobileapp/models/EmployeeData.dart';
import 'package:k2mobileapp/pages/employee_data.dart';
import 'package:k2mobileapp/theme.dart';
import 'package:k2mobileapp/widgets/my_box.dart';
import 'package:k2mobileapp/widgets/my_button.dart';
import 'package:k2mobileapp/widgets/my_scaffold.dart';
import 'package:k2mobileapp/widgets/my_text_field.dart';
import 'package:k2mobileapp/widgets/my_time_picker_row.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

import '../api.dart';
import '../models/EmpDailyEmployee.dart';
import '../models/EmployeeList.dart';
import '../models/JobList.dart';
import '../models/LocationList.dart';

class EmployeeList extends StatefulWidget {
  final int index;
  final String EmpCode;
  final String url;

  const EmployeeList({
    Key? key,
    required this.index,
    required this.EmpCode,
    required this.url,
  }) : super(key: key);

  @override
  State<EmployeeList> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<EmployeeList> {
  Duration work_yesterday = Duration(hours: 9, minutes: 00);

  List<Employeelist> _data = [];
  List<Employeelist> _dataAdd = [];
  List<Employeelist> itemsList = [];
  List<EmpDailyEmployee> empdaily = [];
  List<String> ckboxEmp = [];
  List<JobMaster> jobms = [];
  List<LocationMaster> locationms = [];

  TextEditingController timestart = TextEditingController();
  TextEditingController textempdaily = TextEditingController();
  TextEditingController editingController = TextEditingController();
  TextEditingController editingRemark = TextEditingController();
  TextEditingController LeaveStartDate = TextEditingController();
  TextEditingController LeaveEndDate = TextEditingController();
  bool searchempdaily = false;
  bool valall = false;

  /// custom date
  GetDateTimeCurrent() {
    Duration work_yesterday = Duration(hours: 9, minutes: 00);
    DateTime Date = DateTime.now();
    if ((Date.hour < work_yesterday.inHours) ||
        ((Date.hour == work_yesterday.inHours) &&
            (Date.minute <= work_yesterday.inMinutes.remainder(60)))) {
      Date = new DateTime(Date.year, Date.month, Date.day)
          .add(new Duration(days: -1));
    } else {
      Date = new DateTime(Date.year, Date.month, Date.day);
    }

    return Date;
  }

  CustomTime(texttime) {
    DateTime valDate = DateTime.parse(texttime);
    String date = DateFormat("HH:mm").format(valDate);
    return date.toString();
  }

  CustomTimeTypedate(texttime) {
    DateTime valDate = DateTime.parse(texttime);
    // String date = DateFormat("HH:mm").format(valDate);
    return valDate;
  }

  CustomCountTime(text) {
    final splitted = text.split(':');
    final texttime = '${splitted[0]} ชั่วโมง ${splitted[1]} นาที';
    // DateTime valDate = DateTime.parse(textdate);

    return texttime.toString();
  }

  FormatDate(textdate) {
    // DateTime valdate = DateTime.parse(textdate);
    String date = DateFormat("yyyy-MM-dd").format(new DateTime.now());
    return date;
  }

  formatDateTextTH(textTime) {
    DateTime valDate = DateTime.parse(textTime);
    String date = DateFormat("dd MMMM yyyy", "th")
        .format(DateTime(valDate.year + 543, valDate.month, valDate.day));
    return date;
  }

  formatDateTH(validate) {
    String date = DateFormat("dd MMMM yyyy", "th")
        .format(DateTime(validate.year + 543, validate.month, validate.day));
    return date;
  }

  checkboxEmp(emp) {
    final index = ckboxEmp.indexWhere((note) => note.startsWith(emp));
    if (index < 0) {
      return true;
    } else {
      return false;
    }
  }

  /// custom date end

//ทำงาน
  DateTime OTBeforeStart = DateTime.now();
  DateTime OTBeforeEnd = DateTime.now();
  DateTime DefultOneStart = DateTime.now();
  DateTime DefultOneEnd = DateTime.now();
  DateTime OTAfterStart = DateTime.now();
  DateTime OTAfterEnd = DateTime.now();

  String TextOTBeforeStart = "";
  String TextOTBeforeEnd = "";
  String TextDefultOneStart = "";
  String TextDefultOneEnd = "";
  String TextOTAfterStart = "";
  String TextOTAfterEnd = "";
  String jobdetail = "";
  String locationName = "";

//ลาป่วยบางช่วงเวลา
  DateTime LeavesickStart = DateTime.now();
  DateTime LeavesickEnd = DateTime.now();

  String TextLeavesickStart = "";
  String TextLeavesickEnd = "";

//ลาไม่รับค่าจ้างบางช่วงเวลา
  DateTime LeaveunpaidStart = DateTime.now();
  DateTime LeaveunpaidEnd = DateTime.now();

  String TextLeaveunpaidStart = "";
  String TextLeaveunpaidEnd = "";

//ลาป่วยทั้งวัน
  DateTime LeavesickAllStart = new DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day)
      .add(Duration(hours: 08, minutes: 30));

  DateTime LeavesickAllEnd = new DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day)
      .add(Duration(hours: 17, minutes: 30));

  String TextLeavesickAllStart = "08:30";
  String TextLeavesickAllEnd = "17:30";

//ลาไม่รับค่าจ้างบางช่วงเวลา
  DateTime LeaveunpaidAllStart =
      DateTime.now().subtract(Duration(hours: 08, minutes: 00));
  DateTime LeaveunpaidAllEnd =
      DateTime.now().subtract(Duration(hours: 17, minutes: 30));

  String TextLeaveunpaidAllStart = "08:00";
  String TextLeaveunpaidAllEnd = "17:30";

////////
  List<String> Hours = [];
  List<String> HoursEnd = [];
  List<String> Miniutes = <String>['00', '15', '30', '45'];
  List<String> HoursDefault = <String>[
    '00',
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23'
  ];
  List<String> HoursEndDefault = <String>[
    '00',
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24'
  ];

///// เพิ่มพนักงาน
  void dataaddemployee(
      var cycle, var supcode, var empcode, var projcode) async {
    var tojsontext = {
      "cyCleTime": "${cycle}",
      "suppervisor_Code": "${supcode}",
      "empCode": "${empcode}",
      "projectName": "${projcode}",
    };

    // var tojsontext = decoder.convert(totext);

    var res = await PostTempEmployeeDaily(tojsontext);
    setState(() {
      final jsonData = json.decode(res.body);
      print(res.body);

      //final parsedJson = jsonDecode(res.body);
      if (jsonData == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmployeeList(
              index: widget.index,
              EmpCode: widget.EmpCode,
              url: widget.url,
            ),
          ),
        );
      } else {
        Dialogs.materialDialog(
            msg: 'บันทึกไม่สำเร็จ',
            title: 'ตรวจสอบข้อมูล',
            context: context,
            actions: [
              IconsButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  //getlsttimesheet();
                },
                text: 'ตกลง',
                iconData: Icons.check_circle_outline,
                color: Colors.green,
                textStyle: TextStyle(color: Colors.white),
                iconColor: Colors.white,
              ),
            ]);
      }
    });
/*
   */
  }

  void datasavetimesheet(
      var arrayText, var empcode, var costCenter, var jobcode) async {
    const JsonDecoder decoder = JsonDecoder();
    var Datenow = DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(DateTime.now());
    Map decoded = jsonDecode(arrayText);
    int i = 0;
    String chkEmp = '';

    for (var emp in ckboxEmp) {
      if (chkEmp != '')
        chkEmp = chkEmp + ',' + emp;
      else
        chkEmp = emp;
    }

    String totext = "[";

    decoded.forEach((key, value) {
      i++;
      DateTime valDatestart = DateTime.parse(value[0]);
      DateTime valDateEnd = DateTime.parse(value[1]);

      String Datestart =
          DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(valDatestart);
      String DateEnd = DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(valDateEnd);

      if (i > 1) {
        totext += ',';
      }

      totext += '{';
      totext += '"emp_Code": "${chkEmp}",';
      totext += '"time_In": "${Datestart}",';
      totext += '"time_Out": "${DateEnd}",';

      totext += '"type": "Labour",';
      totext += '"supervisor_Code": "${widget.EmpCode}",';
      totext += '"status": "${key}",';
      totext += '"remark": "${editingRemark.text}",';
      totext += '"costCenter": "${costCenter}",';
      if (jobcode != '') {
        totext += '"jobId": "${jobcode}",';
      }

      totext += '"start_Date": "${Datenow}",';
      totext += '"create_By": "${widget.EmpCode}",';
      totext += '"project_Code": "P0001",';
      totext += '"job_Group": "G001",';
      totext += '"job_Code": "${jobdetail}",';
      totext += '"location_Code": "${locationName}"';
      totext += '}';
    });

    totext += ']';
    print(totext);
    var tojsontext = decoder.convert(totext);
    // print(tojsontext);

    final _baseUrl = '${await SaveTimesheet()}';
    final res = await http.post(Uri.parse("${_baseUrl}"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(tojsontext));

    setState(() {
      final jsonData = json.decode(res.body);
      print(res.body);

      final parsedJson = jsonDecode(res.body);
      if (parsedJson['type'] == "S") {
        Navigator.of(context, rootNavigator: true).pop();
      } else {
        Dialogs.materialDialog(
            msg: '${parsedJson['description']}',
            title: 'ตรวจสอบข้อมูล',
            context: context,
            actions: [
              IconsButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  //getlsttimesheet();
                },
                text: 'ตกลง',
                iconData: Icons.check_circle_outline,
                color: Colors.green,
                textStyle: TextStyle(color: Colors.white),
                iconColor: Colors.white,
              ),
            ]);
      }
    });
  }

  EmployeeData empdata = new EmployeeData(
      empCode: '',
      empCompName: '',
      empDepartmentName: '',
      empName: '',
      empNationality: '',
      empPositionName: '');

  void addEmployee() async {
    await Future.delayed(const Duration(milliseconds: 10));
    if (!mounted) return;

    searchempdaily = false;
    textempdaily = TextEditingController();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Dialogs.bcgColor,
              // content: Dialogs.holder,
              // shape: Dialogs.dialogShape,
              title: const Center(
                child: Text("เพิ่มพนักงาน", style: Dialogs.titleStyle),
              ),
              content: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width - 10,
                  maxWidth: MediaQuery.of(context).size.width - 10,
                  minHeight: 500, //MediaQuery.of(context).size.height - 250,
                  maxHeight: 500, //MediaQuery.of(context).size.height - 250,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            MyTextField(
                              controller: textempdaily,
                              hintText: 'รหัสพนักงาน',
                              prefixIcon: const Icon(
                                Icons.search,
                                size: 22,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            /* ปุ่มค้นหา */
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MyButton(
                                onPressed: () =>
                                    _handleSearchEmployee(setState),
                                text: 'ค้นหา',
                                buttonColor: Colors.blue[900]!,
                                textColor: Colors.white,
                              ),
                            ),
                            searchempdaily
                                ? Container(
                                    margin: const EdgeInsets.only(top: 16.0),
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 1.0,
                                        color: Colors.black12,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              0), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: empdaily.isEmpty
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  'ไม่พบรหัสพนักงาน ${textempdaily.text} ในฐานข้อมูล'),
                                            ],
                                          )
                                        : Column(
                                            children: [
                                              _buildSearchResultRow(
                                                'รหัสพนักงาน',
                                                '${empdaily[0].empCode}',
                                              ),
                                              _buildSearchResultRow(
                                                'ชื่อพนักงาน',
                                                '${empdaily[0].empName}',
                                              ),
                                              _buildSearchResultRow(
                                                'หัวหน้างาน',
                                                '${empdaily[0].supervisorCode} ${empdaily[0].supervisorName}',
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 16.0,
                                                      bottom: 8.0,
                                                    ),
                                                    child: MyButton(
                                                      onPressed: () {
                                                        Dialogs.materialDialog(
                                                          msg:
                                                              'ท่านต้องการบันทึกข้อมูลใช่หรือไม่?',
                                                          title: 'ยืนยันข้อมูล',
                                                          context: context,
                                                          actions: [
                                                            IconsOutlineButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context,
                                                                        rootNavigator:
                                                                            true)
                                                                    .pop();
                                                              },
                                                              text: 'ไม่',
                                                              iconData: Icons
                                                                  .cancel_outlined,
                                                              color:
                                                                  Colors.white,
                                                              textStyle:
                                                                  const TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                              iconColor:
                                                                  Colors.black,
                                                            ),
                                                            IconsButton(
                                                              text: 'ใช่',
                                                              iconData: Icons
                                                                  .check_circle_outline,
                                                              color:
                                                                  Colors.green,
                                                              textStyle:
                                                                  const TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                              iconColor:
                                                                  Colors.white,
                                                              onPressed: () {
                                                                _handleSaveTempDailyEmployee();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                      text: 'บันทึก',
                                                      buttonColor:
                                                          Colors.blue[900]!,
                                                      textColor: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                  )
                                : const SizedBox(height: 0),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: MyButton(
                        onPressed: () => Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pop(),
                        text: 'ยกเลิก',
                        buttonColor: Colors.blue[900]!,
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSearchResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        children: [
          SizedBox(
            width: 110.0,
            child: Text('$label : '),
          ),
          Text(value),
        ],
      ),
    );
  }

  void _handleSearchEmployee(Function setState) async {
    if (textempdaily.text == '') {
      textempdaily.text = '';
    } else {
      await getEmpDailyEmployeeAPI(textempdaily.text);
      setState(() {});
    }
  }

  void _handleSaveTempDailyEmployee() {
    DateTime newDate = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(newDate);

    dataaddemployee(
      formattedDate,
      widget.EmpCode,
      empdaily[0].empCode,
      'โครงการสายสีม่วง',
    );
  }

  GetAPI() async {
    itemsList = await GetEmployeeList(widget.EmpCode);
    var jobmsapi = await GetJobMaster('p0001');
    var locationmsapi = await GetLocationMaster('p0001');
    var Profile = await GetEmpProfile(widget.EmpCode);

    setState(() {
      _data = itemsList.where((res) => res.types == '0').toList();
      _dataAdd = itemsList.where((res) => res.types == '1').toList();
      jobms = jobmsapi;
      locationms = locationmsapi;
      empdata.empCode = Profile['emp_Code'];
      empdata.empCompName = Profile['emp_Comp_Name'];
      empdata.empDepartmentName = Profile['emp_Department_Name'];
      empdata.empName = Profile['emp_Name'];
      empdata.empNationality = Profile['emp_Nationality'];
      empdata.empPositionName = Profile['emp_Position_Name'];
    });
  }

  getEmpDailyEmployeeAPI(empCode) async {
    empdaily = await GetEmpDailyEmployee(empCode);
    print(empdaily);
    searchempdaily = true;
  }

  @override
  void initState() {
    GetAPI();

    // _data = widget.listtimesheet;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      empCode: widget.EmpCode,
      empName: empdata.empName,
      actionButton: _buildAddTimesheet(),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyButton(
                  onPressed: addEmployee,
                  text: 'เพิ่มพนักงาน',
                  buttonColor: Colors.blue[900]!,
                  textColor: Colors.white,
                  textStyle: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            MyTextField(
              controller: editingController,
              hintText: 'ค้นหารหัสพนักงาน / ชื่อ',
              prefixIcon: const Icon(
                Icons.search,
                size: 22,
              ),
              onChanged: (value) {
                setState(() {
                  _data =
                      itemsList.where((res) => res.types == '0').where((item) {
                    return item.empName!.contains(value) ||
                        item.empCode!.contains(value);
                  }).toList();
                  _dataAdd =
                      itemsList.where((res) => res.types == '1').where((item) {
                    return item.empName!.contains(value) ||
                        item.empCode!.contains(value);
                  }).toList();
                });
              },
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: ListTileTheme(
                    horizontalTitleGap: 2.0,
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      //selectedTileColor: Theme.of(context).primaryColor,
                      dense: true,
                      title: Text(
                        'เลือกพนักงานทั้งหมด',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      value: valall,
                      onChanged: (value) {
                        setState(() {
                          if (valall == false) {
                            valall = true;
                            for (var element in _data) {
                              if (checkboxEmp(element.empCode) == true) {
                                ckboxEmp.add(element.empCode!);
                              }
                            }

                            for (var element in _dataAdd) {
                              if (checkboxEmp(element.empCode) == true) {
                                ckboxEmp.add(element.empCode!);
                              }
                            }
                          } else {
                            valall = false;
                            for (var element in _data) {
                              if (checkboxEmp(element.empCode) == false) {
                                ckboxEmp.remove(element.empCode!);
                              }
                            }

                            for (var element in _dataAdd) {
                              if (checkboxEmp(element.empCode) == false) {
                                ckboxEmp.remove(element.empCode!);
                              }
                            }
                          }
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: Text(
                    'จำนวนพนักงาน ${_data.length + _dataAdd.length} คน',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.amber.shade800),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            _buildEmployeeList(_data),
            const SizedBox(height: 28.0),
            if (_dataAdd.isNotEmpty)
              Text(
                'พนักงานที่เพิ่ม',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
            const SizedBox(height: 12.0),
            _buildEmployeeList(_dataAdd),
            const SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }

  String _getDisplayTime(DateTime value) {
    return '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
  }

  void _showTimePicker({
    DateTime? value,
    void Function(Picker, List<int>)? onConfirm,
  }) {
    Picker(
      cancelText: 'ยกเลิก',
      confirmText: 'ตกลง',
      //cancelTextStyle: TextStyle(fontFamily: Fonts.fonts),
      //confirmTextStyle: TextStyle(fontFamily: Fonts.fonts),
      hideHeader: true,
      adapter: DateTimePickerAdapter(
        minuteInterval: 15,
        value: value,
        customColumnType: [3, 4],
      ),
      title: const Text(""),
      selectedTextStyle: const TextStyle(color: Colors.blue),
      onConfirm: onConfirm,
    ).showDialog(context);
  }

  Widget _buildEmployeeList(List<Employeelist> data) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: data.map((Employeelist item) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 0.0, color: Colors.grey.shade400),
            ),
          ),
          child: ListTile(
            trailing: SizedBox(
              width: 80.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(Icons.chevron_right),
                ],
              ),
            ),
            title: ListTileTheme(
              horizontalTitleGap: 2.0,
              child: CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.empCode!,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.black45,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                          ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      item.empName!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                value: (ckboxEmp.isEmpty) ? false : !checkboxEmp(item.empCode!),
                onChanged: (value) {
                  setState(() {
                    valall = false;

                    if (checkboxEmp(item.empCode!)) {
                      ckboxEmp.add(item.empCode!);
                    } else {
                      ckboxEmp.remove(item.empCode!);
                    }

                    print(ckboxEmp);
                  });
                },
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmployeeDetail(
                    index: 1,
                    empCode: widget.EmpCode,
                    empDetail: item,
                    url: widget.url,
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );

    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          data[index].isExpanded = !isExpanded;
        });
      },
      children: data.map<ExpansionPanel>((Employeelist item) {
        return ExpansionPanel(
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: ListTileTheme(
                  horizontalTitleGap: 2.0,
                  child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Row(
                      children: [
                        Text(
                          item.empCode!,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        GoogleFonts.jetBrainsMono().fontFamily,
                                  ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          item.empName!,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    value: (ckboxEmp.isEmpty)
                        ? false
                        : !checkboxEmp(item.empCode!),
                    onChanged: (value) {
                      setState(() {
                        valall = false;

                        if (checkboxEmp(item.empCode!)) {
                          ckboxEmp.add(item.empCode!);
                        } else {
                          ckboxEmp.remove(item.empCode!);
                        }

                        print(ckboxEmp);
                      });
                    },
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmployeeDetail(
                        index: 1,
                        empCode: widget.EmpCode,
                        empDetail: item,
                        url: widget.url,
                      ),
                    ),
                  );
                },
              );
            },
            body: ListTile(
              tileColor: Colors.grey[100],
              subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 10),
                  ]),
              // isThreeLine: true,
            ),
            isExpanded:
                // checkvalueHideEmp(item.empCode!) ? item.isExpanded : false,
                false);
      }).toList(),
    );
  }

  Widget _buildAddTimesheet() {
    return ElevatedButton.icon(
      onPressed: () => {
        if (ckboxEmp.isNotEmpty)
          {
            Dialogs.materialDialog(
              context: context,
              dialogWidth: MediaQuery.of(context).size.width < 500
                  ? MediaQuery.of(context).size.width
                  : 500,
              actions: [
                Column(
                  children: [
                    Text(
                      'เวลาปฏิบัติงาน',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'บันทึกเวลางาน ของวันที่ ${formatDateTH(GetDateTimeCurrent())}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    /* ปุ่ม 'บันทึกเวลาทำงาน' */
                    _buildButtonSaveWorkHours(),
                    /* ปุ่ม 'ลาป่วย' */
                    _buildButtonLeaveSick(),
                    /* ปุ่ม 'ลาไม่รับค่าจ้าง' */
                    _buildButtonLeaveWithoutPay(),
                    /* ปุ่ม 'ลาคลอด' */
                    _buildButtonLeaveMaternity(),
                  ],
                ),
              ],
            ),
          }
        else
          {
            Dialogs.materialDialog(
                msg: 'กรุณาเลือกพนักงานก่อนทำรายการ',
                title: 'ตรวจสอบข้อมูล',
                context: context,
                actions: [
                  IconsButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    text: 'ตกลง',
                    iconData: Icons.check_circle_outline,
                    color: Colors.green,
                    textStyle: const TextStyle(
                      color: Colors.white,
                    ),
                    iconColor: Colors.white,
                  ),
                ]),
          }
      },

      icon: const Icon(
        FontAwesomeIcons.plus,
        size: 12,
        color: Colors.black,
      ),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Text(
          'เพิ่มรายการ',
          style: TextStyle(
            fontFamily: Fonts.fonts,
            color: Colors.black,
          ),
        ),
      ), //label text
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: Colors.white,
        textStyle: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }

  Widget _buildButtonSaveWorkHours() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: MyButton(
          text: 'บันทึกเวลาทำงาน',
          textColor: Colors.white,
          buttonColor: const Color.fromARGB(255, 64, 79, 74),
          verticalPadding: 10.0,
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();

            TextOTBeforeStart = "";
            TextOTBeforeEnd = "";
            TextDefultOneStart = "";
            TextDefultOneEnd = "";
            TextOTAfterStart = "";
            TextOTAfterEnd = "";
            showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      backgroundColor: Dialogs.bcgColor,
                      // content: Dialogs.holder,
                      shape: Dialogs.dialogShape,
                      title: const Center(
                        child: Text(
                          "บันทึกเวลาทำงาน",
                          style: Dialogs.titleStyle,
                        ),
                      ),
                      content: SingleChildScrollView(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width < 500
                              ? MediaQuery.of(context).size.width
                              : 500,
                          // height: 500,
                          child: Column(
                            children: [
                              Text(
                                'จำนวนพนักงานที่เลือก ${ckboxEmp.length} คน',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              /* เวลาทำงานปกติ */
                              MyBox(
                                title: 'เวลาทำงานปกติ',
                                borderColor: Colors.green.shade400,
                                child: Row(
                                  children: [
                                    MyTimePickerRow(
                                      labelStart: 'เวลาเริ่มงาน',
                                      labelEnd: 'เวลาจบงาน',
                                      textStart: TextDefultOneStart,
                                      textEnd: TextDefultOneEnd,
                                      onPressedStart: () => _showTimePicker(
                                          value: DefultOneStart,
                                          onConfirm:
                                              (Picker picker, List value) {
                                            var result = (picker.adapter
                                                    as DateTimePickerAdapter)
                                                .value;
                                            if (result != null) {
                                              setState(() {
                                                DefultOneStart = result;
                                                TextDefultOneStart =
                                                    _getDisplayTime(
                                                        DefultOneStart);
                                              });
                                            }
                                          }),
                                      onPressedEnd: () => _showTimePicker(
                                          value: DefultOneEnd,
                                          onConfirm:
                                              (Picker picker, List value) {
                                            var result = (picker.adapter
                                                    as DateTimePickerAdapter)
                                                .value;
                                            if (result != null) {
                                              setState(() {
                                                DefultOneEnd = result;
                                                TextDefultOneEnd =
                                                    _getDisplayTime(
                                                        DefultOneEnd);
                                              });
                                            }
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              /* เวลาทำงานล่วงเวลา */
                              MyBox(
                                title: 'เวลาทำงานล่วงเวลา',
                                borderColor: Colors.blue.shade400,
                                child: Column(
                                  children: [
                                    MyTimePickerRow(
                                      labelStart: 'เวลาเริ่มล่วงเวลา',
                                      labelEnd: 'เวลาจบล่วงเวลา',
                                      textStart: TextOTBeforeStart,
                                      textEnd: TextOTBeforeEnd,
                                      onPressedStart: () => _showTimePicker(
                                          value: OTBeforeStart,
                                          onConfirm:
                                              (Picker picker, List value) {
                                            var result = (picker.adapter
                                                    as DateTimePickerAdapter)
                                                .value;
                                            if (result != null) {
                                              setState(() {
                                                OTBeforeStart = result;
                                                TextOTBeforeStart =
                                                    _getDisplayTime(
                                                        OTBeforeStart);
                                              });
                                            }
                                          }),
                                      onPressedEnd: () => _showTimePicker(
                                          value: OTBeforeEnd,
                                          onConfirm:
                                              (Picker picker, List value) {
                                            var result = (picker.adapter
                                                    as DateTimePickerAdapter)
                                                .value;
                                            if (result != null) {
                                              setState(() {
                                                OTBeforeEnd = result;
                                                TextOTBeforeEnd =
                                                    _getDisplayTime(
                                                        OTBeforeEnd);
                                              });
                                            }
                                          }),
                                    ),
                                    const SizedBox(height: 10),
                                    MyTimePickerRow(
                                      labelStart: 'เวลาเริ่มล่วงเวลา',
                                      labelEnd: 'เวลาจบล่วงเวลา',
                                      textStart: TextOTAfterStart,
                                      textEnd: TextOTAfterEnd,
                                      onPressedStart: () => _showTimePicker(
                                          value: OTAfterStart,
                                          onConfirm:
                                              (Picker picker, List value) {
                                            var result = (picker.adapter
                                                    as DateTimePickerAdapter)
                                                .value;
                                            if (result != null) {
                                              setState(() {
                                                OTAfterStart = result;
                                                TextOTAfterStart =
                                                    _getDisplayTime(
                                                        OTAfterStart);
                                              });
                                            }
                                          }),
                                      onPressedEnd: () => _showTimePicker(
                                          value: OTAfterEnd,
                                          onConfirm:
                                              (Picker picker, List value) {
                                            var result = (picker.adapter
                                                    as DateTimePickerAdapter)
                                                .value;
                                            if (result != null) {
                                              setState(() {
                                                OTAfterEnd = result;
                                                TextOTAfterEnd =
                                                    _getDisplayTime(OTAfterEnd);
                                              });
                                            }
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              /* เนื้องาน */
                              Row(
                                children: const [
                                  Text('เนื้องาน'),
                                  SizedBox(height: 2.0),
                                ],
                              ),
                              DropdownButtonFormField(
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 2.0,
                                    horizontal: 12.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4.0),
                                    ),
                                  ),
                                ),
                                hint: const Text('เลือกรายละเอียด'),
                                // value: 'J001',
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: jobms
                                    .map((JobMaster jobDetailTop) =>
                                        DropdownMenuItem(
                                          // alignment: AlignmentDirectional.center,
                                          value: jobDetailTop.jobCode,
                                          child: Text(jobDetailTop.jobName!),
                                        ))
                                    .toList(),
                                onChanged: (val) {
                                  setState(() {
                                    jobdetail = val.toString();
                                  });
                                },
                              ),
                              const SizedBox(height: 16),

                              /* สถานที่ */
                              Row(
                                children: const [
                                  Text('สถานที่'),
                                  SizedBox(height: 2.0),
                                ],
                              ),
                              DropdownButtonFormField(
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 2.0,
                                    horizontal: 12.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4.0),
                                    ),
                                  ),
                                ),
                                hint: const Text('เลือกรายละเอียด'),
                                //  value: locationName, //locationName,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: locationms
                                    .map((LocationMaster jobDetailTop) =>
                                        DropdownMenuItem(
                                          // alignment: AlignmentDirectional.center,
                                          value: jobDetailTop.locationCode,
                                          child:
                                              Text(jobDetailTop.locationName!),
                                        ))
                                    .toList(),
                                onChanged: (val) {
                                  setState(() {
                                    locationName = val.toString();
                                  });
                                },
                              ),
                              const SizedBox(height: 16),

                              /* หมายเหตุ */
                              Row(
                                children: const [
                                  Text('หมายเหตุ'),
                                  SizedBox(height: 2.0),
                                ],
                              ),
                              MyTextField(
                                controller: editingRemark,
                                maxLines: 3,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                  horizontal: 12.0,
                                ),
                              ),
                              const SizedBox(height: 24),

                              /* ปุ่ม 'บันทึก' */
                              MyButton(
                                onPressed: () {
                                  //////function check time

                                  var ckOTBefore = "";
                                  var ckOTBeforestart = "";
                                  var ckDefultOne = "";
                                  var ckDefultOnestart = "";
                                  var ckOTAfter = "";
                                  var ckOTOTAfterstart = "";

                                  ///check ค่าว่าง
                                  if ((TextOTBeforeStart != "") ||
                                      (TextOTBeforeEnd != "")) {
                                    ckOTBefore = 'YES1';

                                    if ((TextOTBeforeStart != "") &&
                                        (TextOTBeforeEnd != "")) {
                                      ckOTBefore = '';

                                      ///check ห้ามน้อยกว่าเวลาเริ่ม
                                      if (OTBeforeStart.isAfter(OTBeforeEnd)) {
                                        ckOTBeforestart = 'OVER1';
                                      }
                                    }
                                  }

                                  if ((TextDefultOneStart != "") ||
                                      (TextDefultOneEnd != "")) {
                                    ckDefultOne = 'YES2';

                                    if ((TextDefultOneStart != "") &&
                                        (TextDefultOneEnd != "")) {
                                      ckDefultOne = '';

                                      ///check ห้ามน้อยกว่าเวลาเริ่ม
                                      if (DefultOneStart.isAfter(
                                          DefultOneEnd)) {
                                        ckDefultOnestart = 'OVER2';
                                      }
                                    }
                                  }

                                  if ((TextOTAfterStart != "") ||
                                      (TextOTAfterEnd != "")) {
                                    ckOTAfter = 'YES4';

                                    if ((TextOTAfterStart != "") &&
                                        (TextOTAfterEnd != "")) {
                                      ckOTAfter = '';

                                      ///check ห้ามน้อยกว่าเวลาเริ่ม
                                      if (OTAfterStart.isAfter(OTAfterEnd)) {
                                        ckOTOTAfterstart = 'OVER4';
                                      }
                                    }
                                  }

                                  if ((((ckOTBefore != "") ||
                                              (ckDefultOne != "") ||
                                              (ckOTAfter != "")) ||
                                          ((ckOTBeforestart != "") ||
                                              (ckDefultOnestart != "") ||
                                              (ckOTOTAfterstart != ""))) ||
                                      ((TextOTBeforeStart == "") &&
                                          (TextOTBeforeEnd == "") &&
                                          (TextDefultOneStart == "") &&
                                          (TextDefultOneEnd == "") &&
                                          (TextOTAfterStart == "") &&
                                          (TextOTAfterEnd == ""))) {
                                    Dialogs.materialDialog(
                                        msg:
                                            'กรุณาตรวจสอบเวลาเริ่มต้นและเวลาสิ้นสุดให้ถูกต้อง',
                                        title: 'ตรวจสอบข้อมูล',
                                        context: context,
                                        actions: [
                                          IconsButton(
                                            onPressed: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                            },
                                            text: 'ตกลง',
                                            iconData:
                                                Icons.check_circle_outline,
                                            color: Colors.green,
                                            textStyle: const TextStyle(
                                              color: Colors.white,
                                            ),
                                            iconColor: Colors.white,
                                          ),
                                        ]);
                                  } else if (locationName == '' ||
                                      jobdetail == '') {
                                    Dialogs.materialDialog(
                                        msg:
                                            'กรุณาตรวจสอบ งาน และ สถานที่ทำงาน',
                                        title: 'ตรวจสอบข้อมูล',
                                        context: context,
                                        actions: [
                                          IconsButton(
                                            onPressed: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                            },
                                            text: 'ตกลง',
                                            iconData:
                                                Icons.check_circle_outline,
                                            color: Colors.green,
                                            textStyle: const TextStyle(
                                              color: Colors.white,
                                            ),
                                            iconColor: Colors.white,
                                          ),
                                        ]);
                                  } else {
                                    String arrayText = "";

                                    List<DateTime> typeTimeStart = [];
                                    List<DateTime> typeTimeEnd = [];
                                    if (TextOTBeforeEnd != "") {
                                      typeTimeStart.add(OTBeforeStart);
                                      typeTimeEnd.add(OTBeforeEnd);

                                      arrayText =
                                          '{"201": ["$OTBeforeStart", "$OTBeforeEnd"]';
                                    }
                                    if (TextDefultOneEnd != "") {
                                      typeTimeStart.add(DefultOneStart);
                                      typeTimeEnd.add(DefultOneEnd);

                                      if (arrayText == "") {
                                        arrayText = '{';
                                      } else {
                                        arrayText += ',';
                                      }
                                      arrayText +=
                                          '"100": ["$DefultOneStart", "$DefultOneEnd"]';
                                    }
                                    if (TextOTAfterEnd != "") {
                                      typeTimeStart.add(OTAfterStart);
                                      typeTimeEnd.add(OTAfterEnd);

                                      if (arrayText == "") {
                                        arrayText += '{';
                                      } else {
                                        arrayText += ',';
                                      }
                                      arrayText +=
                                          '"202": ["$OTAfterStart", "$OTAfterEnd"]';
                                    }

                                    arrayText += "}";

                                    var tagsJson = jsonDecode(arrayText);

                                    Dialogs.materialDialog(
                                      msg: 'ท่านต้องการบันทึกข้อมูลใช่หรือไม่?',
                                      title: 'ยืนยันข้อมูล',
                                      context: context,
                                      actions: [
                                        IconsOutlineButton(
                                          onPressed: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                          },
                                          text: 'ไม่',
                                          iconData: Icons.cancel_outlined,
                                          color: Colors.white,
                                          textStyle: const TextStyle(
                                              color: Colors.black),
                                          iconColor: Colors.black,
                                        ),
                                        IconsButton(
                                          text: 'ใช่',
                                          iconData: Icons.check_circle_outline,
                                          color: Colors.green,
                                          textStyle: const TextStyle(
                                              color: Colors.white),
                                          iconColor: Colors.white,
                                          onPressed: () {
                                            datasavetimesheet(
                                                arrayText, '', '', '');
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                          },
                                        ),
                                      ],
                                    );
                                  }
                                },
                                text: 'บันทึก',
                                textColor: Colors.white,
                              ),
                              const SizedBox(height: 16.0),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildButtonLeaveSick() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: MyButton(
          text: 'ลาป่วย',
          textColor: Colors.white,
          buttonColor: const Color.fromARGB(255, 192, 0, 0).withOpacity(0.8),
          verticalPadding: 10.0,
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      backgroundColor: Dialogs.bcgColor,
                      // content: Dialogs.holder,
                      shape: Dialogs.dialogShape,
                      title: const Center(
                        child: Text(
                          'ลาป่วย',
                          style: Dialogs.titleStyle,
                        ),
                      ),
                      content: SizedBox(
                        width: MediaQuery.of(context).size.width < 500
                            ? MediaQuery.of(context).size.width
                            : 500,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'จำนวนพนักงานที่เลือก ${ckboxEmp.length} คน',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            // MyBox(
                            //   borderColor: Colors.grey[400],
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       const Text('ลาป่วย : เวลา '),
                            //       //MyPickerButton(text: '$TextLeavesickAllStart - $TextLeavesickAllEnd'),
                            //       OutlinedButton(
                            //         onPressed: () {},
                            //         child: Text(
                            //             '$TextLeavesickAllStart - $TextLeavesickAllEnd'),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            const SizedBox(height: 24),

                            /* ปุ่ม 'บันทึก' */
                            MyButton(
                              onPressed: () {
                                //////function check time

                                String arrayText =
                                    '{"301": ["$LeavesickAllStart", "$LeavesickAllEnd"]}';

                                var tagsJson = jsonDecode(arrayText);

                                Dialogs.materialDialog(
                                  msg: 'ท่านต้องการบันทึกข้อมูลใช่หรือไม่?',
                                  title: 'ยืนยันข้อมูล',
                                  context: context,
                                  actions: [
                                    IconsOutlineButton(
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                      text: 'ไม่',
                                      iconData: Icons.cancel_outlined,
                                      color: Colors.white,
                                      textStyle:
                                          const TextStyle(color: Colors.black),
                                      iconColor: Colors.black,
                                    ),
                                    IconsButton(
                                      text: 'ใช่',
                                      iconData: Icons.check_circle_outline,
                                      color: Colors.green,
                                      textStyle:
                                          const TextStyle(color: Colors.white),
                                      iconColor: Colors.white,
                                      onPressed: () {
                                        datasavetimesheet(
                                            arrayText, '', '', '');
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                              text: 'บันทึก',
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildButtonLeaveMaternity() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: MyButton(
          text: 'ลาคลอด',
          textColor: Colors.white,
          buttonColor: const Color.fromARGB(255, 192, 0, 0).withOpacity(0.8),
          verticalPadding: 10.0,
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      backgroundColor: Dialogs.bcgColor,
                      // content: Dialogs.holder,
                      shape: Dialogs.dialogShape,
                      title: const Center(
                        child: Text(
                          'ลาคลอด',
                          style: Dialogs.titleStyle,
                        ),
                      ),
                      content: SizedBox(
                        width: MediaQuery.of(context).size.width < 500
                            ? MediaQuery.of(context).size.width
                            : 500,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'จำนวนพนักงานที่เลือก ${ckboxEmp.length} คน',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: const [
                                Text('วันที่เริ่มลา'),
                                SizedBox(height: 2.0),
                              ],
                            ),
                            MyTextField(
                              controller: LeaveStartDate,
                              hintText: 'เลือกวันที่',
                              suffixIcon: const Icon(
                                Icons.calendar_today,
                              ),
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  locale: const Locale("th", "TH"),
                                  initialDate: DateTime(
                                    DateTime.now().year + 543,
                                    DateTime.now().month,
                                    DateTime.now().day,
                                  ),
                                  firstDate: DateTime(2500),
                                  //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(3000),
                                );

                                var formattedDate =
                                    DateFormat("dd/MM/yyyy'").format(
                                  DateTime(
                                    pickedDate!.year,
                                    pickedDate.month,
                                    pickedDate.day,
                                  ),
                                );
                                setState(() {
                                  LeaveStartDate.text = formattedDate;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: const [
                                Text('วันที่สิ้นสุดลา'),
                                SizedBox(height: 2.0),
                              ],
                            ),
                            MyTextField(
                              controller: LeaveStartDate,
                              hintText: 'เลือกวันที่',
                              suffixIcon: const Icon(
                                Icons.calendar_today,
                              ),
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  locale: const Locale("th", "TH"),
                                  initialDate: DateTime(
                                    DateTime.now().year + 543,
                                    DateTime.now().month,
                                    DateTime.now().day,
                                  ),
                                  firstDate: DateTime(2500),
                                  //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(3000),
                                );

                                var formattedDate =
                                    DateFormat("dd/MM/yyyy'").format(
                                  DateTime(
                                    pickedDate!.year,
                                    pickedDate.month,
                                    pickedDate.day,
                                  ),
                                );
                                setState(() {
                                  LeaveEndDate.text = formattedDate;
                                });
                              },
                            ),
                            const SizedBox(height: 24),

                            /* ปุ่ม 'บันทึก' */
                            MyButton(
                              onPressed: () {
                                //////function check time
                                DateTime valdateStart = DateFormat('dd/MM/yyyy')
                                    .parse(LeaveStartDate.text);
                                DateTime valdateEnd = DateFormat('dd/MM/yyyy')
                                    .parse(LeaveEndDate.text);

                                DateTime dtStart = new DateTime(
                                        valdateStart.year - 543,
                                        valdateStart.month,
                                        valdateStart.day)
                                    .add(new Duration(hours: 8, minutes: 30));

                                DateTime dtEnd = new DateTime(
                                        valdateEnd.year - 543,
                                        valdateEnd.month,
                                        valdateEnd.day)
                                    .add(new Duration(hours: 17, minutes: 30));

                                DateTime CurrentDate = GetDateTimeCurrent();
                                print(CurrentDate);
                                print(dtStart);
                                if (dtEnd.isBefore(dtStart)) {
                                  Dialogs.materialDialog(
                                      msg:
                                          'กรุณาตรวจสอบวันที่การลา เวลาสิ้นสุด ต้องมากกว่าเวลาเริ่ม',
                                      title: 'ตรวจสอบข้อมูล',
                                      context: context,
                                      actions: [
                                        IconsButton(
                                          onPressed: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                          },
                                          text: 'ตกลง',
                                          iconData: Icons.check_circle_outline,
                                          color: Colors.green,
                                          textStyle: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          iconColor: Colors.white,
                                        ),
                                      ]);
                                } else if (CurrentDate.isAfter(new DateTime(
                                    valdateStart.year - 543,
                                    valdateStart.month,
                                    valdateStart.day))) {
                                  Dialogs.materialDialog(
                                      msg:
                                          'กรุณาตรวจสอบวันที่การลาไม่ให้ลงย้อนหลัง',
                                      title: 'ตรวจสอบข้อมูล',
                                      context: context,
                                      actions: [
                                        IconsButton(
                                          onPressed: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                          },
                                          text: 'ตกลง',
                                          iconData: Icons.check_circle_outline,
                                          color: Colors.green,
                                          textStyle: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          iconColor: Colors.white,
                                        ),
                                      ]);
                                } else {
                                  String arrayText =
                                      '{"302": ["$dtStart", "$dtEnd"]}';

                                  var tagsJson = jsonDecode(arrayText);

                                  Dialogs.materialDialog(
                                    msg: 'ท่านต้องการบันทึกข้อมูลใช่หรือไม่?',
                                    title: 'ยืนยันข้อมูล',
                                    context: context,
                                    actions: [
                                      IconsOutlineButton(
                                        onPressed: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        },
                                        text: 'ไม่',
                                        iconData: Icons.cancel_outlined,
                                        color: Colors.white,
                                        textStyle: const TextStyle(
                                            color: Colors.black),
                                        iconColor: Colors.black,
                                      ),
                                      IconsButton(
                                        text: 'ใช่',
                                        iconData: Icons.check_circle_outline,
                                        color: Colors.green,
                                        textStyle: const TextStyle(
                                            color: Colors.white),
                                        iconColor: Colors.white,
                                        onPressed: () {
                                          datasavetimesheet(
                                              arrayText, '', '', '');
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        },
                                      ),
                                    ],
                                  );
                                }
                              },
                              text: 'บันทึก',
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildButtonLeaveWithoutPay() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: MyButton(
          text: 'ลาไม่รับค่าจ้าง',
          textColor: Colors.white,
          buttonColor: const Color.fromARGB(255, 192, 0, 0).withOpacity(0.8),
          verticalPadding: 10.0,
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      backgroundColor: Dialogs.bcgColor,
                      // content: Dialogs.holder,
                      shape: Dialogs.dialogShape,
                      title: const Center(
                        child: Text(
                          'ลาไม่รับค่าจ้าง',
                          style: Dialogs.titleStyle,
                        ),
                      ),
                      content: SizedBox(
                        width: MediaQuery.of(context).size.width < 500
                            ? MediaQuery.of(context).size.width
                            : 500,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'จำนวนพนักงานที่เลือก ${ckboxEmp.length} คน',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            // MyBox(
                            //   borderColor: Colors.grey[400],
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       const Text('ลาป่วย : เวลา '),
                            //       //MyPickerButton(text: '$TextLeavesickAllStart - $TextLeavesickAllEnd'),
                            //       OutlinedButton(
                            //         onPressed: () {},
                            //         child: Text(
                            //             '$TextLeavesickAllStart - $TextLeavesickAllEnd'),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            const SizedBox(height: 24),

                            /* ปุ่ม 'บันทึก' */
                            MyButton(
                              onPressed: () {
                                //////function check time

                                String arrayText =
                                    '{"300": ["$LeavesickAllStart", "$LeavesickAllEnd"]}';

                                var tagsJson = jsonDecode(arrayText);

                                Dialogs.materialDialog(
                                  msg: 'ท่านต้องการบันทึกข้อมูลใช่หรือไม่?',
                                  title: 'ยืนยันข้อมูล',
                                  context: context,
                                  actions: [
                                    IconsOutlineButton(
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                      text: 'ไม่',
                                      iconData: Icons.cancel_outlined,
                                      color: Colors.white,
                                      textStyle:
                                          const TextStyle(color: Colors.black),
                                      iconColor: Colors.black,
                                    ),
                                    IconsButton(
                                      text: 'ใช่',
                                      iconData: Icons.check_circle_outline,
                                      color: Colors.green,
                                      textStyle:
                                          const TextStyle(color: Colors.white),
                                      iconColor: Colors.white,
                                      onPressed: () {
                                        datasavetimesheet(
                                            arrayText, '', '', '');
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                              text: 'บันทึก',
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
