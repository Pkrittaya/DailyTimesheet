import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:k2mobileapp/login.dart';
import 'package:k2mobileapp/models/EmployeeData.dart';
import 'package:k2mobileapp/theme.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

import '../api.dart';
import '../models/DailyTimeSheet.dart';
import '../models/EmployeeList.dart';
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
  List<DailyTimeSheet> timesheetCurrent = [];
  List<DailyTimeSheet> timesheetHistory = [];
  List<DailyTimeSheet> workdayHistory = [];
  late TabController _tabController;
  final _selectedColor = Color(0xff1a73e8);
  final _tabs = [
    Tab(text: 'บันทึกเวลางาน'),
    Tab(text: 'ประวัติย้อนหลัง'),
  ];

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

  FormatDateTextTH(texttime) {
    DateTime valDate = DateTime.parse(texttime);
    String date = DateFormat("dd MMMM yyyy", "th")
        .format(new DateTime(valDate.year + 543, valDate.month, valDate.day));
    return date;
  }

  FormatDateTH(valdate) {
    String date = DateFormat("dd MMMM yyyy", "th")
        .format(new DateTime(valdate.year + 543, valdate.month, valdate.day));
    return date;
  }

  CustomCountTime(text) {
    final splitted = text.split(':');
    final texttime = '${splitted[0]} ชั่วโมง ${splitted[1]} นาที';
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

  GetAPI() async {
    var seen = Set<String>();

    var Current = await GetDailyTimesheet(widget.EmpDetail.empCode, 'CURRENT');
    var History = await GetDailyTimesheet('5100024', 'HISTORY');
    var Profile = await GetEmpProfile(widget.EmpCode);

    setState(() {
      timesheetCurrent = Current;
      workdayHistory = History.where((res) => seen.add(res.workDay!)).toList();
      timesheetHistory = History;

      empdata.empCode = Profile['emp_Code'];
      empdata.empCompName = Profile['emp_Comp_Name'];
      empdata.empDepartmentName = Profile['emp_Department_Name'];
      empdata.empName = Profile['emp_Name'];
      empdata.empNationality = Profile['emp_Nationality'];
      empdata.empPositionName = Profile['emp_Position_Name'];
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

  void datasavetimesheet(DailyTimeSheet timesheet) async {
    const JsonDecoder decoder = JsonDecoder();
    var currentDate = GetDateTimeCurrent();
    if (FormatDateTH(currentDate) == FormatDateTextTH(timesheet.workDay!)) {
      var Datenow =
          DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(DateTime.now());

      String totext = "[";
      totext += '{';
      totext += '"emp_Code": "${timesheet.empCode}",';
      totext += '"time_In": "${timesheet.timeIn}",';
      totext += '"time_Out": "${timesheet.timeOut}",';
      totext += '"type": "Labour",';
      totext += '"supervisor_Code": "${widget.EmpCode}",';
      totext += '"status": "400",';
      totext += '"remark": "${timesheet.remark}",';
      totext += '"costCenter": "${timesheet.costCenter}",';
      totext += '"jobId": "${timesheet.jobId}",';
      totext += '"start_Date": "${Datenow}",';
      totext += '"create_By": "${widget.EmpCode}",';
      totext += '"project_Code": "${timesheet.projectCode}",';
      totext += '"job_Group": "${timesheet.jobGroup}",';
      totext += '"job_Code": "${timesheet.jobCode}",';
      totext += '"location_Code": "${timesheet.locationCode}"';
      totext += '}';
      totext += ']';

      var tojsontext = decoder.convert(totext);
      // print(totext);
      print(json.encode(tojsontext));

      final _baseUrl = '${widget.url}/api/Daily/SaveDailyTimeSheet';
      final res = await http.post(Uri.parse("${_baseUrl}"),
          headers: {"Content-Type": "application/json"},
          body: json.encode(tojsontext));

      setState(() {
        final jsonData = json.decode(res.body);
        final parsedJson = jsonDecode(res.body);
        if (parsedJson['type'] == "S") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmployeeDetail(
                index: 1,
                EmpCode: widget.EmpCode,
                EmpDetail: widget.EmpDetail,
                url: widget.url,
              ),
            ),
          );
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
    } else {
      Dialogs.materialDialog(
          msg: 'ไม่สามารถลบได้เนื่องจากวันที่ทำงานกับวันที่สร้างไม่ตรงกัน',
          title: 'ตรวจสอบข้อมูล',
          context: context,
          actions: [
            IconsButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmployeeDetail(
                      index: 1,
                      EmpCode: widget.EmpCode,
                      EmpDetail: widget.EmpDetail,
                      url: widget.url,
                    ),
                  ),
                );
              },
              text: 'ตกลง',
              iconData: Icons.check_circle_outline,
              color: Colors.green,
              textStyle: TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ),
          ]);
    }
  }

  @override
  void initState() {
    super.initState();

    GetAPI();

    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle =
        Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 28.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'บันทึกเวลาทำงาน',
                        style: titleStyle!.copyWith(
                          fontSize: 22.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(widget.EmpCode, style: titleStyle),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('สำหรับรายวัน', style: titleStyle),
                      Text('${empdata.empName}', style: titleStyle),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 14),
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                        ),
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        label: Text('ออกจากระบบ', style: titleStyle),
                        onPressed: () {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Login(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
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
                                  borderRadius: new BorderRadius.circular(8),
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
                                        Text("รหัสพนักงาน : "),
                                        Text("ชื่อ : "),
                                        Text("แผนก : "),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("${widget.EmpDetail.empCode}"),
                                        Text("${widget.EmpDetail.empName}"),
                                        Text(
                                            "${(widget.EmpDetail.empDepartmentName) != '' ? widget.EmpDetail.empDepartmentName : '-'}"),
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
                                    (timesheetCurrent.length != 0)
                                        ? _buildTimesheetCrrent()
                                        : Center(
                                            child: Text('ไม่มีข้อมูล'),
                                          ),
                                    Column(
                                      children: [
                                        (timesheetHistory.length != 0)
                                            ? _buildTimesheetHistoly()
                                            : Center(
                                                child: Text('ไม่มีข้อมูล'),
                                              ),
                                      ],
                                    ),
                                  ],
                                )),
                          ),
                        ]))),
          ],
        ),
      ),
    );
  }

  Widget _buildTimesheetCrrent() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text('วันที่ ${FormatDateTH(GetDateTimeCurrent())}'),
        Text('รวมจำนวน ${CustomCountTime(timesheetCurrent[0].sumtimes)}'),
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
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          workdayHistory[index].isExpanded = !isExpanded;
        });
      },
      children: workdayHistory.map<ExpansionPanel>((DailyTimeSheet day) {
        return ExpansionPanel(
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ListTileTheme(
                        horizontalTitleGap: 2.0,
                        child: Text(
                          'วันที่ ${FormatDateTextTH(day.workDay!)}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            body: ListTile(
              tileColor: Colors.grey[100],
              subtitle: Column(
                children: [
                  Text('รวมจำนวน ${CustomCountTime(day.sumtimes)}'),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: timesheetHistory.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              '${ReplaceStatusTime(timesheetHistory[index].status)} : ${CustomTime(timesheetHistory[index].timeIn)} - ${CustomTime(timesheetHistory[index].timeOut)}'),
                          Text(
                              '${CustomCountTime(timesheetHistory[index].dateDiffs)}'),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            isExpanded: day.isExpanded);
      }).toList(),
    );
  }

  Widget _builddeletetimesheet(DailyTimeSheet item) {
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
                    datasavetimesheet(item);

                    // Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ]);
        },
      ),
    );
  }
}
