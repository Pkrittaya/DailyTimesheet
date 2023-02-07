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

class AddTimesheetLeave extends StatefulWidget {
  final TimesheetData timesheetlist;
  final String EmpCode;
  final String url;

  const AddTimesheetLeave(
      {Key? key,
      required this.timesheetlist,
      required this.EmpCode,
      required this.url})
      : super(key: key);
  @override
  State<AddTimesheetLeave> createState() => _AddtimesheetLeaveState();
}

class _AddtimesheetLeaveState extends State<AddTimesheetLeave> {
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
  bool viewVisible = true;
  bool viewdateVisible = true;
  String dateleave = "";
  TextEditingController txtShowLeave = TextEditingController();

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

  FormatSendDate(textdate) {
    DateTime valdate = DateFormat('dd/MM/yyyy').parse(textdate);
    String date = DateFormat("yyyy-MM-dd'")
        .format(new DateTime(valdate.year - 543, valdate.month, valdate.day));
    return date;
  }

  List<ConfigLeaveData> leaveOptions = [];

  bool _isChecked = true;
  String _currText = '';
  bool value = false;
  bool valueHalfBefore = false;
  bool valueHalfAfter = false;
  bool valueFullTime = false;
  List<String> text = ["InduceSmile.com", "Flutter.io", "google.com"];

