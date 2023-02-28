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
import '../models/EmpDailyEmployee.dart';
import '../models/EmployeeList.dart';

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

  TextEditingController timestart = TextEditingController();
  TextEditingController textempdaily = TextEditingController();
  TextEditingController editingController = TextEditingController();

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
      totext += '"emp_Code": "${empcode}",';
      totext += '"time_In": "${Datestart}",';
      totext += '"time_Out": "${DateEnd}",';
      totext += '"jobNo": "",';
      totext += '"revise_No": "",';
      totext += '"type": "Labour",';
      totext += '"supervisor_Code": "${widget.EmpCode}",';
      totext += '"location_Status": "",';
      totext += '"status": "${key}",';
      totext += '"remark": "",';
      totext += '"costCenter": "${costCenter}",';
      if (jobcode != '') {
        totext += '"jobCode": "${jobcode}",';
      }
      totext += '"start_Date": "${Datenow}",';
      totext += '"create_By": "${widget.EmpCode}"';
      totext += '}';
    });

    totext += ']';

    var tojsontext = decoder.convert(totext);
    // print(tojsontext);

    final _baseUrl = '${widget.url}/api/Interface/SaveDailyTimeSheet';
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

  void AddEmployee() async {
    await Future.delayed(Duration(milliseconds: 10));
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
                title: Center(
                  child: Text(
                    "เพิ่มพนักงาน",
                    style: Dialogs.titleStyle,
                  ),
                ),
                content: SingleChildScrollView(
                  child: Container(
                      width: MediaQuery.of(context).size.width - 10,
                      height: 500,
                      child: Column(
                        children: [
                          SizedBox(height: 8),
                          TextField(
                            controller: textempdaily,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'รหัสพนักงาน',
                            ),
                          ),
                          TextButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue[900],
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'ค้นหา',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 13.0),
                            ),
                            onPressed: () {
                              if (textempdaily.text == '') {
                                textempdaily.text = '';
                              } else {
                                setState(() {
                                  GetEmpDailyEmployeeAPI(textempdaily.text);
                                });
                              }
                            },
                          ),
                          searchempdaily
                              ? Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text('รหัสพนักงาน : '),
                                        Text('${empdaily[0].empCode}'),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('รหัสพนักงาน : '),
                                        Text('${empdaily[0].empName}'),
                                      ],
                                    ),
                                    Text(
                                        'หัวหน้างาน : ${empdaily[0].supervisorCode} ${empdaily[0].supervisorName}'),
                                    Row(
                                      children: [
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
                                            'ยกเลิก',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13.0),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                          },
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
                                            'บันทึก',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13.0),
                                          ),
                                          onPressed: () {
                                            DateTime NewDate = DateTime.now();
                                            String formattedDate =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(NewDate);

                                            dataaddemployee(
                                                '${formattedDate}',
                                                '3900001',
                                                empdaily[0].empCode,
                                                'โครงการสายสีม่วง');
                                            // setState(() {});

                                            // Navigator.of(context,
                                            //         rootNavigator: true)
                                            //     .pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : SizedBox(
                                  height: 0,
                                ),
                          !(searchempdaily)
                              ? TextButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blue[900],
                                    onPrimary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'ยกเลิก',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 13.0),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                )
                              : SizedBox(
                                  height: 0,
                                ),
                        ],
                      )),
                ));
          },
        );
      },
    );
  }

  GetAPI() async {
    itemsList = await GetEmployeeList();

    setState(() {
      _data = itemsList.where((res) => res.types == 'Main').toList();
      _dataAdd = itemsList.where((res) => res.types == 'Add').toList();

      // print(_data.length);
      // print(_dataAdd.length);
    });
  }

  GetEmpDailyEmployeeAPI(empcode) async {
    empdaily = await GetEmpDailyEmployee(empcode);
    empdaily = empdaily;
    searchempdaily = true;
    // setState(() {

    // });
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
                                Column(
                                  children: [
                                    Text(
                                      '${widget.EmpCode}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      '${empdata.empName}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    _buildaddtimesheet(),
                                    // TextButton.icon(
                                    //   style: TextButton.styleFrom(
                                    //     textStyle: TextStyle(fontSize: 14),
                                    //     padding: EdgeInsets.zero,
                                    //     alignment: Alignment.centerLeft,
                                    //     // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    //     backgroundColor: Colors.white,
                                    //   ),
                                    //   icon: Icon(
                                    //     Icons.add,
                                    //     color: Colors.black,
                                    //   ),
                                    //   label: Text('เพิ่มรายการ',
                                    //       style: TextStyle(
                                    //           color: Colors.black,
                                    //           fontFamily: Fonts.fonts)),
                                    //   onPressed: () {

                                    //   },
                                    // ),
                                  ],
                                )
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
                              children: [],
                            ),
                            const SizedBox(height: 15),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
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
                                        'เพิ่มพนักงาน',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13.0),
                                      ),
                                      onPressed: () {
                                        AddEmployee();
                                      },
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: TextField(
                                    style: TextStyle(fontSize: 12),
                                    controller: editingController,
                                    decoration: InputDecoration(
                                        // labelText: "ค้นหารหัสพนักงาน / ชื่อ",
                                        hintText: "ค้นหารหัสพนักงาน / ชื่อ",
                                        prefixIcon: Icon(
                                          Icons.search,
                                          size: 18,
                                        ),
                                        constraints: BoxConstraints(
                                          maxHeight: 30,
                                        ),
                                        contentPadding: EdgeInsets.all(5),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0)))),
                                    onChanged: (value) {
                                      // filterSearchResults(value);
                                    },
                                  ),
                                ),
                                Container(
                                  // color: Colors.blue[50],
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: CheckboxListTile(
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          contentPadding: EdgeInsets.zero,
                                          dense: true,
                                          title: Text(
                                            'เลือกพนักงานทั้งหมด',
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
                                                for (var element in _data) {
                                                  if (checkboxEmp(
                                                          element.empCode) ==
                                                      true) {
                                                    ckboxEmp
                                                        .add(element.empCode!);
                                                  }
                                                }

                                                for (var element in _dataAdd) {
                                                  if (checkboxEmp(
                                                          element.empCode) ==
                                                      true) {
                                                    ckboxEmp
                                                        .add(element.empCode!);
                                                  }
                                                }
                                              } else {
                                                valall = false;
                                                for (var element in _data) {
                                                  if (checkboxEmp(
                                                          element.empCode) ==
                                                      false) {
                                                    ckboxEmp.remove(
                                                        element.empCode!);
                                                  }
                                                }

                                                for (var element in _dataAdd) {
                                                  if (checkboxEmp(
                                                          element.empCode) ==
                                                      false) {
                                                    ckboxEmp.remove(
                                                        element.empCode!);
                                                  }
                                                }
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.topRight,
                                          child: Text(
                                            'จำนวนพนักงาน ${_data.length + _dataAdd.length} คน',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.amber[800]),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),
                                _buildEmployeeTypeMain(),
                                const SizedBox(height: 15),
                                Text('พนักงานที่เพิ่ม'),
                                const SizedBox(height: 15),
                                _buildEmployeeTypeAdd(),
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

  Widget _buildEmployeeTypeMain() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Employeelist item) {
        return ExpansionPanel(
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      title: Text(
                        '${item.empCode!} ${item.empName!}',
                        style: TextStyle(fontSize: 10),
                      ),
                      value: (ckboxEmp.length == 0)
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
                    )),
                  ],
                ),
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
                  ]),
              // isThreeLine: true,
            ),
            isExpanded:
                // checkvalueHideEmp(item.empCode!) ? item.isExpanded : false,
                false);
      }).toList(),
    );
  }

  Widget _buildEmployeeTypeAdd() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _dataAdd[index].isExpanded = !isExpanded;
        });
      },
      children: _dataAdd.map<ExpansionPanel>((Employeelist item) {
        return ExpansionPanel(
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      title: Text(
                        '${item.empCode!} ${item.empName!}',
                        style: TextStyle(fontSize: 10),
                      ),
                      value: (ckboxEmp.length == 0)
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
                    )),
                  ],
                ),
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
                  ]),
              // isThreeLine: true,
            ),
            isExpanded:
                // checkvalueHideEmp(item.empCode!) ? item.isExpanded : false,
                false);
      }).toList(),
    );
  }

  Widget _buildaddtimesheet() {
    return ElevatedButton.icon(
      onPressed: () => {
        Dialogs.materialDialog(context: context, actions: [
          Column(
            children: [
              IconsButton(
                  text: ' ทำงาน',
                  color: Color.fromARGB(255, 64, 79, 74),
                  textStyle: TextStyle(color: Colors.white),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();

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
                              backgroundColor: Dialogs.bcgColor,
                              // content: Dialogs.holder,
                              shape: Dialogs.dialogShape,
                              title: Center(
                                child: Text(
                                  "ทำงาน",
                                  style: Dialogs.titleStyle,
                                ),
                              ),
                              content: SingleChildScrollView(
                                  child: Container(
                                      width: MediaQuery.of(context).size.width -
                                          10,
                                      // height: 500,
                                      child: Column(children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                            // color:
                                            //     Colors.blue[50],
                                            border: Border.all(
                                                color: Colors.blue.shade400),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'โอทีก่อน : เวลา ',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              OutlinedButton(
                                                onPressed: () => Picker(
                                                    hideHeader: true,
                                                    cancelText: 'ยกเลิก',
                                                    confirmText: 'ตกลง',
                                                    cancelTextStyle: TextStyle(
                                                        fontFamily:
                                                            Fonts.fonts),
                                                    confirmTextStyle: TextStyle(
                                                        fontFamily:
                                                            Fonts.fonts),
                                                    adapter:
                                                        DateTimePickerAdapter(
                                                      minuteInterval: 15,
                                                      value: OTBeforeStart,
                                                      customColumnType: [3, 4],
                                                    ),
                                                    title: Text(""),
                                                    selectedTextStyle:
                                                        TextStyle(
                                                            color: Colors.blue),
                                                    onConfirm: (Picker picker,
                                                        List value) {
                                                      var result = (picker
                                                                  .adapter
                                                              as DateTimePickerAdapter)
                                                          .value;
                                                      if (result != null) {
                                                        setState(() {
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
                                              Text(
                                                ' ถึง ',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              OutlinedButton(
                                                onPressed: () =>
                                                    // showPickerDateCustom(
                                                    //     context,
                                                    //     'OTBeforeEnd'),
                                                    Picker(
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
                                                        hideHeader: true,
                                                        adapter:
                                                            DateTimePickerAdapter(
                                                          minuteInterval: 15,
                                                          value: OTBeforeEnd,
                                                          customColumnType: [
                                                            3,
                                                            4
                                                          ],
                                                        ),
                                                        title: Text(""),
                                                        selectedTextStyle:
                                                            TextStyle(
                                                                color: Colors
                                                                    .blue),
                                                        onConfirm:
                                                            (Picker picker,
                                                                List value) {
                                                          var result = (picker
                                                                      .adapter
                                                                  as DateTimePickerAdapter)
                                                              .value;
                                                          if (result != null) {
                                                            setState(() {
                                                              OTBeforeEnd =
                                                                  result;
                                                              TextOTBeforeEnd =
                                                                  '${OTBeforeEnd.hour.toString().padLeft(2, '0')}:${OTBeforeEnd.minute.toString().padLeft(2, '0')}';
                                                            });
                                                          }
                                                        }).showDialog(context),
                                                child:
                                                    Text('${TextOTBeforeEnd}'),
                                              ),
                                              Checkbox(
                                                checkColor: Colors.white,
                                                value: valall,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    valall = value!;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Container(
                                            padding: const EdgeInsets.all(5.0),
                                            decoration: BoxDecoration(
                                              // color:
                                              //     Colors.green[50],
                                              border: Border.all(
                                                  color: Colors.green.shade400),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text('ช่วงแรก : เวลา '),
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
                                                              title: Text(""),
                                                              selectedTextStyle:
                                                                  TextStyle(
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
                                                                    DefultOneEnd,
                                                                customColumnType: [
                                                                  3,
                                                                  4
                                                                ],
                                                              ),
                                                              title: Text(""),
                                                              selectedTextStyle:
                                                                  TextStyle(
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
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text('ช่วงหลัง : เวลา '),
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
                                                                    DefultTwoStart,
                                                                customColumnType: [
                                                                  3,
                                                                  4
                                                                ],
                                                              ),
                                                              title: Text(""),
                                                              selectedTextStyle:
                                                                  TextStyle(
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
                                                                    DefultTwoEnd,
                                                                customColumnType: [
                                                                  3,
                                                                  4
                                                                ],
                                                              ),
                                                              title: Text(""),
                                                              selectedTextStyle:
                                                                  TextStyle(
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
                                              ],
                                            )),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                            // color:
                                            //     Colors.yellow[50],
                                            border: Border.all(
                                                color: Colors.orange.shade400),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('โอทีหลัง : เวลา '),
                                              OutlinedButton(
                                                onPressed: () =>
                                                    // showPickerDateCustom(
                                                    //     context,
                                                    //     'OTAfterStart'),
                                                    Picker(
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
                                                        hideHeader: true,
                                                        adapter:
                                                            DateTimePickerAdapter(
                                                          minuteInterval: 15,
                                                          value: OTAfterStart,
                                                          customColumnType: [
                                                            3,
                                                            4
                                                          ],
                                                        ),
                                                        title: Text(""),
                                                        selectedTextStyle:
                                                            TextStyle(
                                                                color: Colors
                                                                    .blue),
                                                        onConfirm:
                                                            (Picker picker,
                                                                List value) {
                                                          var result = (picker
                                                                      .adapter
                                                                  as DateTimePickerAdapter)
                                                              .value;
                                                          if (result != null) {
                                                            setState(() {
                                                              OTAfterStart =
                                                                  result;
                                                              TextOTAfterStart =
                                                                  '${OTAfterStart.hour.toString().padLeft(2, '0')}:${OTAfterStart.minute.toString().padLeft(2, '0')}';
                                                            });
                                                          }
                                                        }).showDialog(context),
                                                child:
                                                    Text('${TextOTAfterStart}'),
                                              ),
                                              Text(' ถึง '),
                                              OutlinedButton(
                                                onPressed: () =>
                                                    // showPickerDateCustom(
                                                    //     context,
                                                    //     'OTAfterEnd'),
                                                    Picker(
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
                                                        hideHeader: true,
                                                        adapter:
                                                            DateTimePickerAdapter(
                                                          minuteInterval: 15,
                                                          value: OTAfterEnd,
                                                          customColumnType: [
                                                            3,
                                                            4
                                                          ],
                                                        ),
                                                        title: Text(""),
                                                        selectedTextStyle:
                                                            TextStyle(
                                                                color: Colors
                                                                    .blue),
                                                        onConfirm:
                                                            (Picker picker,
                                                                List value) {
                                                          var result = (picker
                                                                      .adapter
                                                                  as DateTimePickerAdapter)
                                                              .value;
                                                          if (result != null) {
                                                            setState(() {
                                                              OTAfterEnd =
                                                                  result;
                                                              TextOTAfterEnd =
                                                                  '${OTAfterEnd.hour.toString().padLeft(2, '0')}:${OTAfterEnd.minute.toString().padLeft(2, '0')}';
                                                            });
                                                          }
                                                        }).showDialog(context),
                                                child:
                                                    Text('${TextOTAfterEnd}'),
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
                                            iconData:
                                                Icons.check_circle_outline,
                                            color: Colors.green,
                                            textStyle:
                                                TextStyle(color: Colors.white),
                                            iconColor: Colors.white,
                                            onPressed: () {
                                              //////function check time

                                              var ckOTBefore = "";
                                              var ckOTBeforestart = "";
                                              var ckDefultOne = "";
                                              var ckDefultOnestart = "";
                                              var ckDefultTwo = "";
                                              var ckOTDefultTwostart = "";
                                              var ckOTAfter = "";
                                              var ckOTOTAfterstart = "";

                                              ///check ค่าว่าง
                                              if ((TextOTBeforeStart != "") ||
                                                  (TextOTBeforeEnd != "")) {
                                                ckOTBefore = 'YES1';

                                                if ((TextOTBeforeStart != "") &&
                                                    (TextOTBeforeEnd != "")) {
                                                  ckOTBefore = '';

                                                  ///check ห้ามน้อยกว่าเวลาเริ่ม
                                                  if (OTBeforeStart.isAfter(
                                                      OTBeforeEnd)) {
                                                    ckOTBeforestart = 'OVER1';
                                                  }
                                                }
                                              }

                                              if ((TextDefultOneStart != "") ||
                                                  (TextDefultOneEnd != "")) {
                                                ckDefultOne = 'YES2';

                                                if ((TextDefultOneStart !=
                                                        "") &&
                                                    (TextDefultOneEnd != "")) {
                                                  ckDefultOne = '';

                                                  ///check ห้ามน้อยกว่าเวลาเริ่ม
                                                  if (DefultOneStart.isAfter(
                                                      DefultOneEnd)) {
                                                    ckDefultOnestart = 'OVER2';
                                                  }
                                                }
                                              }

                                              if ((TextDefultTwoStart != "") ||
                                                  (TextDefultTwoEnd != "")) {
                                                ckDefultTwo = 'YES3';

                                                if ((TextDefultTwoStart !=
                                                        "") &&
                                                    (TextDefultTwoEnd != "")) {
                                                  ckDefultTwo = '';

                                                  ///check ห้ามน้อยกว่าเวลาเริ่ม
                                                  if (DefultTwoStart.isAfter(
                                                      DefultTwoEnd)) {
                                                    ckOTDefultTwostart =
                                                        'OVER3';
                                                  }
                                                }
                                              }

                                              if ((TextOTAfterStart != "") ||
                                                  (TextOTAfterEnd != "")) {
                                                ckOTAfter = 'YES4';

                                                if ((TextOTAfterStart != "") &&
                                                    (TextOTAfterEnd != "")) {
                                                  ckOTAfter = '';

                                                  ///check ห้ามน้อยกว่าเวลาเริ่ม
                                                  if (OTAfterStart.isAfter(
                                                      OTAfterEnd)) {
                                                    ckOTOTAfterstart = 'OVER4';
                                                  }
                                                }
                                              }

                                              if ((((ckOTBefore != "") ||
                                                          (ckDefultOne != "") ||
                                                          (ckDefultTwo != "") ||
                                                          (ckOTAfter != "")) ||
                                                      ((ckOTBeforestart != "") ||
                                                          (ckDefultOnestart !=
                                                              "") ||
                                                          (ckOTDefultTwostart !=
                                                              "") ||
                                                          (ckOTOTAfterstart !=
                                                              ""))) ||
                                                  ((TextOTBeforeStart == "") &&
                                                      (TextOTBeforeEnd == "") &&
                                                      (TextDefultOneStart ==
                                                          "") &&
                                                      (TextDefultOneEnd ==
                                                          "") &&
                                                      (TextDefultTwoStart ==
                                                          "") &&
                                                      (TextDefultTwoEnd ==
                                                          "") &&
                                                      (TextOTAfterStart ==
                                                          "") &&
                                                      (TextOTAfterEnd == ""))) {
                                                Dialogs.materialDialog(
                                                    msg:
                                                        'กรุณาตรวจสอบเวลาเริ่มต้นและเวลาสิ้นสุดให้ถูกต้อง',
                                                    title: 'ตรวจสอบข้อมูล',
                                                    context: context,
                                                    actions: [
                                                      IconsButton(
                                                        onPressed: () {
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pop();
                                                        },
                                                        text: 'ตกลง',
                                                        iconData: Icons
                                                            .check_circle_outline,
                                                        color: Colors.green,
                                                        textStyle: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        iconColor: Colors.white,
                                                      ),
                                                    ]);
                                              } else {
                                                ///check การเรียงลำดับเวลา

                                                String arrayText = "";

                                                List<DateTime> typetimestart =
                                                    [];
                                                List<DateTime> typetimeend = [];
                                                if (TextOTBeforeEnd != "") {
                                                  typetimestart
                                                      .add(OTBeforeStart);
                                                  typetimeend.add(OTBeforeEnd);

                                                  arrayText =
                                                      '{"101": ["${OTBeforeStart}", "${OTBeforeEnd}"]';
                                                }
                                                if (TextDefultOneEnd != "") {
                                                  typetimestart
                                                      .add(DefultOneStart);
                                                  typetimeend.add(DefultOneEnd);

                                                  if (arrayText == "") {
                                                    arrayText = '{';
                                                  } else {
                                                    arrayText += ',';
                                                  }
                                                  arrayText +=
                                                      '"102": ["${DefultOneStart}", "${DefultOneEnd}"]';
                                                }
                                                if (TextDefultTwoEnd != "") {
                                                  typetimestart
                                                      .add(DefultTwoStart);
                                                  typetimeend.add(DefultTwoEnd);

                                                  if (arrayText == "") {
                                                    arrayText = '{';
                                                  } else {
                                                    arrayText += ',';
                                                  }
                                                  arrayText +=
                                                      '"103": ["${DefultTwoStart}", "${DefultTwoEnd}"]';
                                                }
                                                if (TextOTAfterEnd != "") {
                                                  typetimestart
                                                      .add(OTAfterStart);
                                                  typetimeend.add(OTAfterEnd);

                                                  if (arrayText == "") {
                                                    arrayText += '{';
                                                  } else {
                                                    arrayText += ',';
                                                  }
                                                  arrayText +=
                                                      '"104": ["${OTAfterStart}", "${OTAfterEnd}"]';
                                                }

                                                arrayText += "}";

                                                var savedata = "";

                                                for (int i = 0;
                                                    i < typetimestart.length;
                                                    i++) {
                                                  if (!(i ==
                                                      (typetimestart.length -
                                                          1))) {
                                                    if (typetimeend[i].isAfter(
                                                        typetimestart[i + 1])) {
                                                      Dialogs.materialDialog(
                                                          msg:
                                                              'กรุณาตรวจสอบการเรียงลำดับเวลาให้ถูกต้อง',
                                                          title:
                                                              'ตรวจสอบข้อมูล',
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
                                                              color:
                                                                  Colors.green,
                                                              textStyle: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                              iconColor:
                                                                  Colors.white,
                                                            ),
                                                          ]);

                                                      savedata = 'NO';

                                                      break;
                                                    }
                                                  }
                                                }

                                                if (savedata == "") {
                                                  var tagsJson =
                                                      jsonDecode(arrayText);
                                                  datasavetimesheet(
                                                      arrayText, '', '', '');
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop();

                                                  // List<String>
                                                  //     tags =
                                                  //     List.from(tagsJson);
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]))),
                            );
                          },
                        );
                      },
                    );
                  }),
              IconsButton(
                text: ' ลาป่วย',
                color: Color.fromARGB(255, 103, 7, 0),
                textStyle: TextStyle(color: Colors.white),
                iconColor: Colors.white,
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
                            title: Center(
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
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('ลาทั้งวัน : เวลา '),
                                        OutlinedButton(
                                          onPressed: () {},
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
                                    child: IconsButton(
                                      onPressed: () {
                                        //////function check time

                                        String arrayText =
                                            '{"203": ["${LeavesickAllStart}", "${LeavesickAllEnd}"]}';

                                        var tagsJson = jsonDecode(arrayText);
                                        datasavetimesheet(
                                            arrayText, '', '', '');
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                      text: 'ตกลง',
                                      iconData: Icons.check_circle_outline,
                                      color: Colors.green,
                                      textStyle: TextStyle(color: Colors.white),
                                      iconColor: Colors.white,
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
                text: ' ลาคลอด',
                color: Color.fromARGB(255, 103, 7, 0),
                textStyle: TextStyle(color: Colors.white),
                iconColor: Colors.white,
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
                            title: Center(
                              child: Text(
                                "ลาไม่รับค่าจ้างทั้งวัน",
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
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('ลาทั้งวัน : เวลา '),
                                        OutlinedButton(
                                          onPressed: () {},
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
                                    child: IconsButton(
                                      onPressed: () {
                                        //////function check time

                                        String arrayText =
                                            '{"204": ["${LeaveunpaidAllStart}", "${LeaveunpaidAllEnd}"]}';

                                        var tagsJson = jsonDecode(arrayText);
                                        datasavetimesheet(
                                            arrayText, '', '', '');
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                      text: 'ตกลง',
                                      iconData: Icons.check_circle_outline,
                                      color: Colors.green,
                                      textStyle: TextStyle(color: Colors.white),
                                      iconColor: Colors.white,
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
        color: Colors.black,
      ),
      label: Text(
        'เพิ่มรายการ',
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
    );
  }
}
