import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:k2mobileapp/NoPermission.dart';
import 'package:k2mobileapp/example/datepicker.dart';
import 'package:k2mobileapp/home.dart';
import 'package:k2mobileapp/login.dart';
import 'package:k2mobileapp/main.dart';
import 'package:k2mobileapp/models/EmployeeData.dart';
import 'package:k2mobileapp/models/TimesheetData.dart';
import 'package:k2mobileapp/pages/addtimesheet.dart';
import 'package:k2mobileapp/pages/addtimesheet_break.dart';
import 'package:k2mobileapp/pages/addtimesheet_leave.dart';
import 'package:k2mobileapp/pages/addtimesheet_leave_value.dart';
import 'package:k2mobileapp/pages/employee_list.dart';
import 'package:k2mobileapp/profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:k2mobileapp/theme.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

// String fonts = "Kanit";

// CustomDateTime(textdate) {
//   DateTime valDate = DateTime.parse(textdate);
//   String date = DateFormat("dd/MM/yyyy HH:mm").format(valDate);
//   return date.toString();
// }

// CustomDate(textdate) {
//   DateTime valDate = DateTime.parse(textdate);
//   String date = DateFormat("dd/MM/yyyy").format(valDate);
//   return date.toString();
// }

// CustomTime(textdate) {
//   DateTime valDate = DateTime.parse(textdate);
//   String date = DateFormat("HH:mm").format(valDate);
//   return date.toString();
// }

// Customdatetext(textdate) {
//   DateTime valdate = DateTime.parse(textdate);
//   String date = DateFormat("dd/MM/yyyy")
//       .format(new DateTime(valdate.year + 543, valdate.month, valdate.day));
//   return date;
// }

// FormatDate(textdate) {
//   DateTime valdate = DateTime.parse(textdate);
//   String date = DateFormat("yyyy-MM-dd")
//       .format(new DateTime(valdate.year - 543, valdate.month, valdate.day));
//   return date;
// }

// FormatDateTime(textdate) {
//   DateTime valdate = DateTime.parse(textdate);
//   return valdate;
// }

class ManpowerList extends StatefulWidget {
  final List<TimesheetData> listtimesheet;
  final int index;
  final String EmpCode;
  final String url;

  const ManpowerList(
      {Key? key,
      required this.listtimesheet,
      required this.index,
      required this.EmpCode,
      required this.url})
      : super(key: key);

