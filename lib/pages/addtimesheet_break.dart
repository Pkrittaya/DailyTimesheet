import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:k2mobileapp/example/datepicker.dart';
import 'package:k2mobileapp/example/timepicker.dart';
import 'package:k2mobileapp/login.dart';
import 'package:k2mobileapp/main.dart';
import 'package:intl/intl.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:k2mobileapp/models/DropDownData.dart';
import 'package:k2mobileapp/models/TimesheetData.dart';
import 'package:k2mobileapp/theme.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show Codec, base64, json, utf8;
import 'dart:convert';
import '../home.dart';

// String fonts = "Kanit";
TimesheetData timesheet = new TimesheetData();
String chkinserttime = "";
String chkinserttimetext = "";
bool _validate = false;
String titletimesheet = "";
String EmpCode = "";

class AddTimesheetBreak extends StatefulWidget {
  final TimesheetData timesheetlist;
  final String EmpCode;
  final String url;

  const AddTimesheetBreak(
      {Key? key,
      required this.timesheetlist,
      required this.EmpCode,
      required this.url})
      : super(key: key);
  @override
  State<AddTimesheetBreak> createState() => _AddtimesheetBreakState();
}

class _AddtimesheetBreakState extends State<AddTimesheetBreak> {
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
  TextEditingController datetimesheet = TextEditingController();
  TextEditingController TextHours = TextEditingController();
  TextEditingController TextMinutes = TextEditingController();

  TextEditingController TextHoursEnd = TextEditingController();
  TextEditingController TextMinutesEnd = TextEditingController();

  bool isChecked = false;
  final datenow = DateTime.now();
  String jobbreak = "พัก";
  String jobdetailbreak = "พักทานข้าว";
  bool vieweditVisible = false;
  String datebreak = "";
  bool viewaddVisible = false;
  DateTime time = DateTime(2016, 5, 10, 22, 35);
  DateTime timenow = new DateTime.now();
  Duration work_yesterday = Duration(hours: 9, minutes: 00);

  List<String> Selectdate = <String>[
    DateFormat('dd/MM/yyyy').format(new DateTime(
            DateTime.now().year + 543, DateTime.now().month, DateTime.now().day)
        .subtract(Duration(days: 1))),
    DateFormat('dd/MM/yyyy').format(new DateTime(
        DateTime.now().year + 543, DateTime.now().month, DateTime.now().day))
  ];

  List<DropDownData> dateOptions = [];
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

  CustomDate(textdate) {
    DateTime valDate = DateTime.parse(textdate);
    String date = DateFormat("yyyy-MM-dd").format(valDate);
    return date.toString();
  }

  Customdatetext(textdate) {
    DateTime valdate = DateTime.parse(textdate);
    String date = DateFormat("dd/MM/yyyy")
        .format(new DateTime(valdate.year + 543, valdate.month, valdate.day));
    return date;
  }

  FormatDate(textdate) {
    String date = DateFormat("yyyy-MM-dd'").format(textdate);
    return date;
  }

  FormatSendDate(textdate) {
    DateTime valdate = DateFormat('dd/MM/yyyy').parse(textdate);
    String date = DateFormat("yyyy-MM-dd")
        .format(new DateTime(valdate.year - 543, valdate.month, valdate.day));
    return date;
  }

  void _onChanged(dynamic val) => debugPrint(val.toString());

