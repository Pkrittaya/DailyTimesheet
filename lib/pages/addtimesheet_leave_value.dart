import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:k2mobileapp/example/datepicker.dart';
import 'package:k2mobileapp/example/timepicker.dart';
import 'package:k2mobileapp/home.dart';
import 'package:k2mobileapp/login.dart';
import 'package:k2mobileapp/main.dart';
import 'package:intl/intl.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:k2mobileapp/models/ConfigLeaveData.dart';
import 'package:k2mobileapp/models/ConfigShift.dart';
import 'package:k2mobileapp/models/TimesheetData.dart';
import 'package:k2mobileapp/theme.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show Codec, base64, json, utf8;
import 'dart:convert';

String fonts = "Kanit";
TimesheetData timesheet = new TimesheetData();
String chkinserttime = "";
String chkinserttimetext = "";
bool _validate = false;
String titletimesheet = "";
String EmpCode = "";
ConfigShift shift = new ConfigShift();

class AddTimesheetLeaveValue extends StatefulWidget {
  final TimesheetData timesheetlist;
  final String EmpCode;
  final String url;

  const AddTimesheetLeaveValue(
      {Key? key,
      required this.timesheetlist,
      required this.EmpCode,
      required this.url})
      : super(key: key);
  @override
  State<AddTimesheetLeaveValue> createState() => _AddtimesheetLeaveState();
}

class _AddtimesheetLeaveState extends State<AddTimesheetLeaveValue> {
  int currentIndex = 0;
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final _formKey = GlobalKey<FormBuilderState>();
  bool _ageHasError = false;
  bool _genderHasError = false;
  TextEditingController timestart = TextEditingController();
  TextEditingController timeend = TextEditingController();
  TextEditingController jobdetail = TextEditingController();
  TextEditingController project = TextEditingController();
  TextEditingController jobtype = TextEditingController();
  TextEditingController remark = TextEditingController();
  TextEditingController leaveimesheet = TextEditingController();
  TextEditingController datetimesheetstart = TextEditingController();
  TextEditingController datetimesheetend = TextEditingController();
  bool isChecked = false;
  TextEditingController datestart = TextEditingController();
  TextEditingController dateend = TextEditingController();
  TextEditingController TextHours = TextEditingController();
  TextEditingController TextMinutes = TextEditingController();

  TextEditingController TextHoursEnd = TextEditingController();
  TextEditingController TextMinutesEnd = TextEditingController();

  bool viewVisible = true;
  bool viewdateVisible = true;
  String dateleave = "";
  TextEditingController txtShowLeave = TextEditingController();
  String showdate = "";
  String showtime = "";
  String leavedetail = "";
  bool buttonenabled = true;
  DateTime timenow = new DateTime.now();
  Duration work_yesterday = Duration(hours: 9, minutes: 00);

  List<String> Selectdate = <String>[
    DateFormat('dd/MM/yyyy').format(new DateTime(
            DateTime.now().year + 543, DateTime.now().month, DateTime.now().day)
        .subtract(Duration(days: 1))),
    DateFormat('dd/MM/yyyy').format(new DateTime(
        DateTime.now().year + 543, DateTime.now().month, DateTime.now().day))
  ];

  List<ConfigLeaveData> leaveOptions = [];

  bool _isChecked = true;
  String _currText = '';
  bool value = false;
  bool valueHalfBefore = false;
  bool valueHalfAfter = false;
  bool valueFullTime = false;
  List<String> text = ["InduceSmile.com", "Flutter.io", "google.com"];
  List<String> Miniutes = <String>['00', '15', '30', '45'];
  List<String> Hours = <String>[
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

  CustomTime(textdate) {
    DateTime valDate = DateTime.parse(textdate);
    String date = DateFormat("yyyy-MM-dd").format(valDate);
    return date.toString();
  }

  Customdateleave(textdate) {
    DateTime valdate = DateTime.parse(textdate);
    String date = DateFormat("dd/MM/yyyy")
        .format(new DateTime(valdate.year + 543, valdate.month, valdate.day));
    return date;
  }

  FormatDate(textdate) {
    String date = DateFormat("yyyy-MM-dd").format(textdate);
    return date;
  }

  FormatDateShow(textdate) {
    String date = DateFormat("dd/MM/yyyy").format(
        new DateTime(textdate.year + 543, textdate.month, textdate.day));
    return date;
  }

  FormatSendDate(textdate) {
    DateTime valdate = DateFormat('dd/MM/yyyy').parse(textdate);
    String date = DateFormat("yyyy-MM-dd'")
        .format(new DateTime(valdate.year - 543, valdate.month, valdate.day));
    return date;
  }

  void datasavetimesheet(var StartForm, var EndForm) async {
    String senddatetimesheetstart = "";
    String senddatetimesheetend = "";
    String senddateleave = "";

    if (timesheet.jobCode == null) {
      senddatetimesheetstart = FormatSendDate(showdate);
      // senddatetimesheetstart = FormatSendDate(datetimesheetstart.text);
      // senddatetimesheetend = FormatSendDate(datetimesheetend.text);
      senddateleave = "";
    } else {
      senddatetimesheetstart = "";
      senddatetimesheetend = "";
      senddateleave = FormatSendDate(dateleave);
    }

    var tojsontext = {
      "emp_Code": "${widget.EmpCode}",
      "timesheetDate": "${senddatetimesheetstart}",
      "timesheetEndDate": "${senddatetimesheetstart}",
      "in_Time": "${StartForm}",
      "out_Time": "${EndForm}",
      "status": "5",
      "remark": "",
      "project_Name": "${leavedetail}",
      "job_Detail": "${leavedetail}",
      "docType": "Timesheet"
    };

    var tojsontextEdit = {
      "emp_Code": "${widget.EmpCode}",
      "timesheetDate": "${senddateleave}",
      "in_Time": "${StartForm}",
      "out_Time": "${EndForm}",
      "status": "5",
      "remark": "",
      "project_Name": "${leavedetail}",
      "job_Detail": "${leavedetail}",
      "docType": "Timesheet",
      "job_Code": "${timesheet.jobCode}"
    };

    if (timesheet.jobCode == null) {
      tojsontext = tojsontext;
    } else {
      tojsontext = tojsontextEdit;
    }

    final _baseUrl = '${widget.url}/api/Interface/GetPostTimesheet';
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
            title: 'บันทึกข้อมูล',
            context: context,
            actions: [
              IconsButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  getlsttimesheet();
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
      print(parsedJson['description']);
      // remark.text = parsedJson['type'];
      // remark.text = parsedJson['description'];
      // _posts = jsonData["tasks"];
    });
  }