  @override
  State<ManpowerList> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ManpowerList> {
  // List<TimesheetData> _data = [];
  // List<TimesheetData> _datahistory = [];
  // List<TimesheetData> _dataOvernight = [];
  // TextEditingController dateInput = TextEditingController();
  // List<TimesheetData> listTestAuto = [];
  // bool viewVisible = false;
  // bool OvernightVisible = false;
  // String _showdatehistory = "";
  // String _showtimehistory = "";
  // String _showdatetoday = "";
  // String _showtimetoday = "";
  // String _showdateOvernight = "";
  // String _showtimeOvernight = "";
  // DateTime timenow = new DateTime.now();
  // Duration work_yesterday = Duration(hours: 9, minutes: 00);

  // List<String> Selectdate = <String>[
  //   DateFormat('dd/MM/yyyy').format(new DateTime(
  //           DateTime.now().year + 543, DateTime.now().month, DateTime.now().day)
  //       .subtract(Duration(days: 1))),
  //   DateFormat('dd/MM/yyyy').format(new DateTime(
  //       DateTime.now().year + 543, DateTime.now().month, DateTime.now().day))
  // ];

  List<String> titles = [
    "AAA001",
    "AAA002",
    "AAA003",
    "AAA004",
    // "AAA005",
    // "AAA006",
    // "AAA007",
    // "AAA008",
    // "AAA009",
    // "AAA010",
    // "AAA011",
    // "AAA012",
  ];

  // void getlsttimesheet() async {
  //   var client = http.Client();
  //   DateTime NewDate = DateTime.now();

  //   if ((NewDate.hour < work_yesterday.inHours) ||
  //       ((NewDate.hour == work_yesterday.inHours) &&
  //           (NewDate.minute <= work_yesterday.inMinutes.remainder(60)))) {
  //     NewDate = DateTime.now().add(new Duration(days: -1));
  //   } else {
  //     NewDate = DateTime.now();
  //   }
  //   String formattedDate = DateFormat('yyyy-MM-dd').format(NewDate);
  //   var uri = Uri.parse(
  //       "${widget.url}/api/Interface/GetListTimesheeet?Emp_Code=${widget.EmpCode}&dataTime=${formattedDate}");
  //   var response = await client.get(uri);
  //   if (response.statusCode == 200) {
  //     // Map<String, dynamic> map = jsonDecode(response.body);
  //     final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

  //     List<TimesheetData> TestAuto = parsed
  //         .map<TimesheetData>((json) => TimesheetData.fromJson(json))
  //         .toList();

  //     // _data = TestAuto;

  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => homepage(
  //                 index: TestAuto.length,
  //                 listtimesheet: TestAuto,
  //                 EmpCode: widget.EmpCode,
  //                 ShowPopup: '',
  //                 url: widget.url,
  //               )),
  //     );
  //   }
  // }

  // void CheckPremission() async {
  //   var client = http.Client();
  //   var uri = Uri.parse(
  //       "${widget.url}/api/Interface/GetValidatePermission?emp_code=${widget.EmpCode}&page_name=Timesheet");
  //   var response = await client.post(uri);
  //   if (response.statusCode == 200) {
  //     // Map<String, dynamic> map = jsonDecode(response.body);
  //     final jsonData = json.decode(response.body);
  //     //   print(res.body);

  //     final parsedJson = jsonDecode(response.body);
  //     print(response.body);
  //     // print(parsedJson['description']);
  //     // remark.text = parsedJson['type'];
  //     // remark.text = parsedJson['description'];
  //     if (parsedJson['type'] == "E") {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => nopermission(
  //                   EmpCode: widget.EmpCode,
  //                 )),
  //       );
  //     }

  //     // _data = TestAuto;
  //   }
  // }

  // EmployeeData empdata = new EmployeeData(
  //     empCode: '',
  //     empCompName: '',
  //     empDepartmentName: '',
  //     empName: '',
  //     empNationality: '',
  //     empPositionName: '');

  // void GetEmpProfile() async {
  //   var client = http.Client();
  //   var uri = Uri.parse(
  //       "${widget.url}/api/Interface/GetEmployeeData?EmpCode=${widget.EmpCode}");
  //   var response = await client.get(uri);
  //   if (response.statusCode == 200) {
  //     final jsonData = json.decode(response.body);
  //     print(response.body);

  //     final parsedJson = jsonDecode(response.body);

  //     setState(() {
  //       empdata.empCode = parsedJson['emp_Code'];
  //       empdata.empCompName = parsedJson['emp_Comp_Name'];
  //       empdata.empDepartmentName = parsedJson['emp_Department_Name'];
  //       empdata.empName = parsedJson['emp_Name'];
  //       empdata.empNationality = parsedJson['emp_Nationality'];
  //       empdata.empPositionName = parsedJson['emp_Position_Name'];
  //     });
  //   }
  // }

  // @override
  // void initState() {
  // GetEmpProfile();

  // dateInput.text = "";
  // _data = widget.listtimesheet;
  // // _datahistory = widget.listtimesheet;
  // DateTime NewDate = DateTime.now();

  // //Duration work_yesterday = Duration(hours: 9, minutes: 00);

  // if ((NewDate.hour < work_yesterday.inHours) ||
  //     ((NewDate.hour == work_yesterday.inHours) &&
  //         (NewDate.minute <= work_yesterday.inMinutes.remainder(60)))) {
  //   NewDate = DateTime.now().add(new Duration(days: -1));
  // } else {
  //   NewDate = DateTime.now();
  // }

  // if (_data.length == 0) {
  //   _showdatetoday = DateFormat("dd/MM/yyyy")
  //       .format(new DateTime(NewDate.year + 543, NewDate.month, NewDate.day));
  //   _showtimetoday = "00:00";
  // } else {
  //   _showdatetoday = Customdatetext(_data[0].timesheetDate);
  //   _showtimetoday = _data[0].totalHourDataDay!;
  // }

  // CheckPremission();

  // Timer mytimer = Timer.periodic(Duration(seconds: 1), (timer) {
  //   DateTime timenow = DateTime.now(); //get current date and time
  //   if (timenow.hour == 9 && timenow.minute == 00 && timenow.second == 00) {
  //     //setState(() {});
  //     print('timer');
  //     getlsttimesheet();
  //   }
  //   //mytimer.cancel() //to terminate this timer
  // });

  // super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: basicTheme(),
        home: Scaffold(
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, colors: [
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
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Center(
                              child: Text(
                                '6400100 AAAA AAAA',
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
                      children: [
                        // const SizedBox(height: 15),
                        Container(
                            padding: const EdgeInsets.all(10),
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: Column(
                              children: [
                                Text(
                                  "ใบขอกำลังคน",
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  "จำนวน ${titles.length} ใบ",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            )),
                        Column(
                          children: <Widget>[
                            ListViewHomeLayout(),
                          ],
                        )
                      ],
                    )),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget ListViewHomeLayout() {
    return ListView.builder(
        itemCount: titles.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Card(
              child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EmployeeList(
                              index: widget.index,
                              listtimesheet: widget.listtimesheet,
                              EmpCode: widget.EmpCode,
                              url: widget.url,
                              jobno: titles[index])),
                    );
                  },
                  title: Text(
                    "เลขที่งาน ${titles[index]}",
                    style: TextStyle(fontSize: 18, color: Colors.green[900]),
                  ),
                  leading: Icon(Icons.ballot)));
        });
  }
}
