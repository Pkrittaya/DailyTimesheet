import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:k2mobileapp/login.dart';
import 'package:k2mobileapp/models/EmployeeData.dart';
import 'package:k2mobileapp/pages/employee_data.dart';
import 'package:k2mobileapp/theme.dart';
import 'package:k2mobileapp/widgets/my_button.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

import '../api.dart';
import '../models/EmpDailyEmployee.dart';
import '../models/EmployeeList.dart';
import '../models/JobList.dart';
import '../models/LocationList.dart';

class EmployeeList extends StatefulWidget {
  final int index;
  final String EmpCode;
  final String url;

  const EmployeeList({
    Key? key,
    required this.index,
    required this.EmpCode,
    required this.url,
  }) : super(key: key);

  @override
  State<EmployeeList> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<EmployeeList> {
  Duration work_yesterday = Duration(hours: 9, minutes: 00);

  List<Employeelist> _data = [];
  List<Employeelist> _dataAdd = [];
  List<Employeelist> itemsList = [];
  List<EmpDailyEmployee> empdaily = [];
  List<String> ckboxEmp = [];
  List<JobMaster> jobms = [];
  List<LocationMaster> locationms = [];

  TextEditingController timestart = TextEditingController();
  TextEditingController textempdaily = TextEditingController();
  TextEditingController editingController = TextEditingController();
  TextEditingController editingRemark = TextEditingController();
  TextEditingController LeaveStartDate = TextEditingController();
  TextEditingController LeaveEndDate = TextEditingController();
  bool searchempdaily = false;
  bool valall = false;

  /// custom date

  CustomTime(texttime) {
    DateTime valDate = DateTime.parse(texttime);
    String date = DateFormat("HH:mm").format(valDate);
    return date.toString();
  }

  CustomTimeTypedate(texttime) {
    DateTime valDate = DateTime.parse(texttime);
    // String date = DateFormat("HH:mm").format(valDate);
    return valDate;
  }

  CustomCountTime(text) {
    final splitted = text.split(':');
    final texttime = '${splitted[0]} ชั่วโมง ${splitted[1]} นาที';
    // DateTime valDate = DateTime.parse(textdate);

    return texttime.toString();
  }

  FormatDate(textdate) {
    // DateTime valdate = DateTime.parse(textdate);
    String date = DateFormat("yyyy-MM-dd").format(new DateTime.now());
    return date;
  }

  ReplaceStatusTime(text) {
    var statustext = "";
    if (text == '100') {
      statustext = 'ทำงาน';
    } else if (text == '101') {
      statustext = 'โอทีก่อน';
    } else if (text == '102') {
      statustext = 'ช่วงแรก';
    } else if (text == '103') {
      statustext = 'ช่วงหลัง';
    } else if (text == '104') {
      statustext = 'โอทีหลัง';
    } else if (text == '201' ||
        text == '202' ||
        text == '203' ||
        text == '204') {
      statustext = 'ลา';
    } else {
      statustext = 'ไม่มี';
    }

    return statustext.toString();
  }

  checkboxEmp(emp) {
    final index = ckboxEmp.indexWhere((note) => note.startsWith(emp));
    if (index < 0) {
      return true;
    } else {
      return false;
    }
  }

  /// custom date end

//ทำงาน
  DateTime OTBeforeStart = DateTime.now();
  DateTime OTBeforeEnd = DateTime.now();
  DateTime DefultOneStart = DateTime.now();
  DateTime DefultOneEnd = DateTime.now();
  DateTime OTAfterStart = DateTime.now();
  DateTime OTAfterEnd = DateTime.now();

  String TextOTBeforeStart = "";
  String TextOTBeforeEnd = "";
  String TextDefultOneStart = "";
  String TextDefultOneEnd = "";
  String TextOTAfterStart = "";
  String TextOTAfterEnd = "";
  String jobdetail = "J001";
  String locationName = "L001";

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
  DateTime LeavesickAllStart = new DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day)
      .add(Duration(hours: 08, minutes: 30));

  DateTime LeavesickAllEnd = new DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day)
      .add(Duration(hours: 17, minutes: 30));

  String TextLeavesickAllStart = "08:30";
  String TextLeavesickAllEnd = "17:30";

//ลาไม่รับค่าจ้างบางช่วงเวลา
  DateTime LeaveunpaidAllStart =
      DateTime.now().subtract(Duration(hours: 08, minutes: 00));
  DateTime LeaveunpaidAllEnd =
      DateTime.now().subtract(Duration(hours: 17, minutes: 30));

  String TextLeaveunpaidAllStart = "08:00";
  String TextLeaveunpaidAllEnd = "17:30";

////////
  List<String> Hours = [];
  List<String> HoursEnd = [];
  List<String> Miniutes = <String>['00', '15', '30', '45'];
  List<String> HoursDefault = <String>[
    '00',
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23'
  ];
  List<String> HoursEndDefault = <String>[
    '00',
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24'
  ];