  void getlsttimesheet() async {
    var client = http.Client();
    DateTime NewDate = DateTime.now();
    if (NewDate.hour < work_yesterday.inHours) {
      NewDate = DateTime.now().add(new Duration(days: -1));
    } else {
      NewDate = DateTime.now();
    }

    String formattedDate = DateFormat('yyyy-MM-dd').format(NewDate);
    // String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
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

  void findlsttimesheet() async {
    var client = http.Client();
    DateTime NewDate = DateTime.now();

    //Duration work_yesterday = Duration(hours: 9, minutes: 00);

    if (NewDate.hour < 9) {
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

      var leavestatus = TestAuto.firstWhere((element) => element.status == '5');
      setState(() {
        if (leavestatus != null) {
          buttonenabled = false;
        } else {
          buttonenabled = true;
        }
      });

      // String message = parsed['status'];
      //   print(parsed['status']);
    }
  }

  void GetConfig_Shift() async {
    var client = http.Client();
    var uri = Uri.parse(
        "${widget.url}/api/Interface/GetConfig_Shift?Emp_Code=${widget.EmpCode}");
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(response.body);

      final parsedJson = jsonDecode(response.body);

      setState(() {
        shift.startHalftBefore = parsedJson['startHalftBefore'];
        shift.endHalftBefore = parsedJson['endHalftBefore'];
        shift.startHalftAfter = parsedJson['startHalftAfter'];
        shift.endHalftAfter = parsedJson['endHalftAfter'];

        if (valueHalfBefore) {
          timestart.text = parsedJson['startHalftBefore']
              .toString(); //TestAuto[0].startHalftBefore!;
          timeend.text = parsedJson['endHalftBefore']
              .toString(); //TestAuto[0].endHalftBefore!;
        } else if (valueHalfAfter) {
          timestart.text = parsedJson['startHalftAfter'].toString();
          timeend.text = parsedJson['endHalftAfter'].toString();
          //  timestart.text = TestAuto[0].startHalftAfter!;
          //  timeend.text = TestAuto[0].endHalftAfter!;
        } else if (valueFullTime) {
          timestart.text = parsedJson['startHalftBefore'].toString();
          timeend.text = parsedJson['endHalftAfter'].toString();
          //timestart.text = TestAuto[0].startHalftBefore!;
          //  timeend.text = TestAuto[0].endHalftAfter!;
        }
      });
    }
  }