  void datasavetimesheet() async {
    // String date = DateFormat("yyyy-MM-dd").format(datenow);
    String senddatetimesheetstart = "";
    senddatetimesheetstart = FormatSendDate(datebreak);

    var tojsontext = {
      "emp_Code": "${widget.EmpCode}",
      "timesheetDate": "${senddatetimesheetstart}",
      "in_Time": "${timestart.text}",
      "out_Time": "${timeend.text}",
      "status": "4",
      "remark": "",
      "project_Name": "${jobbreak}",
      "job_Detail": "${jobdetailbreak}",
      "docType": "Timesheet"
    };

    var tojsontextEdit = {
      "emp_Code": "${widget.EmpCode}",
      "timesheetDate": "${timesheet.timesheetDate}",
      "in_Time": "${timestart.text}",
      "out_Time": "${timeend.text}",
      "status": "4",
      "remark": "",
      "project_Name": "${jobbreak}",
      "job_Detail": "${jobdetailbreak}",
      "docType": "Timesheet",
      "job_Code": "${timesheet.jobCode}"
    };

    if (timesheet.jobCode == null) {
      tojsontext = tojsontext;
    } else {
      tojsontext = tojsontextEdit;
    }

    print(datenow);
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

  void getDropDownDate() async {
    var client = http.Client();

    var uri = Uri.parse("${widget.url}/api/Interface/GetDropDownDate");

    var response = await client.get(uri);

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

      List<DropDownData> DropDownDate = parsed
          .map<DropDownData>((json) => DropDownData.fromJson(json))
          .toList();

      // _data = TestAuto;
      setState(() {
        dateOptions = DropDownDate;
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

// This shows a CupertinoModalPopup with a reasonable fixed height which hosts CupertinoDatePicker.
  // void _showDialog(Widget child) {
  //   showCupertinoModalPopup<void>(
  //       context: context,
  //       builder: (BuildContext context) => Container(
  //             height: 216,
  //             padding: const EdgeInsets.only(top: 6.0),
  //             // The Bottom margin is provided to align the popup above the system navigation bar.
  //             margin: EdgeInsets.only(
  //               bottom: MediaQuery.of(context).viewInsets.bottom,
  //             ),
  //             // Provide a background color for the popup.
  //             color: CupertinoColors.systemBackground.resolveFrom(context),
  //             // Use a SafeArea widget to avoid system overlaps.
  //             child: SafeArea(
  //               top: false,
  //               child: child,
  //             ),
  //           ));
  // }

  @override
  void initState() {
    getDropDownDate();
    super.initState();
    timesheet = widget.timesheetlist;
    EmpCode = widget.EmpCode;

    if (timesheet.jobCode != null) {
      titletimesheet = "แก้ไขเวลาพัก";
      vieweditVisible = true;
      viewaddVisible = false;
      datebreak = Customdatetext(timesheet.timesheetDate);
    } else {
      titletimesheet = "เพิ่มเวลาพัก";
      vieweditVisible = false;
      viewaddVisible = true;
      // datebreak = "";
      if (timenow.hour < work_yesterday.inHours ||
          (work_yesterday.inHours == timenow.hour &&
              timenow.minute < work_yesterday.inMinutes.remainder(60))) {
        datebreak = Selectdate[0].toString();
      } else {
        datebreak = Selectdate[1].toString();
      }
    }
    if (timesheet.timesheetDate == null) {
      datetimesheet.text = FormatDate(DateTime.now());
    } else {
      datetimesheet.text = CustomDate(timesheet.timesheetDate);
    }

    if (timesheet.inTime == null) {
      timestart.text = '';
      TextHours.text = "00";
      TextMinutes.text = "00";
    } else {
      timestart.text = '${timesheet.inTime}';
      TextHours.text = timesheet.inTime!.split(":")[0];
      TextMinutes.text = timesheet.inTime!.split(":")[1];
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
          Color.fromARGB(255, 8, 170, 234),
          Color.fromARGB(255, 187, 224, 238),
          Color.fromARGB(255, 199, 227, 238),
          Color.fromARGB(255, 255, 255, 255),
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
              child: Table(
                children: [
                  TableRow(children: [
                    Column(
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
                        Container(
                          child: Text(
                            'วันที่ ${datebreak}',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () => Dialogs.materialDialog(
                                msg: 'คุณต้องการยืนยันข้อมูลใช่หรือไม่?',
                                title: 'ยืนยันข้อมูล',
                                context: context,
                                actions: [
                                  IconsOutlineButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    text: 'ไม่',
                                    iconData: Icons.cancel_outlined,
                                    textStyle: TextStyle(color: Colors.black),
                                    iconColor: Colors.black,
                                  ),
                                  IconsButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      timenow = new DateTime.now();
                                      print(timenow);
                                      print(datebreak);
                                      print(timenow.hour);
                                      print(timenow.minute);
                                      print(work_yesterday.inHours);
                                      print(work_yesterday.inMinutes
                                          .remainder(60));

                                      if ((datebreak ==
                                              Selectdate[1].toString()) ||
                                          ((datebreak ==
                                                  Selectdate[1].toString()) ||
                                              (timenow.hour <
                                                      work_yesterday.inHours ||
                                                  (work_yesterday.inHours ==
                                                          timenow.hour &&
                                                      timenow.minute <
                                                          work_yesterday
                                                              .inMinutes
                                                              .remainder(
                                                                  60))))) {
                                        if (timestart.text.isNotEmpty &&
                                            timeend.text.isNotEmpty)
                                          datasavetimesheet();

                                        setState(() {
                                          (timestart.text.isEmpty ||
                                                  timeend.text.isEmpty)
                                              ? _validate = true
                                              : _validate = false;
                                        });
                                      } else {
                                        Dialogs.materialDialog(
                                            msg:
                                                'ไม่สามารถบันทึกข้อมูลได้เนื่องจากเกินเวลาที่กำหนด คือ เวลา ${work_yesterday.inHours.toString().padLeft(2, '0')}.${work_yesterday.inMinutes.remainder(60).toString().padLeft(2, '0')} น.',
                                            title: 'ตรวจสอบข้อมูล',
                                            context: context,
                                            actions: [
                                              IconsOutlineButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                text: 'ยกเลิก',
                                                iconData:
                                                    Icons.check_circle_outline,
                                                color: Colors.white,
                                                textStyle: TextStyle(
                                                    color: Colors.black),
                                                iconColor: Colors.black,
                                              ),
                                              IconsButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                text: 'ตกลง',
                                                iconData:
                                                    Icons.check_circle_outline,
                                                color: Colors.green,
                                                textStyle: TextStyle(
                                                    color: Colors.white),
                                                iconColor: Colors.white,
                                              ),
                                            ]);
                                      }
                                    },
                                    text: 'ใช่',
                                    iconData: Icons.check_circle_outline,
                                    color: Colors.green,
                                    textStyle: TextStyle(color: Colors.white),
                                    iconColor: Colors.white,
                                  ),
                                ]),
                            icon: Icon(
                              FontAwesomeIcons.floppyDisk,
                              size: 15,
                            ), //icon data for elevated button
                            label: Text(
                              'บันทึก',
                              style: GoogleFonts.getFont(Fonts.fonts),
                            ),
                            style: ElevatedButton.styleFrom(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(50),
                                ),
                                primary: Colors.green[700],
                                // padding:
                                //     EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                textStyle: TextStyle(
                                  fontSize: 16,
                                )),
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
                  children: [
                    // Visibility(
                    //     visible: viewaddVisible,
                    //     child: Container(
                    //       child: Text('วันที่'),
                    //     )),
                    // Visibility(
                    //     visible: viewaddVisible,
                    //     child: Container(
                    //       child: DropdownButtonFormField(
                    //         decoration: InputDecoration(
                    //           border: OutlineInputBorder(),
                    //           errorText: _validate ? 'กรุณากรอกข้อมูล' : null,
                    //         ),
                    //         hint: const Text('เลือกวันที่'),
                    //         value: datetimesheet.text,
                    //         icon: const Icon(Icons.keyboard_arrow_down),
                    //         items: dateOptions
                    //             .map((DropDownData dateop) => DropdownMenuItem(
                    //                   // alignment: AlignmentDirectional.center,
                    //                   value: dateop.values,
                    //                   child: Text(dateop.description!),
                    //                 ))
                    //             .toList(),
                    //         onChanged: (val) {
                    //           setState(() {
                    //             datetimesheet.text = val.toString();
                    //           });
                    //         },
                    //       ),
                    //     )),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text('เวลาเริ่ม'),
                            SizedBox(
                              width: 150,
                              child: TextField(
                                controller: timestart,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  // icon: Icon(Icons.calendar_today),
                                  hintText: "เลือกเวลา",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  suffixIcon: Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child: Icon(
                                      FontAwesomeIcons.clock,
                                      size: 20,
                                    ),
                                  ),
                                  errorText:
                                      _validate ? 'กรุณากรอกข้อมูล' : null,
                                ),
                                readOnly: true,
                                onTap: () async {
                                  Dialogs.materialDialog(
                                      title: 'เพิ่มเวลา',
                                      context: context,
                                      actions: [
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin:
                                                      const EdgeInsets.all(2.0),
                                                  width: 100.0,
                                                  height: 60.0,
                                                  child:
                                                      DropdownButtonFormField(
                                                    // hint: const Text(''),
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),

                                                      //errorText: _validate
                                                      //    ? 'กรุณากรอกข้อมูล'
                                                      //    : null,
                                                    ),
                                                    value: TextHours.text,
                                                    icon: const Icon(Icons
                                                        .keyboard_arrow_down),
                                                    items: Hours.map(
                                                        (String jobtypeop) =>
                                                            DropdownMenuItem(
                                                              // alignment: AlignmentDirectional.center,
                                                              value: jobtypeop,
                                                              child: Text(
                                                                  jobtypeop),
                                                            )).toList(),
                                                    onChanged: (val) {
                                                      setState(() {
                                                        TextHours.text =
                                                            val.toString();
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
                                                  width: 100.0,
                                                  height: 60.0,
                                                  child:
                                                      DropdownButtonFormField(
                                                    hint:
                                                        const Text('เลือกเวลา'),
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      errorText: _validate
                                                          ? 'กรุณากรอกข้อมูล'
                                                          : null,
                                                    ),
                                                    value: TextMinutes.text,
                                                    icon: const Icon(Icons
                                                        .keyboard_arrow_down),
                                                    items: Miniutes.map(
                                                        (String jobtypeop) =>
                                                            DropdownMenuItem(
                                                              // alignment: AlignmentDirectional.center,
                                                              value: jobtypeop,
                                                              child: Text(
                                                                  jobtypeop),
                                                            )).toList(),
                                                    onChanged: (val) {
                                                      setState(() {
                                                        TextMinutes.text =
                                                            val.toString();
                                                      });
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin:
                                                      const EdgeInsets.all(1.0),
                                                  // color: Colors.amber[600],
                                                  width: 100.0,
                                                  height: 48.0,
                                                  child: Text('ชั่วโมง'),
                                                ),
                                                Container(
                                                  margin:
                                                      const EdgeInsets.all(1.0),
                                                  // color: Colors.amber[600],
                                                  width: 100.0,
                                                  height: 48.0,
                                                  child: Text('นาที'),
                                                )
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
                                                  child: IconsButton(
                                                      onPressed: () {
                                                        if (TextHours.text
                                                                .isNotEmpty &&
                                                            TextMinutes.text
                                                                .isNotEmpty) {
                                                          {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();

                                                            if (int.parse(TextHours
                                                                        .text) <
                                                                    8 ||
                                                                (8 ==
                                                                        int.parse(TextHours
                                                                            .text) &&
                                                                    int.parse(TextMinutes
                                                                            .text) <
                                                                        30)) {
                                                              Dialogs.materialDialog(
                                                                  msg:
                                                                      'เวลาเริ่มงานคือเวลา 08.30 น. ต้องการเริ่มงานเวลา ${TextHours.text + ':' + TextMinutes.text} น. ใช่หรือไม่',
                                                                  title:
                                                                      'ตรวจสอบข้อมูล',
                                                                  context:
                                                                      context,
                                                                  actions: [
                                                                    IconsButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();

                                                                        timestart.text =
                                                                            '';
                                                                      },
                                                                      text:
                                                                          'ไม่',
                                                                      iconData:
                                                                          Icons
                                                                              .cancel_outlined,
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
                                                                          'ใช่',
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
                                                              //Show Alert
                                                            }

                                                            timestart.text =
                                                                '${TextHours.text}:${TextMinutes.text}';
                                                          }
                                                        }
                                                      },
                                                      text: 'ตกลง',
                                                      iconData: Icons
                                                          .check_circle_outline,
                                                      color: Colors.green,
                                                      textStyle: TextStyle(
                                                          color: Colors.white),
                                                      iconColor: Colors.white,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4)),
                                                ),
                                                Text('  '),
                                                Container(
                                                  width: 130.0,
                                                  height: 40.0,
                                                  child: IconsOutlineButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    text: 'ยกเลิก',
                                                    iconData:
                                                        Icons.cancel_outlined,
                                                    textStyle: TextStyle(
                                                        color: Colors.black),
                                                    iconColor: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ]);
                                  /* Dialogs.materialDialog(
                                      title: 'เพิ่มเวลา',
                                      context: context,
                                      actions: [
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin:
                                                      const EdgeInsets.all(2.0),
                                                  // color: Colors.amber[600],
                                                  width: 100.0,
                                                  height: 40.0,
                                                  child:
                                                      DropdownButtonFormField(
                                                    // hint: const Text(''),
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),

                                                      //errorText: _validate
                                                      //    ? 'กรุณากรอกข้อมูล'
                                                      //    : null,
                                                    ),
                                                    value: TextHours.text,
                                                    icon: const Icon(Icons
                                                        .keyboard_arrow_down),
                                                    items: Hours.map(
                                                        (String jobtypeop) =>
                                                            DropdownMenuItem(
                                                              // alignment: AlignmentDirectional.center,
                                                              value: jobtypeop,
                                                              child: Text(
                                                                  jobtypeop),
                                                            )).toList(),
                                                    onChanged: (val) {
                                                      setState(() {
                                                        TextHours.text =
                                                            val.toString();
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
                                                  width: 100.0,
                                                  height: 40.0,
                                                  child:
                                                      DropdownButtonFormField(
                                                    hint:
                                                        const Text('เลือกเวลา'),
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      errorText: _validate
                                                          ? 'กรุณากรอกข้อมูล'
                                                          : null,
                                                    ),
                                                    value: TextMinutes.text,
                                                    icon: const Icon(Icons
                                                        .keyboard_arrow_down),
                                                    items: Miniutes.map(
                                                        (String jobtypeop) =>
                                                            DropdownMenuItem(
                                                              // alignment: AlignmentDirectional.center,
                                                              value: jobtypeop,
                                                              child: Text(
                                                                  jobtypeop),
                                                            )).toList(),
                                                    onChanged: (val) {
                                                      setState(() {
                                                        TextMinutes.text =
                                                            val.toString();
                                                      });
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin:
                                                      const EdgeInsets.all(1.0),
                                                  // color: Colors.amber[600],
                                                  width: 100.0,
                                                  height: 48.0,
                                                  child: Text('ชั่วโมง'),
                                                ),
                                                Container(
                                                  margin:
                                                      const EdgeInsets.all(1.0),
                                                  // color: Colors.amber[600],
                                                  width: 100.0,
                                                  height: 48.0,
                                                  child: Text('นาที'),
                                                )
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
                                                  child: IconsButton(
                                                      onPressed: () {
                                                        if (TextHours.text
                                                                .isNotEmpty &&
                                                            TextMinutes.text
                                                                .isNotEmpty) {
                                                          {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();

                                                            if (int.parse(TextHours
                                                                        .text) <
                                                                    8 ||
                                                                (8 ==
                                                                        int.parse(TextHours
                                                                            .text) &&
                                                                    int.parse(TextMinutes
                                                                            .text) <
                                                                        30)) {
                                                              Dialogs.materialDialog(
                                                                  msg:
                                                                      'เวลาเริ่มงานคือเวลา 08.30 น. ต้องการเริ่มงานเวลา ${TextHours.text + ':' + TextMinutes.text} น. ใช่หรือไม่',
                                                                  title:
                                                                      'ตรวจสอบข้อมูล',
                                                                  context:
                                                                      context,
                                                                  actions: [
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
                                                              //Show Alert
                                                            }

                                                            timestart.text =
                                                                '${TextHours.text}:${TextMinutes.text}';
                                                          }
                                                        }
                                                      },
                                                      text: 'ตกลง',
                                                      iconData: Icons
                                                          .check_circle_outline,
                                                      color: Colors.green,
                                                      textStyle: TextStyle(
                                                          color: Colors.white),
                                                      iconColor: Colors.white,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4)),
                                                ),
                                                Text('  '),
                                                Container(
                                                  width: 130.0,
                                                  height: 40.0,
                                                  child: IconsOutlineButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    text: 'ยกเลิก',
                                                    iconData:
                                                        Icons.cancel_outlined,
                                                    textStyle: TextStyle(
                                                        color: Colors.grey),
                                                    iconColor: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ]);
                                      */
                                  // _showDialog(
                                  //   CupertinoDatePicker(
                                  //     initialDateTime: time,
                                  //     mode: CupertinoDatePickerMode.time,
                                  //     use24hFormat: true,
                                  //     onDateTimeChanged: (DateTime newTime) {
                                  //       // setState(() => time = newTime);
                                  //       setState(() {
                                  //         time = newTime;
                                  //         // timestart.text =
                                  //         //     '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

                                  //         if (time.hour < 8 ||
                                  //             (8 == time.hour &&
                                  //                 time.minute < 30)) {
                                  //           Dialogs.materialDialog(
                                  //               msg:
                                  //                   'เวลาเริ่มงานคือเวลา 08.30 ต้องการเริ่มงานเวลา ${time.hour.toString().padLeft(2, '0') + ':' + time.minute.toString().padLeft(2, '0')} ใช่หรือไม่',
                                  //               title: 'ตรวจสอบข้อมูล',
                                  //               context: context,
                                  //               actions: [
                                  //                 IconsButton(
                                  //                   onPressed: () {
                                  //                     Navigator.of(context)
                                  //                         .pop();
                                  //                   },
                                  //                   text: 'ตกลง',
                                  //                   iconData: Icons
                                  //                       .check_circle_outline,
                                  //                   color: Colors.green,
                                  //                   textStyle: TextStyle(
                                  //                       color: Colors.white),
                                  //                   iconColor: Colors.white,
                                  //                 ),
                                  //               ]);
                                  //           //Show Alert
                                  //         }
                                  //         timestart.text = time.hour
                                  //                 .toString()
                                  //                 .padLeft(2, '0') +
                                  //             ':' +
                                  //             time.minute
                                  //                 .toString()
                                  //                 .padLeft(2, '0');
                                  //       });
                                  //     },
                                  //   ),
                                  // );
/*
                                  final TimeOfDay? result =
                                      await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                          builder: (context, child) {
                                            return MediaQuery(
                                                data: MediaQuery.of(context)
                                                    .copyWith(
                                                        // Using 12-Hour format
                                                        alwaysUse24HourFormat:
                                                            true),
                                                // If you want 24-Hour format, just change alwaysUse24HourFormat to true
                                                child: child!);
                                          });
                                  if (result != null) {
                                    // context = CustomTime(context);

                                    setState(() {
                                      if (result.hour < 8 ||
                                          (8 == result.hour &&
                                              result.minute < 30)) {
                                        Dialogs.materialDialog(
                                            msg:
                                                'เวลาเริ่มงาน คือ เวลา 08.30 น. ต้องการเริ่มงานเวลา ${result.hour.toString().padLeft(2, '0') + ':' + result.minute.toString().padLeft(2, '0')} น. ใช่หรือไม่',
                                            title: 'ตรวจสอบข้อมูล',
                                            context: context,
                                            actions: [
                                              IconsButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                text: 'ตกลง',
                                                iconData:
                                                    Icons.check_circle_outline,
                                                color: Colors.green,
                                                textStyle: TextStyle(
                                                    color: Colors.white),
                                                iconColor: Colors.white,
                                              ),
                                            ]);
                                        //Show Alert
                                      }
                                      timestart.text = result.hour
                                              .toString()
                                              .padLeft(2, '0') +
                                          ':' +
                                          result.minute
                                              .toString()
                                              .padLeft(2, '0');
                                    });
                                  }
                                  */
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 15),
                        Text('ถึง'),
                        const SizedBox(width: 15),
                        Column(
                          children: [
                            Text('เวลาสิ้นสุด'),
                            SizedBox(
                              width: 150,
                              child: TextField(
                                controller: timeend,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  // icon: Icon(Icons.calendar_today),
                                  hintText: "เลือกเวลา",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  suffixIcon: Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child: Icon(
                                      FontAwesomeIcons.clock,
                                      size: 20,
                                    ),
                                  ),
                                  errorText:
                                      _validate ? 'กรุณากรอกข้อมูล' : null,
                                ),
                                readOnly: true,
                                onTap: () async {
                                  Dialogs.materialDialog(
                                      title: 'เพิ่มเวลา',
                                      context: context,
                                      actions: [
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin:
                                                      const EdgeInsets.all(2.0),
                                                  // color: Colors.amber[600],
                                                  width: 100.0,
                                                  height: 60.0,
                                                  child:
                                                      DropdownButtonFormField(
                                                    // hint: const Text(''),
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),

                                                      //errorText: _validate
                                                      //    ? 'กรุณากรอกข้อมูล'
                                                      //    : null,
                                                    ),
                                                    value: TextHoursEnd.text,
                                                    icon: const Icon(Icons
                                                        .keyboard_arrow_down),
                                                    items: Hours.map(
                                                        (String jobtypeop) =>
                                                            DropdownMenuItem(
                                                              // alignment: AlignmentDirectional.center,
                                                              value: jobtypeop,
                                                              child: Text(
                                                                  jobtypeop),
                                                            )).toList(),
                                                    onChanged: (val) {
                                                      setState(() {
                                                        TextHoursEnd.text =
                                                            val.toString();
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
                                                  width: 100.0,
                                                  height: 60.0,
                                                  child:
                                                      DropdownButtonFormField(
                                                    hint:
                                                        const Text('เลือกเวลา'),
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      errorText: _validate
                                                          ? 'กรุณากรอกข้อมูล'
                                                          : null,
                                                    ),
                                                    value: TextMinutesEnd.text,
                                                    icon: const Icon(Icons
                                                        .keyboard_arrow_down),
                                                    items: Miniutes.map(
                                                        (String jobtypeop) =>
                                                            DropdownMenuItem(
                                                              // alignment: AlignmentDirectional.center,
                                                              value: jobtypeop,
                                                              child: Text(
                                                                  jobtypeop),
                                                            )).toList(),
                                                    onChanged: (val) {
                                                      setState(() {
                                                        TextMinutesEnd.text =
                                                            val.toString();
                                                      });
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin:
                                                      const EdgeInsets.all(1.0),
                                                  // color: Colors.amber[600],
                                                  width: 100.0,
                                                  height: 48.0,
                                                  child: Text('ชั่วโมง'),
                                                ),
                                                Container(
                                                  margin:
                                                      const EdgeInsets.all(1.0),
                                                  // color: Colors.amber[600],
                                                  width: 100.0,
                                                  height: 48.0,
                                                  child: Text('นาที'),
                                                )
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
                                                    iconData:
                                                        Icons.cancel_outlined,
                                                    textStyle: TextStyle(
                                                        color: Colors.black),
                                                    iconColor: Colors.black,
                                                  ),
                                                ),
                                                Text('  '),
                                                Container(
                                                  width: 130.0,
                                                  height: 40.0,
                                                  child: IconsButton(
                                                      onPressed: () {
                                                        if (TextHoursEnd.text
                                                                .isNotEmpty &&
                                                            TextMinutesEnd.text
                                                                .isNotEmpty) {
                                                          {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();

                                                            if (int.parse(TextHoursEnd
                                                                        .text) >
                                                                    17 ||
                                                                (17 ==
                                                                        int.parse(TextHoursEnd
                                                                            .text) &&
                                                                    int.parse(TextMinutesEnd
                                                                            .text) >
                                                                        30)) {
                                                              Dialogs.materialDialog(
                                                                  msg:
                                                                      'เวลาเลิกงาน คือ เวลา 17.30 น. ต้องการเลิกงานเวลา ${TextHoursEnd.text + ':' + TextMinutesEnd.text} น. ใช่หรือไม่',
                                                                  title:
                                                                      'ตรวจสอบข้อมูล',
                                                                  context:
                                                                      context,
                                                                  actions: [
                                                                    IconsButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();

                                                                        timeend.text =
                                                                            '';
                                                                      },
                                                                      text:
                                                                          'ไม่',
                                                                      iconData:
                                                                          Icons
                                                                              .cancel_outlined,
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
                                                                          'ใช่',
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
                                                              //Show Alert
                                                            }

                                                            //check ห้ามน้อยกว่าเวลาเริ่มงาน
                                                            if (!isChecked) {
                                                              DateTime
                                                                  chktimestart =
                                                                  DateFormat(
                                                                          'hh:mm')
                                                                      .parse(timestart
                                                                          .text);
                                                              if (int.parse(TextHoursEnd
                                                                          .text) <
                                                                      chktimestart
                                                                          .hour ||
                                                                  (chktimestart
                                                                              .hour ==
                                                                          int.parse(TextHoursEnd
                                                                              .text) &&
                                                                      int.parse(TextMinutesEnd
                                                                              .text) <
                                                                          chktimestart
                                                                              .minute)) {
                                                                Dialogs.materialDialog(
                                                                    // msg:
                                                                    //     'ไม่สามารถเลือก เวลาสิ้นสุด ${TextHoursEnd.text + ':' + TextMinutesEnd.text} น. ก่อนเวลาเริ่มต้น คือ เวลา ${chktimestart.hour.toString().padLeft(2, '0')}.${chktimestart.minute.toString().padLeft(2, '0')} น. ได้',
                                                                    msg: 'กรุณาตรวจสอบเวลาเริ่มต้นและเวลาสิ้นสุด\nให้ถูกต้อง',
                                                                    title: 'ตรวจสอบข้อมูล',
                                                                    context: context,
                                                                    actions: [
                                                                      IconsButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          timeend.text =
                                                                              "";
                                                                        },
                                                                        text:
                                                                            'ตกลง',
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
                                                                setState(() {
                                                                  timeend.text =
                                                                      "";
                                                                });
                                                                //Show Alert
                                                              }
                                                            } else {
                                                              timeend.text =
                                                                  '${TextHoursEnd.text}:${TextMinutesEnd.text}';
                                                            }
                                                          }
                                                        }
                                                      },
                                                      text: 'ตกลง',
                                                      iconData: Icons
                                                          .check_circle_outline,
                                                      color: Colors.green,
                                                      textStyle: TextStyle(
                                                          color: Colors.white),
                                                      iconColor: Colors.white,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4)),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ]);
                                  /* final TimeOfDay? result =
                                      await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                          builder: (context, child) {
                                            return MediaQuery(
                                                data: MediaQuery.of(context)
                                                    .copyWith(
                                                        // Using 12-Hour format
                                                        alwaysUse24HourFormat:
                                                            true),
                                                // If you want 24-Hour format, just change alwaysUse24HourFormat to true
                                                child: child!);
                                          });
                                  if (result != null) {
                                    setState(() {
                                      if (result.hour > 17 ||
                                          (17 == result.hour &&
                                              result.minute > 30)) {
                                        Dialogs.materialDialog(
                                            msg:
                                                'เวลาเลิกงาน คือ เวลา 17.30 น. ต้องการเลิกงานเวลา ${result.hour.toString().padLeft(2, '0') + ':' + result.minute.toString().padLeft(2, '0')} น. ใช่หรือไม่',
                                            title: 'ตรวจสอบข้อมูล',
                                            context: context,
                                            actions: [
                                              IconsButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                text: 'ตกลง',
                                                iconData:
                                                    Icons.check_circle_outline,
                                                color: Colors.green,
                                                textStyle: TextStyle(
                                                    color: Colors.white),
                                                iconColor: Colors.white,
                                              ),
                                            ]);
                                        //Show Alert
                                      }

                                      timeend.text = result.hour
                                              .toString()
                                              .padLeft(2, '0') +
                                          ':' +
                                          result.minute
                                              .toString()
                                              .padLeft(2, '0');
                                    });
                                  }
                               */
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