  void datasavetimesheet() async {
    String senddatetimesheetstart = "";
    String senddatetimesheetend = "";
    String senddateleave = "";

    if (timesheet.jobCode == null) {
      senddatetimesheetstart = FormatSendDate(datetimesheetstart.text);
      senddatetimesheetend = FormatSendDate(datetimesheetend.text);
      senddateleave = "";
    } else {
      senddatetimesheetstart = "";
      senddatetimesheetend = "";
      senddateleave = FormatSendDate(dateleave);
    }

    var tojsontext = {
      "emp_Code": "${widget.EmpCode}",
      "timesheetDate": "${senddatetimesheetstart}",
      "timesheetEndDate": "${senddatetimesheetend}",
      "in_Time": "${timestart.text}",
      "out_Time": "${timeend.text}",
      "status": "5",
      "remark": "",
      "project_Name": "${leaveimesheet.text}",
      "job_Detail": "${leaveimesheet.text}",
      "docType": "Timesheet"
    };

    var tojsontextEdit = {
      "emp_Code": "${widget.EmpCode}",
      "timesheetDate": "${senddateleave}",
      "in_Time": "${timestart.text}",
      "out_Time": "${timeend.text}",
      "status": "5",
      "remark": "",
      "project_Name": "${leaveimesheet.text}",
      "job_Detail": "${leaveimesheet.text}",
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
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
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
          titletimesheet = "เพิ่มเวลาลา";
          viewVisible = true;
          viewdateVisible = false;
          dateleave = "";
        }

        if (timesheet.projectName == null) {
          leaveimesheet.text = leaveOptions[0].configName!;
        } else {
          leaveimesheet.text = '${timesheet.projectName}';
        }

        if (timesheet.inTime == null) {
          timestart.text = '';
        } else {
          timestart.text = '${timesheet.inTime}';
        }

        if (timesheet.outTime == null) {
          timeend.text = '';
        } else {
          timeend.text = '${timesheet.outTime}';
        }
      });
    }
  }

  String? _selectedTime;
  Future<void> _show() async {
    final TimeOfDay? result = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  // Using 12-Hour format
                  alwaysUse24HourFormat: true),
              // If you want 24-Hour format, just change alwaysUse24HourFormat to true
              child: child!);
        });
    if (result != null) {
      setState(() {
        _selectedTime = result.format(context);
      });
    }
  }

  @override
  void initState() {
    getDropDownLeave();

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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FormBuilder(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 15),
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
                                  IconsButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();

                                      if (timesheet.jobCode != null) {
                                        if (leaveimesheet.text.isNotEmpty &&
                                            timestart.text.isNotEmpty &&
                                            timeend.text.isNotEmpty)
                                          datasavetimesheet();

                                        setState(() {
                                          (leaveimesheet.text.isEmpty ||
                                                  timestart.text.isEmpty ||
                                                  timeend.text.isEmpty)
                                              ? _validate = true
                                              : _validate = false;
                                        });
                                      } else {
                                        if (leaveimesheet.text.isNotEmpty &&
                                            timestart.text.isNotEmpty &&
                                            timeend.text.isNotEmpty &&
                                            datetimesheetstart
                                                .text.isNotEmpty &&
                                            datetimesheetend.text.isNotEmpty)
                                          datasavetimesheet();

                                        setState(() {
                                          (leaveimesheet.text.isEmpty ||
                                                  timestart.text.isEmpty ||
                                                  timeend.text.isEmpty ||
                                                  datetimesheetstart
                                                      .text.isEmpty ||
                                                  datetimesheetend.text.isEmpty)
                                              ? _validate = true
                                              : _validate = false;
                                        });
                                      }

                                      // _onLoading();
                                      // Dialogs.materialDialog(
                                      //   color: Colors.white,
                                      //   msg: 'บันทึกข้อมูลเรียบร้อย',
                                      //   title: 'บันทึกข้อมูลเรียบร้อย',
                                      //   context: context,
                                      //   actions: [
                                      //     IconsButton(
                                      //       onPressed: () {
                                      //         Navigator.of(context).pop();
                                      //       },
                                      //       text: 'Close',
                                      //       // iconData: Icons.done,
                                      //       color: Colors.green,
                                      //       textStyle: TextStyle(color: Colors.white),
                                      //       iconColor: Colors.white,
                                      //     ),
                                      //   ],
                                      // );
                                    },
                                    text: 'ตกลง',
                                    iconData: Icons.check_circle_outline,
                                    color: Colors.green,
                                    textStyle: TextStyle(color: Colors.white),
                                    iconColor: Colors.white,
                                  ),
                                  IconsOutlineButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    text: 'ยกเลิก',
                                    iconData: Icons.cancel_outlined,
                                    textStyle: TextStyle(color: Colors.grey),
                                    iconColor: Colors.grey,
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
                    Text('${titletimesheet}'),
                    Visibility(
                        visible: viewdateVisible,
                        child: Container(
                          child: Text('วันที่ ${dateleave}'),
                        )),
                    Visibility(
                        visible: viewdateVisible,
                        child: Container(
                          child: Text('ประเภทการลา : ${leaveimesheet.text}'),
                        )),
                    SizedBox(
                      width: 400,
                      child: Row(
                        children: <Widget>[
                          // SizedBox(
                          //   width: 10,
                          // ), //SizedBox
                          // SizedBox(width: 10), //SizedBox
                          /** Checkbox Widget **/
                          Expanded(
                            child: Container(
                                child: Row(
                              children: [
                                Checkbox(
                                  value: this.valueHalfBefore,
                                  onChanged: (var value) {
                                    setState(() {
                                      this.valueHalfBefore = value!;
                                      if (this.valueHalfBefore) {
                                        this.valueHalfAfter =
                                            !this.valueHalfBefore;
                                        this.valueFullTime =
                                            !this.valueHalfBefore;
                                      }

                                      GetConfig_Shift();
                                    });
                                  },
                                ),
                                Text('ลาครึ่งวันเช้า',
                                    style: TextStyle(fontSize: 13)),
                              ],
                            )),
                          ),

                          Expanded(
                            child: Container(
                                child: Row(
                              children: [
                                Checkbox(
                                  value: this.valueHalfAfter,
                                  onChanged: (var value) {
                                    setState(() {
                                      this.valueHalfAfter = value!;

                                      if (this.valueHalfAfter) {
                                        this.valueHalfBefore =
                                            !this.valueHalfAfter;
                                        this.valueFullTime =
                                            !this.valueHalfAfter;
                                      }

                                      GetConfig_Shift();
                                    });
                                  },
                                ),
                                Text('ลาครึ่งวันบ่าย',
                                    style: TextStyle(fontSize: 13)),
                              ],
                            )),
                          ),
                          Expanded(
                            child: Container(
                                child: Row(
                              children: [
                                Checkbox(
                                  value: this.valueFullTime,
                                  onChanged: (var value) {
                                    setState(() {
                                      this.valueFullTime = value!;
                                      if (this.valueFullTime) {
                                        this.valueHalfBefore =
                                            !this.valueFullTime;
                                        this.valueHalfAfter =
                                            !this.valueFullTime;
                                      }
                                      GetConfig_Shift();
                                    });
                                  },
                                ),
                                Text('ลาเต็มวัน',
                                    style: TextStyle(fontSize: 13)), //Checkbox
                              ],
                            )),
                          ),
                        ], //<Widget>[]
                      ),
                    ),
                    Visibility(
                        visible: viewVisible,
                        child: Container(
                          child: Text('ประเภทการลา'),
                        )),
                    Visibility(
                        visible: viewVisible,
                        child: Container(
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              errorText: _validate ? 'กรุณากรอกข้อมูล' : null,
                            ),
                            hint: const Text('เลือกประเภทการลา'),
                            value: leaveimesheet.text,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: leaveOptions
                                .map((ConfigLeaveData leaveop) =>
                                    DropdownMenuItem(
                                      // alignment: AlignmentDirectional.center,
                                      value: leaveop.configName,
                                      child: Text(leaveop.configName!),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                leaveimesheet.text = val.toString();
                                datetimesheetstart.text = '';
                                datetimesheetend.text = '';
                                timestart.text = '';
                                timeend.text = '';
                              });
                            },
                          ),
                        )),
                    Text('${txtShowLeave.text}'),
                    Visibility(
                      // maintainSize: true,
                      // maintainAnimation: true,
                      // maintainState: true,
                      visible: viewVisible,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 15, top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text('วันที่เริ่ม'),
                                SizedBox(
                                  width: 150,
                                  child: TextField(
                                    controller: datetimesheetstart,
                                    style: TextStyle(fontSize: 12),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      errorText:
                                          _validate ? 'กรุณากรอกข้อมูล' : null,
                                      hintText: "เลือกวันที่",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      suffixIcon: Align(
                                        widthFactor: 1.0,
                                        heightFactor: 1.0,
                                        child: Icon(
                                          Icons.calendar_today,
                                        ),
                                      ),
                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                              context: context,
                                              locale: const Locale("th", "TH"),
                                              initialDate: new DateTime(
                                                  DateTime.now().year + 543,
                                                  DateTime.now().month,
                                                  DateTime.now().day),
                                              firstDate: DateTime(2500),
                                              //DateTime.now() - not to allow to choose before today.
                                              lastDate: DateTime(3000));

                                      if (pickedDate != null) {
                                        // convert to ค.ศ
                                        pickedDate = new DateTime(
                                            pickedDate.year - 543,
                                            pickedDate.month,
                                            pickedDate.day);

                                        String formattedDate = "";
                                        String Message = "";
                                        var _data = leaveOptions.firstWhere(
                                            (o) =>
                                                o.configName ==
                                                leaveimesheet.text);
                                        if (_data != null) {
                                          if (_data.configAfter! != 0) {
                                            DateTime nowdate = DateTime.now()
                                                .subtract(Duration(
                                                    days: _data.configAfter!));
                                            DateTime dtCheck = new DateTime(
                                                nowdate.year,
                                                nowdate.month,
                                                nowdate.day);

                                            print(dtCheck);
                                            if (dtCheck.compareTo(pickedDate) >
                                                0) {
                                              //print(pickedDate);
                                              Message = "ลาย้อนหลังได้ " +
                                                  _data.configAfter!
                                                      .toString() +
                                                  " วัน";
                                            } else {
                                              formattedDate =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(pickedDate);
                                            }
                                          } else if (_data.configBefore! != 0) {
                                            DateTime nowdate = DateTime.now()
                                                .add(Duration(
                                                    days: _data.configBefore!));
                                            DateTime dtCheck = new DateTime(
                                                nowdate.year,
                                                nowdate.month,
                                                nowdate.day);
                                            if (pickedDate.compareTo(dtCheck) <
                                                0) {
                                              Message = "ลาล่วงหน้าอย่างน้อย " +
                                                  _data.configBefore!
                                                      .toString() +
                                                  " วัน";
                                            } else {
                                              formattedDate =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(pickedDate);
                                            }
                                          }
                                        } else {
                                          formattedDate =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(pickedDate);
                                        }

                                        formattedDate =
                                            DateFormat("dd/MM/yyyy'").format(
                                                new DateTime(
                                                    pickedDate.year + 543,
                                                    pickedDate.month,
                                                    pickedDate.day));
                                        print(formattedDate);
                                        setState(() {
                                          if (Message.isNotEmpty) {
                                            txtShowLeave.text = Message;
                                            datetimesheetstart.text = '';
                                          } else {
                                            txtShowLeave.text = Message;
                                            datetimesheetstart.text =
                                                formattedDate;
                                          }

                                          //set output date to TextField value.
                                        });
                                      } else {}
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
                                Text('วันที่สิ้นสุด'),
                                SizedBox(
                                  width: 150,
                                  child: TextField(
                                    controller: datetimesheetend,
                                    style: TextStyle(fontSize: 12),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      errorText:
                                          _validate ? 'กรุณากรอกข้อมูล' : null,
                                      hintText: "เลือกวันที่",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      suffixIcon: Align(
                                        widthFactor: 1.0,
                                        heightFactor: 1.0,
                                        child: Icon(
                                          Icons.calendar_today,
                                        ),
                                      ),
                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                              context: context,
                                              initialDate: new DateTime(
                                                  DateTime.now().year + 543,
                                                  DateTime.now().month,
                                                  DateTime.now().day),
                                              firstDate: DateTime(2500),
                                              //DateTime.now() - not to allow to choose before today.
                                              lastDate: DateTime(3000));

                                      if (pickedDate != null) {
                                        pickedDate = new DateTime(
                                            pickedDate.year - 543,
                                            pickedDate.month,
                                            pickedDate.day);
                                        print(
                                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                        String formattedDate =
                                            DateFormat('yyyy-MM-dd')
                                                .format(pickedDate);

                                        formattedDate =
                                            DateFormat("dd/MM/yyyy'").format(
                                                new DateTime(
                                                    pickedDate.year + 543,
                                                    pickedDate.month,
                                                    pickedDate.day));
                                        print(
                                            formattedDate); //formatted date output using intl package =>  2021-03-16

                                        setState(() {
                                          datetimesheetend.text = formattedDate;
                                          //set output date to TextField value.
                                        });
                                      } else {}
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
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
                                  errorText:
                                      _validate ? 'กรุณากรอกข้อมูล' : null,
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
                                ),
                                readOnly: true,
                                onTap: () async {
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
                                                'เวลาเริ่มงานคือเวลา 08.30 ต้องการเริ่มงานเวลา ${result.hour.toString() + ':' + result.minute.toString()} ใช่หรือไม่',
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

                                      timestart.text = result.hour.toString() +
                                          ':' +
                                          result.minute.toString();
                                    });
                                  }
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
                                  errorText:
                                      _validate ? 'กรุณากรอกข้อมูล' : null,
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
                                ),
                                readOnly: true,
                                onTap: () async {
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
                                    setState(() {
                                      if (result.hour > 17 ||
                                          (17 == result.hour &&
                                              result.minute > 30)) {
                                        Dialogs.materialDialog(
                                            msg:
                                                'เวลาเลิกงานคือเวลา 17.30 ต้องการเลิกงานเวลา ${result.hour.toString() + ':' + result.minute.toString()} ใช่หรือไม่',
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

                                      timeend.text = result.hour.toString() +
                                          ':' +
                                          result.minute.toString();
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
