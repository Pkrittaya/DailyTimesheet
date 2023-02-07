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
import 'package:k2mobileapp/profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:k2mobileapp/theme.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

String fonts = "Kanit";

CustomDateTime(textdate) {
  DateTime valDate = DateTime.parse(textdate);
  String date = DateFormat("dd/MM/yyyy HH:mm").format(valDate);
  return date.toString();
}

CustomDate(textdate) {
  DateTime valDate = DateTime.parse(textdate);
  String date = DateFormat("dd/MM/yyyy").format(valDate);
  return date.toString();
}

CustomTime(textdate) {
  DateTime valDate = DateTime.parse(textdate);
  String date = DateFormat("HH:mm").format(valDate);
  return date.toString();
}

Customdatetext(textdate) {
  DateTime valdate = DateTime.parse(textdate);
  String date = DateFormat("dd/MM/yyyy")
      .format(new DateTime(valdate.year + 543, valdate.month, valdate.day));
  return date;
}

FormatDate(textdate) {
  DateTime valdate = DateTime.parse(textdate);
  String date = DateFormat("yyyy-MM-dd")
      .format(new DateTime(valdate.year - 543, valdate.month, valdate.day));
  return date;
}

FormatDateTime(textdate) {
  DateTime valdate = DateTime.parse(textdate);
  return valdate;
}

class EmployeeList extends StatefulWidget {
  final List<TimesheetData> listtimesheet;
  final int index;
  final String EmpCode;
  final String url;
  final String jobno;

  const EmployeeList(
      {Key? key,
      required this.listtimesheet,
      required this.index,
      required this.EmpCode,
      required this.url,
      required this.jobno})
      : super(key: key);

