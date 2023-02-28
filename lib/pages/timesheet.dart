import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:k2mobileapp/NoPermission.dart';
import 'package:k2mobileapp/home.dart';
import 'package:k2mobileapp/login.dart';
import 'package:k2mobileapp/models/EmployeeData.dart';
import 'package:k2mobileapp/models/TimesheetData.dart';
import 'package:k2mobileapp/pages/addtimesheet.dart';
import 'package:k2mobileapp/pages/addtimesheet_leave_value.dart';
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

class Timesheet extends StatefulWidget {
  final List<TimesheetData> listtimesheet;
  final int index;
  final String EmpCode;
  final String url;

  const Timesheet(
      {Key? key,
      required this.listtimesheet,
      required this.index,
      required this.EmpCode,
      required this.url})
      : super(key: key);

  @override
  State<Timesheet> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Timesheet> {
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

  void datasavetimesheet(TimesheetData timesheetlist) async {
    var tojsontext = {
      "emp_Code": "${timesheetlist.empCode}",
      "timesheetDate": "${timesheetlist.timesheetDate}",
      "in_Time": "${timesheetlist.inTime}",
      "out_Time": "${timesheetlist.outTime}",
      "status": "3",
      "project_Name": "${timesheetlist.projectName}",
      "job_Detail": "${timesheetlist.jobDetail}",
      "docType": "Timesheet",
      "job_Code": "${timesheetlist.jobCode}"
    };

    final _baseUrl = '${widget.url}/api/Interface/GetPostTimesheet';
    final res = await http.post(Uri.parse("${_baseUrl}"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(tojsontext));

    setState(() {
      final jsonData = json.decode(res.body);
      print(res.body);

      final parsedJson = jsonDecode(res.body);
      if (parsedJson['type'] == "S") {
        getlsttimesheet();
      }
      print(parsedJson['description']);
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
    // _datahistory = widget.listtimesheet;
    DateTime NewDate = DateTime.now();

    //Duration work_yesterday = Duration(hours: 9, minutes: 00);

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

    getlsttimesheetOvernight(_showdatetoday);

    CheckPremission();

    Timer mytimer = Timer.periodic(Duration(seconds: 1), (timer) {
      DateTime timenow = DateTime.now(); //get current date and time
      if (timenow.hour == 9 && timenow.minute == 00 && timenow.second == 00) {
        //setState(() {});
        print('timer');
        getlsttimesheet();
      }
      //mytimer.cancel() //to terminate this timer
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: basicTheme(),
        home: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Container(
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ชื่อ ${empdata.empName}",
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        "รหัสพนักงาน ${empdata.empCode}",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),

                // backgroundColor: Colors.redAccent,
                elevation: 0,
                bottom: TabBar(
                    isScrollable: false,
                    labelPadding: EdgeInsets.symmetric(horizontal: 5.0),
                    labelColor: Palette.colorTheme,
                    unselectedLabelColor: Colors.white,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      color: Colors.white,
                    ),
                    tabs: [
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("บันทึกเวลาปฏิบัติงาน"),
                        ),
                      ),
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("ประวัติการบันทึกเวลาปฏิบัติงาน"),
                        ),
                      ),
                    ]),
                actions: <Widget>[
                  Padding(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      child: Text(
                        'ออกจากระบบ',
                        style: TextStyle(fontSize: 12),
                      ),
                      style: OutlinedButton.styleFrom(
                        primary: Colors.white,
                        // backgroundColor: Colors.white,
                        side: BorderSide(width: 1.0, color: Colors.white),
                      ),
                    ),
                    padding: EdgeInsets.all(13.0),
                  ),

                  // IconsOutlineButton(
                  //   // iconData: FontAwesomeIcons.arrowRightFromBracket,
                  //   text: 'ออกจากระบบ',
                  //   // tooltip: 'Show Snackbar',
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => Login()),
                  //     );
                  //   },
                  //   color: Colors.orange,
                  //   iconColor: Colors.white,
                  //   textStyle: TextStyle(color: Colors.white),
                  // ),
                ],
              ),
              body: TabBarView(
                children: [
                  SingleChildScrollView(
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Table(
                              columnWidths: {
                                0: FlexColumnWidth(3),
                                1: FlexColumnWidth(2),
                              },
                              children: [
                                TableRow(children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 5),
                                      Text("วันที่ ${_showdatetoday}"),
                                      Text(
                                          "เวลาปฏิบัติงานรวม ${_showtimetoday} ชม."),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: ElevatedButton.icon(
                                      onPressed: () => Dialogs.materialDialog(
                                          // msg: 'เลือกประเภทบันทึกเวลาทำงาน',
                                          title: 'เลือกประเภทบันทึกเวลาทำงาน',
                                          context: context,
                                          actions: [
                                            Column(
                                              children: [
                                                IconsOutlineButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AddTimesheetLeaveValue(
                                                                timesheetlist:
                                                                    TimesheetData(),
                                                                EmpCode: widget
                                                                    .EmpCode,
                                                                url: widget.url,
                                                              )),
                                                    );
                                                  },
                                                  text: ' บันทึกเวลาลา',
                                                  iconData: FontAwesomeIcons
                                                      .personWalking,
                                                  color: Colors.orange,
                                                  iconColor: Colors.white,
                                                  textStyle: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                IconsButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AddTimesheet(
                                                                timesheetlist:
                                                                    TimesheetData(),
                                                                EmpCode: widget
                                                                    .EmpCode,
                                                                DepCode: empdata
                                                                    .empDepartmentName!,
                                                                url: widget.url,
                                                              )),
                                                    );
                                                  },
                                                  text: ' บันทึกเวลางาน',
                                                  iconData: FontAwesomeIcons
                                                      .briefcase,
                                                  color: Colors.green,
                                                  textStyle: TextStyle(
                                                      color: Colors.white),
                                                  iconColor: Colors.white,
                                                ),
                                                // IconsOutlineButton(
                                                //   onPressed: () {
                                                //     Navigator.push(
                                                //       context,
                                                //       MaterialPageRoute(
                                                //           builder: (context) =>
                                                //               AddTimesheetBreak(
                                                //                   timesheetlist:
                                                //                       TimesheetData(),
                                                //                   EmpCode: widget
                                                //                       .EmpCode)),
                                                //     );
                                                //   },
                                                //   text: ' เพิ่มเวลาพัก',
                                                //   iconData: FontAwesomeIcons
                                                //       .breadSlice,
                                                //   color: Colors.blue,
                                                //   iconColor: Colors.white,
                                                //   textStyle: TextStyle(
                                                //       color: Colors.white),
                                                // ),
                                              ],
                                            ),
                                          ]),
                                      icon: Icon(
                                        FontAwesomeIcons.plus,
                                        // size: 35,
                                      ), //icon data for elevated button
                                      label: Text(
                                        'เพิ่มรายการ',
                                        style: GoogleFonts.getFont(Fonts.fonts),
                                      ), //label text
                                      style: ElevatedButton.styleFrom(
                                          shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(50),
                                          ),
                                          primary:
                                              Color.fromARGB(255, 34, 67, 114),
                                          // padding:
                                          //     EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                          textStyle: TextStyle(
                                            fontSize: 14,
                                          )),
                                    ),
                                  ),
                                ]),
                              ],
                            ),
                            SizedBox(height: 20),
                            _buildtimesheet(),
                            //Overnight
                            Visibility(
                              visible: OvernightVisible,
                              child: SizedBox(height: 20),
                            ),
                            Visibility(
                              visible: OvernightVisible,
                              child: Table(
                                columnWidths: {
                                  0: FlexColumnWidth(3),
                                  1: FlexColumnWidth(2),
                                },
                                children: [
                                  TableRow(children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 5),
                                        Text("วันที่ ${_showdateOvernight}"),
                                        Text(
                                            "เวลาปฏิบัติงานรวม ${_showtimeOvernight} ชม."),
                                      ],
                                    ),
                                  ]),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: OvernightVisible,
                              child: SizedBox(height: 20),
                            ),
                            Visibility(
                              visible: OvernightVisible,
                              child: _buildtimesheetOvernight(),
                            ),
                          ],
                        )),
                  ),
                  SingleChildScrollView(
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200)),
                                ),
                                child: TextField(
                                  controller: dateInput,
                                  //editing controller of this TextField
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    // icon: Icon(Icons.calendar_today),
                                    hintText: "เลือกวันที่",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    suffixIcon: Align(
                                      widthFactor: 1.0,
                                      heightFactor: 1.0,
                                      child: Icon(
                                        Icons.calendar_today,
                                      ),
                                    ),
                                  ),
                                  readOnly: true,
                                  onTap: () async {
                                    DateTime? pickedDate =
                                        await showRoundedDatePicker(
                                      context: context,
                                      locale: Locale("th", "TH"),
                                      era: EraMode.BUDDHIST_YEAR,
                                      height: 250,
                                      theme: basicTheme(),
                                      // initialDate: new DateTime(
                                      //     DateTime.now().year + 543,
                                      //     DateTime.now().month,
                                      //     DateTime.now().day),
                                      // firstDate: DateTime(2500),
                                      //DateTime.now() - not to allow to choose before today.
                                      // lastDate: DateTime(3000)
                                    );

                                    if (pickedDate != null) {
                                      print(pickedDate);
                                      String SendDate = DateFormat('yyyy-MM-dd')
                                          .format(
                                              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                      String formattedDate =
                                          DateFormat('dd/MM/yyyy').format(
                                              new DateTime(
                                                  pickedDate.year + 543,
                                                  pickedDate.month,
                                                  pickedDate.day));
                                      var client = http.Client();
                                      var uri = Uri.parse(
                                          "${widget.url}/api/Interface/GetListTimesheeet?Emp_Code=${widget.EmpCode}&dataTime=${SendDate}");
                                      var response = await client.get(uri);
                                      if (response.statusCode == 200) {
                                        // Map<String, dynamic> map = jsonDecode(response.body);
                                        final parsed = jsonDecode(response.body)
                                            .cast<Map<String, dynamic>>();

                                        listTestAuto = parsed
                                            .map<TimesheetData>((json) =>
                                                TimesheetData.fromJson(json))
                                            .toList();
                                      }
                                      print(
                                          formattedDate); //formatted date output using intl package =>  2021-03-16
                                      setState(() {
                                        dateInput.text = formattedDate;
                                        _datahistory = listTestAuto;

                                        viewVisible = true;
                                        if (_datahistory.length == 0) {
                                          _showdatehistory = formattedDate;
                                          _showtimehistory = "00:00";
                                        } else {
                                          _showdatehistory = Customdatetext(
                                              _datahistory[0].timesheetDate);
                                          _showtimehistory =
                                              listTestAuto[0].totalHourDataDay!;
                                        }

                                        //set output date to TextField value.
                                      });
                                    } else {}
                                  },
                                )),
                            SizedBox(height: 20),
                            Visibility(
                                visible: viewVisible,
                                child: Container(
                                  child: Table(
                                    columnWidths: {
                                      0: FlexColumnWidth(3),
                                      1: FlexColumnWidth(2),
                                    },
                                    children: [
                                      TableRow(children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 5),
                                            Table(
                                              columnWidths: {
                                                // 0: FlexColumnWidth(1),
                                                // 1: FlexColumnWidth(4),
                                              },
                                              children: [
                                                TableRow(children: [
                                                  Text(
                                                      "วันที่ ${_showdatehistory}",
                                                      textAlign:
                                                          TextAlign.left),
                                                  Text(
                                                      "เวลาปฏิบัติงานรวม ${_showtimehistory} ชม.",
                                                      textAlign:
                                                          TextAlign.right)
                                                ]),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ]),
                                    ],
                                  ),
                                )),
                            SizedBox(height: 20),
                            _buildhistory(),
                          ],
                        )),
                  ),
                ],
              ),
            )));
  }

  Widget _buildtimesheet() {
    DateTime chkdatenow = DateTime.now();
    timenow = new DateTime.now();
    String datetimenow = DateFormat("dd/MM/yyyy")
        .format(new DateTime(timenow.year + 543, timenow.month, timenow.day))
        .toString();
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((TimesheetData item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              leading: Icon(
                FontAwesomeIcons.calendarPlus,
                size: 30,
              ),
              title: Table(
                columnWidths: {
                  0: FlexColumnWidth(1.5),
                  // 1: FlexColumnWidth(4),
                },
                children: [
                  TableRow(children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Text(
                          '${item.inTime} - ${item.outTime == '00:00' ? '24:00' : item.outTime} น.'),
                    ),
                    TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Text(
                          "    (${item.totalHourItemData} ชม.)",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 12),
                        )),
                  ]),
                ],
              ),
              subtitle: Text('${item.projectName}'),
            );
          },
          body: ListTile(
            tileColor: Colors.grey[100],
            // title: Text("Dragonnier"),
            subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // color: Colors.white,
                    // padding: EdgeInsets.all(20.0),
                    padding: EdgeInsets.only(top: 10),
                    child: Table(
                      columnWidths: {
                        0: FlexColumnWidth(0.3),
                        // 1: FlexColumnWidth(4),
                      },
                      children: [
                        // TableRow(children: [
                        //   Text("วันที่"),
                        //   Text("${item.createDate}"),
                        // ]),
                        // TableRow(children: [
                        //   Text("รหัสงาน"),
                        //   Text("${item.jobCode}"),
                        // ]),
                        // TableRow(children: [
                        //   Text("ประเภทงาน"),
                        //   Text("${item.jobTypeCode}"),
                        // ]),
                        item.status != '5'
                            ? TableRow(children: [
                                Text("แผนก"),
                                Text("${item.departmentCode}"),
                              ])
                            : TableRow(children: [
                                SizedBox(width: 0),
                                SizedBox(width: 0),
                              ]),
                        TableRow(children: [
                          Text("เนื้องาน"),
                          Text("${item.jobDetail}"),
                        ]),
                        TableRow(children: [
                          Text("หมายเหตุ"),
                          Text("${item.remark != '' ? item.remark : '-'}"),
                        ]),
                      ],
                    ),
                  ),
                  (!item.jobCode!.contains(
                          DateTime.parse(item.timesheetDate!).year.toString() +
                              DateTime.parse(item.timesheetDate!)
                                  .month
                                  .toString()
                                  .padLeft(2, '0') +
                              DateTime.parse(item.timesheetDate!)
                                  .day
                                  .toString()
                                  .padLeft(2, '0')))
                      ? Center(
                          child: Text(
                            "\nรายการดังกล่าว คือ การบันทึกเวลางานข้ามวัน \n* ไม่สามารถลบข้อมูลได้ *",
                            textAlign: TextAlign.center,
                          ),
                        )
                      : SizedBox(height: 0),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Visibility(
                      //   visible: item.status == '5' ? false : true,
                      //   child: ElevatedButton.icon(
                      //     onPressed: () {
                      //       switch (item.status) {
                      //         case '1':
                      //           {
                      //             Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) => AddTimesheet(
                      //                       timesheetlist: item,
                      //                       EmpCode: widget.EmpCode,
                      //                       DepCode:
                      //                           empdata.empDepartmentName!)),
                      //             );
                      //           }
                      //           break;

                      //         case '4':
                      //           {
                      //             Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) => AddTimesheetBreak(
                      //                       timesheetlist: item,
                      //                       EmpCode: widget.EmpCode)),
                      //             );
                      //           }
                      //           break;

                      //         case '5':
                      //           {
                      //             Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) =>
                      //                       AddTimesheetLeaveValue(
                      //                           timesheetlist: item,
                      //                           EmpCode: widget.EmpCode)),
                      //             );
                      //           }
                      //           break;

                      //         default:
                      //           {
                      //             Dialogs.materialDialog(
                      //               color: Colors.white,
                      //               msg: 'ผิดพลาด',
                      //               title: 'ไม่พบประเภทการลงเวลางาน',
                      //               context: context,
                      //               actions: [
                      //                 IconsButton(
                      //                   onPressed: () {
                      //                     Navigator.of(context).pop();
                      //                   },
                      //                   text: 'Close',
                      //                   // iconData: Icons.done,
                      //                   color: Colors.green,
                      //                   textStyle:
                      //                       TextStyle(color: Colors.white),
                      //                   iconColor: Colors.white,
                      //                 ),
                      //               ],
                      //             );
                      //           }
                      //           break;
                      //       }
                      //     },
                      //     icon: Icon(
                      //       FontAwesomeIcons.pen,
                      //       size: 15,
                      //     ), //icon data for elevated button
                      //     label: Text(
                      //       'แก้ไข',
                      //       style: GoogleFonts.getFont(Fonts.fonts),
                      //     ), //label text
                      //     style: ElevatedButton.styleFrom(
                      //         shape: new RoundedRectangleBorder(
                      //           borderRadius: new BorderRadius.circular(50),
                      //         ),
                      //         primary: Color.fromARGB(255, 192, 118, 49),
                      //         // padding:
                      //         //     EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      //         textStyle: TextStyle(
                      //           fontSize: 14,
                      //         )),
                      //   ),
                      // ),
                      // Visibility(
                      //   visible: item.status == '5' ? false : true,
                      //   child: SizedBox(width: 50),
                      // ),
                      Visibility(
                        visible: (item.jobCode!.contains(
                                DateTime.parse(item.timesheetDate!)
                                        .year
                                        .toString() +
                                    DateTime.parse(item.timesheetDate!)
                                        .month
                                        .toString()
                                        .padLeft(2, '0') +
                                    DateTime.parse(item.timesheetDate!)
                                        .day
                                        .toString()
                                        .padLeft(2, '0')))
                            ? true
                            : false,
                        child: ElevatedButton.icon(
                          onPressed: () => Dialogs.materialDialog(
                              msg: 'ท่านต้องการลบข้อมูลใช่หรือไม่?',
                              title: 'ยืนยันข้อมูล',
                              context: context,
                              actions: [
                                IconsOutlineButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  text: 'ไม่',
                                  iconData: Icons.cancel_outlined,
                                  color: Colors.white,
                                  textStyle: TextStyle(color: Colors.black),
                                  iconColor: Colors.black,
                                ),
                                IconsButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    timenow = new DateTime.now();
                                    String datetimenow =
                                        DateFormat("dd/MM/yyyy")
                                            .format(new DateTime(
                                                timenow.year + 543,
                                                timenow.month,
                                                timenow.day))
                                            .toString();
                                    //check in 9:00
                                    if ((_showdatetoday == datetimenow) ||
                                        ((_showdatetoday == datetimenow) ||
                                            (timenow.hour <
                                                    work_yesterday.inHours ||
                                                (work_yesterday.inHours ==
                                                        timenow.hour &&
                                                    timenow.minute <
                                                        work_yesterday.inMinutes
                                                            .remainder(60))))) {
                                      datasavetimesheet(item);
                                    } else {
                                      Dialogs.materialDialog(
                                          msg:
                                              'ไม่สามารถลบข้อมูลได้เนื่องจากเกินเวลาที่กำหนด คือ เวลา ${work_yesterday.inHours.toString().padLeft(2, '0')}:${work_yesterday.inMinutes.remainder(60).toString().padLeft(2, '0')} น.',
                                          title: 'ตรวจสอบข้อมูล',
                                          context: context,
                                          actions: [
                                            IconsButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                getlsttimesheet();
                                              },
                                              text: 'ตกลง',
                                              iconData:
                                                  Icons.check_circle_outline,
                                              color: Colors.green,
                                              textStyle: TextStyle(
                                                  color: Colors.white),
                                              iconColor: Colors.white,
                                            ),
                                          ]);
                                    }
                                  },
                                  text: 'ใช่',
                                  iconData: Icons.check_circle_outline,
                                  color: Colors.green,
                                  textStyle: TextStyle(color: Colors.white),
                                  iconColor: Colors.white,
                                ),
                              ]),
                          icon: Icon(
                            FontAwesomeIcons.trash,
                            size: 15,
                          ), //icon data for elevated button
                          label: Text(
                            'ลบ ',
                            style: GoogleFonts.getFont(Fonts.fonts),
                          ), //label text
                          style: ElevatedButton.styleFrom(
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(50),
                              ),
                              primary: Color.fromRGBO(114, 41, 34, 1),
                              // padding:
                              //     EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                              textStyle: TextStyle(
                                fontSize: 14,
                              )),
                        ),
                      ),
                    ],
                  )
                ]),
            isThreeLine: true,
            // trailing: Icon(Icons.more_vert)
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }

  Widget _buildtimesheetOvernight() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _dataOvernight[index].isExpanded = !isExpanded;
        });
      },
      children: _dataOvernight.map<ExpansionPanel>((TimesheetData item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              leading: Icon(
                FontAwesomeIcons.calendarPlus,
                size: 30,
              ),
              title: Table(
                columnWidths: {
                  0: FlexColumnWidth(1.5),
                  // 1: FlexColumnWidth(4),
                },
                children: [
                  TableRow(children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Text(
                          '${item.inTime} - ${item.outTime == '00:00' ? '24:00' : item.outTime} น.'),
                    ),
                    TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Text(
                          "    (${item.totalHourItemData} ชม.)",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 12),
                        )),
                  ]),
                ],
              ),
              subtitle: Text('${item.projectName}'),
            );
          },
          body: ListTile(
            tileColor: Colors.grey[100],
            // title: Text("Dragonnier"),
            subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // color: Colors.white,
                    // padding: EdgeInsets.all(20.0),
                    padding: EdgeInsets.only(top: 10),
                    child: Table(
                      columnWidths: {
                        0: FlexColumnWidth(0.3),
                        // 1: FlexColumnWidth(4),
                      },
                      children: [
                        // TableRow(children: [
                        //   Text("วันที่"),
                        //   Text("${item.timeSheetDateShow}"),
                        // ]),
                        // TableRow(children: [
                        //   Text("รหัสงาน"),
                        //   Text("${item.jobCode}"),
                        // ]),
                        // TableRow(children: [
                        //   Text("ประเภทงาน"),
                        //   Text("${item.jobTypeCode}"),
                        // ]),
                        item.status != '5'
                            ? TableRow(children: [
                                Text("แผนก"),
                                Text("${item.departmentCode}"),
                              ])
                            : TableRow(children: [
                                SizedBox(width: 0),
                                SizedBox(width: 0),
                              ]),
                        TableRow(children: [
                          Text("เนื้องาน"),
                          Text("${item.jobDetail}"),
                        ]),
                        TableRow(children: [
                          Text("หมายเหตุ"),
                          Text("${item.remark != '' ? item.remark : '-'}"),
                        ]),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => Dialogs.materialDialog(
                            msg: 'ท่านต้องการลบข้อมูลใช่หรือไม่?',
                            title: 'ยืนยันข้อมูล',
                            context: context,
                            actions: [
                              IconsOutlineButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                text: 'ไม่',
                                iconData: Icons.cancel_outlined,
                                color: Colors.white,
                                textStyle: TextStyle(color: Colors.black),
                                iconColor: Colors.black,
                              ),
                              IconsButton(
                                onPressed: () {
                                  Navigator.of(context).pop();

                                  timenow = new DateTime.now();
                                  String datetimenow = DateFormat("dd/MM/yyyy")
                                      .format(new DateTime(timenow.year + 543,
                                          timenow.month, timenow.day))
                                      .toString();
                                  //check in 9:00

                                  if ((item.jobCode!.contains(
                                          DateTime.parse(item.timesheetDate!).year.toString() +
                                              DateTime.parse(item.timesheetDate!)
                                                  .month
                                                  .toString()
                                                  .padLeft(2, '0') +
                                              DateTime.parse(item.timesheetDate!)
                                                  .day
                                                  .toString()
                                                  .padLeft(2, '0'))) ||
                                      ((!item.jobCode!.contains(DateTime.parse(item.timesheetDate!).year.toString() +
                                              DateTime.parse(item.timesheetDate!)
                                                  .month
                                                  .toString()
                                                  .padLeft(2, '0') +
                                              DateTime.parse(item.timesheetDate!)
                                                  .day
                                                  .toString()
                                                  .padLeft(2, '0'))) &&
                                          ((_showdatetoday == datetimenow) ||
                                              ((_showdatetoday == datetimenow) || (timenow.hour < work_yesterday.inHours || (work_yesterday.inHours == timenow.hour && timenow.minute < work_yesterday.inMinutes.remainder(60))))))) {
                                    datasavetimesheet(item);
                                  } else {
                                    Dialogs.materialDialog(
                                        msg:
                                            'ไม่สามารถลบข้อมูลได้เนื่องจากเกินเวลาที่กำหนด คือ เวลา ${work_yesterday.inHours.toString().padLeft(2, '0')}:${work_yesterday.inMinutes.remainder(60).toString().padLeft(2, '0')} น.',
                                        title: 'ตรวจสอบข้อมูล',
                                        context: context,
                                        actions: [
                                          IconsButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              getlsttimesheet();
                                            },
                                            text: 'ตกลง',
                                            iconData:
                                                Icons.check_circle_outline,
                                            color: Colors.green,
                                            textStyle:
                                                TextStyle(color: Colors.white),
                                            iconColor: Colors.white,
                                          ),
                                        ]);
                                  }
                                },
                                text: 'ใช่',
                                iconData: Icons.check_circle_outline,
                                color: Colors.green,
                                textStyle: TextStyle(color: Colors.white),
                                iconColor: Colors.white,
                              ),
                            ]),
                        icon: Icon(
                          FontAwesomeIcons.trash,
                          size: 15,
                        ), //icon data for elevated button
                        label: Text(
                          'ลบ ',
                          style: GoogleFonts.getFont(Fonts.fonts),
                        ), //label text
                        style: ElevatedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(50),
                            ),
                            primary: Color.fromRGBO(114, 41, 34, 1),
                            // padding:
                            //     EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                            textStyle: TextStyle(
                              fontSize: 14,
                            )),
                      ),
                    ],
                  )
                ]),
            isThreeLine: true,
            // trailing: Icon(Icons.more_vert)
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }

  Widget _buildhistory() {
    return ExpansionPanelList(
      expansionCallback: (int indexhistory, bool isExpandedhistory) {
        setState(() {
          _datahistory[indexhistory].isExpanded = !isExpandedhistory;
        });
      },
      children: _datahistory.map<ExpansionPanel>((TimesheetData item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              leading: Icon(
                FontAwesomeIcons.calendarPlus,
                size: 35,
              ),
              title: Table(
                columnWidths: {
                  0: FlexColumnWidth(1.5),
                  // 1: FlexColumnWidth(4),
                },
                children: [
                  TableRow(children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Text(
                          '${item.inTime} - ${item.outTime == '00:00' ? '24:00' : item.outTime} น.'),
                    ),
                    TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Text(
                          "    (${item.totalHourItemData} ชม.)",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 12),
                        )),
                  ]),
                ],
              ),
              subtitle: Text('${item.projectName}'),
            );
          },
          body: ListTile(
            tileColor: Colors.grey[100],
            // title: Text("Dragonnier"),
            subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // color: Colors.white,
                          // padding: EdgeInsets.all(20.0),
                          padding: EdgeInsets.only(top: 10),
                          child: Table(
                            columnWidths: {
                              0: FlexColumnWidth(0.3),
                              // 1: FlexColumnWidth(4),
                            },
                            children: [
                              // TableRow(children: [
                              //   Text("วันที่"),
                              //   Text("${item.timeSheetDateShow}"),
                              // ]),
                              // TableRow(children: [
                              //   Text("รหัสงาน"),
                              //   Text("${item.jobCode}"),
                              // ]),
                              // TableRow(children: [
                              //   Text("ประเภทงาน"),
                              //   Text("${item.jobTypeCode ?? '-'}"),
                              // ]),
                              item.status != '5'
                                  ? TableRow(children: [
                                      Text("แผนก"),
                                      Text("${item.departmentCode}"),
                                    ])
                                  : TableRow(children: [
                                      SizedBox(width: 0),
                                      SizedBox(width: 0),
                                    ]),
                              TableRow(children: [
                                Text("เนื้องาน"),
                                Text("${item.jobDetail ?? '-'}"),
                              ]),
                              TableRow(children: [
                                Text("หมายเหตุ"),
                                Text(
                                    "${item.remark != '' ? item.remark : '-'}"),
                              ]),
                            ],
                          ),
                        ),
                      ]),
                  SizedBox(height: 20),
                ]),
            isThreeLine: true,
            // trailing: Icon(Icons.more_vert)
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}
