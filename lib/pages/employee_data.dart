import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:k2mobileapp/models/EmployeeData.dart';
import 'package:k2mobileapp/models/TimeSheetHistoryModel.dart';
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

class _MyHomePageState extends State<EmployeeDetail>
    with SingleTickerProviderStateMixin {
  List<TimeSheetHistoryModel> timesheetCurrent = [];
  List<TimeSheetHistoryModel> timesheetHistory = [];
  List<TimeSheetHistoryModel> workdayHistory = [];
  List<Employeelist> empList = [];
  late TabController _tabController;

  final _tabs = ['บันทึกเวลางาน', 'ประวัติย้อนหลัง']
      .map((item) => Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Tab(text: item),
          ))
      .toList();

  getDateTimeCurrent() {
    Duration workYesterday = const Duration(hours: 9, minutes: 00);
    DateTime now = DateTime.now();
    if ((now.hour < workYesterday.inHours) ||
        ((now.hour == workYesterday.inHours) &&
            (now.minute <= workYesterday.inMinutes.remainder(60)))) {
      now =
          DateTime(now.year, now.month, now.day).add(const Duration(days: -1));
    } else {
      now = DateTime(now.year, now.month, now.day);
    }

    return now;
  }

  formatDateTextTH(textTime) {
    DateTime valDate = DateTime.parse(textTime);
    String date = DateFormat("d MMMM yyyy", "th")
        .format(DateTime(valDate.year + 543, valDate.month, valDate.day));
    return date;
  }

  formatDateTH(validate) {
    String date = DateFormat("d MMMM yyyy", "th")
        .format(DateTime(validate.year + 543, validate.month, validate.day));
    return date;
  }

  customCountTime(text) {
    final parts = text.split(':');
    final textTime =
        '${int.parse(parts[0])} ชั่วโมง ${int.parse(parts[1])} นาที';

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
    var emp = await GetEmployeeList(widget.empCode);

    setState(() {
      timesheetCurrent = current;
      workdayHistory = history;
      timesheetHistory = history;
      empList = emp;

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
      var dateNow =
          DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(DateTime.now());

      String toText = "[";
      toText += '{';
      toText += '"emp_Code": "${timesheet.empCode}",';
      toText += '"time_In": "${timesheet.timeIn}",';
      toText += '"time_Out": "${timesheet.timeOut}",';
      toText += '"type": "Labour",';
      toText += '"supervisor_Code": "${timesheet.empCode}",';
      toText += '"status": "400",';
      toText += '"remark": "${timesheet.remark}",';
      toText += '"costCenter": "${timesheet.costCenter}",';
      toText += '"jobId": "${timesheet.jobId}",';
      toText += '"start_Date": "${timesheet.createDate}",';
      toText += '"create_By": "${timesheet.createBy}",';
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
    const borderWidth = 2.0;
    var activeTabColor = Theme.of(context).primaryColor; //Colors.grey.shade600;
    var inActiveTabColor = Colors.grey.shade200;

    return MyScaffold(
      empCode: widget.empCode,
      empName: empData.empName,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*MyButton(
            onPressed: () {},
            text: 'กลับ',
            textStyle: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white),
            leftIcon: const Icon(Icons.chevron_left, size: 16.0),
          ),*/
          ElevatedButton.icon(
            icon: const Icon(
              FontAwesomeIcons.arrowLeft,
              size: 12,
              color: Colors.black,
            ),
            label: Text(
              'กลับ',
              style: Theme.of(context).textTheme.titleSmall,
            ), //label text
            style: ElevatedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
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
          const SizedBox(height: 24),
          Container(
              // margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: Column(
                children: [
                  _buildDropdownEmp(),
                  (widget.empDetail.empDepartmentName) != ''
                      ? Text("แผนก ${widget.empDetail.empDepartmentName}",
                          style: Theme.of(context).textTheme.titleMedium!)
                      : SizedBox(
                          height: 0,
                        )
                ],
              )),
          // const SizedBox(height: 15),
          const SizedBox(height: 24),
          Container(
            height: kToolbarHeight - 16.0,
            decoration: BoxDecoration(
              color: inActiveTabColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              //padding: const EdgeInsets.only(top: 4.0),
              indicator: BoxDecoration(
                border: Border.all(color: activeTabColor, width: borderWidth),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                color: activeTabColor, //Color(0xff1a73e8),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              // Colors.black,
              tabs: _tabs,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Colors.grey.shade100,
                border: Border(
                  top: BorderSide(color: activeTabColor, width: borderWidth),
                  left: BorderSide(color: activeTabColor, width: borderWidth),
                  right: BorderSide(color: activeTabColor, width: borderWidth),
                ),
                //border: Border.all(color: Colors.grey.shade800, width: borderWidth),
              ),
              padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
              child: TabBarView(
                controller: _tabController,
                children: [
                  (timesheetCurrent.isNotEmpty)
                      ? _buildTimesheetCurrent()
                      : const Center(child: Text('ไม่มีข้อมูล')),
                  (timesheetHistory.isNotEmpty)
                      ? _buildTimesheetHistory()
                      : const Center(child: Text('ไม่มีข้อมูล')),
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
      children: [
        ExpansionPanelList(
          expandedHeaderPadding:
              const EdgeInsets.symmetric(horizontal: 2.0, vertical: 0.0),
          elevation: 0.0,
          children: [timesheetCurrent[0].lstTimesheet[0]]
              .map<ExpansionPanel>((DailyTimeSheet day) {
            return ExpansionPanel(
              backgroundColor: Colors.grey.shade200,
              isExpanded: true,
              canTapOnHeader: false,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: ListTileTheme(
                    //horizontalTitleGap: 2.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'วันที่ ${formatDateTextTH(day.workDay!)}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          'รวมเวลา ${customCountTime(day.totalsTime)}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                );
              },
              body: ListTile(
                //tileColor: Colors.grey[100],
                subtitle: Column(
                  children: [
                    //Text('รวมจำนวน ${customCountTime(day.sumtimes)}'),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: timesheetCurrent[0].lstTimesheet.length,
                      itemBuilder: (BuildContext context, int index) {
                        var dayList = timesheetCurrent[0].lstTimesheet;

                        return Container(
                          padding: const EdgeInsets.all(12.0),
                          margin: EdgeInsets.only(
                              bottom: index == dayList.length - 1 ? 12.0 : 0.0),
                          decoration: BoxDecoration(
                            //color: index % 2 == 0 ? Colors.grey.shade100 : Colors.white,
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                    width: 1.0, color: Colors.grey.shade400)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: (dayList[index].status != '301' ||
                                        dayList[index].status != '301')
                                    ? Text(
                                        '${replaceStatusTime(dayList[index].status)} : ${customTime(dayList[index].timeIn)} - ${customTime(dayList[index].timeOut)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall)
                                    : Text(
                                        '${replaceStatusTime(dayList[index].status)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                              ),
                              Expanded(
                                child: Text(
                                  '${customCountTime(dayList[index].dateDiffs)}',
                                  style: Theme.of(context).textTheme.titleSmall,
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              (timesheetCurrent[0]
                                          .lstTimesheet[index]
                                          .createBy ==
                                      widget.empCode)
                                  ? _buildDeleteTimesheet(
                                      timesheetCurrent[0].lstTimesheet[index])
                                  : SizedBox(
                                      height: 0,
                                    )
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /*Widget _buildTimesheetCurrent_old() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'วันที่ ${formatDateTH(getDateTimeCurrent())}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'รวมจำนวน ${customCountTime(timesheetCurrent[0].sumtimes)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Divider(height: 1.0, color: Colors.grey.shade400),
        ),
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
  }*/

  Widget _buildTimesheetHistory() {
    return Column(
      children: [
        ExpansionPanelList(
          expandedHeaderPadding:
              const EdgeInsets.symmetric(horizontal: 2.0, vertical: 0.0),
          elevation: 0.0,
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              workdayHistory[index].isExpanded = !isExpanded;
            });
          },
          children:
              workdayHistory.map<ExpansionPanel>((TimeSheetHistoryModel day) {
            return ExpansionPanel(
              backgroundColor: Colors.grey.shade200,
              isExpanded: day.isExpanded,
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: ListTileTheme(
                    //horizontalTitleGap: 2.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'วันที่ ${formatDateTextTH(day.workDay!)}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        (day.lstTimesheet[0].status != '301' &&
                                day.lstTimesheet[0].status != '302')
                            ? Text(
                                'รวมเวลา ${customCountTime(day.lstTimesheet[0].totalsTime)}',
                                style: Theme.of(context).textTheme.titleMedium,
                              )
                            : SizedBox(
                                height: 0,
                              ),
                      ],
                    ),
                  ),
                );
              },
              body: ListTile(
                //tileColor: Colors.grey[100],
                subtitle: Column(
                  children: [
                    //Text('รวมจำนวน ${customCountTime(day.sumtimes)}'),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: day.lstTimesheet.length,
                      itemBuilder: (BuildContext context, int index) {
                        var dayList = day.lstTimesheet;

                        return Container(
                          padding: const EdgeInsets.all(12.0),
                          margin: EdgeInsets.only(
                              bottom: index == dayList.length - 1 ? 12.0 : 0.0),
                          decoration: BoxDecoration(
                            //color: index % 2 == 0 ? Colors.grey.shade100 : Colors.white,
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                    width: 1.0, color: Colors.grey.shade400)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              (dayList[index].status != '301' &&
                                      dayList[index].status != '301')
                                  ? Text(
                                      '${replaceStatusTime(dayList[index].status)} : ${customTime(dayList[index].timeIn)} - ${customTime(dayList[index].timeOut)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall)
                                  : Text(
                                      '${replaceStatusTime(dayList[index].status)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                              (dayList[index].status != '301' &&
                                      dayList[index].status != '302')
                                  ? Text(
                                      '${customCountTime(dayList[index].dateDiffs)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    )
                                  : SizedBox(
                                      height: 0,
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDeleteTimesheet(DailyTimeSheet item) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.hardEdge,
      child: IconButton(
        icon: const Icon(Icons.delete),
        color: Colors.black87,
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

  Widget _buildDropdownEmp() {
    return DropdownButtonFormField(
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
      hint: const Text('เลือกพนักงาน'),
      value: widget.empDetail.empCode,
      icon: const Icon(Icons.keyboard_arrow_down),
      items: empList
          .map((Employeelist empdetail) => DropdownMenuItem(
                value: empdetail.empCode,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      empdetail.empCode!,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.black45,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                          ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      empdetail.empName!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ))
          .toList(),
      onChanged: (val) {
        print(val.toString());
        List<Employeelist> dropdownempList =
            empList.where((res) => res.empCode == val.toString()).toList();

        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmployeeDetail(
                index: 1,
                empCode: widget.empCode,
                empDetail: dropdownempList[0],
                url: widget.url,
              ),
            ),
          );
        });
      },
    );
  }
}