///// เพิ่มพนักงาน
  void dataaddemployee(
      var cycle, var supcode, var empcode, var projcode) async {
    var tojsontext = {
      "cyCleTime": "${cycle}",
      "suppervisor_Code": "${supcode}",
      "empCode": "${empcode}",
      "projectName": "${projcode}",
    };

    // var tojsontext = decoder.convert(totext);

    var res = PostTempEmployeeDaily(tojsontext);
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
  }

  void datasavetimesheet(
      var arrayText, var empcode, var costCenter, var jobcode) async {
    const JsonDecoder decoder = JsonDecoder();
    var Datenow = DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(DateTime.now());
    Map decoded = jsonDecode(arrayText);
    int i = 0;
    String chkEmp = '';

    for (var emp in ckboxEmp) {
      if (chkEmp != '')
        chkEmp = emp;
      else
        chkEmp = chkEmp + ',' + emp;
    }

    String totext = "[";

    decoded.forEach((key, value) {
      i++;
      DateTime valDatestart = DateTime.parse(value[0]);
      DateTime valDateEnd = DateTime.parse(value[1]);

      String Datestart =
          DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(valDatestart);
      String DateEnd = DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(valDateEnd);

      if (i > 1) {
        totext += ',';
      }

      totext += '{';
      totext += '"emp_Code": "${chkEmp}",';
      totext += '"time_In": "${Datestart}",';
      totext += '"time_Out": "${DateEnd}",';

      totext += '"type": "Labour",';
      totext += '"supervisor_Code": "${widget.EmpCode}",';
      totext += '"status": "${key}",';
      totext += '"remark": "${editingRemark.text}",';
      totext += '"costCenter": "${costCenter}",';
      if (jobcode != '') {
        totext += '"jobId": "${jobcode}",';
      }

      totext += '"start_Date": "${Datenow}",';
      totext += '"create_By": "${widget.EmpCode}",';
      totext += '"project_Code": "P0001",';
      totext += '"job_Group": "G001",';
      totext += '"job_Code": "${jobdetail}",';
      totext += '"location_Code": "${locationName}"';
      totext += '}';
    });

    totext += ']';
    print(totext);
    var tojsontext = decoder.convert(totext);
    // print(tojsontext);

    final _baseUrl = '${widget.url}/api/Daily/SaveDailyTimeSheet';
    final res = await http.post(Uri.parse("${_baseUrl}"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(tojsontext));

    setState(() {
      final jsonData = json.decode(res.body);
      print(res.body);

      final parsedJson = jsonDecode(res.body);
      if (parsedJson['type'] == "S") {
        Dialogs.materialDialog(
            msg: 'บันทึกข้อมูลสำเร็จ',
            title: 'ตรวจสอบข้อมูล',
            context: context,
            actions: [
              IconsButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();

                  // GetManpowerEmployeeList();
                },
                text: 'ตกลง',
                iconData: Icons.check_circle_outline,
                color: Colors.green,
                textStyle: TextStyle(color: Colors.white),
                iconColor: Colors.white,
              ),
            ]);
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

  void addEmployee() async {
    await Future.delayed(const Duration(milliseconds: 10));
    if (!mounted) return;

    searchempdaily = false;
    textempdaily = TextEditingController();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Dialogs.bcgColor,
              // content: Dialogs.holder,
              // shape: Dialogs.dialogShape,
              title: const Center(
                child: Text("เพิ่มพนักงาน", style: Dialogs.titleStyle),
              ),
              content: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width - 10,
                  maxWidth: MediaQuery.of(context).size.width - 10,
                  minHeight: 500, //MediaQuery.of(context).size.height - 250,
                  maxHeight: 500, //MediaQuery.of(context).size.height - 250,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            TextField(
                              controller: textempdaily,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'รหัสพนักงาน',
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            /* ปุ่มค้นหา */
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MyButton(
                                onPressed: () =>
                                    _handleSearchEmployee(setState),
                                text: 'ค้นหา',
                                buttonColor: Colors.blue[900]!,
                                textColor: Colors.white,
                              ),
                            ),
                            searchempdaily
                                ? Container(
                                    margin: const EdgeInsets.only(top: 16.0),
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 1.0,
                                        color: Colors.black12,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              0), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: empdaily.isEmpty
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  'ไม่พบรหัสพนักงาน ${textempdaily.text} ในฐานข้อมูล'),
                                            ],
                                          )
                                        : Column(
                                            children: [
                                              _buildSearchResultRow(
                                                'รหัสพนักงาน',
                                                '${empdaily[0].empCode}',
                                              ),
                                              _buildSearchResultRow(
                                                'ชื่อพนักงาน',
                                                '${empdaily[0].empName}',
                                              ),
                                              _buildSearchResultRow(
                                                'หัวหน้างาน',
                                                '${empdaily[0].supervisorCode} ${empdaily[0].supervisorName}',
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 16.0,
                                                      bottom: 8.0,
                                                    ),
                                                    child: MyButton(
                                                      onPressed:
                                                          _handleSaveTempDailyEmployee,
                                                      text: 'บันทึก',
                                                      buttonColor:
                                                          Colors.blue[900]!,
                                                      textColor: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                  )
                                : const SizedBox(height: 0),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: MyButton(
                        onPressed: () => Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pop(),
                        text: 'ยกเลิก',
                        buttonColor: Colors.blue[900]!,
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSearchResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        children: [
          SizedBox(
            width: 110.0,
            child: Text('$label : '),
          ),
          Text(value),
        ],
      ),
    );
  }

  void _handleSearchEmployee(Function setState) async {
    if (textempdaily.text == '') {
      textempdaily.text = '';
    } else {
      await getEmpDailyEmployeeAPI(textempdaily.text);
      setState(() {});
    }
  }

  void _handleSaveTempDailyEmployee() {
    DateTime newDate = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(newDate);

    dataaddemployee(
      formattedDate,
      '3900001',
      empdaily[0].empCode,
      'โครงการสายสีม่วง',
    );
  }

  GetAPI() async {
    itemsList = await GetEmployeeList();
    var jobmsapi = await GetJobMaster('p0001');
    var locationmsapi = await GetLocationMaster('p0001');

    //  var loc = locationms[0].locationCode!;
    //  var Job = jobms[0].jobCode!;

    // print(loc);
    //print(Job);
    setState(() {
      _data = itemsList.where((res) => res.types == 'Main').toList();
      _dataAdd = itemsList.where((res) => res.types == 'Add').toList();
      jobms = jobmsapi;
      locationms = locationmsapi;
      //locationName = locationms[0].locationCode!;
      //jobdetail = "J001";
    });
    //print(locationms[0].locationCode!);
    //
    //print(jobdetail);
  }

  getEmpDailyEmployeeAPI(empCode) async {
    empdaily = await GetEmpDailyEmployee(empCode);
    print(empdaily);
    searchempdaily = true;
  }

  @override
  void initState() {
    GetEmpProfile();

    GetAPI();

    // _data = widget.listtimesheet;
    super.initState();
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
                      _buildAddTimesheet(),
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
                    topRight: Radius.circular(20),
                  ),
                ),
                //padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MyButton(
                              onPressed: addEmployee,
                              text: 'เพิ่มพนักงาน',
                              buttonColor: Colors.blue[900]!,
                              textColor: Colors.white,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        TextField(
                          style: Theme.of(context).textTheme.titleMedium,
                          controller: editingController,
                          decoration: const InputDecoration(
                            hintText: "ค้นหารหัสพนักงาน / ชื่อ",
                            prefixIcon: Icon(
                              Icons.search,
                              size: 22,
                            ),
                            /*constraints: BoxConstraints(
                              maxHeight: 30,
                            ),*/
                            contentPadding: EdgeInsets.all(2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            // filterSearchResults(value);
                          },
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          children: [
                            Expanded(
                              child: ListTileTheme(
                                horizontalTitleGap: 2.0,
                                child: CheckboxListTile(
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  title: Text(
                                    'เลือกพนักงานทั้งหมด',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  value: valall,
                                  onChanged: (value) {
                                    setState(() {
                                      if (valall == false) {
                                        valall = true;
                                        for (var element in _data) {
                                          if (checkboxEmp(element.empCode) ==
                                              true) {
                                            ckboxEmp.add(element.empCode!);
                                          }
                                        }

                                        for (var element in _dataAdd) {
                                          if (checkboxEmp(element.empCode) ==
                                              true) {
                                            ckboxEmp.add(element.empCode!);
                                          }
                                        }
                                      } else {
                                        valall = false;
                                        for (var element in _data) {
                                          if (checkboxEmp(element.empCode) ==
                                              false) {
                                            ckboxEmp.remove(element.empCode!);
                                          }
                                        }

                                        for (var element in _dataAdd) {
                                          if (checkboxEmp(element.empCode) ==
                                              false) {
                                            ckboxEmp.remove(element.empCode!);
                                          }
                                        }
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                'จำนวนพนักงาน ${_data.length + _dataAdd.length} คน',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(color: Colors.amber[800]),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        _buildEmployeeList(_data),
                        const SizedBox(height: 24.0),
                        Text(
                          'พนักงานที่เพิ่ม',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12.0),
                        _buildEmployeeList(_dataAdd),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeList(List<Employeelist> data) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          data[index].isExpanded = !isExpanded;
        });
      },
      children: data.map<ExpansionPanel>((Employeelist item) {
        return ExpansionPanel(
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ListTileTheme(
                          horizontalTitleGap: 2.0,
                          child: CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            title: Row(
                              children: [
                                Text(
                                  item.empCode!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Colors.black45,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: GoogleFonts.jetBrainsMono()
                                            .fontFamily,
                                      ),
                                ),
                                const SizedBox(width: 8.0),
                                Text(
                                  item.empName!,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                            value: (ckboxEmp.isEmpty)
                                ? false
                                : !checkboxEmp(item.empCode!),
                            onChanged: (value) {
                              setState(() {
                                valall = false;

                                if (checkboxEmp(item.empCode!)) {
                                  ckboxEmp.add(item.empCode!);
                                } else {
                                  ckboxEmp.remove(item.empCode!);
                                }

                                print(ckboxEmp);
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmployeeDetail(
                          index: 1,
                          EmpCode: widget.EmpCode,
                          EmpDetail: item,
                          url: widget.url,
                        ),
                      ),
                    );
                  });
            },
            body: ListTile(
              tileColor: Colors.grey[100],
              subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 10),
                  ]),
              // isThreeLine: true,
            ),
            isExpanded:
                // checkvalueHideEmp(item.empCode!) ? item.isExpanded : false,
                false);
      }).toList(),
    );
  }

  Widget _buildAddTimesheet() {
    return ElevatedButton.icon(
      onPressed: () => {
        Dialogs.materialDialog(
          context: context,
          actions: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: MyButton(
                      text: 'บันทึกเวลาทำงาน',
                      textColor: Colors.white,
                      buttonColor: const Color.fromARGB(255, 64, 79, 74),
                      verticalPadding: 12.0,
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();

                        TextOTBeforeStart = "";
                        TextOTBeforeEnd = "";
                        TextDefultOneStart = "";
                        TextDefultOneEnd = "";
                        TextOTAfterStart = "";
                        TextOTAfterEnd = "";
                        showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  backgroundColor: Dialogs.bcgColor,
                                  // content: Dialogs.holder,
                                  shape: Dialogs.dialogShape,
                                  title: const Center(
                                    child: Text(
                                      "บันทึกเวลาทำงาน",
                                      style: Dialogs.titleStyle,
                                    ),
                                  ),
                                  content: SingleChildScrollView(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          10,
                                      // height: 500,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              decoration: BoxDecoration(
                                                // color:
                                                //     Colors.green[50],
                                                border: Border.all(
                                                    color:
                                                        Colors.green.shade400),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  const Text('เวลาทำงานปกติ'),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: const [
                                                      Text('เวลาเริ่มงาน'),
                                                      Text('เวลาจบงาน'),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      OutlinedButton(
                                                        onPressed: () => Picker(
                                                            cancelText:
                                                                'ยกเลิก',
                                                            confirmText: 'ตกลง',
                                                            cancelTextStyle:
                                                                TextStyle(
                                                                    fontFamily: Fonts
                                                                        .fonts),
                                                            confirmTextStyle:
                                                                TextStyle(
                                                                    fontFamily: Fonts
                                                                        .fonts),
                                                            hideHeader: true,
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
                                                            title:
                                                                const Text(""),
                                                            selectedTextStyle:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .blue),
                                                            onConfirm: (Picker
                                                                    picker,
                                                                List value) {
                                                              var result = (picker
                                                                          .adapter
                                                                      as DateTimePickerAdapter)
                                                                  .value;
                                                              if (result !=
                                                                  null) {
                                                                setState(() {
                                                                  DefultOneStart =
                                                                      result;
                                                                  TextDefultOneStart =
                                                                      '${DefultOneStart.hour.toString().padLeft(2, '0')}:${DefultOneStart.minute.toString().padLeft(2, '0')}';
                                                                });
                                                              }
                                                            }).showDialog(context),
                                                        child: Text(
                                                            TextDefultOneStart),
                                                      ),
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
                                                                cancelTextStyle:
                                                                    TextStyle(
                                                                        fontFamily:
                                                                            Fonts
                                                                                .fonts),
                                                                confirmTextStyle:
                                                                    TextStyle(
                                                                        fontFamily:
                                                                            Fonts
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
                                                                title:
                                                                    const Text(
                                                                        ""),
                                                                selectedTextStyle:
                                                                    const TextStyle(
                                                                        color: Colors
                                                                            .blue),
                                                                onConfirm: (Picker
                                                                        picker,
                                                                    List
                                                                        value) {
                                                                  var result =
                                                                      (picker.adapter
                                                                              as DateTimePickerAdapter)
                                                                          .value;
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
                                                            TextDefultOneEnd),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                          const SizedBox(height: 30),
                                          Container(
                                            padding: const EdgeInsets.all(5.0),
                                            decoration: BoxDecoration(
                                              // color:
                                              //     Colors.blue[50],
                                              border: Border.all(
                                                  color: Colors.blue.shade400),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text('เวลาทำงานล่วงเวลา'),
                                                Row(
                                                  children: const [
                                                    Text('เวลาเริ่มล่วงเวลา'),
                                                    Text('เวลาจบล่วงเวลา'),
                                                    Text('รวม/ชั่วโมง')
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    OutlinedButton(
                                                      onPressed: () => Picker(
                                                          hideHeader: true,
                                                          cancelText: 'ยกเลิก',
                                                          confirmText: 'ตกลง',
                                                          cancelTextStyle:
                                                              TextStyle(
                                                                  fontFamily:
                                                                      Fonts
                                                                          .fonts),
                                                          confirmTextStyle:
                                                              TextStyle(
                                                                  fontFamily:
                                                                      Fonts
                                                                          .fonts),
                                                          adapter:
                                                              DateTimePickerAdapter(
                                                            minuteInterval: 15,
                                                            value:
                                                                OTBeforeStart,
                                                            customColumnType: [
                                                              3,
                                                              4
                                                            ],
                                                          ),
                                                          title: const Text(""),
                                                          selectedTextStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .blue),
                                                          onConfirm:
                                                              (Picker picker,
                                                                  List value) {
                                                            var result = (picker
                                                                        .adapter
                                                                    as DateTimePickerAdapter)
                                                                .value;
                                                            if (result !=
                                                                null) {
                                                              setState(() {
                                                                OTBeforeStart =
                                                                    result;
                                                                TextOTBeforeStart =
                                                                    '${OTBeforeStart.hour.toString().padLeft(2, '0')}:${OTBeforeStart.minute.toString().padLeft(2, '0')}';
                                                              });
                                                            }
                                                          }).showDialog(context),
                                                      child: Text(
                                                          TextOTBeforeStart),
                                                    ),
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
                                                              cancelTextStyle:
                                                                  TextStyle(
                                                                      fontFamily: Fonts
                                                                          .fonts),
                                                              confirmTextStyle:
                                                                  TextStyle(
                                                                      fontFamily: Fonts
                                                                          .fonts),
                                                              hideHeader: true,
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
                                                              title: const Text(
                                                                  ""),
                                                              selectedTextStyle:
                                                                  const TextStyle(
                                                                      color: Colors
                                                                          .blue),
                                                              onConfirm: (Picker
                                                                      picker,
                                                                  List value) {
                                                                var result =
                                                                    (picker.adapter
                                                                            as DateTimePickerAdapter)
                                                                        .value;
                                                                if (result !=
                                                                    null) {
                                                                  setState(() {
                                                                    OTBeforeEnd =
                                                                        result;
                                                                    TextOTBeforeEnd =
                                                                        '${OTBeforeEnd.hour.toString().padLeft(2, '0')}:${OTBeforeEnd.minute.toString().padLeft(2, '0')}';
                                                                  });
                                                                }
                                                              }).showDialog(context),
                                                      child:
                                                          Text(TextOTBeforeEnd),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: const [
                                                    Text('เวลาเริ่มล่วงเวลา'),
                                                    Text('เวลาจบล่วงเวลา'),
                                                    Text('รวม/ชั่วโมง')
                                                  ],
                                                ),
                                                Row(
                                                  children: [
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
                                                              cancelTextStyle:
                                                                  TextStyle(
                                                                      fontFamily: Fonts
                                                                          .fonts),
                                                              confirmTextStyle:
                                                                  TextStyle(
                                                                      fontFamily: Fonts
                                                                          .fonts),
                                                              hideHeader: true,
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
                                                              title: const Text(
                                                                  ""),
                                                              selectedTextStyle:
                                                                  const TextStyle(
                                                                      color: Colors
                                                                          .blue),
                                                              onConfirm: (Picker
                                                                      picker,
                                                                  List value) {
                                                                var result =
                                                                    (picker.adapter
                                                                            as DateTimePickerAdapter)
                                                                        .value;
                                                                if (result !=
                                                                    null) {
                                                                  setState(() {
                                                                    OTAfterStart =
                                                                        result;
                                                                    TextOTAfterStart =
                                                                        '${OTAfterStart.hour.toString().padLeft(2, '0')}:${OTAfterStart.minute.toString().padLeft(2, '0')}';
                                                                  });
                                                                }
                                                              }).showDialog(context),
                                                      child: Text(
                                                          TextOTAfterStart),
                                                    ),
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
                                                              cancelTextStyle:
                                                                  TextStyle(
                                                                      fontFamily: Fonts
                                                                          .fonts),
                                                              confirmTextStyle:
                                                                  TextStyle(
                                                                      fontFamily: Fonts
                                                                          .fonts),
                                                              hideHeader: true,
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
                                                              title: const Text(
                                                                  ""),
                                                              selectedTextStyle:
                                                                  const TextStyle(
                                                                      color: Colors
                                                                          .blue),
                                                              onConfirm: (Picker
                                                                      picker,
                                                                  List value) {
                                                                var result =
                                                                    (picker.adapter
                                                                            as DateTimePickerAdapter)
                                                                        .value;
                                                                if (result !=
                                                                    null) {
                                                                  setState(() {
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
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          const Text('เนื้องาน'),
                                          DropdownButtonFormField(
                                            isExpanded: true,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                            ),
                                            hint: const Text('เลือกรายละเอียด'),
                                            // value: 'J001',
                                            icon: const Icon(
                                                Icons.keyboard_arrow_down),
                                            items: jobms
                                                .map((JobMaster jobdetailtop) =>
                                                    DropdownMenuItem(
                                                      // alignment: AlignmentDirectional.center,
                                                      value:
                                                          jobdetailtop.jobCode,
                                                      child: Text(jobdetailtop
                                                          .jobName!),
                                                    ))
                                                .toList(),
                                            onChanged: (val) {
                                              setState(() {
                                                jobdetail = val.toString();
                                              });
                                            },
                                          ),
                                          const SizedBox(height: 2),
                                          const Text('สถานที่'),
                                          DropdownButtonFormField(
                                            isExpanded: true,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                            ),
                                            hint: const Text('เลือกรายละเอียด'),
                                            //  value: locationName, //locationName,
                                            icon: const Icon(
                                                Icons.keyboard_arrow_down),
                                            items: locationms
                                                .map((LocationMaster
                                                        jobdetailtop) =>
                                                    DropdownMenuItem(
                                                      // alignment: AlignmentDirectional.center,
                                                      value: jobdetailtop
                                                          .locationCode,
                                                      child: Text(jobdetailtop
                                                          .locationName!),
                                                    ))
                                                .toList(),
                                            onChanged: (val) {
                                              setState(() {
                                                locationName = val.toString();
                                              });
                                            },
                                          ),
                                          const SizedBox(height: 20),
                                          const Text('หมายเหตุ'),
                                          TextField(
                                            style:
                                                const TextStyle(fontSize: 12),
                                            controller: editingRemark,
                                            maxLines: 5,
                                            onChanged: (value) {
                                              // filterSearchResults(value);
                                            },
                                          ),
                                          const SizedBox(height: 20),
                                          SizedBox(
                                            width: 100,
                                            child: IconsButton(
                                              text: 'ตกลง',
                                              iconData:
                                                  Icons.check_circle_outline,
                                              color: Colors.green,
                                              textStyle: TextStyle(
                                                  color: Colors.white),
                                              iconColor: Colors.white,
                                              onPressed: () {
                                                //////function check time

                                                var ckOTBefore = "";
                                                var ckOTBeforestart = "";
                                                var ckDefultOne = "";
                                                var ckDefultOnestart = "";
                                                var ckOTAfter = "";
                                                var ckOTOTAfterstart = "";

                                                ///check ค่าว่าง
                                                if ((TextOTBeforeStart != "") ||
                                                    (TextOTBeforeEnd != "")) {
                                                  ckOTBefore = 'YES1';

                                                  if ((TextOTBeforeStart !=
                                                          "") &&
                                                      (TextOTBeforeEnd != "")) {
                                                    ckOTBefore = '';

                                                    ///check ห้ามน้อยกว่าเวลาเริ่ม
                                                    if (OTBeforeStart.isAfter(
                                                        OTBeforeEnd)) {
                                                      ckOTBeforestart = 'OVER1';
                                                    }
                                                  }
                                                }

                                                if ((TextDefultOneStart !=
                                                        "") ||
                                                    (TextDefultOneEnd != "")) {
                                                  ckDefultOne = 'YES2';

                                                  if ((TextDefultOneStart !=
                                                          "") &&
                                                      (TextDefultOneEnd !=
                                                          "")) {
                                                    ckDefultOne = '';

                                                    ///check ห้ามน้อยกว่าเวลาเริ่ม
                                                    if (DefultOneStart.isAfter(
                                                        DefultOneEnd)) {
                                                      ckDefultOnestart =
                                                          'OVER2';
                                                    }
                                                  }
                                                }

                                                if ((TextOTAfterStart != "") ||
                                                    (TextOTAfterEnd != "")) {
                                                  ckOTAfter = 'YES4';

                                                  if ((TextOTAfterStart !=
                                                          "") &&
                                                      (TextOTAfterEnd != "")) {
                                                    ckOTAfter = '';

                                                    ///check ห้ามน้อยกว่าเวลาเริ่ม
                                                    if (OTAfterStart.isAfter(
                                                        OTAfterEnd)) {
                                                      ckOTOTAfterstart =
                                                          'OVER4';
                                                    }
                                                  }
                                                }

                                                if ((((ckOTBefore != "") ||
                                                            (ckDefultOne !=
                                                                "") ||
                                                            (ckOTAfter !=
                                                                "")) ||
                                                        ((ckOTBeforestart != "") ||
                                                            (ckDefultOnestart !=
                                                                "") ||
                                                            (ckOTOTAfterstart !=
                                                                ""))) ||
                                                    ((TextOTBeforeStart ==
                                                            "") &&
                                                        (TextOTBeforeEnd ==
                                                            "") &&
                                                        (TextDefultOneStart ==
                                                            "") &&
                                                        (TextDefultOneEnd ==
                                                            "") &&
                                                        (TextOTAfterStart ==
                                                            "") &&
                                                        (TextOTAfterEnd ==
                                                            ""))) {
                                                  Dialogs.materialDialog(
                                                      msg:
                                                          'กรุณาตรวจสอบเวลาเริ่มต้นและเวลาสิ้นสุดให้ถูกต้อง',
                                                      title: 'ตรวจสอบข้อมูล',
                                                      context: context,
                                                      actions: [
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
                                                          color: Colors.green,
                                                          textStyle:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                          iconColor:
                                                              Colors.white,
                                                        ),
                                                      ]);
                                                } else {
                                                  String arrayText = "";

                                                  List<DateTime> typeTimeStart =
                                                      [];
                                                  List<DateTime> typeTimeEnd =
                                                      [];
                                                  if (TextOTBeforeEnd != "") {
                                                    typeTimeStart
                                                        .add(OTBeforeStart);
                                                    typeTimeEnd
                                                        .add(OTBeforeEnd);

                                                    arrayText =
                                                        '{"201": ["$OTBeforeStart", "$OTBeforeEnd"]';
                                                  }
                                                  if (TextDefultOneEnd != "") {
                                                    typeTimeStart
                                                        .add(DefultOneStart);
                                                    typeTimeEnd
                                                        .add(DefultOneEnd);

                                                    if (arrayText == "") {
                                                      arrayText = '{';
                                                    } else {
                                                      arrayText += ',';
                                                    }
                                                    arrayText +=
                                                        '"100": ["$DefultOneStart", "$DefultOneEnd"]';
                                                  }
                                                  if (TextOTAfterEnd != "") {
                                                    typeTimeStart
                                                        .add(OTAfterStart);
                                                    typeTimeEnd.add(OTAfterEnd);

                                                    if (arrayText == "") {
                                                      arrayText += '{';
                                                    } else {
                                                      arrayText += ',';
                                                    }
                                                    arrayText +=
                                                        '"202": ["$OTAfterStart", "$OTAfterEnd"]';
                                                  }

                                                  arrayText += "}";

                                                  var tagsJson =
                                                      jsonDecode(arrayText);
                                                  datasavetimesheet(
                                                      arrayText, '', '', '');
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop();
                                                }
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: MyButton(
                      text: 'ลาป่วย',
                      textColor: Colors.white,
                      buttonColor:
                          const Color.fromARGB(255, 192, 0, 0).withOpacity(0.8),
                      verticalPadding: 12.0,
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  backgroundColor: Dialogs.bcgColor,
                                  // content: Dialogs.holder,
                                  shape: Dialogs.dialogShape,
                                  title: const Center(
                                    child: Text(
                                      "ลาป่วยทั้งวัน",
                                      style: Dialogs.titleStyle,
                                    ),
                                  ),
                                  actions: <Widget>[
                                    Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey.shade400),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('ลาทั้งวัน : เวลา '),
                                              OutlinedButton(
                                                onPressed: () {},
                                                child: Text(
                                                    '$TextLeavesickAllStart - $TextLeavesickAllEnd'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        SizedBox(
                                          width: 100,
                                          child: IconsButton(
                                            onPressed: () {
                                              //////function check time

                                              String arrayText =
                                                  '{"301": ["$LeavesickAllStart", "$LeavesickAllEnd"]}';

                                              var tagsJson =
                                                  jsonDecode(arrayText);
                                              datasavetimesheet(
                                                  arrayText, '', '', '');
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                            },
                                            text: 'ตกลง',
                                            iconData:
                                                Icons.check_circle_outline,
                                            color: Colors.green,
                                            textStyle: const TextStyle(
                                                color: Colors.white),
                                            iconColor: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: MyButton(
                      text: 'ลาคลอด',
                      textColor: Colors.white,
                      buttonColor:
                          const Color.fromARGB(255, 192, 0, 0).withOpacity(0.8),
                      verticalPadding: 12.0,
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  backgroundColor: Dialogs.bcgColor,
                                  // content: Dialogs.holder,
                                  shape: Dialogs.dialogShape,
                                  title: const Center(
                                    child: Text(
                                      "ลาไม่รับค่าจ้างทั้งวัน",
                                      style: Dialogs.titleStyle,
                                    ),
                                  ),
                                  actions: <Widget>[
                                    Column(
                                      children: [
                                        Text('วันที่เริ่มลา :'),
                                        Container(
                                          padding: const EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey.shade400),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                          ),
                                          child: SizedBox(
                                            child: TextField(
                                              style:
                                                  const TextStyle(fontSize: 12),
                                              controller: LeaveStartDate,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: "เลือกวันที่",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                suffixIcon: Align(
                                                  widthFactor: 1.0,
                                                  heightFactor: 1.0,
                                                  child: Icon(
                                                    Icons.calendar_today,
                                                  ),
                                                ),
                                              ),
                                              onTap: () async {
                                                DateTime? pickedDate =
                                                    await showDatePicker(
                                                        context: context,
                                                        locale: const Locale(
                                                            "th", "TH"),
                                                        initialDate:
                                                            new DateTime(
                                                                DateTime
                                                                            .now()
                                                                        .year +
                                                                    543,
                                                                DateTime.now()
                                                                    .month,
                                                                DateTime.now()
                                                                    .day),
                                                        firstDate:
                                                            DateTime(2500),
                                                        //DateTime.now() - not to allow to choose before today.
                                                        lastDate:
                                                            DateTime(3000));

                                                var formattedDate =
                                                    DateFormat("dd/MM/yyyy'")
                                                        .format(new DateTime(
                                                            pickedDate!.year,
                                                            pickedDate!.month,
                                                            pickedDate!.day));
                                                setState(() {
                                                  LeaveStartDate.text =
                                                      formattedDate;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text('วันที่สิ้นสุดลา :'),
                                        Container(
                                          padding: const EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey.shade400),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                          ),
                                          child: SizedBox(
                                            child: TextField(
                                              style:
                                                  const TextStyle(fontSize: 12),
                                              controller: LeaveEndDate,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: "เลือกวันที่",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                suffixIcon: Align(
                                                  widthFactor: 1.0,
                                                  heightFactor: 1.0,
                                                  child: Icon(
                                                    Icons.calendar_today,
                                                  ),
                                                ),
                                              ),
                                              onTap: () async {
                                                DateTime? pickedDate =
                                                    await showDatePicker(
                                                        context: context,
                                                        locale: const Locale(
                                                            "th", "TH"),
                                                        initialDate:
                                                            new DateTime(
                                                                DateTime
                                                                            .now()
                                                                        .year +
                                                                    543,
                                                                DateTime.now()
                                                                    .month,
                                                                DateTime.now()
                                                                    .day),
                                                        firstDate:
                                                            DateTime(2500),
                                                        //DateTime.now() - not to allow to choose before today.
                                                        lastDate:
                                                            DateTime(3000));

                                                var formattedDate =
                                                    DateFormat("dd/MM/yyyy'")
                                                        .format(new DateTime(
                                                            pickedDate!.year,
                                                            pickedDate!.month,
                                                            pickedDate!.day));
                                                setState(() {
                                                  LeaveEndDate.text =
                                                      formattedDate;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        SizedBox(
                                          width: 100,
                                          child: IconsButton(
                                            onPressed: () {
                                              //////function check time
                                              DateTime valdateStart =
                                                  DateFormat('dd/MM/yyyy')
                                                      .parse(
                                                          LeaveStartDate.text);
                                              DateTime valdateEnd =
                                                  DateFormat('dd/MM/yyyy')
                                                      .parse(LeaveEndDate.text);

                                              DateTime dtStart = new DateTime(
                                                      valdateStart.year + 543,
                                                      valdateStart.month,
                                                      valdateStart.day)
                                                  .add(new Duration(
                                                      hours: 8, minutes: 30));

                                              DateTime dtEnd = new DateTime(
                                                      valdateEnd.year + 543,
                                                      valdateEnd.month,
                                                      valdateEnd.day)
                                                  .add(new Duration(
                                                      hours: 17, minutes: 30));

                                              String arrayText =
                                                  '{"302": ["$dtStart", "$dtEnd"]}';

                                              var tagsJson =
                                                  jsonDecode(arrayText);
                                              datasavetimesheet(
                                                  arrayText, '', '', '');
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                            },
                                            text: 'ตกลง',
                                            iconData:
                                                Icons.check_circle_outline,
                                            color: Colors.green,
                                            textStyle: const TextStyle(
                                                color: Colors.white),
                                            iconColor: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
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
                  ),
                ),
              ],
            ),
          ],
        ),
      },

      icon: const Icon(
        FontAwesomeIcons.plus,
        size: 12,
        color: Colors.black,
      ),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Text(
          'เพิ่มรายการ',
          style: TextStyle(
            fontFamily: Fonts.fonts,
            color: Colors.black,
          ),
        ),
      ), //label text
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: Colors.white,
        textStyle: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }
}