  void getDropDownLeave() async {
    var client = http.Client();

    var uri = Uri.parse("${widget.url}/api/Interface/GetListConfigLeave");

    var response = await client.get(uri);

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

      List<ConfigLeaveData> DropDownLeave = parsed
          .map<ConfigLeaveData>((json) => ConfigLeaveData.fromJson(json))
          .toList();

      // _data = TestAuto;

      setState(() {
        leaveOptions = DropDownLeave;
        if (timesheet.jobCode != null) {
          titletimesheet = "แก้ไขเวลาลา";
          viewVisible = false;
          viewdateVisible = true;
          dateleave = Customdateleave(timesheet.timesheetDate);
        } else {
          titletimesheet = "บันทึกเวลาลา";
          viewVisible = true;
          viewdateVisible = false;
          dateleave = "";
        }

        if (timesheet.timesheetDate == null) {
          // showdate = FormatDateShow(DateTime.now());
          if (timenow.hour < work_yesterday.inHours ||
              (work_yesterday.inHours == timenow.hour &&
                  timenow.minute < work_yesterday.inMinutes.remainder(60))) {
            showdate = Selectdate[0].toString();
          } else {
            showdate = Selectdate[1].toString();
          }
        } else {
          showdate = Customdateleave(timesheet.timesheetDate);
        }

        if (timesheet.projectName == null) {
          leaveimesheet.text = leaveOptions[0].configName!;
        } else {
          leaveimesheet.text = '${timesheet.projectName}';
        }

        if (timesheet.inTime == null) {
          timestart.text = '';
          TextHours.text = "00";
          TextMinutes.text = "00";
        } else {
          timestart.text = '${timesheet.inTime}';
          TextHours.text = timesheet.inTime!.split(":")[0];
          TextMinutes.text = timesheet.inTime!.split(":")[1];
          ;
        }

        if (timesheet.outTime == null) {
          timeend.text = '';
          TextHoursEnd.text = "00";
          TextMinutesEnd.text = "00";
        } else {
          timeend.text = '${timesheet.outTime}';

          TextHoursEnd.text = timesheet.outTime!.split(":")[0];
          TextMinutesEnd.text = timesheet.outTime!.split(":")[1];
        }

        if (timesheet.inTime == null && timesheet.outTime == null) {
          showtime = '';
        } else {
          showtime = ' เวลา ${timesheet.outTime} - ${timesheet.outTime}';
        }
      });
    }
  }

  // String? _selectedTime;
  // Future<void> _show() async {
  //   final TimeOfDay? result = await showTimePicker(
  //       context: context,
  //       initialTime: TimeOfDay.now(),
  //       builder: (context, child) {
  //         return MediaQuery(
  //             data: MediaQuery.of(context).copyWith(
  //                 // Using 12-Hour format
  //                 alwaysUse24HourFormat: true),
  //             // If you want 24-Hour format, just change alwaysUse24HourFormat to true
  //             child: child!);
  //       });
  //   if (result != null) {
  //     setState(() {
  //       _selectedTime = result.format(context);
  //     });
  //   }
  // }

  @override
  void initState() {
    getDropDownLeave();
    GetConfig_Shift();
    findlsttimesheet();
    super.initState();
    timesheet = widget.timesheetlist;
    EmpCode = widget.EmpCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
        child: Text("การบันทึกเวลาปฏิบัติงาน"),
      )),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Color.fromARGB(255, 201, 115, 2),
          Color.fromARGB(255, 224, 215, 204),
          Color.fromARGB(255, 244, 243, 242),
          Color.fromARGB(255, 255, 255, 255),
          Color.fromARGB(255, 255, 255, 255),
        ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${titletimesheet}',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  Text(
                    'วันที่ ${showdate} ${showtime}',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
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
                padding: const EdgeInsets.all(30),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 105,
                              width: 200,
                              child: ElevatedButton(
                                child: Column(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.clock,
                                      size: 30,
                                      // color: Colors.white,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'ลาเต็มวัน',
                                      style: TextStyle(
                                          // color: Colors.white,
                                          fontFamily: Fonts.fonts,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                onPressed: buttonenabled
                                    ? () {
                                        Dialogs.materialDialog(
                                            msg:
                                                'วันนี้ท่านลาเต็มวันใช่หรือไม่?',
                                            title: 'ยืนยันบันทึกข้อมูล',
                                            context: context,
                                            actions: [
                                              IconsOutlineButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                text: 'ไม่',
                                                iconData: Icons.cancel_outlined,
                                                color: Colors.white,
                                                textStyle: TextStyle(
                                                    color: Colors.black),
                                                iconColor: Colors.black,
                                              ),
                                              IconsButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  timenow = new DateTime.now();
                                                  leavedetail = 'ลาเต็มวัน';

                                                  if ((showdate ==
                                                          Selectdate[1]
                                                              .toString()) ||
                                                      ((showdate ==
                                                              Selectdate[1]
                                                                  .toString()) ||
                                                          (timenow.hour <
                                                                  work_yesterday
                                                                      .inHours ||
                                                              (work_yesterday
                                                                          .inHours ==
                                                                      timenow
                                                                          .hour &&
                                                                  timenow.minute <
                                                                      work_yesterday
                                                                          .inMinutes
                                                                          .remainder(
                                                                              60))))) {
                                                    datasavetimesheet(
                                                        shift.startHalftBefore,
                                                        shift.endHalftAfter);
                                                  } else {
                                                    Dialogs.materialDialog(
                                                        msg:
                                                            'ไม่สามารถบันทึกข้อมูลได้เนื่องจากเกินเวลาที่กำหนด คือ เวลา ${work_yesterday.inHours.toString().padLeft(2, '0')}:${work_yesterday.inMinutes.remainder(60).toString().padLeft(2, '0')} น.',
                                                        title: 'ตรวจสอบข้อมูล',
                                                        context: context,
                                                        actions: [
                                                          IconsOutlineButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            text: 'ยกเลิก',
                                                            iconData: Icons
                                                                .check_circle_outline,
                                                            color: Colors.white,
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                            iconColor:
                                                                Colors.black,
                                                          ),
                                                          IconsButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            text: 'ตกลง',
                                                            iconData: Icons
                                                                .check_circle_outline,
                                                            color: Colors.green,
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                            iconColor:
                                                                Colors.white,
                                                          ),
                                                        ]);
                                                  }
                                                },
                                                text: 'ใช่',
                                                iconData:
                                                    Icons.check_circle_outline,
                                                color: Colors.green,
                                                textStyle: TextStyle(
                                                    color: Colors.white),
                                                iconColor: Colors.white,
                                              ),
                                            ]);
                                        //Event
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  onPrimary: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 20),
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  side: BorderSide(
                                    width: 3.0,
                                    color: Colors.blue,
                                  ),
                                  elevation: 8,
                                ),
                              ),
                            ),
                          ]),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 105,
                            width: 200,
                            child: ElevatedButton(
                              child: Column(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.sun,
                                    size: 30,
                                    // color: Colors.white,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'ลาครึ่งวันเช้า',
                                    style: TextStyle(
                                        // color: Colors.white,
                                        fontFamily: Fonts.fonts,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              onPressed: buttonenabled
                                  ? () {
                                      Dialogs.materialDialog(
                                          msg:
                                              'วันนี้ท่านลาเวลา ${shift.startHalftBefore} - ${shift.endHalftBefore} น. ใช่หรือไม่?',
                                          title: 'ยืนยันบันทึกข้อมูล',
                                          context: context,
                                          actions: [
                                            IconsOutlineButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              text: 'ไม่',
                                              iconData: Icons.cancel_outlined,
                                              color: Colors.white,
                                              textStyle: TextStyle(
                                                  color: Colors.black),
                                              iconColor: Colors.black,
                                            ),
                                            IconsButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                timenow = new DateTime.now();
                                                leavedetail = 'ลาครึ่งวันเช้า';

                                                if ((showdate ==
                                                        Selectdate[1]
                                                            .toString()) ||
                                                    ((showdate ==
                                                            Selectdate[1]
                                                                .toString()) ||
                                                        (timenow.hour <
                                                                work_yesterday
                                                                    .inHours ||
                                                            (work_yesterday
                                                                        .inHours ==
                                                                    timenow
                                                                        .hour &&
                                                                timenow.minute <
                                                                    work_yesterday
                                                                        .inMinutes
                                                                        .remainder(
                                                                            60))))) {
                                                  datasavetimesheet(
                                                      shift.startHalftBefore,
                                                      shift.endHalftBefore);
                                                } else {
                                                  Dialogs.materialDialog(
                                                      msg:
                                                          'ไม่สามารถบันทึกข้อมูลได้เนื่องจากเกินเวลาที่กำหนด คือ เวลา ${work_yesterday.inHours.toString().padLeft(2, '0')}:${work_yesterday.inMinutes.remainder(60).toString().padLeft(2, '0')} น.',
                                                      title: 'ตรวจสอบข้อมูล',
                                                      context: context,
                                                      actions: [
                                                        IconsOutlineButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          text: 'ยกเลิก',
                                                          iconData: Icons
                                                              .check_circle_outline,
                                                          color: Colors.white,
                                                          textStyle: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                          iconColor:
                                                              Colors.black,
                                                        ),
                                                        IconsButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          text: 'ตกลง',
                                                          iconData: Icons
                                                              .check_circle_outline,
                                                          color: Colors.green,
                                                          textStyle: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          iconColor:
                                                              Colors.white,
                                                        ),
                                                      ]);
                                                }
                                              },
                                              text: 'ใช่',
                                              iconData:
                                                  Icons.check_circle_outline,
                                              color: Colors.green,
                                              textStyle: TextStyle(
                                                  color: Colors.white),
                                              iconColor: Colors.white,
                                            ),
                                          ]);
                                      //Event
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                onPrimary: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                textStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                side: BorderSide(
                                  width: 3.0,
                                  color: Colors.green,
                                ),
                                elevation: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 105,
                              width: 200,
                              child: ElevatedButton(
                                child: Column(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.cloudSun,
                                      size: 30,
                                      // color: Colors.white,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'ลาครึ่งวันบ่าย',
                                      style: TextStyle(
                                          // color: Colors.white,
                                          fontFamily: Fonts.fonts,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                onPressed: buttonenabled
                                    ? () {
                                        Dialogs.materialDialog(
                                            msg:
                                                'วันนี้ท่านลาเวลา ${shift.startHalftAfter} - ${shift.endHalftAfter} น. ใช่หรือไม่?',
                                            title: 'ยืนยันบันทึกข้อมูล',
                                            context: context,
                                            actions: [
                                              IconsOutlineButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                text: 'ไม่',
                                                iconData: Icons.cancel_outlined,
                                                color: Colors.white,
                                                textStyle: TextStyle(
                                                    color: Colors.black),
                                                iconColor: Colors.black,
                                              ),
                                              IconsButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  timenow = new DateTime.now();
                                                  leavedetail =
                                                      'ลาครึ่งวันบ่าย';

                                                  if ((showdate ==
                                                          Selectdate[1]
                                                              .toString()) ||
                                                      ((showdate ==
                                                              Selectdate[1]
                                                                  .toString()) ||
                                                          (timenow.hour <
                                                                  work_yesterday
                                                                      .inHours ||
                                                              (work_yesterday
                                                                          .inHours ==
                                                                      timenow
                                                                          .hour &&
                                                                  timenow.minute <
                                                                      work_yesterday
                                                                          .inMinutes
                                                                          .remainder(
                                                                              60))))) {
                                                    datasavetimesheet(
                                                        shift.startHalftAfter,
                                                        shift.endHalftAfter);
                                                  } else {
                                                    Dialogs.materialDialog(
                                                        msg:
                                                            'ไม่สามารถบันทึกข้อมูลได้เนื่องจากเกินเวลาที่กำหนด คือ เวลา ${work_yesterday.inHours.toString().padLeft(2, '0')}:${work_yesterday.inMinutes.remainder(60).toString().padLeft(2, '0')} น.',
                                                        title: 'ตรวจสอบข้อมูล',
                                                        context: context,
                                                        actions: [
                                                          IconsOutlineButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            text: 'ยกเลิก',
                                                            iconData: Icons
                                                                .check_circle_outline,
                                                            color: Colors.white,
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                            iconColor:
                                                                Colors.black,
                                                          ),
                                                          IconsButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            text: 'ตกลง',
                                                            iconData: Icons
                                                                .check_circle_outline,
                                                            color: Colors.green,
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                            iconColor:
                                                                Colors.white,
                                                          ),
                                                        ]);
                                                  }
                                                },
                                                text: 'ใช่',
                                                iconData:
                                                    Icons.check_circle_outline,
                                                color: Colors.green,
                                                textStyle: TextStyle(
                                                    color: Colors.white),
                                                iconColor: Colors.white,
                                              ),
                                            ]);
                                        //Event
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  onPrimary: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 20),
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  side: BorderSide(
                                    width: 3.0,
                                    color: Colors.amber,
                                  ),
                                  elevation: 8,
                                ),
                              ),
                            ),
                          ]),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 105,
                            width: 200,
                            child: ElevatedButton(
                              child: Column(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.calendarPlus,
                                    size: 30,
                                    // color: Colors.white,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'ลารายชั่วโมง',
                                    style: TextStyle(
                                        // color: Colors.black,
                                        fontFamily: Fonts.fonts,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              onPressed: buttonenabled
                                  ? () {
                                      Dialogs.materialDialog(
                                          // msg: 'เลือกประเภทบันทึกเวลาทำงาน',
                                          title: 'เลือกเวลาที่ต้องการลา',
                                          context: context,
                                          actions: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text('เวลาเริ่ม'),
                                                    SizedBox(
                                                      width: 150,
                                                      child: TextField(
                                                        controller: timestart,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          errorText: _validate
                                                              ? 'กรุณากรอกข้อมูล'
                                                              : null,
                                                          // icon: Icon(Icons.calendar_today),
                                                          hintText: "เลือกเวลา",
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                          suffixIcon: Align(
                                                            widthFactor: 1.0,
                                                            heightFactor: 1.0,
                                                            child: Icon(
                                                              FontAwesomeIcons
                                                                  .clock,
                                                              size: 20,
                                                            ),
                                                          ),
                                                        ),
                                                        readOnly: true,
                                                        onTap: () async {
                                                          Dialogs.materialDialog(
                                                              title:
                                                                  'เพิ่มเวลา',
                                                              context: context,
                                                              actions: [
                                                                Column(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                          margin:
                                                                              const EdgeInsets.all(2.0),
                                                                          width:
                                                                              100.0,
                                                                          height:
                                                                              60.0,
                                                                          child:
                                                                              DropdownButtonFormField(
                                                                            // hint: const Text(''),
                                                                            decoration:
                                                                                InputDecoration(
                                                                              border: OutlineInputBorder(),

                                                                              //errorText: _validate
                                                                              //    ? 'กรุณากรอกข้อมูล'
                                                                              //    : null,
                                                                            ),
                                                                            value:
                                                                                TextHours.text,
                                                                            icon:
                                                                                const Icon(Icons.keyboard_arrow_down),
                                                                            items: Hours.map((String jobtypeop) =>
                                                                                DropdownMenuItem(
                                                                                  // alignment: AlignmentDirectional.center,
                                                                                  value: jobtypeop,
                                                                                  child: Text(jobtypeop),
                                                                                )).toList(),
                                                                            onChanged:
                                                                                (val) {
                                                                              setState(() {
                                                                                TextHours.text = val.toString();
                                                                                print(val);
                                                                                //  getDropDowncallbackJobType();
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          margin:
                                                                              const EdgeInsets.all(2.0),
                                                                          // color: Colors.amber[600],
                                                                          width:
                                                                              100.0,
                                                                          height:
                                                                              60.0,
                                                                          child:
                                                                              DropdownButtonFormField(
                                                                            hint:
                                                                                const Text('เลือกเวลา'),
                                                                            decoration:
                                                                                InputDecoration(
                                                                              border: OutlineInputBorder(),
                                                                              errorText: _validate ? 'กรุณากรอกข้อมูล' : null,
                                                                            ),
                                                                            value:
                                                                                TextMinutes.text,
                                                                            icon:
                                                                                const Icon(Icons.keyboard_arrow_down),
                                                                            items: Miniutes.map((String jobtypeop) =>
                                                                                DropdownMenuItem(
                                                                                  // alignment: AlignmentDirectional.center,
                                                                                  value: jobtypeop,
                                                                                  child: Text(jobtypeop),
                                                                                )).toList(),
                                                                            onChanged:
                                                                                (val) {
                                                                              setState(() {
                                                                                TextMinutes.text = val.toString();
                                                                              });
                                                                            },
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Container(
                                                                          margin:
                                                                              const EdgeInsets.all(1.0),
                                                                          // color: Colors.amber[600],
                                                                          width:
                                                                              100.0,
                                                                          height:
                                                                              48.0,
                                                                          child:
                                                                              Text('ชั่วโมง'),
                                                                        ),
                                                                        Container(
                                                                          margin:
                                                                              const EdgeInsets.all(1.0),
                                                                          // color: Colors.amber[600],
                                                                          width:
                                                                              100.0,
                                                                          height:
                                                                              48.0,
                                                                          child:
                                                                              Text('นาที'),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Text(''),
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              130.0,
                                                                          height:
                                                                              40.0,
                                                                          child:
                                                                              IconsOutlineButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            text:
                                                                                'ยกเลิก',
                                                                            iconData:
                                                                                Icons.cancel_outlined,
                                                                            color:
                                                                                Colors.white,
                                                                            textStyle:
                                                                                TextStyle(color: Colors.black),
                                                                            iconColor:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                            '  '),
                                                                        Container(
                                                                          width:
                                                                              130.0,
                                                                          height:
                                                                              40.0,
                                                                          child: IconsButton(
                                                                              onPressed: () {
                                                                                if (TextHours.text.isNotEmpty && TextMinutes.text.isNotEmpty) {
                                                                                  {
                                                                                    Navigator.of(context).pop();

                                                                                    if (int.parse(TextHours.text) < 8 || (8 == int.parse(TextHours.text) && int.parse(TextMinutes.text) < 30)) {
                                                                                      Dialogs.materialDialog(msg: 'เวลาเริ่มงาน คือ เวลา 08:30 น. ท่านต้องการลาเวลา ${TextHours.text + ':' + TextMinutes.text} น. ใช่หรือไม่?', title: 'ตรวจสอบข้อมูล', context: context, actions: [
                                                                                        IconsButton(
                                                                                          onPressed: () {
                                                                                            Navigator.of(context).pop();

                                                                                            timestart.text = '';
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

                                                                                            timestart.text = '${TextHours.text}:${TextMinutes.text}';
                                                                                          },
                                                                                          text: 'ใช่',
                                                                                          iconData: Icons.check_circle_outline,
                                                                                          color: Colors.green,
                                                                                          textStyle: TextStyle(color: Colors.white),
                                                                                          iconColor: Colors.white,
                                                                                        ),
                                                                                      ]);
                                                                                      //Show Alert
                                                                                    } else {
                                                                                      setState(() {
                                                                                        print(TextHours.text);
                                                                                        timestart.text = '${TextHours.text}:${TextMinutes.text}';
                                                                                        timeend.text = "";
                                                                                      });
                                                                                    }
                                                                                  }
                                                                                }
                                                                              },
                                                                              text: 'ตกลง',
                                                                              iconData: Icons.check_circle_outline,
                                                                              color: Colors.green,
                                                                              textStyle: TextStyle(color: Colors.white),
                                                                              iconColor: Colors.white,
                                                                              padding: const EdgeInsets.all(4)),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ]);
                                                          /*
                                                    final TimeOfDay? result =
                                                        await showTimePicker(
                                                            context: context,
                                                            initialTime: timestart
                                                                    .text
                                                                    .isEmpty
                                                                ? TimeOfDay
                                                                    .now()
                                                                : TimeOfDay(
                                                                    hour: int.parse(timestart
                                                                        .text
                                                                        .split(':')[
                                                                            0]
                                                                        .toString()),
                                                                    minute: int.parse(timestart
                                                                        .text
                                                                        .split(':')[
                                                                            1]
                                                                        .toString())),
                                                            builder: (context,
                                                                child) {
                                                              return MediaQuery(
                                                                  data: MediaQuery.of(
                                                                          context)
                                                                      .copyWith(
                                                                          // Using 12-Hour format
                                                                          alwaysUse24HourFormat:
                                                                              true),
                                                                  // If you want 24-Hour format, just change alwaysUse24HourFormat to true
                                                                  child:
                                                                      child!);
                                                            });
                                                    if (result != null) {
                                                      // context = CustomTime(context);

                                                      setState(() {
                                                        if (result.hour < 8 ||
                                                            (8 == result.hour &&
                                                                result.minute <
                                                                    30)) {
                                                          Dialogs.materialDialog(
                                                              msg:
                                                                  'เวลาเริ่มงาน คือ เวลา 08.30 น. ลาเวลา ${result.hour.toString().padLeft(2, '0') + ':' + result.minute.toString().padLeft(2, '0')} น. ใช่หรือไม่',
                                                              title:
                                                                  'ตรวจสอบข้อมูล',
                                                              context: context,
                                                              actions: [
                                                                IconsButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
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
                                                                IconsOutlineButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    timestart
                                                                        .text = "";
                                                                  },
                                                                  text:
                                                                      'ยกเลิก',
                                                                  iconData: Icons
                                                                      .check_circle_outline,
                                                                  color: Colors
                                                                      .white,
                                                                  textStyle: TextStyle(
                                                                      color: Colors
                                                                          .grey),
                                                                  iconColor:
                                                                      Colors
                                                                          .grey,
                                                                ),
                                                              ]);
                                                          //Show Alert
                                                        }

                                                        timestart.text = result
                                                                .hour
                                                                .toString()
                                                                .padLeft(
                                                                    2, '0') +
                                                            ':' +
                                                            result.minute
                                                                .toString()
                                                                .padLeft(
                                                                    2, '0');
                                                      });
                                                    } */
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(width: 10),
                                                Text('ถึง'),
                                                const SizedBox(width: 10),
                                                Column(
                                                  children: [
                                                    Text('เวลาสิ้นสุด'),
                                                    SizedBox(
                                                      width: 150,
                                                      child: TextField(
                                                        controller: timeend,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          errorText: _validate
                                                              ? 'กรุณากรอกข้อมูล'
                                                              : null,
                                                          // icon: Icon(Icons.calendar_today),
                                                          hintText: "เลือกเวลา",
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                          suffixIcon: Align(
                                                            widthFactor: 1.0,
                                                            heightFactor: 1.0,
                                                            child: Icon(
                                                              FontAwesomeIcons
                                                                  .clock,
                                                              size: 20,
                                                            ),
                                                          ),
                                                        ),
                                                        readOnly: true,
                                                        onTap: () async {
                                                          Dialogs.materialDialog(
                                                              title:
                                                                  'เพิ่มเวลา',
                                                              context: context,
                                                              actions: [
                                                                Column(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                          margin:
                                                                              const EdgeInsets.all(2.0),
                                                                          // color: Colors.amber[600],
                                                                          width:
                                                                              100.0,
                                                                          height:
                                                                              60.0,
                                                                          child:
                                                                              DropdownButtonFormField(
                                                                            // hint: const Text(''),
                                                                            decoration:
                                                                                InputDecoration(
                                                                              border: OutlineInputBorder(),

                                                                              //errorText: _validate
                                                                              //    ? 'กรุณากรอกข้อมูล'
                                                                              //    : null,
                                                                            ),
                                                                            value:
                                                                                TextHoursEnd.text,
                                                                            icon:
                                                                                const Icon(Icons.keyboard_arrow_down),
                                                                            items: Hours.map((String jobtypeop) =>
                                                                                DropdownMenuItem(
                                                                                  // alignment: AlignmentDirectional.center,
                                                                                  value: jobtypeop,
                                                                                  child: Text(jobtypeop),
                                                                                )).toList(),
                                                                            onChanged:
                                                                                (val) {
                                                                              setState(() {
                                                                                TextHoursEnd.text = val.toString();
                                                                                print(val);
                                                                                //  getDropDowncallbackJobType();
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          margin:
                                                                              const EdgeInsets.all(2.0),
                                                                          // color: Colors.amber[600],
                                                                          width:
                                                                              100.0,
                                                                          height:
                                                                              60.0,
                                                                          child:
                                                                              DropdownButtonFormField(
                                                                            hint:
                                                                                const Text('เลือกเวลา'),
                                                                            decoration:
                                                                                InputDecoration(
                                                                              border: OutlineInputBorder(),
                                                                              errorText: _validate ? 'กรุณากรอกข้อมูล' : null,
                                                                            ),
                                                                            value:
                                                                                TextMinutesEnd.text,
                                                                            icon:
                                                                                const Icon(Icons.keyboard_arrow_down),
                                                                            items: Miniutes.map((String jobtypeop) =>
                                                                                DropdownMenuItem(
                                                                                  // alignment: AlignmentDirectional.center,
                                                                                  value: jobtypeop,
                                                                                  child: Text(jobtypeop),
                                                                                )).toList(),
                                                                            onChanged:
                                                                                (val) {
                                                                              setState(() {
                                                                                TextMinutesEnd.text = val.toString();
                                                                              });
                                                                            },
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Container(
                                                                          margin:
                                                                              const EdgeInsets.all(1.0),
                                                                          // color: Colors.amber[600],
                                                                          width:
                                                                              100.0,
                                                                          height:
                                                                              48.0,
                                                                          child:
                                                                              Text('ชั่วโมง'),
                                                                        ),
                                                                        Container(
                                                                          margin:
                                                                              const EdgeInsets.all(1.0),
                                                                          // color: Colors.amber[600],
                                                                          width:
                                                                              100.0,
                                                                          height:
                                                                              48.0,
                                                                          child:
                                                                              Text('นาที'),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Text(''),
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              130.0,
                                                                          height:
                                                                              40.0,
                                                                          child:
                                                                              IconsOutlineButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            text:
                                                                                'ยกเลิก',
                                                                            iconData:
                                                                                Icons.cancel_outlined,
                                                                            color:
                                                                                Colors.white,
                                                                            textStyle:
                                                                                TextStyle(color: Colors.black),
                                                                            iconColor:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                            '  '),
                                                                        Container(
                                                                          width:
                                                                              130.0,
                                                                          height:
                                                                              40.0,
                                                                          child: IconsButton(
                                                                              onPressed: () {
                                                                                if (TextHoursEnd.text.isNotEmpty && TextMinutesEnd.text.isNotEmpty) {
                                                                                  {
                                                                                    Navigator.of(context).pop();

                                                                                    // if (int.parse(TextHoursEnd.text) > 17 || (17 == int.parse(TextHoursEnd.text) && int.parse(TextMinutesEnd.text) > 30)) {
                                                                                    //   Dialogs.materialDialog(msg: 'เวลาเลิกงาน คือ เวลา 17:30 น. ลาเวลา ${TextHoursEnd.text + ':' + TextMinutesEnd.text} น. ใช่หรือไม่', title: 'ตรวจสอบข้อมูล', context: context, actions: [
                                                                                    //     IconsButton(
                                                                                    //       onPressed: () {
                                                                                    //         Navigator.of(context).pop();

                                                                                    //         timeend.text = '';
                                                                                    //       },
                                                                                    //       text: 'ไม่',
                                                                                    //       iconData: Icons.cancel_outlined,
                                                                                    //       color: Colors.white,
                                                                                    //       textStyle: TextStyle(color: Colors.black),
                                                                                    //       iconColor: Colors.black,
                                                                                    //     ),
                                                                                    //     IconsButton(
                                                                                    //       onPressed: () {
                                                                                    //         Navigator.of(context).pop();
                                                                                    //         timeend.text = '${TextHoursEnd.text}:${TextMinutesEnd.text}';
                                                                                    //         setState(() {
                                                                                    //           timeend.text = '${TextHoursEnd.text}:${TextMinutesEnd.text}';

                                                                                    //         });
                                                                                    //       },
                                                                                    //       text: 'ใช่',
                                                                                    //       iconData: Icons.check_circle_outline,
                                                                                    //       color: Colors.green,
                                                                                    //       textStyle: TextStyle(color: Colors.white),
                                                                                    //       iconColor: Colors.white,
                                                                                    //     ),
                                                                                    //   ]);

                                                                                    // } else {
                                                                                    setState(() {
                                                                                      timeend.text = '${TextHoursEnd.text}:${TextMinutesEnd.text}';
                                                                                    });
                                                                                    // }

                                                                                    //check ห้ามน้อยกว่าเวลาเริ่มงาน
                                                                                    if (!isChecked) {
                                                                                      DateTime chktimestart = DateFormat('HH:mm').parse(timestart.text);
                                                                                      if (int.parse(TextHoursEnd.text) < chktimestart.hour || (chktimestart.hour == int.parse(TextHoursEnd.text) && int.parse(TextMinutesEnd.text) < chktimestart.minute)) {
                                                                                        Dialogs.materialDialog(
                                                                                            // msg:
                                                                                            //     'ไม่สามารถเลือก เวลาสิ้นสุด ${TextHoursEnd.text + ':' + TextMinutesEnd.text} น. ก่อนเวลาเริ่มต้น คือ เวลา ${chktimestart.hour.toString().padLeft(2, '0')}.${chktimestart.minute.toString().padLeft(2, '0')} น. ได้',
                                                                                            msg: 'กรุณาตรวจสอบเวลาเริ่มต้นและเวลาสิ้นสุด\nให้ถูกต้อง',
                                                                                            title: 'ตรวจสอบข้อมูล',
                                                                                            context: context,
                                                                                            actions: [
                                                                                              IconsButton(
                                                                                                onPressed: () {
                                                                                                  Navigator.of(context).pop();
                                                                                                  timeend.text = "";
                                                                                                },
                                                                                                text: 'ตกลง',
                                                                                                iconData: Icons.check_circle_outline,
                                                                                                color: Colors.green,
                                                                                                textStyle: TextStyle(color: Colors.white),
                                                                                                iconColor: Colors.white,
                                                                                              ),
                                                                                            ]);
                                                                                        setState(() {
                                                                                          timeend.text = "";
                                                                                        });
                                                                                        //Show Alert
                                                                                      }
                                                                                    }
                                                                                  }
                                                                                }
                                                                              },
                                                                              text: 'ตกลง',
                                                                              iconData: Icons.check_circle_outline,
                                                                              color: Colors.green,
                                                                              textStyle: TextStyle(color: Colors.white),
                                                                              iconColor: Colors.white,
                                                                              padding: const EdgeInsets.all(4)),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ]);
                                                          /*  final TimeOfDay? result =
                                                        await showTimePicker(
                                                            context: context,
                                                            initialTime: timeend
                                                                    .text
                                                                    .isEmpty
                                                                ? TimeOfDay
                                                                    .now()
                                                                : TimeOfDay(
                                                                    hour: int.parse(timeend
                                                                        .text
                                                                        .split(':')[
                                                                            0]
                                                                        .toString()),
                                                                    minute: int.parse(timeend
                                                                        .text
                                                                        .split(':')[
                                                                            1]
                                                                        .toString())),
                                                            builder: (context,
                                                                child) {
                                                              return MediaQuery(
                                                                  data: MediaQuery.of(
                                                                          context)
                                                                      .copyWith(
                                                                          // Using 12-Hour format
                                                                          alwaysUse24HourFormat:
                                                                              true),
                                                                  // If you want 24-Hour format, just change alwaysUse24HourFormat to true
                                                                  child:
                                                                      child!);
                                                            });
                                                    if (result != null) {
                                                      setState(() {
                                                        if (result.hour > 17 ||
                                                            (17 ==
                                                                    result
                                                                        .hour &&
                                                                result.minute >
                                                                    30)) {
                                                          Dialogs.materialDialog(
                                                              msg:
                                                                  'เวลาเลิกงาน คือ เวลา 17:30 น. ลาเวลา ${result.hour.toString().padLeft(2, '0') + ':' + result.minute.toString().padLeft(2, '0')} น. ใช่หรือไม่',
                                                              title:
                                                                  'ตรวจสอบข้อมูล',
                                                              context: context,
                                                              actions: [
                                                                IconsButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
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
                                                                IconsOutlineButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    timeend.text =
                                                                        "";
                                                                  },
                                                                  text:
                                                                      'ยกเลิก',
                                                                  iconData: Icons
                                                                      .check_circle_outline,
                                                                  color: Colors
                                                                      .white,
                                                                  textStyle: TextStyle(
                                                                      color: Colors
                                                                          .grey),
                                                                  iconColor:
                                                                      Colors
                                                                          .grey,
                                                                ),
                                                              ]);
                                                          //Show Alert
                                                        }

                                                        timeend.text = result
                                                                .hour
                                                                .toString()
                                                                .padLeft(
                                                                    2, '0') +
                                                            ':' +
                                                            result.minute
                                                                .toString()
                                                                .padLeft(
                                                                    2, '0');
                                                      });
                                                    } */
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(''),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 130.0,
                                                      height: 40.0,
                                                      child: IconsOutlineButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        text: 'ยกเลิก',
                                                        iconData: Icons
                                                            .cancel_outlined,
                                                        color: Colors.white,
                                                        textStyle: TextStyle(
                                                            color:
                                                                Colors.black),
                                                        iconColor: Colors.black,
                                                      ),
                                                    ),
                                                    Text('  '),
                                                    Container(
                                                      width: 130.0,
                                                      height: 40.0,
                                                      child: IconsButton(
                                                          onPressed: () {
                                                            timenow =
                                                                new DateTime
                                                                    .now();
                                                            leavedetail =
                                                                'ลารายชั่วโมง';

                                                            if ((showdate ==
                                                                    Selectdate[
                                                                            1]
                                                                        .toString()) ||
                                                                ((showdate ==
                                                                        Selectdate[1]
                                                                            .toString()) ||
                                                                    (timenow.hour <
                                                                            work_yesterday
                                                                                .inHours ||
                                                                        (work_yesterday.inHours == timenow.hour &&
                                                                            timenow.minute <
                                                                                work_yesterday.inMinutes.remainder(60))))) {
                                                              if (timestart.text
                                                                      .isNotEmpty &&
                                                                  timeend.text
                                                                      .isNotEmpty) {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();

                                                                datasavetimesheet(
                                                                    timestart
                                                                        .text,
                                                                    timeend
                                                                        .text);
                                                              }
                                                            } else {
                                                              Dialogs.materialDialog(
                                                                  msg:
                                                                      'ไม่สามารถบันทึกข้อมูลได้เนื่องจากเกินเวลาที่กำหนด คือ เวลา ${work_yesterday.inHours.toString().padLeft(2, '0')}:${work_yesterday.inMinutes.remainder(60).toString().padLeft(2, '0')} น.',
                                                                  title:
                                                                      'ตรวจสอบข้อมูล',
                                                                  context:
                                                                      context,
                                                                  actions: [
                                                                    IconsOutlineButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      text:
                                                                          'ยกเลิก',
                                                                      iconData:
                                                                          Icons
                                                                              .check_circle_outline,
                                                                      color: Colors
                                                                          .white,
                                                                      textStyle:
                                                                          TextStyle(
                                                                              color: Colors.black),
                                                                      iconColor:
                                                                          Colors
                                                                              .black,
                                                                    ),
                                                                    IconsButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      text:
                                                                          'ตกลง',
                                                                      iconData:
                                                                          Icons
                                                                              .check_circle_outline,
                                                                      color: Colors
                                                                          .green,
                                                                      textStyle:
                                                                          TextStyle(
                                                                              color: Colors.white),
                                                                      iconColor:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                  ]);
                                                            }
                                                          },
                                                          text: 'ตกลง',
                                                          iconData: Icons
                                                              .check_circle_outline,
                                                          color: Colors.green,
                                                          textStyle: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          iconColor:
                                                              Colors.white,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4)),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ]);
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                onPrimary: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 20),
                                textStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                side: BorderSide(
                                  width: 3.0,
                                  color: Colors.brown,
                                ),
                                elevation: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
