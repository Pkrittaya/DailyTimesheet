import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:k2mobileapp/models/EmployeeData.dart';
import 'package:k2mobileapp/pages/employee_list.dart';
import 'package:k2mobileapp/widgets/my_scaffold.dart';

import '../models/ManpowerEmpData.dart';
import '../models/ManpowerJobDetail.dart';

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
  final List<ManpowerJobDetail> listtimesheet;
  final List<ManpowerEmpData> listEmp;
  final int index;
  final String EmpCode;
  final String url;

  const ManpowerList(
      {Key? key,
      required this.listtimesheet,
      required this.listEmp,
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
/*
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
*/
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

  EmployeeData empData = EmployeeData(
    empCode: '',
    empCompName: '',
    empDepartmentName: '',
    empName: '',
    empNationality: '',
    empPositionName: '',
  );

  void getEmpProfile() async {
    var client = http.Client();
    var uri = Uri.parse(
        "${widget.url}/api/Interface/GetEmployeeData?EmpCode=${widget.EmpCode}");
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      final parsedJson = jsonDecode(response.body);

      setState(() {
        empData = EmployeeData.fromJson(parsedJson);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getEmpProfile();

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
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      empCode: widget.EmpCode,
      empName: empData.empName ?? '',
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                children: [
                  const Text(
                    "ใบขอกำลังคน",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "จำนวน ${widget.listtimesheet.length} ใบ",
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                _buildListViewHomeLayout(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildListViewHomeLayout() {
    return ListView.builder(
      itemCount: widget.listtimesheet.length,
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
                    listtimesheet: widget.listEmp,
                    EmpCode: widget.EmpCode,
                    url: widget.url,
                    manpower: widget.listtimesheet[index],
                  ),
                ),
              );
            },
            title: Text(
              "เลขที่งาน ${widget.listtimesheet[index].jobNo}",
              style: TextStyle(fontSize: 18, color: Colors.green[900]),
            ),
            leading: const Icon(Icons.ballot),
          ),
        );
      },
    );
  }
}
