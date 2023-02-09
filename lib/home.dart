import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:k2mobileapp/login.dart';
import 'package:k2mobileapp/models/DailyTimeSheet.dart';
import 'package:k2mobileapp/models/TimesheetData.dart';
import 'package:k2mobileapp/pages/employee_list.dart';
import 'package:k2mobileapp/pages/manpower_list.dart';
import 'package:k2mobileapp/pages/timesheet.dart';
import 'package:k2mobileapp/profile.dart';
import 'package:k2mobileapp/theme.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:http/http.dart' as http;

import 'models/ManpowerEmpData.dart';
import 'models/ManpowerJobDetail.dart';

class homepage extends StatefulWidget {
  final List<TimesheetData> listtimesheet;
  final int index;
  final String EmpCode;
  final String ShowPopup;
  final String url;

  const homepage(
      {Key? key,
      required this.listtimesheet,
      required this.index,
      required this.EmpCode,
      required this.ShowPopup,
      required this.url})
      : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

ThemeData appTheme = ThemeData(
  primaryColor: Color.fromRGBO(114, 41, 34, 1),
  /* Colors.tealAccent,*/
  secondaryHeaderColor: Colors.blue /* Colors.teal*/,
  fontFamily: 'Kanit',
);

int sel = 0;
List<ManpowerJobDetail> itemsList = [];
List<ManpowerEmpData> EmpList = [];

class _homepageState extends State<homepage> {
  int index = 0;
  @override
  void initState() {
    super.initState();
    GetManpowerList();
    GetManpowerEmployeeList();
    //getlsttimesheet();
    // _data = widget.listtimesheet;
    index = widget.index;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.ShowPopup == "1") {
        Dialogs.materialDialog(
            msg:
                'กรุณากรอกข้อมูลที่เป็นจริงเท่านั้น\nหากทางบริษัทตรวจสอบและพบว่า\nข้อมูลที่ท่านบันทึกในระบบเป็นเท็จ\nทางบริษัทจะมีบทลงโทษในลำดับถัดไป',
            title: 'แจ้งเตือน',
            context: context,
            actions: [
              IconsButton(
                onPressed: () async {
                  Navigator.of(context).pop();
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

  void GetManpowerList() async {
    try {
      var _baseUrl =
          "https://dev-unique.com:9012/api/Interface/RequestDailyManpower?Emp_Code=4300001";
      final res = await http.get(
        Uri.parse("$_baseUrl"),
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);

        final parsedJson = jsonDecode(res.body);

        if (parsedJson['type'] == "S") {
          List<dynamic> parsedListJson = jsonDecode(parsedJson['description']);

          setState(() {
            itemsList = List<ManpowerJobDetail>.from(
                parsedListJson.map<ManpowerJobDetail>(
                    (dynamic i) => ManpowerJobDetail.fromJson(i)));
          });
        }
      }

      /*var _baseUrl =
          "https://dev-unique.com:9012/api/Interface/GetDailyEmployee?Emp_Code=3900001";
      final res = await http.get(
        Uri.parse("$_baseUrl"),
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);

        final parsedJson = jsonDecode(res.body);

        if (parsedJson['type'] == "S") {

          List<dynamic> parsedListJson = jsonDecode(parsedJson['description']);
          List<ManpowerEmpData> itemsList = List<ManpowerEmpData>.from(
              parsedListJson.map<ManpowerEmpData>(
                  (dynamic i) => ManpowerEmpData.fromJson(i)));

        } 
      }

*/
    } catch (err) {
      print('Something went wrong');
    }
  }

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

  late TabController _tabController;

  int _selectedTab = 0;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screen = [
      ManpowerList(
        index: widget.index,
        listtimesheet: itemsList,
        listEmp: EmpList,
        EmpCode: widget.EmpCode,
        url: widget.url,
      ),
    ];

    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Tab Demo"),
      // ),
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: currentIndex,
        children: screen,
      ),
    );
  }
}
