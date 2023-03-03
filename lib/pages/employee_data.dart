import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:k2mobileapp/models/EmployeeData.dart';
import 'package:k2mobileapp/theme.dart';
import 'package:k2mobileapp/widgets/my_button.dart';
import 'package:k2mobileapp/widgets/my_scaffold.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

import '../api.dart';
import '../models/DailyTimeSheet.dart';
import '../models/EmployeeList.dart';
import 'employee_list.dart';

class EmployeeDetail extends StatefulWidget {
  final int index;
  final String empCode;
  final String url;
  final Employeelist empDetail;

  const EmployeeDetail({
    Key? key,
    required this.index,
    required this.empCode,
    required this.url,
    required this.empDetail,
  }) : super(key: key);

  @override
  State<EmployeeDetail> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<EmployeeDetail> with SingleTickerProviderStateMixin {
  List<DailyTimeSheet> timesheetCurrent = [];
  List<DailyTimeSheet> timesheetHistory = [];
  List<DailyTimeSheet> workdayHistory = [];
  late TabController _tabController;
  final _selectedColor = const Color(0xff1a73e8);
  final _tabs = [
    const Tab(text: 'บันทึกเวลางาน'),
    const Tab(text: 'ประวัติย้อนหลัง'),
  ];

  getDateTimeCurrent() {
    Duration workYesterday = const Duration(hours: 9, minutes: 00);
    DateTime now = DateTime.now();
    if ((now.hour < workYesterday.inHours) ||
        ((now.hour == workYesterday.inHours) && (now.minute <= workYesterday.inMinutes.remainder(60)))) {
      now = DateTime(now.year, now.month, now.day).add(const Duration(days: -1));
    } else {
      now = DateTime(now.year, now.month, now.day);
    }

    return now;
  }

  formatDateTextTH(textTime) {
    DateTime valDate = DateTime.parse(textTime);
    String date = DateFormat("dd MMMM yyyy", "th").format(DateTime(valDate.year + 543, valDate.month, valDate.day));
    return date;
  }

  formatDateTH(validate) {
    String date = DateFormat("dd MMMM yyyy", "th").format(DateTime(validate.year + 543, validate.month, validate.day));
    return date;
  }

  customCountTime(text) {
    final parts = text.split(':');
    final textTime = '${parts[0]} ชั่วโมง ${parts[1]} นาที';
    // DateTime valDate = DateTime.parse(textdate);

    return textTime.toString();
  }

  EmployeeData empData = EmployeeData(
    empCode: '',
    empCompName: '',
    empDepartmentName: '',
    empName: '',
    empNationality: '',
    empPositionName: '',
  );

  getAPI() async {
    var seen = <String>{};

    var current = await GetDailyTimesheet(widget.empDetail.empCode, 'CURRENT');
    var history = await GetDailyTimesheet(widget.empDetail.empCode, 'HISTORY');
    var profile = await GetEmpProfile(widget.empCode);

    setState(() {
      timesheetCurrent = current;
      workdayHistory = history.where((res) => seen.add(res.workDay!)).toList();
      timesheetHistory = history;

      empData.empCode = profile['emp_Code'];
      empData.empCompName = profile['emp_Comp_Name'];
      empData.empDepartmentName = profile['emp_Department_Name'];
      empData.empName = profile['emp_Name'];
      empData.empNationality = profile['emp_Nationality'];
      empData.empPositionName = profile['emp_Position_Name'];
    });
  }

  customTime(textTime) {
    DateTime valDate = DateTime.parse(textTime);
    String date = DateFormat("HH:mm").format(valDate);
    return date.toString();
  }

  replaceStatusTime(text) {
    var statusText = "";
    if (text == '100') {
      statusText = 'ทำงาน';
    } else if (text == '201' || text == '202') {
      statusText = 'โอที';
    } else if (text == '301') {
      statusText = 'ลาป่วย';
    } else if (text == '302') {
      statusText = 'ลาคลอด';
    } else {
      statusText = 'ขาด';
    }

    return statusText.toString();
  }

  void dataSaveTimesheet(DailyTimeSheet timesheet) async {
    const JsonDecoder decoder = JsonDecoder();
    var currentDate = getDateTimeCurrent();
    if (formatDateTH(currentDate) == formatDateTextTH(timesheet.workDay!)) {
      var dateNow = DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(DateTime.now());

      String toText = "[";
      toText += '{';
      toText += '"emp_Code": "${timesheet.empCode}",';
      toText += '"time_In": "${timesheet.timeIn}",';
      toText += '"time_Out": "${timesheet.timeOut}",';
      toText += '"type": "Labour",';
      toText += '"supervisor_Code": "${widget.empCode}",';
      toText += '"status": "400",';
      toText += '"remark": "${timesheet.remark}",';
      toText += '"costCenter": "${timesheet.costCenter}",';
      toText += '"jobId": "${timesheet.jobId}",';
      toText += '"start_Date": "$dateNow",';
      toText += '"create_By": "${widget.empCode}",';
      toText += '"project_Code": "${timesheet.projectCode}",';
      toText += '"job_Group": "${timesheet.jobGroup}",';
      toText += '"job_Code": "${timesheet.jobCode}",';
      toText += '"location_Code": "${timesheet.locationCode}"';
      toText += '}';
      toText += ']';

      var jsonText = decoder.convert(toText);
      // print(toText);
      print(json.encode(jsonText));

      final baseUrl = await SaveTimesheet();
      final res = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(jsonText),
      );

      setState(
        () {
          final parsedJson = jsonDecode(res.body);
          if (parsedJson['type'] == "S") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EmployeeDetail(
                  index: 1,
                  empCode: widget.empCode,
                  empDetail: widget.empDetail,
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
                  textStyle: const TextStyle(color: Colors.white),
                  iconColor: Colors.white,
                ),
              ],
            );
          }
        },
      );
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
                    empCode: widget.empCode,
                    empDetail: widget.empDetail,
                    url: widget.url,
                  ),
                ),
              );
            },
            text: 'ตกลง',
            iconData: Icons.check_circle_outline,
            color: Colors.green,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ],
      );
    }
  }

  @override
  void initState() {
    super.initState();

    getAPI();

    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      empCode: widget.empCode,
      empName: empData.empName,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MyButton(
            onPressed: () {},
            text: 'กลับ',
            leftIcon: const Icon(Icons.chevron_left),
          ),
          ElevatedButton.icon(
            icon: const Icon(
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: Colors.white,
              textStyle: const TextStyle(fontSize: 10),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmployeeList(
                    index: widget.index,
                    EmpCode: widget.empCode,
                    url: widget.url,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 15),
          /*Card(
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
            ),*/
          const SizedBox(height: 15),
          Container(
            height: kToolbarHeight - 8.0,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: _selectedColor),
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
                  (timesheetCurrent.isNotEmpty) ? _buildTimesheetCurrent() : const Center(child: Text('ไม่มีข้อมูล')),
                  Column(
                    children: [
                      (timesheetHistory.isNotEmpty)
                          ? _buildTimesheetHistory()
                          : const Center(child: Text('ไม่มีข้อมูล')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimesheetCurrent() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text('วันที่ ${formatDateTH(getDateTimeCurrent())}'),
        Text('รวมจำนวน ${customCountTime(timesheetCurrent[0].sumtimes)}'),
        Expanded(
          child: ListView.builder(
            itemCount: timesheetCurrent.length,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (timesheetCurrent[index].status != '301' || timesheetCurrent[index].status != '301')
                      ? Text(
                          '${replaceStatusTime(timesheetCurrent[index].status)} : ${customTime(timesheetCurrent[index].timeIn)} - ${customTime(timesheetCurrent[index].timeOut)}')
                      : Text('${replaceStatusTime(timesheetCurrent[index].status)}'),
                  Row(
                    children: [
                      const SizedBox(width: 6),
                      _buildDeleteTimesheet(timesheetCurrent[index]),
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

  Widget _buildTimesheetHistory() {
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
                          'วันที่ ${formatDateTextTH(day.workDay!)}',
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
                  Text('รวมจำนวน ${customCountTime(day.sumtimes)}'),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: timesheetHistory.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          (timesheetCurrent[index].status != '301' || timesheetCurrent[index].status != '301')
                              ? Text(
                                  '${replaceStatusTime(timesheetHistory[index].status)} : ${customTime(timesheetHistory[index].timeIn)} - ${customTime(timesheetHistory[index].timeOut)}')
                              : Text('${replaceStatusTime(timesheetHistory[index].status)}'),
                          Text('${customCountTime(timesheetHistory[index].dateDiffs)}'),
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

  Widget _buildDeleteTimesheet(DailyTimeSheet item) {
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
                textStyle: const TextStyle(color: Colors.black),
                iconColor: Colors.black,
              ),
              IconsButton(
                text: 'ใช่',
                iconData: Icons.check_circle_outline,
                color: Colors.green,
                textStyle: const TextStyle(color: Colors.white),
                iconColor: Colors.white,
                onPressed: () {
                  dataSaveTimesheet(item);

                  // Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
