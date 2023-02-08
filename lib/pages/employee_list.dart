import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
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
  TextEditingController timestart = TextEditingController();

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
  ];

  TextEditingController texttime = TextEditingController();

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

////////

  String dropdownValue = 'พื้นที่ไม่พร้อม';
  List<String> LocationDetail = [
    'พื้นที่ไม่พร้อม',
    'วัสดุไม่พร้อม',
    'เครื่องจักรไม่พร้อม'
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

    _data = widget.listtimesheet;

    // DateTime NewDate = DateTime.now();

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

    // getlsttimesheetOvernight(_showdatetoday);

    // CheckPremission();

    // Timer mytimer = Timer.periodic(Duration(seconds: 1), (timer) {
    //   DateTime timenow = DateTime.now(); //get current date and time
    //   if (timenow.hour == 9 && timenow.minute == 00 && timenow.second == 00) {
    //     getlsttimesheet();
    //   }
    // });

    // super.initState();
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
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.blue[900],
                                            onPrimary: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            'พร้อมทำงาน',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13.0),
                                          ),
                                          onPressed: () {},
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        TextButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.red[900],
                                            onPrimary: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            'ไม่พร้อม',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13.0),
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return StatefulBuilder(
                                                  builder: (context, setState) {
                                                    return AlertDialog(
                                                      backgroundColor:
                                                          Dialogs.bcgColor,
                                                      // content: Dialogs.holder,
                                                      shape:
                                                          Dialogs.dialogShape,
                                                      title: Center(
                                                        child: Text(
                                                          "ไม่พร้อม",
                                                          style: Dialogs
                                                              .titleStyle,
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
                                                                        .grey
                                                                        .shade400),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5)),
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      'รายละเอียด'),
                                                                  DropdownButtonFormField(
                                                                    hint: const Text(
                                                                        'เลือกรายละเอียด'),
                                                                    decoration:
                                                                        InputDecoration(
                                                                      border:
                                                                          OutlineInputBorder(),
                                                                    ),
                                                                    // dropdownColor:
                                                                    //     Colors
                                                                    //         .greenAccent,
                                                                    value:
                                                                        dropdownValue,
                                                                    onChanged:
                                                                        (String?
                                                                            newValue) {
                                                                      setState(
                                                                          () {
                                                                        dropdownValue =
                                                                            newValue!;
                                                                      });
                                                                    },
                                                                    items: LocationDetail.map<
                                                                        DropdownMenuItem<
                                                                            String>>((String
                                                                        value) {
                                                                      return DropdownMenuItem<
                                                                          String>(
                                                                        value:
                                                                            value,
                                                                        child:
                                                                            Text(
                                                                          value,
                                                                          style:
                                                                              TextStyle(fontSize: 20),
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                  ),
                                                                  Text(
                                                                      'สาเหตุ'),
                                                                  TextField(
                                                                    // key: '',
                                                                    // controller: remark,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      border:
                                                                          OutlineInputBorder(),
                                                                    ),
                                                                    maxLines: 2,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Dialogs.materialDialog(
                                                                    msg:
                                                                        'ท่านต้องการบันทึกข้อมูลใช่หรือไม่?',
                                                                    title:
                                                                        'ยืนยันข้อมูล',
                                                                    context:
                                                                        context,
                                                                    actions: [
                                                                      IconsOutlineButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context, rootNavigator: true)
                                                                              .pop();
                                                                          Navigator.of(context, rootNavigator: true)
                                                                              .pop();
                                                                        },
                                                                        text:
                                                                            'ไม่',
                                                                        iconData:
                                                                            Icons.cancel_outlined,
                                                                        color: Colors
                                                                            .white,
                                                                        textStyle:
                                                                            TextStyle(color: Colors.black),
                                                                        iconColor:
                                                                            Colors.black,
                                                                      ),
                                                                      IconsButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context, rootNavigator: true)
                                                                              .pop();
                                                                          Navigator.of(context, rootNavigator: true)
                                                                              .pop();
                                                                        },
                                                                        text:
                                                                            'ใช่',
                                                                        iconData:
                                                                            Icons.check_circle_outline,
                                                                        color: Colors
                                                                            .green,
                                                                        textStyle:
                                                                            TextStyle(color: Colors.white),
                                                                        iconColor:
                                                                            Colors.white,
                                                                      ),
                                                                    ]);
                                                              },
                                                              child: Container(
                                                                color: Colors
                                                                    .blue[900],
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical: 5,
                                                                    horizontal:
                                                                        10),
                                                                child:
                                                                    const Text(
                                                                  'ตกลง',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          13.0),
                                                                ),
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
                                    if (valall == false) {
                                      setState(() {
                                        valall = true;
                                      });
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
                                                              color: Colors.grey
                                                                  .shade400),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
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
                                                                          setState(
                                                                              () {
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
                                                                          setState(
                                                                              () {
                                                                            OTBeforeEnd =
                                                                                result;
                                                                            TextOTBeforeEnd =
                                                                                '${OTBeforeEnd.hour.toString().padLeft(2, '0')}:${OTBeforeEnd.minute.toString().padLeft(2, '0')}';
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
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .shade400),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                        ),
                                                        child: Row(
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
                                                                            DefultOneStart,
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
                                                                          setState(
                                                                              () {
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
                                                                            DefultOneEnd,
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
                                                                          setState(
                                                                              () {
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
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .shade400),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                        ),
                                                        child: Row(
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
                                                                            DefultTwoStart,
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
                                                                          setState(
                                                                              () {
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
                                                                            DefultTwoEnd,
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
                                                                          setState(
                                                                              () {
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
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .shade400),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
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
                                                                          setState(
                                                                              () {
                                                                            OTAfterStart =
                                                                                result;
                                                                            TextOTAfterStart =
                                                                                '${OTAfterStart.hour.toString().padLeft(2, '0')}:${OTAfterStart.minute.toString().padLeft(2, '0')}';
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
                                                                          setState(
                                                                              () {
                                                                            OTAfterEnd =
                                                                                result;
                                                                            TextOTAfterEnd =
                                                                                '${OTAfterEnd.hour.toString().padLeft(2, '0')}:${OTAfterEnd.minute.toString().padLeft(2, '0')}';
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
                                                        height: 20,
                                                      ),
                                                      SizedBox(
                                                        width: 100,
                                                        child: IconsButton(
                                                          text: 'ตกลง',
                                                          iconData: Icons
                                                              .check_circle_outline,
                                                          color: Colors.green,
                                                          textStyle: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          iconColor:
                                                              Colors.white,
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context,
                                                                    rootNavigator:
                                                                        true)
                                                                .pop();

                                                            //////function check time
                                                          },
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
                                    } else {
                                      setState(() {
                                        valall = false;
                                      });
                                    }
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
                            onPressed: () => {
                              Dialogs.materialDialog(
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
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();

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
                                                    builder:
                                                        (context, setState) {
                                                      return AlertDialog(
                                                        backgroundColor:
                                                            Dialogs.bcgColor,
                                                        // content: Dialogs.holder,
                                                        shape:
                                                            Dialogs.dialogShape,
                                                        title: Center(
                                                          child: Text(
                                                            "ทำงาน",
                                                            style: Dialogs
                                                                .titleStyle,
                                                          ),
                                                        ),
                                                        actions: <Widget>[
                                                          Column(
                                                            children: [
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        5.0),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade400),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
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
                                                                      onPressed: () => Picker(
                                                                          hideHeader: true,
                                                                          cancelText: 'ยกเลิก',
                                                                          confirmText: 'ตกลง',
                                                                          cancelTextStyle: TextStyle(fontFamily: Fonts.fonts),
                                                                          confirmTextStyle: TextStyle(fontFamily: Fonts.fonts),
                                                                          adapter: DateTimePickerAdapter(
                                                                            minuteInterval:
                                                                                15,
                                                                            value:
                                                                                OTBeforeStart,
                                                                            customColumnType: [
                                                                              3,
                                                                              4
                                                                            ],
                                                                          ),
                                                                          title: Text(""),
                                                                          selectedTextStyle: TextStyle(color: Colors.blue),
                                                                          onConfirm: (Picker picker, List value) {
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
                                                                    Text(
                                                                        ' ถึง '),
                                                                    OutlinedButton(
                                                                      onPressed: () =>
                                                                          // showPickerDateCustom(
                                                                          //     context,
                                                                          //     'OTBeforeEnd'),
                                                                          Picker(
                                                                              cancelText: 'ยกเลิก',
                                                                              confirmText: 'ตกลง',
                                                                              cancelTextStyle: TextStyle(fontFamily: Fonts.fonts),
                                                                              confirmTextStyle: TextStyle(fontFamily: Fonts.fonts),
                                                                              hideHeader: true,
                                                                              adapter: DateTimePickerAdapter(
                                                                                minuteInterval: 15,
                                                                                value: OTBeforeEnd,
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
                                                                height: 10,
                                                              ),
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        5.0),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade400),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5)),
                                                                ),
                                                                child: Row(
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
                                                                    Text(
                                                                        ' ถึง '),
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
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        5.0),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade400),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5)),
                                                                ),
                                                                child: Row(
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
                                                                    Text(
                                                                        ' ถึง '),
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
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        5.0),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade400),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
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
                                                                              cancelText: 'ยกเลิก',
                                                                              confirmText: 'ตกลง',
                                                                              cancelTextStyle: TextStyle(fontFamily: Fonts.fonts),
                                                                              confirmTextStyle: TextStyle(fontFamily: Fonts.fonts),
                                                                              hideHeader: true,
                                                                              adapter: DateTimePickerAdapter(
                                                                                minuteInterval: 15,
                                                                                value: OTAfterStart,
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
                                                                                    OTAfterStart = result;
                                                                                    TextOTAfterStart = '${OTAfterStart.hour.toString().padLeft(2, '0')}:${OTAfterStart.minute.toString().padLeft(2, '0')}';
                                                                                  });
                                                                                }
                                                                              }).showDialog(context),
                                                                      child: Text(
                                                                          '${TextOTAfterStart}'),
                                                                    ),
                                                                    Text(
                                                                        ' ถึง '),
                                                                    OutlinedButton(
                                                                      onPressed: () =>
                                                                          // showPickerDateCustom(
                                                                          //     context,
                                                                          //     'OTAfterEnd'),
                                                                          Picker(
                                                                              cancelText: 'ยกเลิก',
                                                                              confirmText: 'ตกลง',
                                                                              cancelTextStyle: TextStyle(fontFamily: Fonts.fonts),
                                                                              confirmTextStyle: TextStyle(fontFamily: Fonts.fonts),
                                                                              hideHeader: true,
                                                                              adapter: DateTimePickerAdapter(
                                                                                minuteInterval: 15,
                                                                                value: OTAfterEnd,
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
                                                                height: 20,
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
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context,
                                                                            rootNavigator:
                                                                                true)
                                                                        .pop();

                                                                    //////function check time
                                                                    // if (OTBeforeStart >
                                                                    //     OTBeforeEnd) {
                                                                    //   showAboutDialog(
                                                                    //       context:
                                                                    //           context,
                                                                    //       children: [Text('ก่อนมากกว่าหลัง')]);
                                                                    // }
                                                                  },
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
                                            }),
                                        IconsButton(
                                          text: ' ลาป่วยบางช่วงเวลา',
                                          color: Colors.yellow[800],
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          iconColor: Colors.white,
                                          onPressed: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                            TextLeavesickStart = "";
                                            TextLeavesickEnd = "";
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return StatefulBuilder(
                                                  builder: (context, setState) {
                                                    return AlertDialog(
                                                      backgroundColor:
                                                          Dialogs.bcgColor,
                                                      // content: Dialogs.holder,
                                                      shape:
                                                          Dialogs.dialogShape,
                                                      title: Center(
                                                        child: Text(
                                                          "ลาป่วยบางช่วงเวลา",
                                                          style: Dialogs
                                                              .titleStyle,
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
                                                                        .grey
                                                                        .shade400),
                                                                borderRadius: BorderRadius
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
                                                                      'ลา : เวลา '),
                                                                  OutlinedButton(
                                                                    onPressed: () => Picker(
                                                                        hideHeader: true,
                                                                        cancelText: 'ยกเลิก',
                                                                        confirmText: 'ตกลง',
                                                                        cancelTextStyle: TextStyle(fontFamily: Fonts.fonts),
                                                                        confirmTextStyle: TextStyle(fontFamily: Fonts.fonts),
                                                                        adapter: DateTimePickerAdapter(
                                                                          minuteInterval:
                                                                              15,
                                                                          value:
                                                                              LeavesickStart,
                                                                          customColumnType: [
                                                                            3,
                                                                            4
                                                                          ],
                                                                        ),
                                                                        title: Text(""),
                                                                        selectedTextStyle: TextStyle(color: Colors.blue),
                                                                        onConfirm: (Picker picker, List value) {
                                                                          var result =
                                                                              (picker.adapter as DateTimePickerAdapter).value;
                                                                          if (result !=
                                                                              null) {
                                                                            setState(() {
                                                                              LeavesickStart = result;
                                                                              TextLeavesickStart = '${LeavesickStart.hour.toString().padLeft(2, '0')}:${LeavesickStart.minute.toString().padLeft(2, '0')}';
                                                                            });
                                                                          }
                                                                        }).showDialog(context),
                                                                    child: Text(
                                                                        '${TextLeavesickStart}'),
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
                                                                            cancelTextStyle: TextStyle(fontFamily: Fonts.fonts),
                                                                            confirmTextStyle: TextStyle(fontFamily: Fonts.fonts),
                                                                            hideHeader: true,
                                                                            adapter: DateTimePickerAdapter(
                                                                              minuteInterval: 15,
                                                                              value: LeavesickEnd,
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
                                                                                  LeavesickEnd = result;
                                                                                  TextLeavesickEnd = '${LeavesickEnd.hour.toString().padLeft(2, '0')}:${LeavesickEnd.minute.toString().padLeft(2, '0')}';
                                                                                });
                                                                              }
                                                                            }).showDialog(context),
                                                                    child: Text(
                                                                        '${TextLeavesickEnd}'),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            SizedBox(
                                                              width: 100,
                                                              child:
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
                                                                color: Colors
                                                                    .green,
                                                                textStyle: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                                iconColor:
                                                                    Colors
                                                                        .white,
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
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          iconColor: Colors.white,
                                          onPressed: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                            TextLeaveunpaidStart = "";
                                            TextLeaveunpaidEnd = "";
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return StatefulBuilder(
                                                  builder: (context, setState) {
                                                    return AlertDialog(
                                                      backgroundColor:
                                                          Dialogs.bcgColor,
                                                      // content: Dialogs.holder,
                                                      shape:
                                                          Dialogs.dialogShape,
                                                      title: Center(
                                                        child: Text(
                                                          "ลาไม่รับค่าจ้างบางช่วงเวลา",
                                                          style: Dialogs
                                                              .titleStyle,
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
                                                                        .grey
                                                                        .shade400),
                                                                borderRadius: BorderRadius
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
                                                                      'ลา : เวลา '),
                                                                  OutlinedButton(
                                                                    onPressed: () => Picker(
                                                                        hideHeader: true,
                                                                        cancelText: 'ยกเลิก',
                                                                        confirmText: 'ตกลง',
                                                                        cancelTextStyle: TextStyle(fontFamily: Fonts.fonts),
                                                                        confirmTextStyle: TextStyle(fontFamily: Fonts.fonts),
                                                                        adapter: DateTimePickerAdapter(
                                                                          minuteInterval:
                                                                              15,
                                                                          value:
                                                                              LeaveunpaidStart,
                                                                          customColumnType: [
                                                                            3,
                                                                            4
                                                                          ],
                                                                        ),
                                                                        title: Text(""),
                                                                        selectedTextStyle: TextStyle(color: Colors.blue),
                                                                        onConfirm: (Picker picker, List value) {
                                                                          var result =
                                                                              (picker.adapter as DateTimePickerAdapter).value;
                                                                          if (result !=
                                                                              null) {
                                                                            setState(() {
                                                                              LeaveunpaidStart = result;
                                                                              TextLeaveunpaidStart = '${LeaveunpaidStart.hour.toString().padLeft(2, '0')}:${LeaveunpaidStart.minute.toString().padLeft(2, '0')}';
                                                                            });
                                                                          }
                                                                        }).showDialog(context),
                                                                    child: Text(
                                                                        '${TextLeaveunpaidStart}'),
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
                                                                            cancelTextStyle: TextStyle(fontFamily: Fonts.fonts),
                                                                            confirmTextStyle: TextStyle(fontFamily: Fonts.fonts),
                                                                            hideHeader: true,
                                                                            adapter: DateTimePickerAdapter(
                                                                              minuteInterval: 15,
                                                                              value: LeaveunpaidEnd,
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
                                                                                  LeaveunpaidEnd = result;
                                                                                  TextLeaveunpaidEnd = '${LeaveunpaidEnd.hour.toString().padLeft(2, '0')}:${LeaveunpaidEnd.minute.toString().padLeft(2, '0')}';
                                                                                });
                                                                              }
                                                                            }).showDialog(context),
                                                                    child: Text(
                                                                        '${TextLeaveunpaidEnd}'),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            SizedBox(
                                                              width: 100,
                                                              child:
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
                                                                color: Colors
                                                                    .green,
                                                                textStyle: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                                iconColor:
                                                                    Colors
                                                                        .white,
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
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          iconColor: Colors.white,
                                          onPressed: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return StatefulBuilder(
                                                  builder: (context, setState) {
                                                    return AlertDialog(
                                                      backgroundColor:
                                                          Dialogs.bcgColor,
                                                      // content: Dialogs.holder,
                                                      shape:
                                                          Dialogs.dialogShape,
                                                      title: Center(
                                                        child: Text(
                                                          "ลาป่วยทั้งวัน",
                                                          style: Dialogs
                                                              .titleStyle,
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
                                                                        .grey
                                                                        .shade400),
                                                                borderRadius: BorderRadius
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
                                                                      'ลาทั้งวัน : เวลา '),
                                                                  OutlinedButton(
                                                                    onPressed:
                                                                        () {},
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
                                                              child:
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
                                                                color: Colors
                                                                    .green,
                                                                textStyle: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                                iconColor:
                                                                    Colors
                                                                        .white,
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
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          iconColor: Colors.white,
                                          onPressed: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return StatefulBuilder(
                                                  builder: (context, setState) {
                                                    return AlertDialog(
                                                      backgroundColor:
                                                          Dialogs.bcgColor,
                                                      // content: Dialogs.holder,
                                                      shape:
                                                          Dialogs.dialogShape,
                                                      title: Center(
                                                        child: Text(
                                                          "ลาไม่รับค่าจ้างทั้งวัน",
                                                          style: Dialogs
                                                              .titleStyle,
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
                                                                        .grey
                                                                        .shade400),
                                                                borderRadius: BorderRadius
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
                                                                      'ลาทั้งวัน : เวลา '),
                                                                  OutlinedButton(
                                                                    onPressed:
                                                                        () {},
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
                                                              child:
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
                                                                color: Colors
                                                                    .green,
                                                                textStyle: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                                iconColor:
                                                                    Colors
                                                                        .white,
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
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
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
                              style: TextStyle(
                                  color: Colors.white, fontSize: 13.0),
                            ),
                            onPressed: () {
                              Dialogs.materialDialog(
                                  msg: 'ท่านต้องการลบชื่อใช่หรือไม่?',
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
                                      textStyle: TextStyle(color: Colors.black),
                                      iconColor: Colors.black,
                                    ),
                                    IconsButton(
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                      text: 'ใช่',
                                      iconData: Icons.check_circle_outline,
                                      color: Colors.green,
                                      textStyle: TextStyle(color: Colors.white),
                                      iconColor: Colors.white,
                                    ),
                                  ]);
                            },
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
                                          onPressed: () {
                                            Dialogs.materialDialog(
                                                msg:
                                                    'ท่านต้องการบันทึกข้อมูลใช่หรือไม่?',
                                                title: 'ยืนยันข้อมูล',
                                                context: context,
                                                actions: [
                                                  IconsOutlineButton(
                                                    onPressed: () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    },
                                                    text: 'ไม่',
                                                    iconData:
                                                        Icons.cancel_outlined,
                                                    color: Colors.white,
                                                    textStyle: TextStyle(
                                                        color: Colors.black),
                                                    iconColor: Colors.black,
                                                  ),
                                                  IconsButton(
                                                    onPressed: () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    },
                                                    text: 'ใช่',
                                                    iconData: Icons
                                                        .check_circle_outline,
                                                    color: Colors.green,
                                                    textStyle: TextStyle(
                                                        color: Colors.white),
                                                    iconColor: Colors.white,
                                                  ),
                                                ]);
                                          },
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

  showPickerDateCustom(BuildContext context, String title) {
    Picker(
        cancelText: 'ยกเลิก',
        confirmText: 'ตกลง',
        hideHeader: true,
        adapter: DateTimePickerAdapter(
          customColumnType: [3, 4],
        ),
        title: Text(""),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          var result = (picker.adapter as DateTimePickerAdapter).value;
          if (result != null) {
            setState(() {
              if (title == 'OTBeforeStart') {
                OTBeforeStart = result;
              } else if (title == 'OTBeforeEnd') {
                OTBeforeStart = result;
              } else if (title == 'DefultOneStart') {
                OTBeforeEnd = result;
              } else if (title == 'DefultOneEnd') {
                DefultOneStart = result;
              } else if (title == 'DefultTwoStart') {
                DefultOneEnd = result;
              } else if (title == 'DefultTwoEnd') {
                DefultTwoStart = result;
              } else if (title == 'OTAfterStart') {
                OTAfterStart = result;
              } else if (title == 'OTAfterEnd') {
                OTAfterEnd = result;
              } else {}
            });
          }
        }).showDialog(context);
  }
}
