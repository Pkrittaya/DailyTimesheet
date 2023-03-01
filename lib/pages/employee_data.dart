import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:k2mobileapp/home.dart';
import 'package:k2mobileapp/login.dart';
import 'package:k2mobileapp/main.dart';
import 'package:k2mobileapp/models/EmployeeData.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:k2mobileapp/theme.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import '../api.dart';
import '../models/DailyTimeSheet.dart';
import '../models/EmpDailyEmployee.dart';
import '../models/EmployeeList.dart';
import '../models/JobList.dart';
import '../models/LocationList.dart';
import 'employee_list.dart';

class EmployeeDetail extends StatefulWidget {
  final int index;
  final String EmpCode;
  final String url;
  final Employeelist EmpDetail;

  const EmployeeDetail({
    Key? key,
    required this.index,
    required this.EmpCode,
    required this.url,
    required this.EmpDetail,
  }) : super(key: key);

  @override
  State<EmployeeDetail> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<EmployeeDetail>
    with SingleTickerProviderStateMixin {
  Duration work_yesterday = Duration(hours: 9, minutes: 00);

  List<DailyTimeSheet> timesheetCurrent = [];
  List<DailyTimeSheet> timesheetHistory = [];
  late TabController _tabController;
  final _selectedColor = Color(0xff1a73e8);
  final _tabs = [
    Tab(text: 'บันทึกเวลางาน'),
    Tab(text: 'ประวัติย้อนหลัง'),
  ];

  GetDateTimeCurrent() {
    DateTime Date = DateTime.now();
    if ((Date.hour < work_yesterday.inHours) ||
        ((Date.hour == work_yesterday.inHours) &&
            (Date.minute <= work_yesterday.inMinutes.remainder(60)))) {
      Date = DateTime.now().add(new Duration(days: -1));
    } else {
      Date = DateTime.now();
    }

    return Date;
  }

  FormatDate(valdate) {
    String date = DateFormat("dd-MM-yyyy")
        .format(new DateTime(valdate.year + 543, valdate.month, valdate.day));
    return date;
  }

  CustomCountTimeSum(text) {
    final splitted = text.split(':');
    final texttime = 'รวมจำนวน ${splitted[0]} ชั่วโมง ${splitted[1]} นาที';
    // DateTime valDate = DateTime.parse(textdate);

    return texttime.toString();
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

  GetAPI() async {
    timesheetCurrent = await GetDailyTimesheet('5100024', 'CURRENT');
    timesheetHistory = await GetDailyTimesheet('5100024', 'HISTORY');

    setState(() {
      timesheetCurrent = timesheetCurrent;
      timesheetHistory = timesheetHistory;
    });
  }

  CustomTime(texttime) {
    DateTime valDate = DateTime.parse(texttime);
    String date = DateFormat("HH:mm").format(valDate);
    return date.toString();
  }

  ReplaceStatusTime(text) {
    var statustext = "";
    if (text == '100') {
      statustext = 'ทำงาน';
    } else if (text == '201') {
      statustext = 'โอที';
    } else if (text == '202') {
      statustext = 'โอที';
    } else {
      statustext = 'ไม่มี';
    }

    return statustext.toString();
  }

  @override
  void initState() {
    super.initState();
    GetEmpProfile();

    GetAPI();

    // _data = widget.listtimesheet;

    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

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
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(height: 15),
                              ElevatedButton.icon(
                                icon: Icon(
                                  FontAwesomeIcons.arrowLeft,
                                  size: 10,
                                  color: Colors.black,
                                ),
                                label: Text(
                                  'กลับ',
                                  style: TextStyle(
                                    fontFamily: Fonts.fonts,
                                    color: Colors.black,
                                  ),
                                ), //label text
                                style: ElevatedButton.styleFrom(
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(8),
                                    ),
                                    primary: Colors.white,
                                    textStyle: TextStyle(
                                      fontSize: 10,
                                    )),
                                onPressed: () {
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
                                },
                              ),
                              const SizedBox(height: 15),
                              Card(
                                shape: RoundedRectangleBorder(
                                  // side: BorderSide(
                                  //   color: Palette.Colortheme,
                                  // ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: SizedBox(
                                  // width: 300,
                                  // height: 100,
                                  child: Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                                "รหัสพนักงาน : ${widget.EmpDetail.empCode}"),
                                            Text(
                                                "ชื่อ : ${widget.EmpDetail.empName}"),
                                            Text(
                                                "แผนก : ${widget.EmpDetail.empDepartmentName}"),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(""),
                                            Text(""),
                                            Text(""),
                                          ],
                                        )
                                      ],
                                    ),
                                  )),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                height: kToolbarHeight - 8.0,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: TabBar(
                                  controller: _tabController,
                                  indicator: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: _selectedColor),
                                  labelColor: Colors.white,
                                  unselectedLabelColor: Colors.black,
                                  tabs: _tabs,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      // borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: TabBarView(
                                      controller: _tabController,
                                      children: <Widget>[
                                        // SingleChildScrollView(
                                        //   child:
                                        _buildTimesheetCrrent(),
                                        // ),
                                        _buildTimesheetHistoly(),
                                      ],
                                    )),
                              ),
                            ]))),
              ],
            ),
          ),
        ));
  }

  Widget _buildTimesheetCrrent() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text('วันที่ ${FormatDate(GetDateTimeCurrent())}'),
        Text('${CustomCountTimeSum(timesheetCurrent[0].sumtimes)}'),
        Expanded(
          child: ListView.builder(
            itemCount: timesheetCurrent.length,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      '${ReplaceStatusTime(timesheetCurrent[index].status)} : ${CustomTime(timesheetCurrent[index].timeIn)} - ${CustomTime(timesheetCurrent[index].timeOut)}'),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 6,
                      ),
                      _builddeletetimesheet(timesheetCurrent[index]),
                    ],
                  ),
                ],
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildTimesheetHistoly() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text('วันที่ ${FormatDate(GetDateTimeCurrent())}'),
        Text('${CustomCountTimeSum(timesheetHistory[0].sumtimes)}'),
        Expanded(
          child: ListView.builder(
            itemCount: timesheetHistory.length,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      '${ReplaceStatusTime(timesheetHistory[index].status)} : ${CustomTime(timesheetHistory[index].timeIn)} - ${CustomTime(timesheetHistory[index].timeOut)}'),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 6,
                      ),
                      _builddeletetimesheet(timesheetHistory[index]),
                    ],
                  ),
                ],
              );
            },
          ),
        )
      ],
    );
  }

  Widget _builddeletetimesheet(var item) {
    return Ink(
      decoration: const ShapeDecoration(
        color: Colors.red,
        shape: CircleBorder(),
      ),
      width: 30,
      child: IconButton(
        icon: const Icon(Icons.delete),
        color: Colors.black,
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
                    String arrayText = '{"400": ["", ""]}';

                    var tagsJson = jsonDecode(arrayText);

                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ]);
        },
      ),
    );
  }
}
