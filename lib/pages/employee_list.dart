import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:k2mobileapp/home.dart';
import 'package:k2mobileapp/login.dart';
import 'package:k2mobileapp/main.dart';
import 'package:k2mobileapp/models/DailyTimeSheet.dart';
import 'package:k2mobileapp/models/EmployeeData.dart';
import 'package:k2mobileapp/models/TimesheetData.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:k2mobileapp/theme.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

import '../models/ManpowerEmpData.dart';
import '../models/ManpowerJobDetail.dart';
import 'manpower_list.dart';

class EmployeeList extends StatefulWidget {
  final List<ManpowerEmpData> listtimesheet;
  final int index;
  final String EmpCode;
  final String url;
  final ManpowerJobDetail manpower;

  const EmployeeList(
      {Key? key,
      required this.listtimesheet,
      required this.index,
      required this.EmpCode,
      required this.url,
      required this.manpower})
      : super(key: key);

  @override
  State<EmployeeList> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<EmployeeList> {
  List<ManpowerEmpData> _data = [];
  Duration work_yesterday = Duration(hours: 9, minutes: 00);
  TextEditingController timestart = TextEditingController();

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

  ReplaceStatusTime(text) {
    var statustext = "";
    if (text == '100') {
      statustext = 'ทำงาน';
    } else if (text == '101') {
      statustext = 'โอทีก่อน';
    } else if (text == '102') {
      statustext = 'ช่วงแรก';
    } else if (text == '103') {
      statustext = 'ช่วงหลัง';
    } else if (text == '104') {
      statustext = 'โอทีหลัง';
    } else if (text == '201' ||
        text == '202' ||
        text == '203' ||
        text == '204') {
      statustext = 'ลา';
    } else {
      statustext = 'ไม่มี';
    }

    return statustext.toString();
  }

  checkvalueHideEmp(emp) {
    final index = HideEmp.indexWhere((note) => note.startsWith(emp));
    if (index < 0) {
      return true;
    } else {
      return false;
    }
  }

//ทำงาน
  DateTime OTBeforeStart = DateTime.now();
  DateTime OTBeforeEnd = DateTime.now();
  DateTime DefultOneStart = DateTime.now();
  DateTime DefultOneEnd = DateTime.now();
  DateTime DefultTwoStart = DateTime.now();
  DateTime DefultTwoEnd = DateTime.now();
  DateTime OTAfterStart = DateTime.now();
  DateTime OTAfterEnd = DateTime.now();

  String TextOTBeforeStart = "";
  String TextOTBeforeEnd = "";
  String TextDefultOneStart = "";
  String TextDefultOneEnd = "";
  String TextDefultTwoStart = "";
  String TextDefultTwoEnd = "";
  String TextOTAfterStart = "";
  String TextOTAfterEnd = "";

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
  DateTime LeavesickAllStart =
      DateTime.now().subtract(Duration(hours: 08, minutes: 00));
  DateTime LeavesickAllEnd =
      DateTime.now().subtract(Duration(hours: 17, minutes: 30));

  String TextLeavesickAllStart = "08:00";
  String TextLeavesickAllEnd = "17:30";

//ลาไม่รับค่าจ้างบางช่วงเวลา
  DateTime LeaveunpaidAllStart =
      DateTime.now().subtract(Duration(hours: 08, minutes: 00));
  DateTime LeaveunpaidAllEnd =
      DateTime.now().subtract(Duration(hours: 17, minutes: 30));

  String TextLeaveunpaidAllStart = "08:00";
  String TextLeaveunpaidAllEnd = "17:30";

//แก้ไขเวลา
  DateTime EdittimeStart = DateTime.now();
  DateTime EdittimeEnd = DateTime.now();

  String TextEdittimeStart = "";
  String TextEdittimeEnd = "";

//สภาพหน้างาน
  DateTime LocationStart = DateTime.now();
  DateTime LocationEnd = DateTime.now();

  String TextLocationStart = "";
  String TextLocationEnd = "";

////////

  String dropdownValue = 'พื้นที่ไม่พร้อม';
  List<String> LocationDetail = [
    'พื้นที่ไม่พร้อม',
    'วัสดุไม่พร้อม',
    'เครื่องจักรไม่พร้อม'
  ];

  List<String> HideEmp = [];

  bool statusLocation = false;

  void GetManpowerEmployeeList() async {
    try {
      var _baseUrl =
          "https://dev-unique.com:9012/api/Interface/GetDailyEmployee?Emp_Code=4300001";
      final res = await http.get(
        Uri.parse("$_baseUrl"),
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);

        final parsedJson = jsonDecode(res.body);

        if (parsedJson['type'] == "S") {
          List<dynamic> parsedListJson = jsonDecode(parsedJson['description']);

          List<ManpowerEmpData> lstEmp = List<ManpowerEmpData>.from(
              parsedListJson.map<ManpowerEmpData>(
                  (dynamic i) => ManpowerEmpData.fromJson(i)));

          ///check 9.00
          DateTime NewDate = DateTime.now();

          Duration work_yesterday =
              Duration(hours: Cutofftime.hours, minutes: Cutofftime.minutes);

          if ((NewDate.hour < work_yesterday.inHours) ||
              ((NewDate.hour == work_yesterday.inHours) &&
                  (NewDate.minute < work_yesterday.inMinutes.remainder(60)))) {
            NewDate = DateTime.now().add(new Duration(days: -1));
          } else {
            NewDate = DateTime.now();
          }

          String formattedDate = DateFormat('yyyy-MM-dd').format(NewDate);

          for (var empData in lstEmp) {
            var _serviceBaseURL =
                "https://dev-unique.com:9012/api/Interface/GetDailyTimeSheet?Emp_Code=${empData.empCode}&DateTime=${formattedDate}";
            final res_emp = await http.get(
              Uri.parse("$_serviceBaseURL"),
            );

            if (res_emp.statusCode == 200) {
              final jsonDataEmp = json.decode(res_emp.body);

              final parsedJsonEmp = jsonDecode(res_emp.body);

              if (parsedJsonEmp['type'] == "S") {
                List<dynamic> parsedListJsonEmp =
                    jsonDecode(parsedJsonEmp['description']);

                List<DailyTimeSheet> lstEmpData = List<DailyTimeSheet>.from(
                    parsedListJsonEmp.map<DailyTimeSheet>(
                        (dynamic i) => DailyTimeSheet.fromJson(i)));

                empData.lstDaily = lstEmpData;
                if (lstEmpData.length > 0)
                  empData.SumTime = lstEmpData[0].sumtimes!.substring(1, 5);
                else
                  empData.SumTime = "00:00";

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EmployeeList(
                          index: widget.index,
                          listtimesheet: lstEmp,
                          EmpCode: widget.EmpCode,
                          url: widget.url,
                          manpower: widget.manpower)
                      // homepage(
                      //     index: 1,
                      //     listtimesheet: [],
                      //     EmpCode: widget.EmpCode,
                      //     ShowPopup: '',
                      //     url: widget.url)
                      ),
                );
              }
            }
          }

          setState(() {
            EmpList = lstEmp;
          });
        }
      }
    } catch (err) {
      print('Something went wrong');
    }
  }

  void datasavetimesheet(
      var arrayText, var empcode, var costCenter, var jobcode) async {
    const JsonDecoder decoder = JsonDecoder();
    var Datenow = DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(DateTime.now());
    Map decoded = jsonDecode(arrayText);
    int i = 0;
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
      totext += '"emp_Code": "${empcode}",';
      totext += '"time_In": "${Datestart}",';
      totext += '"time_Out": "${DateEnd}",';
      totext += '"jobNo": "${widget.manpower.jobNo}",';
      totext += '"revise_No": "${widget.manpower.reviseNo}",';
      totext += '"type": "Labour",';
      totext += '"supervisor_Code": "${widget.EmpCode}",';
      totext += '"location_Status": "",';
      totext += '"status": "${key}",';
      totext += '"remark": "",';
      totext += '"costCenter": "${costCenter}",';
      if (jobcode != '') {
        totext += '"jobCode": "${jobcode}",';
      }
      totext += '"start_Date": "${Datenow}",';
      totext += '"create_By": "${widget.EmpCode}"';
      totext += '}';
    });

    totext += ']';

    var tojsontext = decoder.convert(totext);
    // print(tojsontext);

    final _baseUrl = '${widget.url}/api/Interface/SaveDailyTimeSheet';
    final res = await http.post(Uri.parse("${_baseUrl}"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(tojsontext));

    setState(() {
      final jsonData = json.decode(res.body);
      print(res.body);

      final parsedJson = jsonDecode(res.body);
      if (parsedJson['type'] == "S") {
        Dialogs.materialDialog(
            msg: 'บันทึกข้อมูลสำเร็จ',
            title: 'ตรวจสอบข้อมูล',
            context: context,
            actions: [
              IconsButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) =>
                  //           EmployeeList(
                  //               index: widget.index,
                  //               listtimesheet: widget.listtimesheet,
                  //               EmpCode: widget.EmpCode,
                  //               url: widget.url,
                  //               manpower: widget.manpower)
                  //           // homepage(
                  //           //   index: 1,
                  //           //   listtimesheet: [],
                  //           //   EmpCode: widget.EmpCode,
                  //           //   ShowPopup: '',
                  //           //   url: widget.url,
                  //           // )
                  //           ),
                  // );
                  GetManpowerEmployeeList();
                },
                text: 'ตกลง',
                iconData: Icons.check_circle_outline,
                color: Colors.green,
                textStyle: TextStyle(color: Colors.white),
                iconColor: Colors.white,
              ),
            ]);
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

  void getlsttimesheet() async {
    var client = http.Client();
    DateTime NewDate = DateTime.now();

    if ((NewDate.hour < work_yesterday.inHours) ||
        ((NewDate.hour == work_yesterday.inHours) &&
            (NewDate.minute <= work_yesterday.inMinutes.remainder(60)))) {
      NewDate = DateTime.now().add(new Duration(days: -1));
    } else {
      NewDate = DateTime.now();
    }
    String formattedDate = DateFormat('yyyy-MM-dd').format(NewDate);
    var uri = Uri.parse(
        "${widget.url}/api/Interface/GetListTimesheeet?Emp_Code=${widget.EmpCode}&dataTime=${formattedDate}");
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

      List<TimesheetData> TestAuto = parsed
          .map<TimesheetData>((json) => TimesheetData.fromJson(json))
          .toList();

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => homepage(
                  index: TestAuto.length,
                  listtimesheet: TestAuto,
                  EmpCode: widget.EmpCode,
                  ShowPopup: '',
                  url: widget.url,
                )),
      );
    }
  }

  EmployeeData empdata = new EmployeeData(
      empCode: '',
      empCompName: '',
      empDepartmentName: '',
      empName: '',
      empNationality: '',
      empPositionName: '');

  void GetEmpProfile() async {
    var client = http.Client();
    var uri = Uri.parse(
        "${widget.url}/api/Interface/GetEmployeeData?EmpCode=${widget.EmpCode}");
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(response.body);

      final parsedJson = jsonDecode(response.body);

      setState(() {
        empdata.empCode = parsedJson['emp_Code'];
        empdata.empCompName = parsedJson['emp_Comp_Name'];
        empdata.empDepartmentName = parsedJson['emp_Department_Name'];
        empdata.empName = parsedJson['emp_Name'];
        empdata.empNationality = parsedJson['emp_Nationality'];
        empdata.empPositionName = parsedJson['emp_Position_Name'];
      });
    }
  }

  Locationstatus() async {
    await Future.delayed(Duration(milliseconds: 10));
    TextLocationStart = "";
    TextLocationEnd = "";
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
                title: Center(
                  child: Text(
                    "สภาพหน้างาน",
                    style: Dialogs.titleStyle,
                  ),
                ),
                // actions: <Widget>[
                //   SizedBox(height: 20),
                //   Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       SizedBox(
                //         width: 100,
                //         child: IconsOutlineButton(
                //           onPressed: () {
                //             Navigator.of(context, rootNavigator: true).pop();
                //           },
                //           text: 'ไม่',
                //           iconData: Icons.cancel_outlined,
                //           color: Colors.white,
                //           textStyle: TextStyle(color: Colors.black),
                //           iconColor: Colors.black,
                //         ),
                //       ),
                //       SizedBox(
                //         width: 10,
                //       ),
                //       SizedBox(
                //         width: 100,
                //         child: IconsButton(
                //           onPressed: () {
                //             Navigator.of(context, rootNavigator: true).pop();
                //           },
                //           text: 'ใช่',
                //           iconData: Icons.check_circle_outline,
                //           color: Colors.green,
                //           textStyle: TextStyle(color: Colors.white),
                //           iconColor: Colors.white,
                //         ),
                //       ),
                //     ],
                //   )
                // ],
                content: SingleChildScrollView(
                  child: Container(
                      width: MediaQuery.of(context).size.width - 10,
                      height: 500,
                      child: Column(
                        children: [
                          SizedBox(height: 15),
                          Row(
                            children: [
                              TextButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue[900],
                                  onPrimary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'พร้อมทำงาน',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13.0),
                                ),
                                onPressed: () {
                                  setState(() {
                                    statusLocation = false;
                                  });
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              TextButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red[900],
                                  onPrimary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'ไม่พร้อม',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13.0),
                                ),
                                onPressed: () {
                                  setState(() {
                                    statusLocation = true;
                                  });
                                },
                              ),
                            ],
                          ),
                          statusLocation
                              ? Expanded(
                                  child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade400),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      Text('เวลาไม่พร้อม'),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text('เริ่ม : '),
                                          OutlinedButton(
                                              child:
                                                  Text('${TextLocationStart}'),
                                              onPressed: () => {
                                                    Picker(
                                                        hideHeader: true,
                                                        cancelText: 'ยกเลิก',
                                                        confirmText: 'ตกลง',
                                                        cancelTextStyle:
                                                            TextStyle(
                                                                fontFamily:
                                                                    Fonts
                                                                        .fonts),
                                                        confirmTextStyle:
                                                            TextStyle(
                                                                fontFamily:
                                                                    Fonts
                                                                        .fonts),
                                                        adapter:
                                                            DateTimePickerAdapter(
                                                          minuteInterval: 15,
                                                          value: LocationStart,
                                                          customColumnType: [
                                                            3,
                                                            4
                                                          ],
                                                        ),
                                                        title: Text(""),
                                                        selectedTextStyle:
                                                            TextStyle(
                                                                color: Colors
                                                                    .blue),
                                                        onConfirm:
                                                            (Picker picker,
                                                                List value) {
                                                          var result = (picker
                                                                      .adapter
                                                                  as DateTimePickerAdapter)
                                                              .value;
                                                          if (result != null) {
                                                            setState(() {
                                                              LocationStart =
                                                                  result;
                                                              TextLocationStart =
                                                                  '${LocationStart.hour.toString().padLeft(2, '0')}:${LocationStart.minute.toString().padLeft(2, '0')}';
                                                            });
                                                          }
                                                        }).showDialog(context),
                                                  }),
                                          Text(' ถึง '),
                                          OutlinedButton(
                                              child: Text('${TextLocationEnd}'),
                                              onPressed: () => {
                                                    Picker(
                                                        cancelText: 'ยกเลิก',
                                                        confirmText: 'ตกลง',
                                                        cancelTextStyle:
                                                            TextStyle(
                                                                fontFamily:
                                                                    Fonts
                                                                        .fonts),
                                                        confirmTextStyle:
                                                            TextStyle(
                                                                fontFamily:
                                                                    Fonts
                                                                        .fonts),
                                                        hideHeader: true,
                                                        adapter:
                                                            DateTimePickerAdapter(
                                                          minuteInterval: 15,
                                                          value: LocationEnd,
                                                          customColumnType: [
                                                            3,
                                                            4
                                                          ],
                                                        ),
                                                        title: Text(""),
                                                        selectedTextStyle:
                                                            TextStyle(
                                                                color: Colors
                                                                    .blue),
                                                        onConfirm:
                                                            (Picker picker,
                                                                List value) {
                                                          var result = (picker
                                                                      .adapter
                                                                  as DateTimePickerAdapter)
                                                              .value;
                                                          if (result != null) {
                                                            setState(() {
                                                              LocationEnd =
                                                                  result;
                                                              TextLocationEnd =
                                                                  '${LocationEnd.hour.toString().padLeft(2, '0')}:${LocationEnd.minute.toString().padLeft(2, '0')}';
                                                            });
                                                          }
                                                        }).showDialog(context),
                                                  }),
                                        ],
                                      ),
                                      Text('รายละเอียด'),
                                      DropdownButtonFormField(
                                        hint: const Text('เลือกรายละเอียด'),
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                        // dropdownColor:
                                        //     Colors
                                        //         .greenAccent,
                                        value: dropdownValue,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropdownValue = newValue!;
                                          });
                                        },
                                        items: LocationDetail.map<
                                                DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                      Text('สาเหตุ'),
                                      TextField(
                                        // key: '',
                                        // controller: remark,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                        maxLines: 2,
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ))
                              : const SizedBox(height: 0),
                          SizedBox(height: 20),
                          statusLocation
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child: IconsOutlineButton(
                                        onPressed: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        },
                                        text: 'ไม่',
                                        iconData: Icons.cancel_outlined,
                                        color: Colors.white,
                                        textStyle:
                                            TextStyle(color: Colors.black),
                                        iconColor: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: IconsButton(
                                        onPressed: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        },
                                        text: 'ใช่',
                                        iconData: Icons.check_circle_outline,
                                        color: Colors.green,
                                        textStyle:
                                            TextStyle(color: Colors.white),
                                        iconColor: Colors.white,
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox(height: 20),
                        ],
                      )),
                ));
          },
        );
      },
    );
  }

  @override
  void initState() {
    GetEmpProfile();

    _data = widget.listtimesheet;
    super.initState();
    Locationstatus();
  }

  bool valall = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: basicTheme(),
        home: DefaultTabController(
            length: 2,
            child: Scaffold(
              body: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient:
                        LinearGradient(begin: Alignment.topCenter, colors: [
                  Color.fromARGB(255, 165, 29, 8),
                  Color.fromARGB(255, 165, 29, 8),
                  Color.fromARGB(255, 165, 29, 8),
                  Color.fromARGB(255, 165, 29, 8),
                  Color.fromARGB(255, 165, 29, 8),
                  Color.fromARGB(255, 165, 29, 8),
                  Color.fromARGB(255, 165, 29, 8),
                ])),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Table(
                        children: [
                          TableRow(children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'บันทึกเวลาทำงาน',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Container(
                                  child: Text(
                                    'สำหรับรายวัน',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextButton.icon(
                                  style: TextButton.styleFrom(
                                    textStyle: TextStyle(fontSize: 14),
                                    padding: EdgeInsets.zero,
                                    alignment: Alignment.centerLeft,
                                    // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  icon: Icon(
                                    Icons.logout,
                                    color: Colors.white,
                                  ),
                                  label: Text('ออกจากระบบ',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: Fonts.fonts)),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Login()),
                                    );
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Center(
                                  child: Text(
                                    '${widget.EmpCode} ${empdata.empName}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: SingleChildScrollView(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 15),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'เลขที่ใบงาน : ${widget.manpower.jobNo}',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                  ),
                                ),
                                // const SizedBox(height: 15),
                                ListView(
                                  shrinkWrap: true,
                                  children: [
                                    Card(
                                        child: ListTile(
                                            // onTap: () {},
                                            title: Row(
                                      children: [
                                        Text(
                                          "สภาพหน้างาน",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.green[900]),
                                        ),
                                        TextButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.blue[900],
                                            onPrimary: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            'แก้ไข',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13.0),
                                          ),
                                          onPressed: () {
                                            Locationstatus();
                                          },
                                        ),
                                      ],
                                    )
                                            // leading: Icon(Icons.ballot)
                                            ))
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ElevatedButton.icon(
                                  icon: Icon(
                                    FontAwesomeIcons.plus,
                                    size: 10,
                                  ),
                                  label: Text(
                                    'ใช้เวลาและกิจกรรมร่วมกัน',
                                    style: GoogleFonts.getFont(Fonts.fonts),
                                  ), //label text
                                  style: ElevatedButton.styleFrom(
                                      shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(8),
                                      ),
                                      primary: Colors.blue[900],
                                      textStyle: TextStyle(
                                        fontSize: 10,
                                      )),
                                  onPressed: () => {
                                    if (valall == false)
                                      {
                                        setState(() {
                                          valall = true;
                                        }),
                                        TextOTBeforeStart = "",
                                        TextOTBeforeEnd = "",
                                        TextDefultOneStart = "",
                                        TextDefultOneEnd = "",
                                        TextDefultTwoStart = "",
                                        TextDefultTwoEnd = "",
                                        TextOTAfterStart = "",
                                        TextOTAfterEnd = "",
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return StatefulBuilder(
                                              builder: (context, setState) {
                                                return AlertDialog(
                                                  backgroundColor:
                                                      Dialogs.bcgColor,
                                                  // content: Dialogs.holder,
                                                  shape: Dialogs.dialogShape,
                                                  title: Center(
                                                    child: Text(
                                                      "ทำงาน",
                                                      style: Dialogs.titleStyle,
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    Column(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .blue
                                                                    .shade400),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5)),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  'โอทีก่อน : เวลา '),
                                                              OutlinedButton(
                                                                onPressed: () =>
                                                                    Picker(
                                                                        hideHeader:
                                                                            true,
                                                                        cancelText:
                                                                            'ยกเลิก',
                                                                        confirmText:
                                                                            'ตกลง',
                                                                        cancelTextStyle: TextStyle(
                                                                            fontFamily: Fonts
                                                                                .fonts),
                                                                        confirmTextStyle: TextStyle(
                                                                            fontFamily: Fonts
                                                                                .fonts),
                                                                        adapter:
                                                                            DateTimePickerAdapter(
                                                                          minuteInterval:
                                                                              15,
                                                                          value:
                                                                              OTBeforeStart,
                                                                          customColumnType: [
                                                                            3,
                                                                            4
                                                                          ],
                                                                        ),
                                                                        title: Text(
                                                                            ""),
                                                                        selectedTextStyle: TextStyle(
                                                                            color: Colors
                                                                                .blue),
                                                                        onConfirm: (Picker
                                                                                picker,
                                                                            List
                                                                                value) {
                                                                          var result =
                                                                              (picker.adapter as DateTimePickerAdapter).value;
                                                                          if (result !=
                                                                              null) {
                                                                            setState(() {
                                                                              OTBeforeStart = result;
                                                                              TextOTBeforeStart = '${OTBeforeStart.hour.toString().padLeft(2, '0')}:${OTBeforeStart.minute.toString().padLeft(2, '0')}';
                                                                            });
                                                                          }
                                                                        }).showDialog(context),
                                                                child: Text(
                                                                    '${TextOTBeforeStart}'),
                                                              ),
                                                              Text(' ถึง '),
                                                              OutlinedButton(
                                                                onPressed: () =>
                                                                    // showPickerDateCustom(
                                                                    //     context,
                                                                    //     'OTBeforeEnd'),
                                                                    Picker(
                                                                        cancelText:
                                                                            'ยกเลิก',
                                                                        confirmText:
                                                                            'ตกลง',
                                                                        cancelTextStyle: TextStyle(
                                                                            fontFamily: Fonts
                                                                                .fonts),
                                                                        confirmTextStyle: TextStyle(
                                                                            fontFamily: Fonts
                                                                                .fonts),
                                                                        hideHeader:
                                                                            true,
                                                                        adapter:
                                                                            DateTimePickerAdapter(
                                                                          minuteInterval:
                                                                              15,
                                                                          value:
                                                                              OTBeforeEnd,
                                                                          customColumnType: [
                                                                            3,
                                                                            4
                                                                          ],
                                                                        ),
                                                                        title: Text(
                                                                            ""),
                                                                        selectedTextStyle: TextStyle(
                                                                            color: Colors
                                                                                .blue),
                                                                        onConfirm: (Picker
                                                                                picker,
                                                                            List
                                                                                value) {
                                                                          var result =
                                                                              (picker.adapter as DateTimePickerAdapter).value;
                                                                          if (result !=
                                                                              null) {
                                                                            setState(() {
                                                                              OTBeforeEnd = result;
                                                                              TextOTBeforeEnd = '${OTBeforeEnd.hour.toString().padLeft(2, '0')}:${OTBeforeEnd.minute.toString().padLeft(2, '0')}';
                                                                            });
                                                                          }
                                                                        }).showDialog(context),
                                                                child: Text(
                                                                    '${TextOTBeforeEnd}'),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .green
                                                                    .shade400),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5)),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      'ช่วงแรก : เวลา '),
                                                                  OutlinedButton(
                                                                    onPressed: () =>
                                                                        // showPickerDateCustom(
                                                                        //     context,
                                                                        //     'DefultOneStart'),
                                                                        Picker(
                                                                            cancelText: 'ยกเลิก',
                                                                            confirmText: 'ตกลง',
                                                                            cancelTextStyle: TextStyle(fontFamily: Fonts.fonts),
                                                                            confirmTextStyle: TextStyle(fontFamily: Fonts.fonts),
                                                                            hideHeader: true,
                                                                            adapter: DateTimePickerAdapter(
                                                                              minuteInterval: 15,
                                                                              value: DefultOneStart,
                                                                              customColumnType: [
                                                                                3,
                                                                                4
                                                                              ],
                                                                            ),
                                                                            title: Text(""),
                                                                            selectedTextStyle: TextStyle(color: Colors.blue),
                                                                            onConfirm: (Picker picker, List value) {
                                                                              var result = (picker.adapter as DateTimePickerAdapter).value;
                                                                              if (result != null) {
                                                                                setState(() {
                                                                                  DefultOneStart = result;
                                                                                  TextDefultOneStart = '${DefultOneStart.hour.toString().padLeft(2, '0')}:${DefultOneStart.minute.toString().padLeft(2, '0')}';
                                                                                });
                                                                              }
                                                                            }).showDialog(context),
                                                                    child: Text(
                                                                        '${TextDefultOneStart}'),
                                                                  ),
                                                                  Text(' ถึง '),
                                                                  OutlinedButton(
                                                                    onPressed: () =>
                                                                        // showPickerDateCustom(
                                                                        //     context,
                                                                        //     'DefultOneEnd'),
                                                                        Picker(
                                                                            cancelText: 'ยกเลิก',
                                                                            confirmText: 'ตกลง',
                                                                            cancelTextStyle: TextStyle(fontFamily: Fonts.fonts),
                                                                            confirmTextStyle: TextStyle(fontFamily: Fonts.fonts),
                                                                            hideHeader: true,
                                                                            adapter: DateTimePickerAdapter(
                                                                              minuteInterval: 15,
                                                                              value: DefultOneEnd,
                                                                              customColumnType: [
                                                                                3,
                                                                                4
                                                                              ],
                                                                            ),
                                                                            title: Text(""),
                                                                            selectedTextStyle: TextStyle(color: Colors.blue),
                                                                            onConfirm: (Picker picker, List value) {
                                                                              var result = (picker.adapter as DateTimePickerAdapter).value;
                                                                              if (result != null) {
                                                                                setState(() {
                                                                                  DefultOneEnd = result;
                                                                                  TextDefultOneEnd = '${DefultOneEnd.hour.toString().padLeft(2, '0')}:${DefultOneEnd.minute.toString().padLeft(2, '0')}';
                                                                                });
                                                                              }
                                                                            }).showDialog(context),
                                                                    child: Text(
                                                                        '${TextDefultOneEnd}'),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      'ช่วงหลัง : เวลา '),
                                                                  OutlinedButton(
                                                                    onPressed: () =>
                                                                        // showPickerDateCustom(
                                                                        //     context,
                                                                        //     'DefultTwoStart'),
                                                                        Picker(
                                                                            cancelText: 'ยกเลิก',
                                                                            confirmText: 'ตกลง',
                                                                            cancelTextStyle: TextStyle(fontFamily: Fonts.fonts),
                                                                            confirmTextStyle: TextStyle(fontFamily: Fonts.fonts),
                                                                            hideHeader: true,
                                                                            adapter: DateTimePickerAdapter(
                                                                              minuteInterval: 15,
                                                                              value: DefultTwoStart,
                                                                              customColumnType: [
                                                                                3,
                                                                                4
                                                                              ],
                                                                            ),
                                                                            title: Text(""),
                                                                            selectedTextStyle: TextStyle(color: Colors.blue),
                                                                            onConfirm: (Picker picker, List value) {
                                                                              var result = (picker.adapter as DateTimePickerAdapter).value;
                                                                              if (result != null) {
                                                                                setState(() {
                                                                                  DefultTwoStart = result;
                                                                                  TextDefultTwoStart = '${DefultTwoStart.hour.toString().padLeft(2, '0')}:${DefultTwoStart.minute.toString().padLeft(2, '0')}';
                                                                                });
                                                                              }
                                                                            }).showDialog(context),
                                                                    child: Text(
                                                                        '${TextDefultTwoStart}'),
                                                                  ),
                                                                  Text(' ถึง '),
                                                                  OutlinedButton(
                                                                    onPressed: () =>
                                                                        // showPickerDateCustom(
                                                                        //     context,
                                                                        //     'DefultTwoEnd'),
                                                                        Picker(
                                                                            cancelText: 'ยกเลิก',
                                                                            confirmText: 'ตกลง',
                                                                            cancelTextStyle: TextStyle(fontFamily: Fonts.fonts),
                                                                            confirmTextStyle: TextStyle(fontFamily: Fonts.fonts),
                                                                            hideHeader: true,
                                                                            adapter: DateTimePickerAdapter(
                                                                              minuteInterval: 15,
                                                                              value: DefultTwoEnd,
                                                                              customColumnType: [
                                                                                3,
                                                                                4
                                                                              ],
                                                                            ),
                                                                            title: Text(""),
                                                                            selectedTextStyle: TextStyle(color: Colors.blue),
                                                                            onConfirm: (Picker picker, List value) {
                                                                              var result = (picker.adapter as DateTimePickerAdapter).value;
                                                                              if (result != null) {
                                                                                setState(() {
                                                                                  DefultTwoEnd = result;
                                                                                  TextDefultTwoEnd = '${DefultTwoEnd.hour.toString().padLeft(2, '0')}:${DefultTwoEnd.minute.toString().padLeft(2, '0')}';
                                                                                });
                                                                              }
                                                                            }).showDialog(context),
                                                                    child: Text(
                                                                        '${TextDefultTwoEnd}'),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .orange
                                                                    .shade400),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5)),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  'โอทีหลัง : เวลา '),
                                                              OutlinedButton(
                                                                onPressed: () =>
                                                                    // showPickerDateCustom(
                                                                    //     context,
                                                                    //     'OTAfterStart'),
                                                                    Picker(
                                                                        cancelText:
                                                                            'ยกเลิก',
                                                                        confirmText:
                                                                            'ตกลง',
                                                                        cancelTextStyle: TextStyle(
                                                                            fontFamily: Fonts
                                                                                .fonts),
                                                                        confirmTextStyle: TextStyle(
                                                                            fontFamily: Fonts
                                                                                .fonts),
                                                                        hideHeader:
                                                                            true,
                                                                        adapter:
                                                                            DateTimePickerAdapter(
                                                                          minuteInterval:
                                                                              15,
                                                                          value:
                                                                              OTAfterStart,
                                                                          customColumnType: [
                                                                            3,
                                                                            4
                                                                          ],
                                                                        ),
                                                                        title: Text(
                                                                            ""),
                                                                        selectedTextStyle: TextStyle(
                                                                            color: Colors
                                                                                .blue),
                                                                        onConfirm: (Picker
                                                                                picker,
                                                                            List
                                                                                value) {
                                                                          var result =
                                                                              (picker.adapter as DateTimePickerAdapter).value;
                                                                          if (result !=
                                                                              null) {
                                                                            setState(() {
                                                                              OTAfterStart = result;
                                                                              TextOTAfterStart = '${OTAfterStart.hour.toString().padLeft(2, '0')}:${OTAfterStart.minute.toString().padLeft(2, '0')}';
                                                                            });
                                                                          }
                                                                        }).showDialog(context),
                                                                child: Text(
                                                                    '${TextOTAfterStart}'),
                                                              ),
                                                              Text(' ถึง '),
                                                              OutlinedButton(
                                                                onPressed: () =>
                                                                    // showPickerDateCustom(
                                                                    //     context,
                                                                    //     'OTAfterEnd'),
                                                                    Picker(
                                                                        cancelText:
                                                                            'ยกเลิก',
                                                                        confirmText:
                                                                            'ตกลง',
                                                                        cancelTextStyle: TextStyle(
                                                                            fontFamily: Fonts
                                                                                .fonts),
                                                                        confirmTextStyle: TextStyle(
                                                                            fontFamily: Fonts
                                                                                .fonts),
                                                                        hideHeader:
                                                                            true,
                                                                        adapter:
                                                                            DateTimePickerAdapter(
                                                                          minuteInterval:
                                                                              15,
                                                                          value:
                                                                              OTAfterEnd,
                                                                          customColumnType: [
                                                                            3,
                                                                            4
                                                                          ],
                                                                        ),
                                                                        title: Text(
                                                                            ""),
                                                                        selectedTextStyle: TextStyle(
                                                                            color: Colors
                                                                                .blue),
                                                                        onConfirm: (Picker
                                                                                picker,
                                                                            List
                                                                                value) {
                                                                          var result =
                                                                              (picker.adapter as DateTimePickerAdapter).value;
                                                                          if (result !=
                                                                              null) {
                                                                            setState(() {
                                                                              OTAfterEnd = result;
                                                                              TextOTAfterEnd = '${OTAfterEnd.hour.toString().padLeft(2, '0')}:${OTAfterEnd.minute.toString().padLeft(2, '0')}';
                                                                            });
                                                                          }
                                                                        }).showDialog(context),
                                                                child: Text(
                                                                    '${TextOTAfterEnd}'),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              width: 100,
                                                              child:
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
                                                                color: Colors
                                                                    .white,
                                                                textStyle: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                                iconColor:
                                                                    Colors
                                                                        .black,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            SizedBox(
                                                              width: 100,
                                                              child:
                                                                  IconsButton(
                                                                text: 'ตกลง',
                                                                iconData: Icons
                                                                    .check_circle_outline,
                                                                color: Colors
                                                                    .green,
                                                                textStyle: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                                iconColor:
                                                                    Colors
                                                                        .white,
                                                                onPressed: () {
                                                                  //////function check time

                                                                  var ckOTBefore =
                                                                      "";
                                                                  var ckOTBeforestart =
                                                                      "";
                                                                  var ckDefultOne =
                                                                      "";
                                                                  var ckDefultOnestart =
                                                                      "";
                                                                  var ckDefultTwo =
                                                                      "";
                                                                  var ckOTDefultTwostart =
                                                                      "";
                                                                  var ckOTAfter =
                                                                      "";
                                                                  var ckOTOTAfterstart =
                                                                      "";

                                                                  ///check ค่าว่าง
                                                                  if ((TextOTBeforeStart !=
                                                                          "") ||
                                                                      (TextOTBeforeEnd !=
                                                                          "")) {
                                                                    ckOTBefore =
                                                                        'YES1';

                                                                    if ((TextOTBeforeStart !=
                                                                            "") &&
                                                                        (TextOTBeforeEnd !=
                                                                            "")) {
                                                                      ckOTBefore =
                                                                          '';

                                                                      ///check ห้ามน้อยกว่าเวลาเริ่ม
                                                                      if (OTBeforeStart
                                                                          .isAfter(
                                                                              OTBeforeEnd)) {
                                                                        ckOTBeforestart =
                                                                            'OVER1';
                                                                      }
                                                                    }
                                                                  }

                                                                  if ((TextDefultOneStart !=
                                                                          "") ||
                                                                      (TextDefultOneEnd !=
                                                                          "")) {
                                                                    ckDefultOne =
                                                                        'YES2';

                                                                    if ((TextDefultOneStart !=
                                                                            "") &&
                                                                        (TextDefultOneEnd !=
                                                                            "")) {
                                                                      ckDefultOne =
                                                                          '';

                                                                      ///check ห้ามน้อยกว่าเวลาเริ่ม
                                                                      if (DefultOneStart
                                                                          .isAfter(
                                                                              DefultOneEnd)) {
                                                                        ckDefultOnestart =
                                                                            'OVER2';
                                                                      }
                                                                    }
                                                                  }

                                                                  if ((TextDefultTwoStart !=
                                                                          "") ||
                                                                      (TextDefultTwoEnd !=
                                                                          "")) {
                                                                    ckDefultTwo =
                                                                        'YES3';

                                                                    if ((TextDefultTwoStart !=
                                                                            "") &&
                                                                        (TextDefultTwoEnd !=
                                                                            "")) {
                                                                      ckDefultTwo =
                                                                          '';

                                                                      ///check ห้ามน้อยกว่าเวลาเริ่ม
                                                                      if (DefultTwoStart
                                                                          .isAfter(
                                                                              DefultTwoEnd)) {
                                                                        ckOTDefultTwostart =
                                                                            'OVER3';
                                                                      }
                                                                    }
                                                                  }

                                                                  if ((TextOTAfterStart !=
                                                                          "") ||
                                                                      (TextOTAfterEnd !=
                                                                          "")) {
                                                                    ckOTAfter =
                                                                        'YES4';

                                                                    if ((TextOTAfterStart !=
                                                                            "") &&
                                                                        (TextOTAfterEnd !=
                                                                            "")) {
                                                                      ckOTAfter =
                                                                          '';

                                                                      ///check ห้ามน้อยกว่าเวลาเริ่ม
                                                                      if (OTAfterStart
                                                                          .isAfter(
                                                                              OTAfterEnd)) {
                                                                        ckOTOTAfterstart =
                                                                            'OVER4';
                                                                      }
                                                                    }
                                                                  }

                                                                  if ((((ckOTBefore != "") ||
                                                                              (ckDefultOne !=
                                                                                  "") ||
                                                                              (ckDefultTwo !=
                                                                                  "") ||
                                                                              (ckOTAfter !=
                                                                                  "")) ||
                                                                          ((ckOTBeforestart != "") ||
                                                                              (ckDefultOnestart !=
                                                                                  "") ||
                                                                              (ckOTDefultTwostart !=
                                                                                  "") ||
                                                                              (ckOTOTAfterstart !=
                                                                                  ""))) ||
                                                                      ((TextOTBeforeStart == "") &&
                                                                          (TextOTBeforeEnd ==
                                                                              "") &&
                                                                          (TextDefultOneStart ==
                                                                              "") &&
                                                                          (TextDefultOneEnd ==
                                                                              "") &&
                                                                          (TextDefultTwoStart ==
                                                                              "") &&
                                                                          (TextDefultTwoEnd ==
                                                                              "") &&
                                                                          (TextOTAfterStart ==
                                                                              "") &&
                                                                          (TextOTAfterEnd ==
                                                                              ""))) {
                                                                    Dialogs.materialDialog(
                                                                        msg:
                                                                            'กรุณาตรวจสอบเวลาเริ่มต้นและเวลาสิ้นสุดให้ถูกต้อง',
                                                                        title:
                                                                            'ตรวจสอบข้อมูล',
                                                                        context:
                                                                            context,
                                                                        actions: [
                                                                          IconsButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context, rootNavigator: true).pop();
                                                                            },
                                                                            text:
                                                                                'ตกลง',
                                                                            iconData:
                                                                                Icons.check_circle_outline,
                                                                            color:
                                                                                Colors.green,
                                                                            textStyle:
                                                                                TextStyle(color: Colors.white),
                                                                            iconColor:
                                                                                Colors.white,
                                                                          ),
                                                                        ]);
                                                                  } else {
                                                                    ///check การเรียงลำดับเวลา

                                                                    String
                                                                        arrayText =
                                                                        "";

                                                                    List<DateTime>
                                                                        typetimestart =
                                                                        [];
                                                                    List<DateTime>
                                                                        typetimeend =
                                                                        [];
                                                                    if (TextOTBeforeEnd !=
                                                                        "") {
                                                                      typetimestart
                                                                          .add(
                                                                              OTBeforeStart);
                                                                      typetimeend
                                                                          .add(
                                                                              OTBeforeEnd);

                                                                      arrayText =
                                                                          '{"101": ["${OTBeforeStart}", "${OTBeforeEnd}"]';
                                                                    }
                                                                    if (TextDefultOneEnd !=
                                                                        "") {
                                                                      typetimestart
                                                                          .add(
                                                                              DefultOneStart);
                                                                      typetimeend
                                                                          .add(
                                                                              DefultOneEnd);

                                                                      if (arrayText ==
                                                                          "") {
                                                                        arrayText =
                                                                            '{';
                                                                      } else {
                                                                        arrayText +=
                                                                            ',';
                                                                      }
                                                                      arrayText +=
                                                                          '"102": ["${DefultOneStart}", "${DefultOneEnd}"]';
                                                                    }
                                                                    if (TextDefultTwoEnd !=
                                                                        "") {
                                                                      typetimestart
                                                                          .add(
                                                                              DefultTwoStart);
                                                                      typetimeend
                                                                          .add(
                                                                              DefultTwoEnd);

                                                                      if (arrayText ==
                                                                          "") {
                                                                        arrayText =
                                                                            '{';
                                                                      } else {
                                                                        arrayText +=
                                                                            ',';
                                                                      }
                                                                      arrayText +=
                                                                          '"103": ["${DefultTwoStart}", "${DefultTwoEnd}"]';
                                                                    }
                                                                    if (TextOTAfterEnd !=
                                                                        "") {
                                                                      typetimestart
                                                                          .add(
                                                                              OTAfterStart);
                                                                      typetimeend
                                                                          .add(
                                                                              OTAfterEnd);

                                                                      if (arrayText ==
                                                                          "") {
                                                                        arrayText +=
                                                                            '{';
                                                                      } else {
                                                                        arrayText +=
                                                                            ',';
                                                                      }
                                                                      arrayText +=
                                                                          '"104": ["${OTAfterStart}", "${OTAfterEnd}"]';
                                                                    }

                                                                    arrayText +=
                                                                        "}";

                                                                    var savedata =
                                                                        "";

                                                                    for (int i =
                                                                            0;
                                                                        i < typetimestart.length;
                                                                        i++) {
                                                                      if (!(i ==
                                                                          (typetimestart.length -
                                                                              1))) {
                                                                        if (typetimeend[i].isAfter(typetimestart[i +
                                                                            1])) {
                                                                          Dialogs.materialDialog(
                                                                              msg: 'กรุณาตรวจสอบการเรียงลำดับเวลาให้ถูกต้อง',
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
                                                                                  textStyle: TextStyle(color: Colors.white),
                                                                                  iconColor: Colors.white,
                                                                                ),
                                                                              ]);

                                                                          savedata =
                                                                              'NO';

                                                                          break;
                                                                        }
                                                                      }
                                                                    }

                                                                    if (savedata ==
                                                                        "") {
                                                                      var tagsJson =
                                                                          jsonDecode(
                                                                              arrayText);

                                                                      // for (int i = 0;
                                                                      //     i <
                                                                      //         _data
                                                                      //             .length;
                                                                      //     i++) {
                                                                      //   print(
                                                                      //       _data.empCode!);
                                                                      // }

                                                                      var emplist =
                                                                          "";
                                                                      var empcostCenter =
                                                                          "";
                                                                      int i = 0;

                                                                      for (final item
                                                                          in _data) {
                                                                        i++;
                                                                        if (checkvalueHideEmp(
                                                                            item.empCode!)) {
                                                                          if (emplist ==
                                                                              "") {
                                                                            emplist =
                                                                                item.empCode!;
                                                                          } else {
                                                                            emplist +=
                                                                                ',${item.empCode!}';
                                                                          }
                                                                        }

                                                                        empcostCenter =
                                                                            item.costCenter!;
                                                                      }

                                                                      datasavetimesheet(
                                                                          arrayText,
                                                                          emplist,
                                                                          empcostCenter,
                                                                          '');
                                                                      Navigator.of(
                                                                              context,
                                                                              rootNavigator: true)
                                                                          .pop();
                                                                    }
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        )
                                      }
                                    else
                                      {
                                        setState(() {
                                          valall = false;
                                        })
                                      }
                                  },
                                ),
                                // CheckboxListTile(
                                //   controlAffinity:
                                //       ListTileControlAffinity.leading,
                                //   contentPadding: EdgeInsets.zero,
                                //   dense: true,
                                //   title: Text(
                                //     'ใช้เวลาและกิจกรรมร่วมกัน',
                                //     style: const TextStyle(
                                //       fontSize: 16.0,
                                //       color: Colors.black,
                                //     ),
                                //   ),
                                //   value: valall,
                                //   onChanged: (value) {
                                //     if (valall == false) {
                                //       setState(() {
                                //         valall = true;
                                //       });
                                //       TextOTBeforeStart = "";
                                //       TextOTBeforeEnd = "";
                                //       TextDefultOneStart = "";
                                //       TextDefultOneEnd = "";
                                //       TextDefultTwoStart = "";
                                //       TextDefultTwoEnd = "";
                                //       TextOTAfterStart = "";
                                //       TextOTAfterEnd = "";
                                //       showDialog(
                                //         barrierDismissible: false,
                                //         context: context,
                                //         builder: (context) {
                                //           return StatefulBuilder(
                                //             builder: (context, setState) {
                                //               return AlertDialog(
                                //                 backgroundColor:
                                //                     Dialogs.bcgColor,
                                //                 // content: Dialogs.holder,
                                //                 shape: Dialogs.dialogShape,
                                //                 title: Center(
                                //                   child: Text(
                                //                     "ทำงาน",
                                //                     style: Dialogs.titleStyle,
                                //                   ),
                                //                 ),
                                //                 actions: <Widget>[
                                //                   Column(
                                //                     children: [
                                //                       Container(
                                //                         padding:
                                //                             const EdgeInsets
                                //                                 .all(5.0),
                                //                         decoration:
                                //                             BoxDecoration(
                                //                           border: Border.all(
                                //                               color: Colors.blue
                                //                                   .shade400),
                                //                           borderRadius:
                                //                               BorderRadius.all(
                                //                                   Radius
                                //                                       .circular(
                                //                                           5)),
                                //                         ),
                                //                         child: Row(
                                //                           mainAxisAlignment:
                                //                               MainAxisAlignment
                                //                                   .spaceBetween,
                                //                           children: [
                                //                             Text(
                                //                                 'โอทีก่อน : เวลา '),
                                //                             OutlinedButton(
                                //                               onPressed: () =>
                                //                                   Picker(
                                //                                       hideHeader:
                                //                                           true,
                                //                                       cancelText:
                                //                                           'ยกเลิก',
                                //                                       confirmText:
                                //                                           'ตกลง',
                                //                                       cancelTextStyle: TextStyle(
                                //                                           fontFamily: Fonts
                                //                                               .fonts),
                                //                                       confirmTextStyle: TextStyle(
                                //                                           fontFamily: Fonts
                                //                                               .fonts),
                                //                                       adapter:
                                //                                           DateTimePickerAdapter(
                                //                                         minuteInterval:
                                //                                             15,
                                //                                         value:
                                //                                             OTBeforeStart,
                                //                                         customColumnType: [
                                //                                           3,
                                //                                           4
                                //                                         ],
                                //                                       ),
                                //                                       title: Text(
                                //                                           ""),
                                //                                       selectedTextStyle: TextStyle(
                                //                                           color: Colors
                                //                                               .blue),
                                //                                       onConfirm: (Picker
                                //                                               picker,
                                //                                           List
                                //                                               value) {
                                //                                         var result =
                                //                                             (picker.adapter as DateTimePickerAdapter).value;
                                //                                         if (result !=
                                //                                             null) {
                                //                                           setState(
                                //                                               () {
                                //                                             OTBeforeStart =
                                //                                                 result;
                                //                                             TextOTBeforeStart =
                                //                                                 '${OTBeforeStart.hour.toString().padLeft(2, '0')}:${OTBeforeStart.minute.toString().padLeft(2, '0')}';
                                //                                           });
                                //                                         }
                                //                                       }).showDialog(context),
                                //                               child: Text(
                                //                                   '${TextOTBeforeStart}'),
                                //                             ),
                                //                             Text(' ถึง '),
                                //                             OutlinedButton(
                                //                               onPressed: () =>
                                //                                   // showPickerDateCustom(
                                //                                   //     context,
                                //                                   //     'OTBeforeEnd'),
                                //                                   Picker(
                                //                                       cancelText:
                                //                                           'ยกเลิก',
                                //                                       confirmText:
                                //                                           'ตกลง',
                                //                                       cancelTextStyle: TextStyle(
                                //                                           fontFamily: Fonts
                                //                                               .fonts),
                                //                                       confirmTextStyle: TextStyle(
                                //                                           fontFamily: Fonts
                                //                                               .fonts),
                                //                                       hideHeader:
                                //                                           true,
                                //                                       adapter:
                                //                                           DateTimePickerAdapter(
                                //                                         minuteInterval:
                                //                                             15,
                                //                                         value:
                                //                                             OTBeforeEnd,
                                //                                         customColumnType: [
                                //                                           3,
                                //                                           4
                                //                                         ],
                                //                                       ),
                                //                                       title: Text(
                                //                                           ""),
                                //                                       selectedTextStyle: TextStyle(
                                //                                           color: Colors
                                //                                               .blue),
                                //                                       onConfirm: (Picker
                                //                                               picker,
                                //                                           List
                                //                                               value) {
                                //                                         var result =
                                //                                             (picker.adapter as DateTimePickerAdapter).value;
                                //                                         if (result !=
                                //                                             null) {
                                //                                           setState(
                                //                                               () {
                                //                                             OTBeforeEnd =
                                //                                                 result;
                                //                                             TextOTBeforeEnd =
                                //                                                 '${OTBeforeEnd.hour.toString().padLeft(2, '0')}:${OTBeforeEnd.minute.toString().padLeft(2, '0')}';
                                //                                           });
                                //                                         }
                                //                                       }).showDialog(context),
                                //                               child: Text(
                                //                                   '${TextOTBeforeEnd}'),
                                //                             ),
                                //                           ],
                                //                         ),
                                //                       ),
                                //                       SizedBox(
                                //                         height: 30,
                                //                       ),
                                //                       Container(
                                //                         padding:
                                //                             const EdgeInsets
                                //                                 .all(5.0),
                                //                         decoration:
                                //                             BoxDecoration(
                                //                           border: Border.all(
                                //                               color: Colors
                                //                                   .green
                                //                                   .shade400),
                                //                           borderRadius:
                                //                               BorderRadius.all(
                                //                                   Radius
                                //                                       .circular(
                                //                                           5)),
                                //                         ),
                                //                         child: Column(
                                //                           children: [
                                //                             Row(
                                //                               mainAxisAlignment:
                                //                                   MainAxisAlignment
                                //                                       .spaceBetween,
                                //                               children: [
                                //                                 Text(
                                //                                     'ช่วงแรก : เวลา '),
                                //                                 OutlinedButton(
                                //                                   onPressed: () =>
                                //                                       // showPickerDateCustom(
                                //                                       //     context,
                                //                                       //     'DefultOneStart'),
                                //                                       Picker(
                                //                                           cancelText: 'ยกเลิก',
                                //                                           confirmText: 'ตกลง',
                                //                                           cancelTextStyle: TextStyle(fontFamily: Fonts.fonts),
                                //                                           confirmTextStyle: TextStyle(fontFamily: Fonts.fonts),
                                //                                           hideHeader: true,
                                //                                           adapter: DateTimePickerAdapter(
                                //                                             minuteInterval:
                                //                                                 15,
                                //                                             value:
                                //                                                 DefultOneStart,
                                //                                             customColumnType: [
                                //                                               3,
                                //                                               4
                                //                                             ],
                                //                                           ),
                                //                                           title: Text(""),
                                //                                           selectedTextStyle: TextStyle(color: Colors.blue),
                                //                                           onConfirm: (Picker picker, List value) {
                                //                                             var result =
                                //                                                 (picker.adapter as DateTimePickerAdapter).value;
                                //                                             if (result !=
                                //                                                 null) {
                                //                                               setState(() {
                                //                                                 DefultOneStart = result;
                                //                                                 TextDefultOneStart = '${DefultOneStart.hour.toString().padLeft(2, '0')}:${DefultOneStart.minute.toString().padLeft(2, '0')}';
                                //                                               });
                                //                                             }
                                //                                           }).showDialog(context),
                                //                                   child: Text(
                                //                                       '${TextDefultOneStart}'),
                                //                                 ),
                                //                                 Text(' ถึง '),
                                //                                 OutlinedButton(
                                //                                   onPressed: () =>
                                //                                       // showPickerDateCustom(
                                //                                       //     context,
                                //                                       //     'DefultOneEnd'),
                                //                                       Picker(
                                //                                           cancelText: 'ยกเลิก',
                                //                                           confirmText: 'ตกลง',
                                //                                           cancelTextStyle: TextStyle(fontFamily: Fonts.fonts),
                                //                                           confirmTextStyle: TextStyle(fontFamily: Fonts.fonts),
                                //                                           hideHeader: true,
                                //                                           adapter: DateTimePickerAdapter(
                                //                                             minuteInterval:
                                //                                                 15,
                                //                                             value:
                                //                                                 DefultOneEnd,
                                //                                             customColumnType: [
                                //                                               3,
                                //                                               4
                                //                                             ],
                                //                                           ),
                                //                                           title: Text(""),
                                //                                           selectedTextStyle: TextStyle(color: Colors.blue),
                                //                                           onConfirm: (Picker picker, List value) {
                                //                                             var result =
                                //                                                 (picker.adapter as DateTimePickerAdapter).value;
                                //                                             if (result !=
                                //                                                 null) {
                                //                                               setState(() {
                                //                                                 DefultOneEnd = result;
                                //                                                 TextDefultOneEnd = '${DefultOneEnd.hour.toString().padLeft(2, '0')}:${DefultOneEnd.minute.toString().padLeft(2, '0')}';
                                //                                               });
                                //                                             }
                                //                                           }).showDialog(context),
                                //                                   child: Text(
                                //                                       '${TextDefultOneEnd}'),
                                //                                 ),
                                //                               ],
                                //                             ),
                                //                             Row(
                                //                               mainAxisAlignment:
                                //                                   MainAxisAlignment
                                //                                       .spaceBetween,
                                //                               children: [
                                //                                 Text(
                                //                                     'ช่วงหลัง : เวลา '),
                                //                                 OutlinedButton(
                                //                                   onPressed: () =>
                                //                                       // showPickerDateCustom(
                                //                                       //     context,
                                //                                       //     'DefultTwoStart'),
                                //                                       Picker(
                                //                                           cancelText: 'ยกเลิก',
                                //                                           confirmText: 'ตกลง',
                                //                                           cancelTextStyle: TextStyle(fontFamily: Fonts.fonts),
                                //                                           confirmTextStyle: TextStyle(fontFamily: Fonts.fonts),
                                //                                           hideHeader: true,
                                //                                           adapter: DateTimePickerAdapter(
                                //                                             minuteInterval:
                                //                                                 15,
                                //                                             value:
                                //                                                 DefultTwoStart,
                                //                                             customColumnType: [
                                //                                               3,
                                //                                               4
                                //                                             ],
                                //                                           ),
                                //                                           title: Text(""),
                                //                                           selectedTextStyle: TextStyle(color: Colors.blue),
                                //                                           onConfirm: (Picker picker, List value) {
                                //                                             var result =
                                //                                                 (picker.adapter as DateTimePickerAdapter).value;
                                //                                             if (result !=
                                //                                                 null) {
                                //                                               setState(() {
                                //                                                 DefultTwoStart = result;
                                //                                                 TextDefultTwoStart = '${DefultTwoStart.hour.toString().padLeft(2, '0')}:${DefultTwoStart.minute.toString().padLeft(2, '0')}';
                                //                                               });
                                //                                             }
                                //                                           }).showDialog(context),
                                //                                   child: Text(
                                //                                       '${TextDefultTwoStart}'),
                                //                                 ),
                                //                                 Text(' ถึง '),
                                //                                 OutlinedButton(
                                //                                   onPressed: () =>
                                //                                       // showPickerDateCustom(
                                //                                       //     context,
                                //                                       //     'DefultTwoEnd'),
                                //                                       Picker(
                                //                                           cancelText: 'ยกเลิก',
                                //                                           confirmText: 'ตกลง',
                                //                                           cancelTextStyle: TextStyle(fontFamily: Fonts.fonts),
                                //                                           confirmTextStyle: TextStyle(fontFamily: Fonts.fonts),
                                //                                           hideHeader: true,
                                //                                           adapter: DateTimePickerAdapter(
                                //                                             minuteInterval:
                                //                                                 15,
                                //                                             value:
                                //                                                 DefultTwoEnd,
                                //                                             customColumnType: [
                                //                                               3,
                                //                                               4
                                //                                             ],
                                //                                           ),
                                //                                           title: Text(""),
                                //                                           selectedTextStyle: TextStyle(color: Colors.blue),
                                //                                           onConfirm: (Picker picker, List value) {
                                //                                             var result =
                                //                                                 (picker.adapter as DateTimePickerAdapter).value;
                                //                                             if (result !=
                                //                                                 null) {
                                //                                               setState(() {
                                //                                                 DefultTwoEnd = result;
                                //                                                 TextDefultTwoEnd = '${DefultTwoEnd.hour.toString().padLeft(2, '0')}:${DefultTwoEnd.minute.toString().padLeft(2, '0')}';
                                //                                               });
                                //                                             }
                                //                                           }).showDialog(context),
                                //                                   child: Text(
                                //                                       '${TextDefultTwoEnd}'),
                                //                                 ),
                                //                               ],
                                //                             ),
                                //                           ],
                                //                         ),
                                //                       ),
                                //                       SizedBox(
                                //                         height: 30,
                                //                       ),
                                //                       Container(
                                //                         padding:
                                //                             const EdgeInsets
                                //                                 .all(5.0),
                                //                         decoration:
                                //                             BoxDecoration(
                                //                           border: Border.all(
                                //                               color: Colors
                                //                                   .orange
                                //                                   .shade400),
                                //                           borderRadius:
                                //                               BorderRadius.all(
                                //                                   Radius
                                //                                       .circular(
                                //                                           5)),
                                //                         ),
                                //                         child: Row(
                                //                           mainAxisAlignment:
                                //                               MainAxisAlignment
                                //                                   .spaceBetween,
                                //                           children: [
                                //                             Text(
                                //                                 'โอทีหลัง : เวลา '),
                                //                             OutlinedButton(
                                //                               onPressed: () =>
                                //                                   // showPickerDateCustom(
                                //                                   //     context,
                                //                                   //     'OTAfterStart'),
                                //                                   Picker(
                                //                                       cancelText:
                                //                                           'ยกเลิก',
                                //                                       confirmText:
                                //                                           'ตกลง',
                                //                                       cancelTextStyle: TextStyle(
                                //                                           fontFamily: Fonts
                                //                                               .fonts),
                                //                                       confirmTextStyle: TextStyle(
                                //                                           fontFamily: Fonts
                                //                                               .fonts),
                                //                                       hideHeader:
                                //                                           true,
                                //                                       adapter:
                                //                                           DateTimePickerAdapter(
                                //                                         minuteInterval:
                                //                                             15,
                                //                                         value:
                                //                                             OTAfterStart,
                                //                                         customColumnType: [
                                //                                           3,
                                //                                           4
                                //                                         ],
                                //                                       ),
                                //                                       title: Text(
                                //                                           ""),
                                //                                       selectedTextStyle: TextStyle(
                                //                                           color: Colors
                                //                                               .blue),
                                //                                       onConfirm: (Picker
                                //                                               picker,
                                //                                           List
                                //                                               value) {
                                //                                         var result =
                                //                                             (picker.adapter as DateTimePickerAdapter).value;
                                //                                         if (result !=
                                //                                             null) {
                                //                                           setState(
                                //                                               () {
                                //                                             OTAfterStart =
                                //                                                 result;
                                //                                             TextOTAfterStart =
                                //                                                 '${OTAfterStart.hour.toString().padLeft(2, '0')}:${OTAfterStart.minute.toString().padLeft(2, '0')}';
                                //                                           });
                                //                                         }
                                //                                       }).showDialog(context),
                                //                               child: Text(
                                //                                   '${TextOTAfterStart}'),
                                //                             ),
                                //                             Text(' ถึง '),
                                //                             OutlinedButton(
                                //                               onPressed: () =>
                                //                                   // showPickerDateCustom(
                                //                                   //     context,
                                //                                   //     'OTAfterEnd'),
                                //                                   Picker(
                                //                                       cancelText:
                                //                                           'ยกเลิก',
                                //                                       confirmText:
                                //                                           'ตกลง',
                                //                                       cancelTextStyle: TextStyle(
                                //                                           fontFamily: Fonts
                                //                                               .fonts),
                                //                                       confirmTextStyle: TextStyle(
                                //                                           fontFamily: Fonts
                                //                                               .fonts),
                                //                                       hideHeader:
                                //                                           true,
                                //                                       adapter:
                                //                                           DateTimePickerAdapter(
                                //                                         minuteInterval:
                                //                                             15,
                                //                                         value:
                                //                                             OTAfterEnd,
                                //                                         customColumnType: [
                                //                                           3,
                                //                                           4
                                //                                         ],
                                //                                       ),
                                //                                       title: Text(
                                //                                           ""),
                                //                                       selectedTextStyle: TextStyle(
                                //                                           color: Colors
                                //                                               .blue),
                                //                                       onConfirm: (Picker
                                //                                               picker,
                                //                                           List
                                //                                               value) {
                                //                                         var result =
                                //                                             (picker.adapter as DateTimePickerAdapter).value;
                                //                                         if (result !=
                                //                                             null) {
                                //                                           setState(
                                //                                               () {
                                //                                             OTAfterEnd =
                                //                                                 result;
                                //                                             TextOTAfterEnd =
                                //                                                 '${OTAfterEnd.hour.toString().padLeft(2, '0')}:${OTAfterEnd.minute.toString().padLeft(2, '0')}';
                                //                                           });
                                //                                         }
                                //                                       }).showDialog(context),
                                //                               child: Text(
                                //                                   '${TextOTAfterEnd}'),
                                //                             ),
                                //                           ],
                                //                         ),
                                //                       ),
                                //                       SizedBox(
                                //                         height: 30,
                                //                       ),
                                //                       Row(
                                //                         mainAxisAlignment:
                                //                             MainAxisAlignment
                                //                                 .center,
                                //                         crossAxisAlignment:
                                //                             CrossAxisAlignment
                                //                                 .center,
                                //                         children: [
                                //                           SizedBox(
                                //                             width: 100,
                                //                             child:
                                //                                 IconsOutlineButton(
                                //                               onPressed: () {
                                //                                 Navigator.of(
                                //                                         context,
                                //                                         rootNavigator:
                                //                                             true)
                                //                                     .pop();
                                //                               },
                                //                               text: 'ไม่',
                                //                               iconData: Icons
                                //                                   .cancel_outlined,
                                //                               color:
                                //                                   Colors.white,
                                //                               textStyle: TextStyle(
                                //                                   color: Colors
                                //                                       .black),
                                //                               iconColor:
                                //                                   Colors.black,
                                //                             ),
                                //                           ),
                                //                           SizedBox(
                                //                             width: 10,
                                //                           ),
                                //                           SizedBox(
                                //                             width: 100,
                                //                             child: IconsButton(
                                //                               text: 'ตกลง',
                                //                               iconData: Icons
                                //                                   .check_circle_outline,
                                //                               color:
                                //                                   Colors.green,
                                //                               textStyle: TextStyle(
                                //                                   color: Colors
                                //                                       .white),
                                //                               iconColor:
                                //                                   Colors.white,
                                //                               onPressed: () {
                                //                                 //////function check time

                                //                                 var ckOTBefore =
                                //                                     "";
                                //                                 var ckOTBeforestart =
                                //                                     "";
                                //                                 var ckDefultOne =
                                //                                     "";
                                //                                 var ckDefultOnestart =
                                //                                     "";
                                //                                 var ckDefultTwo =
                                //                                     "";
                                //                                 var ckOTDefultTwostart =
                                //                                     "";
                                //                                 var ckOTAfter =
                                //                                     "";
                                //                                 var ckOTOTAfterstart =
                                //                                     "";

                                //                                 ///check ค่าว่าง
                                //                                 if ((TextOTBeforeStart !=
                                //                                         "") ||
                                //                                     (TextOTBeforeEnd !=
                                //                                         "")) {
                                //                                   ckOTBefore =
                                //                                       'YES1';

                                //                                   if ((TextOTBeforeStart !=
                                //                                           "") &&
                                //                                       (TextOTBeforeEnd !=
                                //                                           "")) {
                                //                                     ckOTBefore =
                                //                                         '';

                                //                                     ///check ห้ามน้อยกว่าเวลาเริ่ม
                                //                                     if (OTBeforeStart
                                //                                         .isAfter(
                                //                                             OTBeforeEnd)) {
                                //                                       ckOTBeforestart =
                                //                                           'OVER1';
                                //                                     }
                                //                                   }
                                //                                 }

                                //                                 if ((TextDefultOneStart !=
                                //                                         "") ||
                                //                                     (TextDefultOneEnd !=
                                //                                         "")) {
                                //                                   ckDefultOne =
                                //                                       'YES2';

                                //                                   if ((TextDefultOneStart !=
                                //                                           "") &&
                                //                                       (TextDefultOneEnd !=
                                //                                           "")) {
                                //                                     ckDefultOne =
                                //                                         '';

                                //                                     ///check ห้ามน้อยกว่าเวลาเริ่ม
                                //                                     if (DefultOneStart
                                //                                         .isAfter(
                                //                                             DefultOneEnd)) {
                                //                                       ckDefultOnestart =
                                //                                           'OVER2';
                                //                                     }
                                //                                   }
                                //                                 }

                                //                                 if ((TextDefultTwoStart !=
                                //                                         "") ||
                                //                                     (TextDefultTwoEnd !=
                                //                                         "")) {
                                //                                   ckDefultTwo =
                                //                                       'YES3';

                                //                                   if ((TextDefultTwoStart !=
                                //                                           "") &&
                                //                                       (TextDefultTwoEnd !=
                                //                                           "")) {
                                //                                     ckDefultTwo =
                                //                                         '';

                                //                                     ///check ห้ามน้อยกว่าเวลาเริ่ม
                                //                                     if (DefultTwoStart
                                //                                         .isAfter(
                                //                                             DefultTwoEnd)) {
                                //                                       ckOTDefultTwostart =
                                //                                           'OVER3';
                                //                                     }
                                //                                   }
                                //                                 }

                                //                                 if ((TextOTAfterStart !=
                                //                                         "") ||
                                //                                     (TextOTAfterEnd !=
                                //                                         "")) {
                                //                                   ckOTAfter =
                                //                                       'YES4';

                                //                                   if ((TextOTAfterStart !=
                                //                                           "") &&
                                //                                       (TextOTAfterEnd !=
                                //                                           "")) {
                                //                                     ckOTAfter =
                                //                                         '';

                                //                                     ///check ห้ามน้อยกว่าเวลาเริ่ม
                                //                                     if (OTAfterStart
                                //                                         .isAfter(
                                //                                             OTAfterEnd)) {
                                //                                       ckOTOTAfterstart =
                                //                                           'OVER4';
                                //                                     }
                                //                                   }
                                //                                 }

                                //                                 if ((((ckOTBefore != "") ||
                                //                                             (ckDefultOne !=
                                //                                                 "") ||
                                //                                             (ckDefultTwo !=
                                //                                                 "") ||
                                //                                             (ckOTAfter !=
                                //                                                 "")) ||
                                //                                         ((ckOTBeforestart != "") ||
                                //                                             (ckDefultOnestart !=
                                //                                                 "") ||
                                //                                             (ckOTDefultTwostart !=
                                //                                                 "") ||
                                //                                             (ckOTOTAfterstart !=
                                //                                                 ""))) ||
                                //                                     ((TextOTBeforeStart == "") &&
                                //                                         (TextOTBeforeEnd ==
                                //                                             "") &&
                                //                                         (TextDefultOneStart ==
                                //                                             "") &&
                                //                                         (TextDefultOneEnd ==
                                //                                             "") &&
                                //                                         (TextDefultTwoStart ==
                                //                                             "") &&
                                //                                         (TextDefultTwoEnd ==
                                //                                             "") &&
                                //                                         (TextOTAfterStart ==
                                //                                             "") &&
                                //                                         (TextOTAfterEnd ==
                                //                                             ""))) {
                                //                                   Dialogs.materialDialog(
                                //                                       msg:
                                //                                           'กรุณาตรวจสอบเวลาเริ่มต้นและเวลาสิ้นสุดให้ถูกต้อง',
                                //                                       title:
                                //                                           'ตรวจสอบข้อมูล',
                                //                                       context:
                                //                                           context,
                                //                                       actions: [
                                //                                         IconsButton(
                                //                                           onPressed:
                                //                                               () {
                                //                                             Navigator.of(context, rootNavigator: true).pop();
                                //                                           },
                                //                                           text:
                                //                                               'ตกลง',
                                //                                           iconData:
                                //                                               Icons.check_circle_outline,
                                //                                           color:
                                //                                               Colors.green,
                                //                                           textStyle:
                                //                                               TextStyle(color: Colors.white),
                                //                                           iconColor:
                                //                                               Colors.white,
                                //                                         ),
                                //                                       ]);
                                //                                 } else {
                                //                                   ///check การเรียงลำดับเวลา

                                //                                   String
                                //                                       arrayText =
                                //                                       "";

                                //                                   List<DateTime>
                                //                                       typetimestart =
                                //                                       [];
                                //                                   List<DateTime>
                                //                                       typetimeend =
                                //                                       [];
                                //                                   if (TextOTBeforeEnd !=
                                //                                       "") {
                                //                                     typetimestart
                                //                                         .add(
                                //                                             OTBeforeStart);
                                //                                     typetimeend.add(
                                //                                         OTBeforeEnd);

                                //                                     arrayText =
                                //                                         '{"101": ["${OTBeforeStart}", "${OTBeforeEnd}"]';
                                //                                   }
                                //                                   if (TextDefultOneEnd !=
                                //                                       "") {
                                //                                     typetimestart
                                //                                         .add(
                                //                                             DefultOneStart);
                                //                                     typetimeend.add(
                                //                                         DefultOneEnd);

                                //                                     if (arrayText ==
                                //                                         "") {
                                //                                       arrayText =
                                //                                           '{';
                                //                                     } else {
                                //                                       arrayText +=
                                //                                           ',';
                                //                                     }
                                //                                     arrayText +=
                                //                                         '"102": ["${DefultOneStart}", "${DefultOneEnd}"]';
                                //                                   }
                                //                                   if (TextDefultTwoEnd !=
                                //                                       "") {
                                //                                     typetimestart
                                //                                         .add(
                                //                                             DefultTwoStart);
                                //                                     typetimeend.add(
                                //                                         DefultTwoEnd);

                                //                                     if (arrayText ==
                                //                                         "") {
                                //                                       arrayText =
                                //                                           '{';
                                //                                     } else {
                                //                                       arrayText +=
                                //                                           ',';
                                //                                     }
                                //                                     arrayText +=
                                //                                         '"103": ["${DefultTwoStart}", "${DefultTwoEnd}"]';
                                //                                   }
                                //                                   if (TextOTAfterEnd !=
                                //                                       "") {
                                //                                     typetimestart
                                //                                         .add(
                                //                                             OTAfterStart);
                                //                                     typetimeend.add(
                                //                                         OTAfterEnd);

                                //                                     if (arrayText ==
                                //                                         "") {
                                //                                       arrayText +=
                                //                                           '{';
                                //                                     } else {
                                //                                       arrayText +=
                                //                                           ',';
                                //                                     }
                                //                                     arrayText +=
                                //                                         '"104": ["${OTAfterStart}", "${OTAfterEnd}"]';
                                //                                   }

                                //                                   arrayText +=
                                //                                       "}";

                                //                                   var savedata =
                                //                                       "";

                                //                                   for (int i =
                                //                                           0;
                                //                                       i <
                                //                                           typetimestart
                                //                                               .length;
                                //                                       i++) {
                                //                                     if (!(i ==
                                //                                         (typetimestart.length -
                                //                                             1))) {
                                //                                       if (typetimeend[
                                //                                               i]
                                //                                           .isAfter(typetimestart[i +
                                //                                               1])) {
                                //                                         Dialogs.materialDialog(
                                //                                             msg:
                                //                                                 'กรุณาตรวจสอบการเรียงลำดับเวลาให้ถูกต้อง',
                                //                                             title:
                                //                                                 'ตรวจสอบข้อมูล',
                                //                                             context:
                                //                                                 context,
                                //                                             actions: [
                                //                                               IconsButton(
                                //                                                 onPressed: () {
                                //                                                   Navigator.of(context, rootNavigator: true).pop();
                                //                                                 },
                                //                                                 text: 'ตกลง',
                                //                                                 iconData: Icons.check_circle_outline,
                                //                                                 color: Colors.green,
                                //                                                 textStyle: TextStyle(color: Colors.white),
                                //                                                 iconColor: Colors.white,
                                //                                               ),
                                //                                             ]);

                                //                                         savedata =
                                //                                             'NO';

                                //                                         break;
                                //                                       }
                                //                                     }
                                //                                   }

                                //                                   if (savedata ==
                                //                                       "") {
                                //                                     var tagsJson =
                                //                                         jsonDecode(
                                //                                             arrayText);

                                //                                     // for (int i = 0;
                                //                                     //     i <
                                //                                     //         _data
                                //                                     //             .length;
                                //                                     //     i++) {
                                //                                     //   print(
                                //                                     //       _data.empCode!);
                                //                                     // }

                                //                                     var emplist =
                                //                                         "";
                                //                                     var empcostCenter =
                                //                                         "";
                                //                                     int i = 0;

                                //                                     for (final item
                                //                                         in _data) {
                                //                                       i++;
                                //                                       if (checkvalueHideEmp(
                                //                                           item.empCode!)) {
                                //                                         if (emplist ==
                                //                                             "") {
                                //                                           emplist =
                                //                                               item.empCode!;
                                //                                         } else {
                                //                                           emplist +=
                                //                                               ',${item.empCode!}';
                                //                                         }
                                //                                       }

                                //                                       empcostCenter =
                                //                                           item.costCenter!;
                                //                                     }

                                //                                     datasavetimesheet(
                                //                                         arrayText,
                                //                                         emplist,
                                //                                         empcostCenter,
                                //                                         '');
                                //                                     Navigator.of(
                                //                                             context,
                                //                                             rootNavigator:
                                //                                                 true)
                                //                                         .pop();
                                //                                   }
                                //                                 }
                                //                               },
                                //                             ),
                                //                           ),
                                //                         ],
                                //                       ),
                                //                       SizedBox(
                                //                         height: 10,
                                //                       ),
                                //                     ],
                                //                   ),
                                //                 ],
                                //               );
                                //             },
                                //           );
                                //         },
                                //       );
                                //     } else {
                                //       setState(() {
                                //         valall = false;
                                //       });
                                //     }
                                //   },
                                // ),
                                const SizedBox(height: 15),
                                _buildtimesheet(),
                              ],
                            ),
                          ],
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }

  Widget _buildtimesheet() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((ManpowerEmpData item) {
        return ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              enabled: checkvalueHideEmp(item.empCode!) ? true : false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${item.empCode!} ${item.empName!}',
                    style: TextStyle(fontSize: 10),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                            child: checkvalueHideEmp(item.empCode!)
                                ? _buildaddtimesheet(item)
                                : SizedBox(
                                    width: 0,
                                  )),
                        SizedBox(
                          width: 8,
                        ),
                        checkvalueHideEmp(item.empCode!)
                            ? _buildtakeoutEmp(item)
                            : _buildimportEmp(item)
                      ],
                    ),
                  )
                ],
              ),
              subtitle: Text(
                  '(${item.SumTime != null ? CustomCountTime(item.SumTime!) : ''})'),
            );
          },
          body: ListTile(
            tileColor: Colors.grey[100],
            subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Text(FormatDate('date')),
                  ),
                  Container(
                    // padding: EdgeInsets.only(top: 10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 300.0,
                          child: ListView.builder(
                            itemCount: item.lstDaily.length,
                            itemBuilder: (BuildContext context, int index) {
                              return item.lstDaily[index].status != '300'
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            '${ReplaceStatusTime(item.lstDaily[index].status)} : ${CustomTime(item.lstDaily[index].timeIn)} - ${CustomTime(item.lstDaily[index].timeOut)} (${CustomCountTime(item.lstDaily[index].dateDiffs)})'),
                                        //Text(
                                        //    "ช่วงแรก : 08:00 - 12:00 (4 ชั่วโมง 0 นาที)"),
                                        Row(
                                          children: <Widget>[
                                            _buildedittimesheet(
                                                item.lstDaily[index]),
                                            SizedBox(
                                              width: 6,
                                            ),
                                            _builddeletetimesheet(
                                                item.lstDaily[index]),
                                          ],
                                        ),
                                      ],
                                    )
                                  : SizedBox(
                                      width: 0,
                                    );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
            // isThreeLine: true,
          ),
          isExpanded:
              checkvalueHideEmp(item.empCode!) ? item.isExpanded : false,
        );
      }).toList(),
    );
  }

  Widget _buildedittimesheet(var item) {
    return Ink(
      decoration: const ShapeDecoration(
        color: Color.fromRGBO(21, 101, 192, 1),
        shape: CircleBorder(),
      ),
      width: 30,
      child: IconButton(
        icon: const Icon(Icons.edit),
        color: Colors.white,
        iconSize: 16.0,
        onPressed: () {
          TextEdittimeStart = CustomTime(item.timeIn);
          TextEdittimeEnd = CustomTime(item.timeOut);
          EdittimeStart = CustomTimeTypedate(item.timeIn);
          EdittimeEnd = CustomTimeTypedate(item.timeOut);
          showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    backgroundColor: Dialogs.bcgColor,
                    // content: Dialogs.holder,
                    shape: Dialogs.dialogShape,
                    title: Center(
                      child: Text(
                        '${ReplaceStatusTime(item.status)}',
                        style: Dialogs.titleStyle,
                      ),
                    ),
                    actions: <Widget>[
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    '${ReplaceStatusTime(item.status)} : เวลา '),
                                OutlinedButton(
                                    child: Text('${TextEdittimeStart}'),
                                    onPressed: () => {
                                          Picker(
                                              hideHeader: true,
                                              cancelText: 'ยกเลิก',
                                              confirmText: 'ตกลง',
                                              cancelTextStyle: TextStyle(
                                                  fontFamily: Fonts.fonts),
                                              confirmTextStyle: TextStyle(
                                                  fontFamily: Fonts.fonts),
                                              adapter: DateTimePickerAdapter(
                                                minuteInterval: 15,
                                                value: EdittimeStart,
                                                customColumnType: [3, 4],
                                              ),
                                              title: Text(""),
                                              selectedTextStyle:
                                                  TextStyle(color: Colors.blue),
                                              onConfirm:
                                                  (Picker picker, List value) {
                                                var result = (picker.adapter
                                                        as DateTimePickerAdapter)
                                                    .value;
                                                if (result != null) {
                                                  setState(() {
                                                    EdittimeStart = result;
                                                    TextEdittimeStart =
                                                        '${EdittimeStart.hour.toString().padLeft(2, '0')}:${EdittimeStart.minute.toString().padLeft(2, '0')}';
                                                  });
                                                }
                                              }).showDialog(context),
                                        }),
                                Text(' ถึง '),
                                OutlinedButton(
                                    child: Text('${TextEdittimeEnd}'),
                                    onPressed: () => {
                                          Picker(
                                              cancelText: 'ยกเลิก',
                                              confirmText: 'ตกลง',
                                              cancelTextStyle: TextStyle(
                                                  fontFamily: Fonts.fonts),
                                              confirmTextStyle: TextStyle(
                                                  fontFamily: Fonts.fonts),
                                              hideHeader: true,
                                              adapter: DateTimePickerAdapter(
                                                minuteInterval: 15,
                                                value: EdittimeEnd,
                                                customColumnType: [3, 4],
                                              ),
                                              title: Text(""),
                                              selectedTextStyle:
                                                  TextStyle(color: Colors.blue),
                                              onConfirm:
                                                  (Picker picker, List value) {
                                                var result = (picker.adapter
                                                        as DateTimePickerAdapter)
                                                    .value;
                                                if (result != null) {
                                                  setState(() {
                                                    EdittimeEnd = result;
                                                    TextEdittimeEnd =
                                                        '${EdittimeEnd.hour.toString().padLeft(2, '0')}:${EdittimeEnd.minute.toString().padLeft(2, '0')}';
                                                  });
                                                }
                                              }).showDialog(context),
                                        }),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 100,
                            child: IconsButton(
                              onPressed: () {
                                //////function check time

                                var cktime = "";
                                var cktimestart = "";

                                ///check ค่าว่าง
                                if ((TextEdittimeStart != "") &&
                                    (TextEdittimeEnd != "")) {
                                  cktime = 'YES1';

                                  if ((TextEdittimeStart != "") &&
                                      (TextEdittimeEnd != "")) {
                                    cktime = '';

                                    ///check ห้ามน้อยกว่าเวลาเริ่ม
                                    if (EdittimeStart.isAfter(EdittimeEnd)) {
                                      cktimestart = 'OVER1';
                                    }
                                  }
                                } else {
                                  cktime = 'YES1';
                                }

                                if ((cktime != "") || (cktimestart != "")) {
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
                                          iconData: Icons.check_circle_outline,
                                          color: Colors.green,
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          iconColor: Colors.white,
                                        ),
                                      ]);
                                } else {
                                  String arrayText =
                                      '{"${item.status}": ["${EdittimeStart}", "${EdittimeEnd}"]}';

                                  var tagsJson = jsonDecode(arrayText);
                                  datasavetimesheet(arrayText, item.empCode,
                                      item.costCenter, item.jobCode);
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                }
                              },
                              text: 'ตกลง',
                              iconData: Icons.check_circle_outline,
                              color: Colors.green,
                              textStyle: TextStyle(color: Colors.white),
                              iconColor: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _builddeletetimesheet(var item) {
    return Ink(
      decoration: const ShapeDecoration(
        color: Color.fromRGBO(198, 40, 40, 1),
        shape: CircleBorder(),
      ),
      width: 30,
      child: IconButton(
        icon: const Icon(Icons.delete),
        color: Colors.white,
        iconSize: 16.0,
        onPressed: () {
          Dialogs.materialDialog(
              msg: 'ท่านต้องการบันทึกข้อมูลใช่หรือไม่?',
              title: 'ยืนยันข้อมูล',
              context: context,
              actions: [
                IconsOutlineButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  text: 'ไม่',
                  iconData: Icons.cancel_outlined,
                  color: Colors.white,
                  textStyle: TextStyle(color: Colors.black),
                  iconColor: Colors.black,
                ),
                IconsButton(
                  text: 'ใช่',
                  iconData: Icons.check_circle_outline,
                  color: Colors.green,
                  textStyle: TextStyle(color: Colors.white),
                  iconColor: Colors.white,
                  onPressed: () {
                    //////
                    String arrayText =
                        '{"300": ["${CustomTimeTypedate(item.timeIn)}", "${CustomTimeTypedate(item.timeOut)}"]}';

                    var tagsJson = jsonDecode(arrayText);
                    datasavetimesheet(
                        arrayText, item.empCode, item.costCenter, item.jobCode);
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ]);
        },
      ),
    );
  }

  Widget _buildaddtimesheet(var item) {
    return ElevatedButton.icon(
      onPressed: () => {
        Dialogs.materialDialog(context: context, actions: [
          Column(
            children: [
              IconsButton(
                  text: ' ทำงาน',
                  color: Color.fromARGB(255, 64, 79, 74),
                  textStyle: TextStyle(color: Colors.white),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();

                    TextOTBeforeStart = "";
                    TextOTBeforeEnd = "";
                    TextDefultOneStart = "";
                    TextDefultOneEnd = "";
                    TextDefultTwoStart = "";
                    TextDefultTwoEnd = "";
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
                              title: Center(
                                child: Text(
                                  "ทำงาน",
                                  style: Dialogs.titleStyle,
                                ),
                              ),
                              // actions: <Widget>[
                              //   Column(
                              //     children: [
                              //       Container(
                              //         padding: const EdgeInsets.all(5.0),
                              //         decoration: BoxDecoration(
                              //           // color:
                              //           //     Colors.blue[50],
                              //           border: Border.all(
                              //               color: Colors.blue.shade400),
                              //           borderRadius: BorderRadius.all(
                              //               Radius.circular(5)),
                              //         ),
                              //         child: Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.spaceBetween,
                              //           children: [
                              //             Text('โอทีก่อน : เวลา '),
                              //             OutlinedButton(
                              //               onPressed: () => Picker(
                              //                   hideHeader: true,
                              //                   cancelText: 'ยกเลิก',
                              //                   confirmText: 'ตกลง',
                              //                   cancelTextStyle: TextStyle(
                              //                       fontFamily: Fonts.fonts),
                              //                   confirmTextStyle: TextStyle(
                              //                       fontFamily: Fonts.fonts),
                              //                   adapter: DateTimePickerAdapter(
                              //                     minuteInterval: 15,
                              //                     value: OTBeforeStart,
                              //                     customColumnType: [3, 4],
                              //                   ),
                              //                   title: Text(""),
                              //                   selectedTextStyle: TextStyle(
                              //                       color: Colors.blue),
                              //                   onConfirm: (Picker picker,
                              //                       List value) {
                              //                     var result = (picker.adapter
                              //                             as DateTimePickerAdapter)
                              //                         .value;
                              //                     if (result != null) {
                              //                       setState(() {
                              //                         OTBeforeStart = result;
                              //                         TextOTBeforeStart =
                              //                             '${OTBeforeStart.hour.toString().padLeft(2, '0')}:${OTBeforeStart.minute.toString().padLeft(2, '0')}';
                              //                       });
                              //                     }
                              //                   }).showDialog(context),
                              //               child: Text('${TextOTBeforeStart}'),
                              //             ),
                              //             Text(' ถึง '),
                              //             OutlinedButton(
                              //               onPressed: () =>
                              //                   // showPickerDateCustom(
                              //                   //     context,
                              //                   //     'OTBeforeEnd'),
                              //                   Picker(
                              //                       cancelText: 'ยกเลิก',
                              //                       confirmText: 'ตกลง',
                              //                       cancelTextStyle: TextStyle(
                              //                           fontFamily:
                              //                               Fonts.fonts),
                              //                       confirmTextStyle: TextStyle(
                              //                           fontFamily:
                              //                               Fonts.fonts),
                              //                       hideHeader: true,
                              //                       adapter:
                              //                           DateTimePickerAdapter(
                              //                         minuteInterval: 15,
                              //                         value: OTBeforeEnd,
                              //                         customColumnType: [3, 4],
                              //                       ),
                              //                       title: Text(""),
                              //                       selectedTextStyle:
                              //                           TextStyle(
                              //                               color: Colors.blue),
                              //                       onConfirm: (Picker picker,
                              //                           List value) {
                              //                         var result = (picker
                              //                                     .adapter
                              //                                 as DateTimePickerAdapter)
                              //                             .value;
                              //                         if (result != null) {
                              //                           setState(() {
                              //                             OTBeforeEnd = result;
                              //                             TextOTBeforeEnd =
                              //                                 '${OTBeforeEnd.hour.toString().padLeft(2, '0')}:${OTBeforeEnd.minute.toString().padLeft(2, '0')}';
                              //                           });
                              //                         }
                              //                       }).showDialog(context),
                              //               child: Text('${TextOTBeforeEnd}'),
                              //             ),

                              //             // CheckboxListTile(
                              //             //     controlAffinity:
                              //             //         ListTileControlAffinity
                              //             //             .leading,
                              //             //     contentPadding: EdgeInsets.zero,
                              //             //     dense: true,
                              //             //     title: Text(
                              //             //       'ข้ามวัน',
                              //             //       style: const TextStyle(
                              //             //         fontSize: 16.0,
                              //             //         color: Colors.black,
                              //             //       ),
                              //             //     ),
                              //             //     value: valall,
                              //             //     onChanged: (value) {
                              //             //       if (valall == false) {
                              //             //         setState(() {
                              //             //           valall = true;
                              //             //         });
                              //             //       } else {
                              //             //         setState(() {
                              //             //           valall = false;
                              //             //         });
                              //             //       }
                              //             //     })
                              //           ],
                              //         ),
                              //       ),
                              //       SizedBox(
                              //         height: 30,
                              //       ),
                              //       Container(
                              //           padding: const EdgeInsets.all(5.0),
                              //           decoration: BoxDecoration(
                              //             // color:
                              //             //     Colors.green[50],
                              //             border: Border.all(
                              //                 color: Colors.green.shade400),
                              //             borderRadius: BorderRadius.all(
                              //                 Radius.circular(5)),
                              //           ),
                              //           child: Column(
                              //             children: [
                              //               Row(
                              //                 mainAxisAlignment:
                              //                     MainAxisAlignment
                              //                         .spaceBetween,
                              //                 children: [
                              //                   Text('ช่วงแรก : เวลา '),
                              //                   OutlinedButton(
                              //                     onPressed: () =>
                              //                         // showPickerDateCustom(
                              //                         //     context,
                              //                         //     'DefultOneStart'),
                              //                         Picker(
                              //                             cancelText: 'ยกเลิก',
                              //                             confirmText: 'ตกลง',
                              //                             cancelTextStyle:
                              //                                 TextStyle(
                              //                                     fontFamily:
                              //                                         Fonts
                              //                                             .fonts),
                              //                             confirmTextStyle:
                              //                                 TextStyle(
                              //                                     fontFamily:
                              //                                         Fonts
                              //                                             .fonts),
                              //                             hideHeader: true,
                              //                             adapter:
                              //                                 DateTimePickerAdapter(
                              //                               minuteInterval: 15,
                              //                               value:
                              //                                   DefultOneStart,
                              //                               customColumnType: [
                              //                                 3,
                              //                                 4
                              //                               ],
                              //                             ),
                              //                             title: Text(""),
                              //                             selectedTextStyle:
                              //                                 TextStyle(
                              //                                     color: Colors
                              //                                         .blue),
                              //                             onConfirm:
                              //                                 (Picker picker,
                              //                                     List value) {
                              //                               var result = (picker
                              //                                           .adapter
                              //                                       as DateTimePickerAdapter)
                              //                                   .value;
                              //                               if (result !=
                              //                                   null) {
                              //                                 setState(() {
                              //                                   DefultOneStart =
                              //                                       result;
                              //                                   TextDefultOneStart =
                              //                                       '${DefultOneStart.hour.toString().padLeft(2, '0')}:${DefultOneStart.minute.toString().padLeft(2, '0')}';
                              //                                 });
                              //                               }
                              //                             }).showDialog(context),
                              //                     child: Text(
                              //                         '${TextDefultOneStart}'),
                              //                   ),
                              //                   Text(' ถึง '),
                              //                   OutlinedButton(
                              //                     onPressed: () =>
                              //                         // showPickerDateCustom(
                              //                         //     context,
                              //                         //     'DefultOneEnd'),
                              //                         Picker(
                              //                             cancelText: 'ยกเลิก',
                              //                             confirmText: 'ตกลง',
                              //                             cancelTextStyle:
                              //                                 TextStyle(
                              //                                     fontFamily:
                              //                                         Fonts
                              //                                             .fonts),
                              //                             confirmTextStyle:
                              //                                 TextStyle(
                              //                                     fontFamily:
                              //                                         Fonts
                              //                                             .fonts),
                              //                             hideHeader: true,
                              //                             adapter:
                              //                                 DateTimePickerAdapter(
                              //                               minuteInterval: 15,
                              //                               value: DefultOneEnd,
                              //                               customColumnType: [
                              //                                 3,
                              //                                 4
                              //                               ],
                              //                             ),
                              //                             title: Text(""),
                              //                             selectedTextStyle:
                              //                                 TextStyle(
                              //                                     color: Colors
                              //                                         .blue),
                              //                             onConfirm:
                              //                                 (Picker picker,
                              //                                     List value) {
                              //                               var result = (picker
                              //                                           .adapter
                              //                                       as DateTimePickerAdapter)
                              //                                   .value;
                              //                               if (result !=
                              //                                   null) {
                              //                                 setState(() {
                              //                                   DefultOneEnd =
                              //                                       result;
                              //                                   TextDefultOneEnd =
                              //                                       '${DefultOneEnd.hour.toString().padLeft(2, '0')}:${DefultOneEnd.minute.toString().padLeft(2, '0')}';
                              //                                 });
                              //                               }
                              //                             }).showDialog(context),
                              //                     child: Text(
                              //                         '${TextDefultOneEnd}'),
                              //                   ),
                              //                 ],
                              //               ),
                              //               Row(
                              //                 mainAxisAlignment:
                              //                     MainAxisAlignment
                              //                         .spaceBetween,
                              //                 children: [
                              //                   Text('ช่วงหลัง : เวลา '),
                              //                   OutlinedButton(
                              //                     onPressed: () =>
                              //                         // showPickerDateCustom(
                              //                         //     context,
                              //                         //     'DefultTwoStart'),
                              //                         Picker(
                              //                             cancelText: 'ยกเลิก',
                              //                             confirmText: 'ตกลง',
                              //                             cancelTextStyle:
                              //                                 TextStyle(
                              //                                     fontFamily:
                              //                                         Fonts
                              //                                             .fonts),
                              //                             confirmTextStyle:
                              //                                 TextStyle(
                              //                                     fontFamily:
                              //                                         Fonts
                              //                                             .fonts),
                              //                             hideHeader: true,
                              //                             adapter:
                              //                                 DateTimePickerAdapter(
                              //                               minuteInterval: 15,
                              //                               value:
                              //                                   DefultTwoStart,
                              //                               customColumnType: [
                              //                                 3,
                              //                                 4
                              //                               ],
                              //                             ),
                              //                             title: Text(""),
                              //                             selectedTextStyle:
                              //                                 TextStyle(
                              //                                     color: Colors
                              //                                         .blue),
                              //                             onConfirm:
                              //                                 (Picker picker,
                              //                                     List value) {
                              //                               var result = (picker
                              //                                           .adapter
                              //                                       as DateTimePickerAdapter)
                              //                                   .value;
                              //                               if (result !=
                              //                                   null) {
                              //                                 setState(() {
                              //                                   DefultTwoStart =
                              //                                       result;
                              //                                   TextDefultTwoStart =
                              //                                       '${DefultTwoStart.hour.toString().padLeft(2, '0')}:${DefultTwoStart.minute.toString().padLeft(2, '0')}';
                              //                                 });
                              //                               }
                              //                             }).showDialog(context),
                              //                     child: Text(
                              //                         '${TextDefultTwoStart}'),
                              //                   ),
                              //                   Text(' ถึง '),
                              //                   OutlinedButton(
                              //                     onPressed: () =>
                              //                         // showPickerDateCustom(
                              //                         //     context,
                              //                         //     'DefultTwoEnd'),
                              //                         Picker(
                              //                             cancelText: 'ยกเลิก',
                              //                             confirmText: 'ตกลง',
                              //                             cancelTextStyle:
                              //                                 TextStyle(
                              //                                     fontFamily:
                              //                                         Fonts
                              //                                             .fonts),
                              //                             confirmTextStyle:
                              //                                 TextStyle(
                              //                                     fontFamily:
                              //                                         Fonts
                              //                                             .fonts),
                              //                             hideHeader: true,
                              //                             adapter:
                              //                                 DateTimePickerAdapter(
                              //                               minuteInterval: 15,
                              //                               value: DefultTwoEnd,
                              //                               customColumnType: [
                              //                                 3,
                              //                                 4
                              //                               ],
                              //                             ),
                              //                             title: Text(""),
                              //                             selectedTextStyle:
                              //                                 TextStyle(
                              //                                     color: Colors
                              //                                         .blue),
                              //                             onConfirm:
                              //                                 (Picker picker,
                              //                                     List value) {
                              //                               var result = (picker
                              //                                           .adapter
                              //                                       as DateTimePickerAdapter)
                              //                                   .value;
                              //                               if (result !=
                              //                                   null) {
                              //                                 setState(() {
                              //                                   DefultTwoEnd =
                              //                                       result;
                              //                                   TextDefultTwoEnd =
                              //                                       '${DefultTwoEnd.hour.toString().padLeft(2, '0')}:${DefultTwoEnd.minute.toString().padLeft(2, '0')}';
                              //                                 });
                              //                               }
                              //                             }).showDialog(context),
                              //                     child: Text(
                              //                         '${TextDefultTwoEnd}'),
                              //                   ),
                              //                 ],
                              //               ),
                              //             ],
                              //           )),
                              //       SizedBox(
                              //         height: 30,
                              //       ),
                              //       Container(
                              //         padding: const EdgeInsets.all(5.0),
                              //         decoration: BoxDecoration(
                              //           // color:
                              //           //     Colors.yellow[50],
                              //           border: Border.all(
                              //               color: Colors.orange.shade400),
                              //           borderRadius: BorderRadius.all(
                              //               Radius.circular(5)),
                              //         ),
                              //         child: Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.spaceBetween,
                              //           children: [
                              //             Text('โอทีหลัง : เวลา '),
                              //             OutlinedButton(
                              //               onPressed: () =>
                              //                   // showPickerDateCustom(
                              //                   //     context,
                              //                   //     'OTAfterStart'),
                              //                   Picker(
                              //                       cancelText: 'ยกเลิก',
                              //                       confirmText: 'ตกลง',
                              //                       cancelTextStyle: TextStyle(
                              //                           fontFamily:
                              //                               Fonts.fonts),
                              //                       confirmTextStyle: TextStyle(
                              //                           fontFamily:
                              //                               Fonts.fonts),
                              //                       hideHeader: true,
                              //                       adapter:
                              //                           DateTimePickerAdapter(
                              //                         minuteInterval: 15,
                              //                         value: OTAfterStart,
                              //                         customColumnType: [3, 4],
                              //                       ),
                              //                       title: Text(""),
                              //                       selectedTextStyle:
                              //                           TextStyle(
                              //                               color: Colors.blue),
                              //                       onConfirm: (Picker picker,
                              //                           List value) {
                              //                         var result = (picker
                              //                                     .adapter
                              //                                 as DateTimePickerAdapter)
                              //                             .value;
                              //                         if (result != null) {
                              //                           setState(() {
                              //                             OTAfterStart = result;
                              //                             TextOTAfterStart =
                              //                                 '${OTAfterStart.hour.toString().padLeft(2, '0')}:${OTAfterStart.minute.toString().padLeft(2, '0')}';
                              //                           });
                              //                         }
                              //                       }).showDialog(context),
                              //               child: Text('${TextOTAfterStart}'),
                              //             ),
                              //             Text(' ถึง '),
                              //             OutlinedButton(
                              //               onPressed: () =>
                              //                   // showPickerDateCustom(
                              //                   //     context,
                              //                   //     'OTAfterEnd'),
                              //                   Picker(
                              //                       cancelText: 'ยกเลิก',
                              //                       confirmText: 'ตกลง',
                              //                       cancelTextStyle: TextStyle(
                              //                           fontFamily:
                              //                               Fonts.fonts),
                              //                       confirmTextStyle: TextStyle(
                              //                           fontFamily:
                              //                               Fonts.fonts),
                              //                       hideHeader: true,
                              //                       adapter:
                              //                           DateTimePickerAdapter(
                              //                         minuteInterval: 15,
                              //                         value: OTAfterEnd,
                              //                         customColumnType: [3, 4],
                              //                       ),
                              //                       title: Text(""),
                              //                       selectedTextStyle:
                              //                           TextStyle(
                              //                               color: Colors.blue),
                              //                       onConfirm: (Picker picker,
                              //                           List value) {
                              //                         var result = (picker
                              //                                     .adapter
                              //                                 as DateTimePickerAdapter)
                              //                             .value;
                              //                         if (result != null) {
                              //                           setState(() {
                              //                             OTAfterEnd = result;
                              //                             TextOTAfterEnd =
                              //                                 '${OTAfterEnd.hour.toString().padLeft(2, '0')}:${OTAfterEnd.minute.toString().padLeft(2, '0')}';
                              //                           });
                              //                         }
                              //                       }).showDialog(context),
                              //               child: Text('${TextOTAfterEnd}'),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //       SizedBox(
                              //         height: 20,
                              //       ),
                              //       SizedBox(
                              //         width: 100,
                              //         child: IconsButton(
                              //           text: 'ตกลง',
                              //           iconData: Icons.check_circle_outline,
                              //           color: Colors.green,
                              //           textStyle:
                              //               TextStyle(color: Colors.white),
                              //           iconColor: Colors.white,
                              //           onPressed: () {
                              //             //////function check time

                              //             var ckOTBefore = "";
                              //             var ckOTBeforestart = "";
                              //             var ckDefultOne = "";
                              //             var ckDefultOnestart = "";
                              //             var ckDefultTwo = "";
                              //             var ckOTDefultTwostart = "";
                              //             var ckOTAfter = "";
                              //             var ckOTOTAfterstart = "";

                              //             ///check ค่าว่าง
                              //             if ((TextOTBeforeStart != "") ||
                              //                 (TextOTBeforeEnd != "")) {
                              //               ckOTBefore = 'YES1';

                              //               if ((TextOTBeforeStart != "") &&
                              //                   (TextOTBeforeEnd != "")) {
                              //                 ckOTBefore = '';

                              //                 ///check ห้ามน้อยกว่าเวลาเริ่ม
                              //                 if (OTBeforeStart.isAfter(
                              //                     OTBeforeEnd)) {
                              //                   ckOTBeforestart = 'OVER1';
                              //                 }
                              //               }
                              //             }

                              //             if ((TextDefultOneStart != "") ||
                              //                 (TextDefultOneEnd != "")) {
                              //               ckDefultOne = 'YES2';

                              //               if ((TextDefultOneStart != "") &&
                              //                   (TextDefultOneEnd != "")) {
                              //                 ckDefultOne = '';

                              //                 ///check ห้ามน้อยกว่าเวลาเริ่ม
                              //                 if (DefultOneStart.isAfter(
                              //                     DefultOneEnd)) {
                              //                   ckDefultOnestart = 'OVER2';
                              //                 }
                              //               }
                              //             }

                              //             if ((TextDefultTwoStart != "") ||
                              //                 (TextDefultTwoEnd != "")) {
                              //               ckDefultTwo = 'YES3';

                              //               if ((TextDefultTwoStart != "") &&
                              //                   (TextDefultTwoEnd != "")) {
                              //                 ckDefultTwo = '';

                              //                 ///check ห้ามน้อยกว่าเวลาเริ่ม
                              //                 if (DefultTwoStart.isAfter(
                              //                     DefultTwoEnd)) {
                              //                   ckOTDefultTwostart = 'OVER3';
                              //                 }
                              //               }
                              //             }

                              //             if ((TextOTAfterStart != "") ||
                              //                 (TextOTAfterEnd != "")) {
                              //               ckOTAfter = 'YES4';

                              //               if ((TextOTAfterStart != "") &&
                              //                   (TextOTAfterEnd != "")) {
                              //                 ckOTAfter = '';

                              //                 ///check ห้ามน้อยกว่าเวลาเริ่ม
                              //                 if (OTAfterStart.isAfter(
                              //                     OTAfterEnd)) {
                              //                   ckOTOTAfterstart = 'OVER4';
                              //                 }
                              //               }
                              //             }

                              //             if ((((ckOTBefore != "") ||
                              //                         (ckDefultOne != "") ||
                              //                         (ckDefultTwo != "") ||
                              //                         (ckOTAfter != "")) ||
                              //                     ((ckOTBeforestart != "") ||
                              //                         (ckDefultOnestart !=
                              //                             "") ||
                              //                         (ckOTDefultTwostart !=
                              //                             "") ||
                              //                         (ckOTOTAfterstart !=
                              //                             ""))) ||
                              //                 ((TextOTBeforeStart == "") &&
                              //                     (TextOTBeforeEnd == "") &&
                              //                     (TextDefultOneStart == "") &&
                              //                     (TextDefultOneEnd == "") &&
                              //                     (TextDefultTwoStart == "") &&
                              //                     (TextDefultTwoEnd == "") &&
                              //                     (TextOTAfterStart == "") &&
                              //                     (TextOTAfterEnd == ""))) {
                              //               Dialogs.materialDialog(
                              //                   msg:
                              //                       'กรุณาตรวจสอบเวลาเริ่มต้นและเวลาสิ้นสุดให้ถูกต้อง',
                              //                   title: 'ตรวจสอบข้อมูล',
                              //                   context: context,
                              //                   actions: [
                              //                     IconsButton(
                              //                       onPressed: () {
                              //                         Navigator.of(context,
                              //                                 rootNavigator:
                              //                                     true)
                              //                             .pop();
                              //                       },
                              //                       text: 'ตกลง',
                              //                       iconData: Icons
                              //                           .check_circle_outline,
                              //                       color: Colors.green,
                              //                       textStyle: TextStyle(
                              //                           color: Colors.white),
                              //                       iconColor: Colors.white,
                              //                     ),
                              //                   ]);
                              //             } else {
                              //               ///check การเรียงลำดับเวลา

                              //               String arrayText = "";

                              //               List<DateTime> typetimestart = [];
                              //               List<DateTime> typetimeend = [];
                              //               if (TextOTBeforeEnd != "") {
                              //                 typetimestart.add(OTBeforeStart);
                              //                 typetimeend.add(OTBeforeEnd);

                              //                 arrayText =
                              //                     '{"101": ["${OTBeforeStart}", "${OTBeforeEnd}"]';
                              //               }
                              //               if (TextDefultOneEnd != "") {
                              //                 typetimestart.add(DefultOneStart);
                              //                 typetimeend.add(DefultOneEnd);

                              //                 if (arrayText == "") {
                              //                   arrayText = '{';
                              //                 } else {
                              //                   arrayText += ',';
                              //                 }
                              //                 arrayText +=
                              //                     '"102": ["${DefultOneStart}", "${DefultOneEnd}"]';
                              //               }
                              //               if (TextDefultTwoEnd != "") {
                              //                 typetimestart.add(DefultTwoStart);
                              //                 typetimeend.add(DefultTwoEnd);

                              //                 if (arrayText == "") {
                              //                   arrayText = '{';
                              //                 } else {
                              //                   arrayText += ',';
                              //                 }
                              //                 arrayText +=
                              //                     '"103": ["${DefultTwoStart}", "${DefultTwoEnd}"]';
                              //               }
                              //               if (TextOTAfterEnd != "") {
                              //                 typetimestart.add(OTAfterStart);
                              //                 typetimeend.add(OTAfterEnd);

                              //                 if (arrayText == "") {
                              //                   arrayText += '{';
                              //                 } else {
                              //                   arrayText += ',';
                              //                 }
                              //                 arrayText +=
                              //                     '"104": ["${OTAfterStart}", "${OTAfterEnd}"]';
                              //               }

                              //               arrayText += "}";

                              //               var savedata = "";

                              //               for (int i = 0;
                              //                   i < typetimestart.length;
                              //                   i++) {
                              //                 if (!(i ==
                              //                     (typetimestart.length - 1))) {
                              //                   if (typetimeend[i].isAfter(
                              //                       typetimestart[i + 1])) {
                              //                     Dialogs.materialDialog(
                              //                         msg:
                              //                             'กรุณาตรวจสอบการเรียงลำดับเวลาให้ถูกต้อง',
                              //                         title: 'ตรวจสอบข้อมูล',
                              //                         context: context,
                              //                         actions: [
                              //                           IconsButton(
                              //                             onPressed: () {
                              //                               Navigator.of(
                              //                                       context,
                              //                                       rootNavigator:
                              //                                           true)
                              //                                   .pop();
                              //                             },
                              //                             text: 'ตกลง',
                              //                             iconData: Icons
                              //                                 .check_circle_outline,
                              //                             color: Colors.green,
                              //                             textStyle: TextStyle(
                              //                                 color:
                              //                                     Colors.white),
                              //                             iconColor:
                              //                                 Colors.white,
                              //                           ),
                              //                         ]);

                              //                     savedata = 'NO';

                              //                     break;
                              //                   }
                              //                 }
                              //               }

                              //               if (savedata == "") {
                              //                 var tagsJson =
                              //                     jsonDecode(arrayText);
                              //                 datasavetimesheet(
                              //                     arrayText,
                              //                     item.empCode!,
                              //                     item.costCenter!,
                              //                     '');
                              //                 Navigator.of(context,
                              //                         rootNavigator: true)
                              //                     .pop();

                              //                 // List<String>
                              //                 //     tags =
                              //                 //     List.from(tagsJson);
                              //               }
                              //             }
                              //           },
                              //         ),
                              //       ),
                              //       SizedBox(
                              //         height: 10,
                              //       ),
                              //     ],
                              //   ),
                              // ],
                              content: SingleChildScrollView(
                                  child: Container(
                                      width: MediaQuery.of(context).size.width -
                                          10,
                                      // height: 500,
                                      child: Column(children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                            // color:
                                            //     Colors.blue[50],
                                            border: Border.all(
                                                color: Colors.blue.shade400),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'โอทีก่อน : เวลา ',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              OutlinedButton(
                                                onPressed: () => Picker(
                                                    hideHeader: true,
                                                    cancelText: 'ยกเลิก',
                                                    confirmText: 'ตกลง',
                                                    cancelTextStyle: TextStyle(
                                                        fontFamily:
                                                            Fonts.fonts),
                                                    confirmTextStyle: TextStyle(
                                                        fontFamily:
                                                            Fonts.fonts),
                                                    adapter:
                                                        DateTimePickerAdapter(
                                                      minuteInterval: 15,
                                                      value: OTBeforeStart,
                                                      customColumnType: [3, 4],
                                                    ),
                                                    title: Text(""),
                                                    selectedTextStyle:
                                                        TextStyle(
                                                            color: Colors.blue),
                                                    onConfirm: (Picker picker,
                                                        List value) {
                                                      var result = (picker
                                                                  .adapter
                                                              as DateTimePickerAdapter)
                                                          .value;
                                                      if (result != null) {
                                                        setState(() {
                                                          OTBeforeStart =
                                                              result;
                                                          TextOTBeforeStart =
                                                              '${OTBeforeStart.hour.toString().padLeft(2, '0')}:${OTBeforeStart.minute.toString().padLeft(2, '0')}';
                                                        });
                                                      }
                                                    }).showDialog(context),
                                                child: Text(
                                                    '${TextOTBeforeStart}'),
                                              ),
                                              Text(
                                                ' ถึง ',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              OutlinedButton(
                                                onPressed: () =>
                                                    // showPickerDateCustom(
                                                    //     context,
                                                    //     'OTBeforeEnd'),
                                                    Picker(
                                                        cancelText: 'ยกเลิก',
                                                        confirmText: 'ตกลง',
                                                        cancelTextStyle:
                                                            TextStyle(
                                                                fontFamily:
                                                                    Fonts
                                                                        .fonts),
                                                        confirmTextStyle:
                                                            TextStyle(
                                                                fontFamily:
                                                                    Fonts
                                                                        .fonts),
                                                        hideHeader: true,
                                                        adapter:
                                                            DateTimePickerAdapter(
                                                          minuteInterval: 15,
                                                          value: OTBeforeEnd,
                                                          customColumnType: [
                                                            3,
                                                            4
                                                          ],
                                                        ),
                                                        title: Text(""),
                                                        selectedTextStyle:
                                                            TextStyle(
                                                                color: Colors
                                                                    .blue),
                                                        onConfirm:
                                                            (Picker picker,
                                                                List value) {
                                                          var result = (picker
                                                                      .adapter
                                                                  as DateTimePickerAdapter)
                                                              .value;
                                                          if (result != null) {
                                                            setState(() {
                                                              OTBeforeEnd =
                                                                  result;
                                                              TextOTBeforeEnd =
                                                                  '${OTBeforeEnd.hour.toString().padLeft(2, '0')}:${OTBeforeEnd.minute.toString().padLeft(2, '0')}';
                                                            });
                                                          }
                                                        }).showDialog(context),
                                                child:
                                                    Text('${TextOTBeforeEnd}'),
                                              ),
                                              Checkbox(
                                                checkColor: Colors.white,
                                                value: valall,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    valall = value!;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Container(
                                            padding: const EdgeInsets.all(5.0),
                                            decoration: BoxDecoration(
                                              // color:
                                              //     Colors.green[50],
                                              border: Border.all(
                                                  color: Colors.green.shade400),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text('ช่วงแรก : เวลา '),
                                                    OutlinedButton(
                                                      onPressed: () =>
                                                          // showPickerDateCustom(
                                                          //     context,
                                                          //     'DefultOneStart'),
                                                          Picker(
                                                              cancelText:
                                                                  'ยกเลิก',
                                                              confirmText:
                                                                  'ตกลง',
                                                              cancelTextStyle:
                                                                  TextStyle(
                                                                      fontFamily: Fonts
                                                                          .fonts),
                                                              confirmTextStyle:
                                                                  TextStyle(
                                                                      fontFamily: Fonts
                                                                          .fonts),
                                                              hideHeader: true,
                                                              adapter:
                                                                  DateTimePickerAdapter(
                                                                minuteInterval:
                                                                    15,
                                                                value:
                                                                    DefultOneStart,
                                                                customColumnType: [
                                                                  3,
                                                                  4
                                                                ],
                                                              ),
                                                              title: Text(""),
                                                              selectedTextStyle:
                                                                  TextStyle(
                                                                      color: Colors
                                                                          .blue),
                                                              onConfirm: (Picker
                                                                      picker,
                                                                  List value) {
                                                                var result =
                                                                    (picker.adapter
                                                                            as DateTimePickerAdapter)
                                                                        .value;
                                                                if (result !=
                                                                    null) {
                                                                  setState(() {
                                                                    DefultOneStart =
                                                                        result;
                                                                    TextDefultOneStart =
                                                                        '${DefultOneStart.hour.toString().padLeft(2, '0')}:${DefultOneStart.minute.toString().padLeft(2, '0')}';
                                                                  });
                                                                }
                                                              }).showDialog(context),
                                                      child: Text(
                                                          '${TextDefultOneStart}'),
                                                    ),
                                                    Text(' ถึง '),
                                                    OutlinedButton(
                                                      onPressed: () =>
                                                          // showPickerDateCustom(
                                                          //     context,
                                                          //     'DefultOneEnd'),
                                                          Picker(
                                                              cancelText:
                                                                  'ยกเลิก',
                                                              confirmText:
                                                                  'ตกลง',
                                                              cancelTextStyle:
                                                                  TextStyle(
                                                                      fontFamily: Fonts
                                                                          .fonts),
                                                              confirmTextStyle:
                                                                  TextStyle(
                                                                      fontFamily: Fonts
                                                                          .fonts),
                                                              hideHeader: true,
                                                              adapter:
                                                                  DateTimePickerAdapter(
                                                                minuteInterval:
                                                                    15,
                                                                value:
                                                                    DefultOneEnd,
                                                                customColumnType: [
                                                                  3,
                                                                  4
                                                                ],
                                                              ),
                                                              title: Text(""),
                                                              selectedTextStyle:
                                                                  TextStyle(
                                                                      color: Colors
                                                                          .blue),
                                                              onConfirm: (Picker
                                                                      picker,
                                                                  List value) {
                                                                var result =
                                                                    (picker.adapter
                                                                            as DateTimePickerAdapter)
                                                                        .value;
                                                                if (result !=
                                                                    null) {
                                                                  setState(() {
                                                                    DefultOneEnd =
                                                                        result;
                                                                    TextDefultOneEnd =
                                                                        '${DefultOneEnd.hour.toString().padLeft(2, '0')}:${DefultOneEnd.minute.toString().padLeft(2, '0')}';
                                                                  });
                                                                }
                                                              }).showDialog(context),
                                                      child: Text(
                                                          '${TextDefultOneEnd}'),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text('ช่วงหลัง : เวลา '),
                                                    OutlinedButton(
                                                      onPressed: () =>
                                                          // showPickerDateCustom(
                                                          //     context,
                                                          //     'DefultTwoStart'),
                                                          Picker(
                                                              cancelText:
                                                                  'ยกเลิก',
                                                              confirmText:
                                                                  'ตกลง',
                                                              cancelTextStyle:
                                                                  TextStyle(
                                                                      fontFamily: Fonts
                                                                          .fonts),
                                                              confirmTextStyle:
                                                                  TextStyle(
                                                                      fontFamily: Fonts
                                                                          .fonts),
                                                              hideHeader: true,
                                                              adapter:
                                                                  DateTimePickerAdapter(
                                                                minuteInterval:
                                                                    15,
                                                                value:
                                                                    DefultTwoStart,
                                                                customColumnType: [
                                                                  3,
                                                                  4
                                                                ],
                                                              ),
                                                              title: Text(""),
                                                              selectedTextStyle:
                                                                  TextStyle(
                                                                      color: Colors
                                                                          .blue),
                                                              onConfirm: (Picker
                                                                      picker,
                                                                  List value) {
                                                                var result =
                                                                    (picker.adapter
                                                                            as DateTimePickerAdapter)
                                                                        .value;
                                                                if (result !=
                                                                    null) {
                                                                  setState(() {
                                                                    DefultTwoStart =
                                                                        result;
                                                                    TextDefultTwoStart =
                                                                        '${DefultTwoStart.hour.toString().padLeft(2, '0')}:${DefultTwoStart.minute.toString().padLeft(2, '0')}';
                                                                  });
                                                                }
                                                              }).showDialog(context),
                                                      child: Text(
                                                          '${TextDefultTwoStart}'),
                                                    ),
                                                    Text(' ถึง '),
                                                    OutlinedButton(
                                                      onPressed: () =>
                                                          // showPickerDateCustom(
                                                          //     context,
                                                          //     'DefultTwoEnd'),
                                                          Picker(
                                                              cancelText:
                                                                  'ยกเลิก',
                                                              confirmText:
                                                                  'ตกลง',
                                                              cancelTextStyle:
                                                                  TextStyle(
                                                                      fontFamily: Fonts
                                                                          .fonts),
                                                              confirmTextStyle:
                                                                  TextStyle(
                                                                      fontFamily: Fonts
                                                                          .fonts),
                                                              hideHeader: true,
                                                              adapter:
                                                                  DateTimePickerAdapter(
                                                                minuteInterval:
                                                                    15,
                                                                value:
                                                                    DefultTwoEnd,
                                                                customColumnType: [
                                                                  3,
                                                                  4
                                                                ],
                                                              ),
                                                              title: Text(""),
                                                              selectedTextStyle:
                                                                  TextStyle(
                                                                      color: Colors
                                                                          .blue),
                                                              onConfirm: (Picker
                                                                      picker,
                                                                  List value) {
                                                                var result =
                                                                    (picker.adapter
                                                                            as DateTimePickerAdapter)
                                                                        .value;
                                                                if (result !=
                                                                    null) {
                                                                  setState(() {
                                                                    DefultTwoEnd =
                                                                        result;
                                                                    TextDefultTwoEnd =
                                                                        '${DefultTwoEnd.hour.toString().padLeft(2, '0')}:${DefultTwoEnd.minute.toString().padLeft(2, '0')}';
                                                                  });
                                                                }
                                                              }).showDialog(context),
                                                      child: Text(
                                                          '${TextDefultTwoEnd}'),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                            // color:
                                            //     Colors.yellow[50],
                                            border: Border.all(
                                                color: Colors.orange.shade400),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('โอทีหลัง : เวลา '),
                                              OutlinedButton(
                                                onPressed: () =>
                                                    // showPickerDateCustom(
                                                    //     context,
                                                    //     'OTAfterStart'),
                                                    Picker(
                                                        cancelText: 'ยกเลิก',
                                                        confirmText: 'ตกลง',
                                                        cancelTextStyle:
                                                            TextStyle(
                                                                fontFamily:
                                                                    Fonts
                                                                        .fonts),
                                                        confirmTextStyle:
                                                            TextStyle(
                                                                fontFamily:
                                                                    Fonts
                                                                        .fonts),
                                                        hideHeader: true,
                                                        adapter:
                                                            DateTimePickerAdapter(
                                                          minuteInterval: 15,
                                                          value: OTAfterStart,
                                                          customColumnType: [
                                                            3,
                                                            4
                                                          ],
                                                        ),
                                                        title: Text(""),
                                                        selectedTextStyle:
                                                            TextStyle(
                                                                color: Colors
                                                                    .blue),
                                                        onConfirm:
                                                            (Picker picker,
                                                                List value) {
                                                          var result = (picker
                                                                      .adapter
                                                                  as DateTimePickerAdapter)
                                                              .value;
                                                          if (result != null) {
                                                            setState(() {
                                                              OTAfterStart =
                                                                  result;
                                                              TextOTAfterStart =
                                                                  '${OTAfterStart.hour.toString().padLeft(2, '0')}:${OTAfterStart.minute.toString().padLeft(2, '0')}';
                                                            });
                                                          }
                                                        }).showDialog(context),
                                                child:
                                                    Text('${TextOTAfterStart}'),
                                              ),
                                              Text(' ถึง '),
                                              OutlinedButton(
                                                onPressed: () =>
                                                    // showPickerDateCustom(
                                                    //     context,
                                                    //     'OTAfterEnd'),
                                                    Picker(
                                                        cancelText: 'ยกเลิก',
                                                        confirmText: 'ตกลง',
                                                        cancelTextStyle:
                                                            TextStyle(
                                                                fontFamily:
                                                                    Fonts
                                                                        .fonts),
                                                        confirmTextStyle:
                                                            TextStyle(
                                                                fontFamily:
                                                                    Fonts
                                                                        .fonts),
                                                        hideHeader: true,
                                                        adapter:
                                                            DateTimePickerAdapter(
                                                          minuteInterval: 15,
                                                          value: OTAfterEnd,
                                                          customColumnType: [
                                                            3,
                                                            4
                                                          ],
                                                        ),
                                                        title: Text(""),
                                                        selectedTextStyle:
                                                            TextStyle(
                                                                color: Colors
                                                                    .blue),
                                                        onConfirm:
                                                            (Picker picker,
                                                                List value) {
                                                          var result = (picker
                                                                      .adapter
                                                                  as DateTimePickerAdapter)
                                                              .value;
                                                          if (result != null) {
                                                            setState(() {
                                                              OTAfterEnd =
                                                                  result;
                                                              TextOTAfterEnd =
                                                                  '${OTAfterEnd.hour.toString().padLeft(2, '0')}:${OTAfterEnd.minute.toString().padLeft(2, '0')}';
                                                            });
                                                          }
                                                        }).showDialog(context),
                                                child:
                                                    Text('${TextOTAfterEnd}'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: IconsButton(
                                            text: 'ตกลง',
                                            iconData:
                                                Icons.check_circle_outline,
                                            color: Colors.green,
                                            textStyle:
                                                TextStyle(color: Colors.white),
                                            iconColor: Colors.white,
                                            onPressed: () {
                                              //////function check time

                                              var ckOTBefore = "";
                                              var ckOTBeforestart = "";
                                              var ckDefultOne = "";
                                              var ckDefultOnestart = "";
                                              var ckDefultTwo = "";
                                              var ckOTDefultTwostart = "";
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
                                                  if (OTBeforeStart.isAfter(
                                                      OTBeforeEnd)) {
                                                    ckOTBeforestart = 'OVER1';
                                                  }
                                                }
                                              }

                                              if ((TextDefultOneStart != "") ||
                                                  (TextDefultOneEnd != "")) {
                                                ckDefultOne = 'YES2';

                                                if ((TextDefultOneStart !=
                                                        "") &&
                                                    (TextDefultOneEnd != "")) {
                                                  ckDefultOne = '';

                                                  ///check ห้ามน้อยกว่าเวลาเริ่ม
                                                  if (DefultOneStart.isAfter(
                                                      DefultOneEnd)) {
                                                    ckDefultOnestart = 'OVER2';
                                                  }
                                                }
                                              }

                                              if ((TextDefultTwoStart != "") ||
                                                  (TextDefultTwoEnd != "")) {
                                                ckDefultTwo = 'YES3';

                                                if ((TextDefultTwoStart !=
                                                        "") &&
                                                    (TextDefultTwoEnd != "")) {
                                                  ckDefultTwo = '';

                                                  ///check ห้ามน้อยกว่าเวลาเริ่ม
                                                  if (DefultTwoStart.isAfter(
                                                      DefultTwoEnd)) {
                                                    ckOTDefultTwostart =
                                                        'OVER3';
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
                                                  if (OTAfterStart.isAfter(
                                                      OTAfterEnd)) {
                                                    ckOTOTAfterstart = 'OVER4';
                                                  }
                                                }
                                              }

                                              if ((((ckOTBefore != "") ||
                                                          (ckDefultOne != "") ||
                                                          (ckDefultTwo != "") ||
                                                          (ckOTAfter != "")) ||
                                                      ((ckOTBeforestart != "") ||
                                                          (ckDefultOnestart !=
                                                              "") ||
                                                          (ckOTDefultTwostart !=
                                                              "") ||
                                                          (ckOTOTAfterstart !=
                                                              ""))) ||
                                                  ((TextOTBeforeStart == "") &&
                                                      (TextOTBeforeEnd == "") &&
                                                      (TextDefultOneStart ==
                                                          "") &&
                                                      (TextDefultOneEnd ==
                                                          "") &&
                                                      (TextDefultTwoStart ==
                                                          "") &&
                                                      (TextDefultTwoEnd ==
                                                          "") &&
                                                      (TextOTAfterStart ==
                                                          "") &&
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
                                                                  rootNavigator:
                                                                      true)
                                                              .pop();
                                                        },
                                                        text: 'ตกลง',
                                                        iconData: Icons
                                                            .check_circle_outline,
                                                        color: Colors.green,
                                                        textStyle: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        iconColor: Colors.white,
                                                      ),
                                                    ]);
                                              } else {
                                                ///check การเรียงลำดับเวลา

                                                String arrayText = "";

                                                List<DateTime> typetimestart =
                                                    [];
                                                List<DateTime> typetimeend = [];
                                                if (TextOTBeforeEnd != "") {
                                                  typetimestart
                                                      .add(OTBeforeStart);
                                                  typetimeend.add(OTBeforeEnd);

                                                  arrayText =
                                                      '{"101": ["${OTBeforeStart}", "${OTBeforeEnd}"]';
                                                }
                                                if (TextDefultOneEnd != "") {
                                                  typetimestart
                                                      .add(DefultOneStart);
                                                  typetimeend.add(DefultOneEnd);

                                                  if (arrayText == "") {
                                                    arrayText = '{';
                                                  } else {
                                                    arrayText += ',';
                                                  }
                                                  arrayText +=
                                                      '"102": ["${DefultOneStart}", "${DefultOneEnd}"]';
                                                }
                                                if (TextDefultTwoEnd != "") {
                                                  typetimestart
                                                      .add(DefultTwoStart);
                                                  typetimeend.add(DefultTwoEnd);

                                                  if (arrayText == "") {
                                                    arrayText = '{';
                                                  } else {
                                                    arrayText += ',';
                                                  }
                                                  arrayText +=
                                                      '"103": ["${DefultTwoStart}", "${DefultTwoEnd}"]';
                                                }
                                                if (TextOTAfterEnd != "") {
                                                  typetimestart
                                                      .add(OTAfterStart);
                                                  typetimeend.add(OTAfterEnd);

                                                  if (arrayText == "") {
                                                    arrayText += '{';
                                                  } else {
                                                    arrayText += ',';
                                                  }
                                                  arrayText +=
                                                      '"104": ["${OTAfterStart}", "${OTAfterEnd}"]';
                                                }

                                                arrayText += "}";

                                                var savedata = "";

                                                for (int i = 0;
                                                    i < typetimestart.length;
                                                    i++) {
                                                  if (!(i ==
                                                      (typetimestart.length -
                                                          1))) {
                                                    if (typetimeend[i].isAfter(
                                                        typetimestart[i + 1])) {
                                                      Dialogs.materialDialog(
                                                          msg:
                                                              'กรุณาตรวจสอบการเรียงลำดับเวลาให้ถูกต้อง',
                                                          title:
                                                              'ตรวจสอบข้อมูล',
                                                          context: context,
                                                          actions: [
                                                            IconsButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context,
                                                                        rootNavigator:
                                                                            true)
                                                                    .pop();
                                                              },
                                                              text: 'ตกลง',
                                                              iconData: Icons
                                                                  .check_circle_outline,
                                                              color:
                                                                  Colors.green,
                                                              textStyle: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                              iconColor:
                                                                  Colors.white,
                                                            ),
                                                          ]);

                                                      savedata = 'NO';

                                                      break;
                                                    }
                                                  }
                                                }

                                                if (savedata == "") {
                                                  var tagsJson =
                                                      jsonDecode(arrayText);
                                                  datasavetimesheet(
                                                      arrayText,
                                                      item.empCode!,
                                                      item.costCenter!,
                                                      '');
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop();

                                                  // List<String>
                                                  //     tags =
                                                  //     List.from(tagsJson);
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]))),
                            );
                          },
                        );
                      },
                    );
                  }),
              IconsButton(
                text: ' ลาป่วยบางช่วงเวลา',
                color: Colors.yellow[800],
                textStyle: TextStyle(color: Colors.white),
                iconColor: Colors.white,
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  TextLeavesickStart = "";
                  TextLeavesickEnd = "";
                  showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            backgroundColor: Dialogs.bcgColor,
                            // content: Dialogs.holder,
                            shape: Dialogs.dialogShape,
                            title: Center(
                              child: Text(
                                "ลาป่วยบางช่วงเวลา",
                                style: Dialogs.titleStyle,
                              ),
                            ),
                            actions: <Widget>[
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade400),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('ลา : เวลา '),
                                        OutlinedButton(
                                          onPressed: () => Picker(
                                              hideHeader: true,
                                              cancelText: 'ยกเลิก',
                                              confirmText: 'ตกลง',
                                              cancelTextStyle: TextStyle(
                                                  fontFamily: Fonts.fonts),
                                              confirmTextStyle: TextStyle(
                                                  fontFamily: Fonts.fonts),
                                              adapter: DateTimePickerAdapter(
                                                minuteInterval: 15,
                                                value: LeavesickStart,
                                                customColumnType: [3, 4],
                                              ),
                                              title: Text(""),
                                              selectedTextStyle:
                                                  TextStyle(color: Colors.blue),
                                              onConfirm:
                                                  (Picker picker, List value) {
                                                var result = (picker.adapter
                                                        as DateTimePickerAdapter)
                                                    .value;
                                                if (result != null) {
                                                  setState(() {
                                                    LeavesickStart = result;
                                                    TextLeavesickStart =
                                                        '${LeavesickStart.hour.toString().padLeft(2, '0')}:${LeavesickStart.minute.toString().padLeft(2, '0')}';
                                                  });
                                                }
                                              }).showDialog(context),
                                          child: Text('${TextLeavesickStart}'),
                                        ),
                                        Text(' ถึง '),
                                        OutlinedButton(
                                          onPressed: () =>
                                              // showPickerDateCustom(
                                              //     context,
                                              //     'OTBeforeEnd'),
                                              Picker(
                                                  cancelText: 'ยกเลิก',
                                                  confirmText: 'ตกลง',
                                                  cancelTextStyle: TextStyle(
                                                      fontFamily: Fonts.fonts),
                                                  confirmTextStyle: TextStyle(
                                                      fontFamily: Fonts.fonts),
                                                  hideHeader: true,
                                                  adapter:
                                                      DateTimePickerAdapter(
                                                    minuteInterval: 15,
                                                    value: LeavesickEnd,
                                                    customColumnType: [3, 4],
                                                  ),
                                                  title: Text(""),
                                                  selectedTextStyle: TextStyle(
                                                      color: Colors.blue),
                                                  onConfirm: (Picker picker,
                                                      List value) {
                                                    var result = (picker.adapter
                                                            as DateTimePickerAdapter)
                                                        .value;
                                                    if (result != null) {
                                                      setState(() {
                                                        LeavesickEnd = result;
                                                        TextLeavesickEnd =
                                                            '${LeavesickEnd.hour.toString().padLeft(2, '0')}:${LeavesickEnd.minute.toString().padLeft(2, '0')}';
                                                      });
                                                    }
                                                  }).showDialog(context),
                                          child: Text('${TextLeavesickEnd}'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: IconsButton(
                                      onPressed: () {
                                        //////function check time

                                        var cksick = "";
                                        var cksickstart = "";

                                        ///check ค่าว่าง
                                        if ((TextLeavesickStart != "") &&
                                            (TextLeavesickEnd != "")) {
                                          cksick = 'YES1';

                                          if ((TextLeavesickStart != "") &&
                                              (TextLeavesickEnd != "")) {
                                            cksick = '';

                                            ///check ห้ามน้อยกว่าเวลาเริ่ม
                                            if (LeavesickStart.isAfter(
                                                LeavesickEnd)) {
                                              cksickstart = 'OVER1';
                                            }
                                          }
                                        } else {
                                          cksick = 'YES1';
                                        }

                                        if ((cksick != "") ||
                                            (cksickstart != "")) {
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
                                                  iconData: Icons
                                                      .check_circle_outline,
                                                  color: Colors.green,
                                                  textStyle: TextStyle(
                                                      color: Colors.white),
                                                  iconColor: Colors.white,
                                                ),
                                              ]);
                                        } else {
                                          String arrayText =
                                              '{"201": ["${LeavesickStart}", "${LeavesickEnd}"]}';

                                          var tagsJson = jsonDecode(arrayText);
                                          datasavetimesheet(
                                              arrayText,
                                              item.empCode!,
                                              item.costCenter!,
                                              '');
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        }
                                      },
                                      text: 'ตกลง',
                                      iconData: Icons.check_circle_outline,
                                      color: Colors.green,
                                      textStyle: TextStyle(color: Colors.white),
                                      iconColor: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
              IconsButton(
                text: ' ลาไม่รับค่าจ้างบางช่วงเวลา',
                color: Colors.yellow[800],
                textStyle: TextStyle(color: Colors.white),
                iconColor: Colors.white,
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  TextLeaveunpaidStart = "";
                  TextLeaveunpaidEnd = "";
                  showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            backgroundColor: Dialogs.bcgColor,
                            // content: Dialogs.holder,
                            shape: Dialogs.dialogShape,
                            title: Center(
                              child: Text(
                                "ลาไม่รับค่าจ้างบางช่วงเวลา",
                                style: Dialogs.titleStyle,
                              ),
                            ),
                            actions: <Widget>[
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade400),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('ลา : เวลา '),
                                        OutlinedButton(
                                          onPressed: () => Picker(
                                              hideHeader: true,
                                              cancelText: 'ยกเลิก',
                                              confirmText: 'ตกลง',
                                              cancelTextStyle: TextStyle(
                                                  fontFamily: Fonts.fonts),
                                              confirmTextStyle: TextStyle(
                                                  fontFamily: Fonts.fonts),
                                              adapter: DateTimePickerAdapter(
                                                minuteInterval: 15,
                                                value: LeaveunpaidStart,
                                                customColumnType: [3, 4],
                                              ),
                                              title: Text(""),
                                              selectedTextStyle:
                                                  TextStyle(color: Colors.blue),
                                              onConfirm:
                                                  (Picker picker, List value) {
                                                var result = (picker.adapter
                                                        as DateTimePickerAdapter)
                                                    .value;
                                                if (result != null) {
                                                  setState(() {
                                                    LeaveunpaidStart = result;
                                                    TextLeaveunpaidStart =
                                                        '${LeaveunpaidStart.hour.toString().padLeft(2, '0')}:${LeaveunpaidStart.minute.toString().padLeft(2, '0')}';
                                                  });
                                                }
                                              }).showDialog(context),
                                          child:
                                              Text('${TextLeaveunpaidStart}'),
                                        ),
                                        Text(' ถึง '),
                                        OutlinedButton(
                                          onPressed: () =>
                                              // showPickerDateCustom(
                                              //     context,
                                              //     'OTBeforeEnd'),
                                              Picker(
                                                  cancelText: 'ยกเลิก',
                                                  confirmText: 'ตกลง',
                                                  cancelTextStyle: TextStyle(
                                                      fontFamily: Fonts.fonts),
                                                  confirmTextStyle: TextStyle(
                                                      fontFamily: Fonts.fonts),
                                                  hideHeader: true,
                                                  adapter:
                                                      DateTimePickerAdapter(
                                                    minuteInterval: 15,
                                                    value: LeaveunpaidEnd,
                                                    customColumnType: [3, 4],
                                                  ),
                                                  title: Text(""),
                                                  selectedTextStyle: TextStyle(
                                                      color: Colors.blue),
                                                  onConfirm: (Picker picker,
                                                      List value) {
                                                    var result = (picker.adapter
                                                            as DateTimePickerAdapter)
                                                        .value;
                                                    if (result != null) {
                                                      setState(() {
                                                        LeaveunpaidEnd = result;
                                                        TextLeaveunpaidEnd =
                                                            '${LeaveunpaidEnd.hour.toString().padLeft(2, '0')}:${LeaveunpaidEnd.minute.toString().padLeft(2, '0')}';
                                                      });
                                                    }
                                                  }).showDialog(context),
                                          child: Text('${TextLeaveunpaidEnd}'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: IconsButton(
                                      onPressed: () {
                                        //////function check time

                                        var ckunpaid = "";
                                        var ckunpaidstart = "";

                                        ///check ค่าว่าง
                                        if ((TextLeaveunpaidStart != "") &&
                                            (TextLeaveunpaidEnd != "")) {
                                          ckunpaid = 'YES1';

                                          if ((TextLeaveunpaidStart != "") &&
                                              (TextLeaveunpaidEnd != "")) {
                                            ckunpaid = '';

                                            ///check ห้ามน้อยกว่าเวลาเริ่ม
                                            if (LeaveunpaidStart.isAfter(
                                                LeaveunpaidEnd)) {
                                              ckunpaidstart = 'OVER1';
                                            }
                                          }
                                        } else {
                                          ckunpaid = 'YES1';
                                        }

                                        if ((ckunpaid != "") ||
                                            (ckunpaidstart != "")) {
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
                                                  iconData: Icons
                                                      .check_circle_outline,
                                                  color: Colors.green,
                                                  textStyle: TextStyle(
                                                      color: Colors.white),
                                                  iconColor: Colors.white,
                                                ),
                                              ]);
                                        } else {
                                          String arrayText =
                                              '{"202": ["${LeaveunpaidStart}", "${LeaveunpaidEnd}"]}';

                                          var tagsJson = jsonDecode(arrayText);
                                          datasavetimesheet(
                                              arrayText,
                                              item.empCode!,
                                              item.costCenter!,
                                              '');
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        }
                                      },
                                      text: 'ตกลง',
                                      iconData: Icons.check_circle_outline,
                                      color: Colors.green,
                                      textStyle: TextStyle(color: Colors.white),
                                      iconColor: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
              IconsButton(
                text: ' ลาป่วยทั้งวัน',
                color: Color.fromARGB(255, 103, 7, 0),
                textStyle: TextStyle(color: Colors.white),
                iconColor: Colors.white,
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
                            title: Center(
                              child: Text(
                                "ลาป่วยทั้งวัน",
                                style: Dialogs.titleStyle,
                              ),
                            ),
                            actions: <Widget>[
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade400),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('ลาทั้งวัน : เวลา '),
                                        OutlinedButton(
                                          onPressed: () {},
                                          child: Text(
                                              '${TextLeavesickAllStart} - ${TextLeavesickAllEnd}'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: IconsButton(
                                      onPressed: () {
                                        //////function check time

                                        String arrayText =
                                            '{"203": ["${LeavesickAllStart}", "${LeavesickAllEnd}"]}';

                                        var tagsJson = jsonDecode(arrayText);
                                        datasavetimesheet(
                                            arrayText,
                                            item.empCode!,
                                            item.costCenter!,
                                            '');
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                      text: 'ตกลง',
                                      iconData: Icons.check_circle_outline,
                                      color: Colors.green,
                                      textStyle: TextStyle(color: Colors.white),
                                      iconColor: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
              IconsButton(
                text: ' ลาไม่รับค่าจ้างทั้งวัน',
                color: Color.fromARGB(255, 103, 7, 0),
                textStyle: TextStyle(color: Colors.white),
                iconColor: Colors.white,
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
                            title: Center(
                              child: Text(
                                "ลาไม่รับค่าจ้างทั้งวัน",
                                style: Dialogs.titleStyle,
                              ),
                            ),
                            actions: <Widget>[
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade400),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('ลาทั้งวัน : เวลา '),
                                        OutlinedButton(
                                          onPressed: () {},
                                          child: Text(
                                              '${TextLeaveunpaidAllStart} - ${TextLeaveunpaidAllEnd}'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: IconsButton(
                                      onPressed: () {
                                        //////function check time

                                        String arrayText =
                                            '{"204": ["${LeaveunpaidAllStart}", "${LeaveunpaidAllEnd}"]}';

                                        var tagsJson = jsonDecode(arrayText);
                                        datasavetimesheet(
                                            arrayText,
                                            item.empCode!,
                                            item.costCenter!,
                                            '');
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                      text: 'ตกลง',
                                      iconData: Icons.check_circle_outline,
                                      color: Colors.green,
                                      textStyle: TextStyle(color: Colors.white),
                                      iconColor: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ]),
      },

      icon: Icon(
        FontAwesomeIcons.plus,
        size: 10,
      ),
      label: Text(
        'เพิ่มรายการ',
        style: GoogleFonts.getFont(Fonts.fonts),
      ), //label text
      style: ElevatedButton.styleFrom(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(8),
          ),
          primary: Colors.blue[900],
          textStyle: TextStyle(
            fontSize: 10,
          )),
    );
  }

  Widget _buildtakeoutEmp(var item) {
    return Expanded(
      child: TextButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.red[900],
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'ลบชื่อ',
          style: TextStyle(color: Colors.white, fontSize: 13.0),
        ),
        onPressed: () {
          Dialogs.materialDialog(
              msg: 'ท่านต้องการลบชื่อใช่หรือไม่?',
              title: 'ยืนยันข้อมูล',
              context: context,
              actions: [
                IconsOutlineButton(
                  text: 'ไม่',
                  iconData: Icons.cancel_outlined,
                  color: Colors.white,
                  textStyle: TextStyle(color: Colors.black),
                  iconColor: Colors.black,
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
                IconsButton(
                  text: 'ใช่',
                  iconData: Icons.check_circle_outline,
                  color: Colors.green,
                  textStyle: TextStyle(color: Colors.white),
                  iconColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      HideEmp.add(item.empCode!);
                    });

                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ]);
        },
      ),
    );
  }

  Widget _buildimportEmp(var item) {
    return Expanded(
      child: TextButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.red[900],
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'เพิ่มชื่อ',
          style: TextStyle(color: Colors.white, fontSize: 13.0),
        ),
        onPressed: () {
          Dialogs.materialDialog(
              msg: 'ท่านต้องการเพิ่มชื่อใช่หรือไม่?',
              title: 'ยืนยันข้อมูล',
              context: context,
              actions: [
                IconsOutlineButton(
                  text: 'ไม่',
                  iconData: Icons.cancel_outlined,
                  color: Colors.white,
                  textStyle: TextStyle(color: Colors.black),
                  iconColor: Colors.black,
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
                IconsButton(
                  text: 'ใช่',
                  iconData: Icons.check_circle_outline,
                  color: Colors.green,
                  textStyle: TextStyle(color: Colors.white),
                  iconColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      HideEmp.removeWhere((element) {
                        return element == item.empCode!;
                      });
                    });

                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ]);
        },
      ),
    );
  }
}