  @override
  State<EmployeeList> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<EmployeeList> {
  List<TimesheetData> _data = [];
  List<TimesheetData> _datahistory = [];
  List<TimesheetData> _dataOvernight = [];
  TextEditingController dateInput = TextEditingController();
  List<TimesheetData> listTestAuto = [];
  bool viewVisible = false;
  bool OvernightVisible = false;
  String _showdatehistory = "";
  String _showtimehistory = "";
  String _showdatetoday = "";
  String _showtimetoday = "";
  String _showdateOvernight = "";
  String _showtimeOvernight = "";
  DateTime timenow = new DateTime.now();
  Duration work_yesterday = Duration(hours: 9, minutes: 00);

  List<String> Selectdate = <String>[
    DateFormat('dd/MM/yyyy').format(new DateTime(
            DateTime.now().year + 543, DateTime.now().month, DateTime.now().day)
        .subtract(Duration(days: 1))),
    DateFormat('dd/MM/yyyy').format(new DateTime(
        DateTime.now().year + 543, DateTime.now().month, DateTime.now().day))
  ];

  List<String> items = [
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

  // void datasavetimesheet(TimesheetData timesheetlist) async {
  //   var tojsontext = {
  //     "emp_Code": "${timesheetlist.empCode}",
  //     "timesheetDate": "${timesheetlist.timesheetDate}",
  //     "in_Time": "${timesheetlist.inTime}",
  //     "out_Time": "${timesheetlist.outTime}",
  //     "status": "3",
  //     "project_Name": "${timesheetlist.projectName}",
  //     "job_Detail": "${timesheetlist.jobDetail}",
  //     "docType": "Timesheet",
  //     "job_Code": "${timesheetlist.jobCode}"
  //   };

  //   final _baseUrl = '${widget.url}/api/Interface/GetPostTimesheet';
  //   final res = await http.post(Uri.parse("${_baseUrl}"),
  //       headers: {"Content-Type": "application/json"},
  //       body: json.encode(tojsontext));

  //   setState(() {
  //     final jsonData = json.decode(res.body);
  //     print(res.body);

  //     final parsedJson = jsonDecode(res.body);
  //     if (parsedJson['type'] == "S") {
  //       getlsttimesheet();
  //     }
  //     print(parsedJson['description']);
  //   });
  // }

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
      // Map<String, dynamic> map = jsonDecode(response.body);
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

      List<TimesheetData> TestAuto = parsed
          .map<TimesheetData>((json) => TimesheetData.fromJson(json))
          .toList();

      // _data = TestAuto;

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

  void getlsttimesheetOvernight(_showdatetoday) async {
    var client = http.Client();
    DateTime NewDate = DateFormat('dd/MM/yyyy').parse(_showdatetoday);

    NewDate = NewDate.add(new Duration(days: 1));

    String formattedDate = DateFormat("yyyy-MM-dd")
        .format(new DateTime(NewDate.year - 543, NewDate.month, NewDate.day));
    var uri = Uri.parse(
        "${widget.url}/api/Interface/GetListTimesheeet?Emp_Code=${widget.EmpCode}&dataTime=${formattedDate}");
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      // Map<String, dynamic> map = jsonDecode(response.body);
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

      List<TimesheetData> TestAuto = parsed
          .map<TimesheetData>((json) => TimesheetData.fromJson(json))
          .toList();

      _dataOvernight = TestAuto;
      if (_dataOvernight.length == 0) {
        OvernightVisible = false;
      } else {
        setState(() {
          OvernightVisible = true;
          _showdateOvernight = Customdatetext(_dataOvernight[0].timesheetDate);
          ;
          _showtimeOvernight = _dataOvernight[0].totalHourDataDay!;
        });
      }
    }
  }

  void CheckPremission() async {
    var client = http.Client();
    var uri = Uri.parse(
        "${widget.url}/api/Interface/GetValidatePermission?emp_code=${widget.EmpCode}&page_name=Timesheet");
    var response = await client.post(uri);
    if (response.statusCode == 200) {
      // Map<String, dynamic> map = jsonDecode(response.body);
      final jsonData = json.decode(response.body);
      //   print(res.body);

      final parsedJson = jsonDecode(response.body);
      print(response.body);
      // print(parsedJson['description']);
      // remark.text = parsedJson['type'];
      // remark.text = parsedJson['description'];
      if (parsedJson['type'] == "E") {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => nopermission(
                    EmpCode: widget.EmpCode,
                  )),
        );
      }

      // _data = TestAuto;
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

  @override
  void initState() {
    GetEmpProfile();

    dateInput.text = "";
    _data = widget.listtimesheet;

    DateTime NewDate = DateTime.now();

    if ((NewDate.hour < work_yesterday.inHours) ||
        ((NewDate.hour == work_yesterday.inHours) &&
            (NewDate.minute <= work_yesterday.inMinutes.remainder(60)))) {
      NewDate = DateTime.now().add(new Duration(days: -1));
    } else {
      NewDate = DateTime.now();
    }

    if (_data.length == 0) {
      _showdatetoday = DateFormat("dd/MM/yyyy")
          .format(new DateTime(NewDate.year + 543, NewDate.month, NewDate.day));
      _showtimetoday = "00:00";
    } else {
      _showdatetoday = Customdatetext(_data[0].timesheetDate);
      _showtimetoday = _data[0].totalHourDataDay!;
    }

    // getlsttimesheetOvernight(_showdatetoday);

    // CheckPremission();

    Timer mytimer = Timer.periodic(Duration(seconds: 1), (timer) {
      DateTime timenow = DateTime.now(); //get current date and time
      if (timenow.hour == 9 && timenow.minute == 00 && timenow.second == 00) {
        getlsttimesheet();
      }
    });

    super.initState();
  }

  bool valall = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: basicTheme(),
        home: DefaultTabController(
            length: 2,
            child: Scaffold(
              // appBar: AppBar(
              //   title: Container(
              //     alignment: Alignment.topLeft,
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           "ชื่อ ${empdata.empName}",
              //           style: TextStyle(fontSize: 14),
              //         ),
              //         Text(
              //           "รหัสพนักงาน ${empdata.empCode}",
              //           style: TextStyle(fontSize: 14),
              //         ),
              //       ],
              //     ),
              //   ),

              //   // backgroundColor: Colors.redAccent,
              //   elevation: 0,
              //   bottom: TabBar(
              //       isScrollable: false,
              //       labelPadding: EdgeInsets.symmetric(horizontal: 5.0),
              //       labelColor: Palette.Colortheme,
              //       unselectedLabelColor: Colors.white,
              //       indicatorSize: TabBarIndicatorSize.label,
              //       indicator: BoxDecoration(
              //         borderRadius: BorderRadius.only(
              //             topLeft: Radius.circular(10),
              //             topRight: Radius.circular(10)),
              //         color: Colors.white,
              //       ),
              //       tabs: [
              //         Tab(
              //           child: Align(
              //             alignment: Alignment.center,
              //             child: Text("บันทึกเวลาปฏิบัติงาน"),
              //           ),
              //         ),
              //         Tab(
              //           child: Align(
              //             alignment: Alignment.center,
              //             child: Text("ประวัติการบันทึกเวลาปฏิบัติงาน"),
              //           ),
              //         ),
              //       ]),
              //   actions: <Widget>[
              //     Padding(
              //       child: OutlinedButton(
              //         onPressed: () {
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(builder: (context) => Login()),
              //           );
              //         },
              //         child: Text(
              //           'ออกจากระบบ',
              //           style: TextStyle(fontSize: 12),
              //         ),
              //         style: OutlinedButton.styleFrom(
              //           primary: Colors.white,
              //           // backgroundColor: Colors.white,
              //           side: BorderSide(width: 1.0, color: Colors.white),
              //         ),
              //       ),
              //       padding: EdgeInsets.all(13.0),
              //     ),

              //     // IconsOutlineButton(
              //     //   // iconData: FontAwesomeIcons.arrowRightFromBracket,
              //     //   text: 'ออกจากระบบ',
              //     //   // tooltip: 'Show Snackbar',
              //     //   onPressed: () {
              //     //     Navigator.push(
              //     //       context,
              //     //       MaterialPageRoute(builder: (context) => Login()),
              //     //     );
              //     //   },
              //     //   color: Colors.orange,
              //     //   iconColor: Colors.white,
              //     //   textStyle: TextStyle(color: Colors.white),
              //     // ),
              //   ],
              // ),
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
                          children: <Widget>[
                            const SizedBox(height: 15),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'เลขที่ใบงาน : ${widget.jobno}',
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
                                          onPressed: () {},
                                          child: Container(
                                            color: Colors.blue[900],
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            child: const Text(
                                              'พร้อมทำงาน',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13.0),
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {},
                                          child: Container(
                                            color: Colors.red[900],
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            child: const Text(
                                              'ไม่พร้อม',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13.0),
                                            ),
                                          ),
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
                                CheckboxListTile(
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  title: Text(
                                    'ใช้เวลาและกิจกรรมร่วมกัน',
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  value: valall,
                                  onChanged: (value) {
                                    setState(() {
                                      if (valall == false) {
                                        valall = true;
                                      } else {
                                        valall = false;
                                      }
                                    });
                                  },
                                ),
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
      children: _data.map<ExpansionPanel>((TimesheetData item) {
        return ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('690000 AAAA BBB'),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => Dialogs.materialDialog(
                                // msg: 'เลือกประเภทบันทึกเวลาทำงาน',
                                // title: 'เลือกประเภทบันทึกเวลาทำงาน',
                                context: context,
                                actions: [
                                  Column(
                                    children: [
                                      IconsButton(
                                          text: ' ทำงาน',
                                          color:
                                              Color.fromARGB(255, 64, 79, 74),
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            // Dialogs.materialDialog(
                                            //     title: 'ทำงาน',
                                            //     context: context,
                                            //     actions: [
                                            //       Column(
                                            //         children: [Text('ทำงาน')],
                                            //       ),
                                            //     ]);
                                          }),
                                      IconsButton(
                                        onPressed: () {},
                                        text: ' ลาป่วยบางช่วงเวลา',
                                        color: Colors.yellow[800],
                                        textStyle:
                                            TextStyle(color: Colors.white),
                                        iconColor: Colors.white,
                                      ),
                                      IconsButton(
                                        onPressed: () {},
                                        text: ' ลาไม่รับค่าจ้างบางช่วงเวลา',
                                        color: Colors.yellow[800],
                                        textStyle:
                                            TextStyle(color: Colors.white),
                                        iconColor: Colors.white,
                                      ),
                                      IconsButton(
                                        onPressed: () {},
                                        text: ' ลาป่วยทั้งวัน',
                                        color: Color.fromARGB(255, 103, 7, 0),
                                        textStyle:
                                            TextStyle(color: Colors.white),
                                        iconColor: Colors.white,
                                      ),
                                      IconsButton(
                                        onPressed: () {},
                                        text: ' ลาไม่รับค่าจ้างทั้งวัน',
                                        color: Color.fromARGB(255, 103, 7, 0),
                                        textStyle:
                                            TextStyle(color: Colors.white),
                                        iconColor: Colors.white,
                                      ),
                                    ],
                                  ),
                                ]),
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
                                    // borderRadius: new BorderRadius.circular(10),
                                    ),
                                primary: Colors.blue[900],
                                textStyle: TextStyle(
                                  fontSize: 10,
                                )),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {},
                            child: Container(
                              color: Colors.red[900],
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: const Text(
                                'ลบชื่อ',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              subtitle: Text('(9 ชั่วโมง 0 นาที)'),
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
                    child: Text('วันที่ 05 ตุลาคม 2565'),
                  ),
                  Container(
                    // padding: EdgeInsets.only(top: 10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 300.0,
                          child: ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Text('Item ${item.empCode}'),
                                  Text(
                                      "ช่วงแรก : 08:00 - 12:00 (4 ชั่วโมง 0 นาที)"),
                                  Row(
                                    children: <Widget>[
                                      Ink(
                                        decoration: const ShapeDecoration(
                                          color:
                                              Color.fromRGBO(21, 101, 192, 1),
                                          shape: CircleBorder(),
                                        ),
                                        width: 30,
                                        child: IconButton(
                                          icon: const Icon(Icons.edit),
                                          color: Colors.white,
                                          iconSize: 16.0,
                                          onPressed: () {},
                                        ),
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Ink(
                                        decoration: const ShapeDecoration(
                                          color: Color.fromRGBO(198, 40, 40, 1),
                                          shape: CircleBorder(),
                                        ),
                                        width: 30,
                                        child: IconButton(
                                          icon: const Icon(Icons.delete),
                                          color: Colors.white,
                                          iconSize: 16.0,
                                          onPressed: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    // Table(
                    //   columnWidths: {
                    //     0: FlexColumnWidth(0.3),
                    //   },
                    //   children: [
                    //     TableRow(children: [
                    //       Text("แผนก"),
                    //       Text("${item.departmentCode}"),
                    //     ]),
                    //     TableRow(children: [
                    //       Text("เนื้องาน"),
                    //       Text("${item.jobDetail}"),
                    //     ]),
                    //     TableRow(children: [
                    //       Text("หมายเหตุ"),
                    //       Text("${item.remark != '' ? item.remark : '-'}"),
                    //     ]),
                    //   ],
                    // ),
                  ),
                ]),
            // isThreeLine: true,
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}
