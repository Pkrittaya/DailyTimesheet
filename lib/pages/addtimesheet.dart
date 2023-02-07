import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:k2mobileapp/models/DropDownData.dart';
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
String titletimesheet = "";
bool _validate = false;
String EmpCode = "";

class AddTimesheet extends StatefulWidget {
  final TimesheetData timesheetlist;
  final String EmpCode;
  final String DepCode;
  final String url;

  const AddTimesheet(
      {Key? key,
      required this.timesheetlist,
      required this.EmpCode,
      required this.DepCode,
      required this.url})
      : super(key: key);

  @override
  State<AddTimesheet> createState() => _AddtimesheetState();
}

class _AddtimesheetState extends State<AddTimesheet> {
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
  TextEditingController department = TextEditingController();
  TextEditingController project = TextEditingController();
  TextEditingController jobtype = TextEditingController();
  TextEditingController remark = TextEditingController();
  TextEditingController datetimesheet = TextEditingController();
  TextEditingController datetimesheetstart = TextEditingController();
  TextEditingController datetimesheetend = TextEditingController();
  TextEditingController TextHours = TextEditingController();
  TextEditingController TextMinutes = TextEditingController();

  TextEditingController TextHoursEnd = TextEditingController();
  TextEditingController TextMinutesEnd = TextEditingController();

  bool isChecked = false;
  String getdepcode = "";
  String getworkcode = "";
  String getjobtypecode = "";
  bool viewVisible = false;
  bool vieweditVisible = false;
  bool viewovernightVisible = false;
  bool dropdownminout = true;
  String datework = "";
  DateTime timenow = new DateTime.now();
  Duration work_yesterday = Duration(hours: 9, minutes: 00);

  List<String> Selectdate = <String>[
    DateFormat('dd/MM/yyyy').format(new DateTime(
            DateTime.now().year + 543, DateTime.now().month, DateTime.now().day)
        .subtract(Duration(days: 1))),
    DateFormat('dd/MM/yyyy').format(new DateTime(
        DateTime.now().year + 543, DateTime.now().month, DateTime.now().day))
  ];

  List<DropDownData> departmentoption = [];
  List<DropDownData> projectoption = [];
  List<DropDownData> jobtypeoption = [];
  List<DropDownData> jobdetailoption = [];
  List<DropDownData> dateOptions = [];
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

  List<String> HoursBefore = <String>[
    '00',
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08'
  ];
  List<String> HoursAfter = <String>[
    '00',
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09'
  ];

  CustomDate(textdate) {
    DateTime valDate = DateTime.parse(textdate);
    String date = DateFormat("yyyy-MM-dd'").format(valDate);
    return date.toString();
  }

  Customdatetext(textdate) {
    DateTime valdate = DateTime.parse(textdate);
    String date = DateFormat("dd/MM/yyyy")
        .format(new DateTime(valdate.year + 543, valdate.month, valdate.day));
    return date;
  }

  FormatDate(textdate) {
    String date = DateFormat("yyyy-MM-dd").format(textdate);
    return date;
  }

  FormatDatetext(textdate) {
    String date = DateFormat("dd/MM/yyyy").format(
        new DateTime(textdate.year + 543, textdate.month, textdate.day));
    return date;
  }

  FormatSendDate(textdate) {
    DateTime valdate = DateFormat('dd/MM/yyyy').parse(textdate);
    String date = DateFormat("yyyy-MM-dd")
        .format(new DateTime(valdate.year - 543, valdate.month, valdate.day));
    return date;
  }

  Checkovernight() {
    if (isChecked) {
      // viewVisible = true;
      // datetimesheetstart.text = Selectdate[0].toString();

      // DateTime formatedatetime = DateTime.parse(datetimesheet.text);
      // datetimesheetend.text = Selectdate[1].toString();
      viewVisible = true;
      String datestartformat = FormatSendDate(datework);
      datetimesheetstart.text = Customdatetext(datestartformat);

      DateTime formatedatetime = DateTime.parse(datestartformat);
      datetimesheetend.text =
          FormatDatetext(formatedatetime.add(const Duration(days: 1)));
    } else {
      viewVisible = false;
      datetimesheetstart.text = "";
      datetimesheetend.text = "";
    }
  }

  void datasavetimesheet() async {
    String senddatetimesheetstart = "";
    String senddatetimesheetend = "";
    String senddateedit = "";

    if (timesheet.jobCode == null) {
      // if (isChecked) {
      senddatetimesheetstart = datetimesheetstart.text;
      senddatetimesheetend = datetimesheetend.text;
      // } else {
      //   senddatetimesheetstart = FormatSendDate(datework);
      //   senddatetimesheetend = "";
      // }

      senddateedit = "";
    } else {
      senddatetimesheetstart = "";
      senddatetimesheetend = "";
      senddateedit = FormatSendDate(datework);
    }
    print(senddatetimesheetstart);
    var tojsontext = {
      "emp_Code": "${EmpCode}",
      "timesheetDate": "${senddatetimesheetstart}",
      "timesheetEndDate": "${senddatetimesheetend}",
      "in_Time": "${timestart.text}",
      "out_Time": "${timeend.text == '24:00' ? '00:00' : timeend.text}",
      "status": "1",
      "remark": "${remark.text}",
      "project_Name": "${project.text}",
      "job_Detail": "${jobdetail.text}",
      "docType": "Timesheet",
      "job_Type_code": "${jobtype.text}",
      "department_Code": "${department.text}",
    };
    // var tojsontextOvernight = {
    //   "emp_Code": "${EmpCode}",
    //   "timesheetDate": "${senddatetimesheetstart}",
    //   "timesheetEndDate": "${senddatetimesheetend}",
    //   "in_Time": "${timestart.text}",
    //   "out_Time": "${timeend.text == '24:00' ? '00:00' : timeend.text}",
    //   "status": "1",
    //   "remark": "${remark.text}",
    //   "project_Name": "${project.text}",
    //   "job_Detail": "${jobdetail.text}",
    //   "docType": "Timesheet",
    //   "job_Type_code": "${jobtype.text}",
    //   "department_Code": "${department.text}",
    // };
    var tojsontextEdit = {
      "emp_Code": "${EmpCode}",
      "timesheetDate": "${senddateedit}",
      "in_Time": "${timestart.text}",
      "out_Time": "${timeend.text == '24:00' ? '00:00' : timeend.text}",
      "status": "1",
      "remark": "${remark.text}",
      "project_Name": "${project.text}",
      "job_Detail": "${jobdetail.text}",
      "docType": "Timesheet",
      "job_Code": "${timesheet.jobCode}",
      "job_Type_code": "${jobtype.text}",
      "department_Code": "${department.text}",
    };
    if (timesheet.jobCode == null) {
      // if (isChecked) {
      tojsontext = tojsontext;
      // } else {
      //   tojsontext = tojsontextOvernight;
      // }
    } else {
      tojsontext = tojsontextEdit;
    }
    print(tojsontext);
    final _baseUrl = '${widget.url}/api/Interface/GetPostDataTimesheetValues';
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
    });
  }

  void getlsttimesheet() async {
    var client = http.Client();
    DateTime NewDate = DateTime.now();
    if ((NewDate.hour < work_yesterday.inHours) ||
        ((NewDate.hour == work_yesterday.inHours) &&
            (NewDate.minute <= work_yesterday.inMinutes.remainder(60)))) {
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

///// load fisttime

  void getDropDownDepartment() async {
    var client = http.Client();
//project.text
    var uri = Uri.parse(
        "${widget.url}/api/Interface/GetDropDownDepartmentProject?EmpCode=${widget.EmpCode}&Workcode=${project.text}");

    var response = await client.get(uri);

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

      List<DropDownData> DropDownDepartment = parsed
          .map<DropDownData>((json) => DropDownData.fromJson(json))
          .toList();

      // String setworkcode = "";
      // if (timesheet.departmentCode == null) {
      //   setworkcode = DropDownDepartment[0].description!;
      // } else {
      //   setworkcode = '${timesheet.departmentCode}';
      // }

      // print(setworkcode);

      // String setjobcode = "";
      // var workcode = DropDownDepartment.firstWhere(
      //     (element) => element.description == setworkcode);
      // if (workcode != null) {
      //   setjobcode = workcode.values!;
      // }

      // print(workcode);

      setState(() {
        departmentoption = DropDownDepartment;
        if (timesheet.departmentCode == null) {
          department.text = departmentoption[0].description!;
        } else {
          department.text = '${timesheet.departmentCode}';
        }
        getDropDownJobData();
        // getDropDownProject();
      });
    }
  }

  void getDropDownProject() async {
    var depcode = departmentoption
        .where((element) => element.description == department.text)
        .toList();

    if (depcode.length > 0) {
      getdepcode = depcode[0].values!;
    }

    var client = http.Client();

    var uri = Uri.parse(
        "${widget.url}/api/Interface/GetDropDownWorkByEmpCode?EmpCode=${widget.EmpCode}");

    var response = await client.get(uri);

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

      List<DropDownData> DropDownLeave = parsed
          .map<DropDownData>((json) => DropDownData.fromJson(json))
          .toList();

      String setworkcode = "";
      if (timesheet.projectName == null) {
        setworkcode = DropDownLeave[0].description!;
      } else {
        setworkcode = '${timesheet.projectName}';
      }

      // print(setworkcode);

      String setjobcode = "";
      var workcode = DropDownLeave.firstWhere(
          (element) => element.description == setworkcode);
      if (workcode != null) {
        setjobcode = workcode.values!;
      }

      // print(workcode);

      // var urigetworkcode = Uri.parse(
      //     "${widget.url}/api/Interface/GetDropDownJobTypeCode?EmpCode=${widget.EmpCode}&Workcode=${setjobcode}");

      // var responsegetworkcode = await client.get(urigetworkcode);
      // print(responsegetworkcode.body);

      // if (responsegetworkcode.statusCode == 200) {
      //   final parsedgetworkcode =
      //       jsonDecode(responsegetworkcode.body).cast<Map<String, dynamic>>();

      //   List<DropDownData> DropDownJobType = parsedgetworkcode
      //       .map<DropDownData>((json) => DropDownData.fromJson(json))
      //       .toList();

      //   setState(() {
      //     projectoption = DropDownLeave;
      //     if (timesheet.projectName == null) {
      //       project.text = projectoption[0].description!;
      //     } else {
      //       project.text = '${timesheet.projectName}';
      //     }

      //     jobtypeoption = DropDownJobType;
      //     if (timesheet.jobTypeCode == null) {
      //       jobtype.text = jobtypeoption[0].description!;
      //       print(jobtype.text);
      //     } else {
      //       jobtype.text = '${timesheet.jobTypeCode}';
      //     }
      //   });
      // }

      setState(() {
        projectoption = DropDownLeave;
        if (timesheet.projectName == null) {
          project.text = projectoption[0].description!;
        } else {
          project.text = '${timesheet.projectName}';
        }
        getDropDownDepartment();
        //
      });
    }
  }

  void getDropDownJobData() async {
    var workcode = projectoption
        .firstWhere((element) => element.description == project.text);

    if (workcode != null) {
      getworkcode = workcode.values!;
    }

    var client = http.Client();

    var uri = Uri.parse(
        "${widget.url}/api/Interface/GetDropDownJobData?EmpCode=${widget.EmpCode}&Workcode=${getworkcode}");

    var response = await client.get(uri);

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

      List<DropDownData> DropDownJobType = parsed
          .map<DropDownData>((json) => DropDownData.fromJson(json))
          .toList();

      setState(() {
        jobdetailoption = DropDownJobType;

        if (timesheet.jobDetailValues == null) {
          jobdetail.text = DropDownJobType[0].values!;
        } else {
          jobdetail.text = '${timesheet.jobDetailValues}';
        }

        //getDropDownJobDetail();
      });
    }
  }

  void getDropDownJobType() async {
    var workcode = projectoption
        .firstWhere((element) => element.description == project.text);
    if (workcode != null) {
      getworkcode = workcode.values!;
    }
    var client = http.Client();

    var uri = Uri.parse(
        "${widget.url}/api/Interface/GetDropDownJobTypeCode?EmpCode=${widget.EmpCode}&Workcode=${getworkcode}");

    var response = await client.get(uri);

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

      List<DropDownData> DropDownJobType = parsed
          .map<DropDownData>((json) => DropDownData.fromJson(json))
          .toList();

      setState(() {
        jobtypeoption = DropDownJobType;
        if (timesheet.jobTypeCode == null) {
          jobtype.text = jobtypeoption[0].description!;
          print(jobtype.text);
        } else {
          jobtype.text = '${timesheet.jobTypeCode}';
        }

        getDropDownJobDetail();
      });
    }
  }

  void getDropDownJobDetail() async {
    var jobtypecode = jobtypeoption
        .firstWhere((element) => element.description == jobtype.text);
    if (jobtypecode != null) {
      getjobtypecode = jobtypecode.values!;
    }
    var client = http.Client();

    var uri = Uri.parse(
        "${widget.url}/api/Interface/GetDropDownJob?Job_type_code=${getjobtypecode}");

    var response = await client.get(uri);

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

      List<DropDownData> DropDownJobType = parsed
          .map<DropDownData>((json) => DropDownData.fromJson(json))
          .toList();

      setState(() {
        jobdetailoption = DropDownJobType;
        if (timesheet.jobDetail == null) {
          jobdetail.text = jobdetailoption[0].description!;
        } else {
          jobdetail.text = '${timesheet.jobDetail}';
        }
      });
    }
  }

///// load change
  void getDropDowncallbackProject() async {
    var client = http.Client();

    // var uri = Uri.parse(
    //     "${widget.url}/api/Interface/GetDropDownWorkByDepartment?Departmentcode=${Uri.encodeFull(department.text).replaceAll('&', '%26')}");
    //dev-unique.com:9012/

    var uri = Uri.parse(
        "${widget.url}/api/Interface/GetDropDownDepartmentProject?EmpCode=${widget.EmpCode}&Workcode=${project.text}");

    var response = await client.get(uri);

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

      List<DropDownData> DropDownLeave = parsed
          .map<DropDownData>((json) => DropDownData.fromJson(json))
          .toList();

      String setworkcode = "";
      if (timesheet.projectName == null) {
        setworkcode = project.text;
      } else {
        setworkcode = project.text;
      }

      // print(setworkcode);

      String setjobcode = "";
      var workcode = DropDownLeave.where(
          (element) => element.description == department.text).toList();
      if (workcode.length > 0) {
        setjobcode = workcode[0].description!;
      } else {
        setjobcode = DropDownLeave[0].description!;
      }

      var urigetworkcode = Uri.parse(
          "${widget.url}/api/Interface/DropDownJobDataByDepartment?Department=${Uri.encodeFull(department.text).replaceAll('&', '%26')}&Workcode=${project.text}");

      var responsegetworkcode = await client.get(urigetworkcode);

      // print(responsegetworkcode.body);

      if (responsegetworkcode.statusCode == 200) {
        final parsedgetworkcode =
            jsonDecode(responsegetworkcode.body).cast<Map<String, dynamic>>();

        List<DropDownData> DropDownJobType = parsedgetworkcode
            .map<DropDownData>((json) => DropDownData.fromJson(json))
            .toList();

        // var workcode = DropDownJobType.firstWhere(
        //     (element) => element.description == project.text);
        // if (workcode != null) {
        //   setjobcode = workcode.description!;
        // } else {
        //   setjobcode = DropDownJobType[0].description!;
        // }

        setState(() {
          // projectoption = DropDownLeave;

          ///  project.text = setjobcode;
          ///

          departmentoption = DropDownLeave;
          department.text = setjobcode;
          jobdetailoption = DropDownJobType;

          jobdetail.text = jobdetailoption[0].values!;

          // print(jobdetail.text);
        });
      }
    }
  }

  void getDropDowncallbackJobType() async {
    var jobtypecode = jobtypeoption
        .firstWhere((element) => element.description == jobtype.text);
    if (jobtypecode != null) {
      getjobtypecode = jobtypecode.values!;
    }
    var client = http.Client();

    var uri = Uri.parse(
        "${widget.url}/api/Interface/GetDropDownJob?Job_type_code=${getjobtypecode}");

    var response = await client.get(uri);

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

      List<DropDownData> DropDownJobType = parsed
          .map<DropDownData>((json) => DropDownData.fromJson(json))
          .toList();

      setState(() {
        jobdetailoption = DropDownJobType;
        jobdetail.text = jobdetailoption[0].description!;
      });
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
        datetimesheetstart.text = dateOptions[0].values!;
        datetimesheetend.text = dateOptions[0].values!;

        Hours = HoursDefault;
        HoursEnd = HoursEndDefault;
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
    getDropDownProject();
    getDropDownDate();
    super.initState();
    timesheet = widget.timesheetlist;
    EmpCode = widget.EmpCode;

    if (timesheet.jobCode != null) {
      titletimesheet = "แก้ไขเวลางาน";
      viewovernightVisible = false;
      vieweditVisible = true;
      datework = Customdatetext(timesheet.timesheetDate);
    } else {
      titletimesheet = "บันทึกเวลางาน";
      viewovernightVisible = true;
      vieweditVisible = false;
      if (timenow.hour < work_yesterday.inHours ||
          (work_yesterday.inHours == timenow.hour &&
              timenow.minute < work_yesterday.inMinutes.remainder(60))) {
        datework = Selectdate[0].toString();
      } else {
        datework = Selectdate[1].toString();
      }
    }

    if (timesheet.timesheetDate == null) {
      // items = data.map((item) => DropdownMenuItem(child: Text(item['item_name']), value: item['id'].toString())).toList();
      // _mySelection = data[0]["id"];
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
      ;
    }

    if (timesheet.outTime == null) {
      timeend.text = '';
      TextHoursEnd.text = "00";
      TextMinutesEnd.text = "00";
    } else {
      timeend.text =
          '${timesheet.outTime == '00:00' ? '24:00' : timesheet.outTime}';

      TextHoursEnd.text = timeend.text.split(":")[0];
      TextMinutesEnd.text = timeend.text.split(":")[1];
    }

    if (timesheet.remark == null) {
      remark.text = '';
    } else {
      remark.text = '${timesheet.remark}';
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
          Color.fromARGB(255, 8, 165, 53),
          Color.fromARGB(255, 183, 239, 200),
          Color.fromARGB(255, 226, 242, 230),
          Color.fromARGB(255, 255, 255, 255),
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
                            'วันที่ ${datework}',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        )
                      ],
                    ),
                    //บันทึก
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () => Dialogs.materialDialog(
                                msg: 'ท่านต้องการบันทึกข้อมูลใช่หรือไม่?',
                                title: 'ยืนยันข้อมูล',
                                context: context,
                                actions: [
                                  IconsOutlineButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
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
                                      timenow = new DateTime.now();
                                      DateTime _datetimesheetstart =
                                          new DateTime.now();
                                      DateTime _datetimesheetend =
                                          new DateTime.now()
                                              .subtract(Duration(days: 1));

                                      if (datetimesheetstart.text.isNotEmpty &&
                                          datetimesheetend.text.isNotEmpty) {
                                        _datetimesheetstart = DateTime.parse(
                                            datetimesheetstart.text);
                                        _datetimesheetend = DateTime.parse(
                                            datetimesheetend.text);
                                      }

                                      if ((datetimesheetstart.text.isEmpty ||
                                              datetimesheetend.text.isEmpty) ||
                                          (_datetimesheetstart.compareTo(
                                                  _datetimesheetend) >
                                              0)) {
                                        Dialogs.materialDialog(
                                            msg:
                                                'กรุณาตรวจสอบ วันเริ่มต้น และ วันสิ้นสุด ให้ถูกต้อง',
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
                                      } else if ((datework ==
                                              Selectdate[1].toString()) ||
                                          ((datework ==
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
                                        if (datetimesheet.text.isNotEmpty &&
                                            timestart.text.isNotEmpty &&
                                            timeend.text.isNotEmpty &&
                                            project.text.isNotEmpty &&
                                            jobdetail.text.isNotEmpty &&
                                            datetimesheetstart
                                                .text.isNotEmpty &&
                                            datetimesheetend.text.isNotEmpty)
                                          datasavetimesheet();

                                        setState(() {
                                          (datetimesheet.text.isEmpty ||
                                                  timestart.text.isEmpty ||
                                                  timeend.text.isEmpty ||
                                                  project.text.isEmpty ||
                                                  jobdetail.text.isEmpty ||
                                                  datetimesheetstart
                                                      .text.isEmpty ||
                                                  datetimesheetend.text.isEmpty)
                                              ? _validate = true
                                              : _validate = false;
                                        });
                                      } else {
                                        Dialogs.materialDialog(
                                            msg:
                                                'ไม่สามารถบันทึกข้อมูลได้เนื่องจากเกินเวลาที่กำหนด คือ เวลา ${work_yesterday.inHours.toString().padLeft(2, '0')}:${work_yesterday.inMinutes.remainder(60).toString().padLeft(2, '0')} น.',
                                            title: 'ตรวจสอบข้อมูล',
                                            context: context,
                                            actions: [
                                              IconsButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  getlsttimesheet();
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
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            // Visibility(
                            //     visible: viewVisible,
                            //     child: Container(
                            //       child: Text(
                            //           'วันที่เริ่ม : ${datetimesheetstart.text}'),
                            //     )),
                            Text('วันที่เริ่ม'),
                            SizedBox(
                              width: 150,
                              child: DropdownButtonFormField(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  errorText:
                                      _validate ? 'กรุณากรอกข้อมูล' : null,
                                  // suffixIcon: Icon(Icons.keyboard_arrow_down),
                                ),
                                value: datetimesheetstart.text,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: dateOptions
                                    .map((datestart) => DropdownMenuItem(
                                          // alignment: AlignmentDirectional.center,
                                          value: datestart.values,
                                          child: Text(datestart.description!),
                                        ))
                                    .toList(),
                                onChanged: (val) {
                                  setState(() {
                                    datetimesheetstart.text = val.toString();
                                    datetimesheetend.text = val.toString();
                                    timestart.text = "";
                                    timeend.text = "";
                                    TextHours.text = "00";
                                    TextMinutes.text = "00";
                                    TextHoursEnd.text = "00";
                                    TextMinutesEnd.text = "00";

                                    if (datetimesheetstart.text ==
                                        dateOptions[1].values) {
                                      Hours = HoursDefault;
                                      HoursEnd = HoursEndDefault;
                                    } else if (datetimesheetstart.text ==
                                        dateOptions[2].values) {
                                      Hours = HoursBefore;
                                      HoursEnd = HoursAfter;
                                    } else {
                                      Hours = HoursDefault;
                                      HoursEnd = HoursEndDefault;
                                    }
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 15),
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
                                                  child: IconsOutlineButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    text: 'ยกเลิก',
                                                    iconData:
                                                        Icons.cancel_outlined,
                                                    color: Colors.white,
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
                                                                      'เวลาเริ่มงาน คือเวลา 08:30 น. ท่านต้องการเริ่มงานเวลา ${TextHours.text + ':' + TextMinutes.text} น. ใช่หรือไม่?',
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
                                                            timeend.text = "";
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
                                  /*  final TimeOfDay? result =
                                      await showTimePicker(
                                          context: context,
                                          initialTime: timestart.text.isEmpty
                                              ? TimeOfDay.now()
                                              : TimeOfDay(
                                                  hour: int.parse(timestart.text
                                                      .split(':')[0]
                                                      .toString()),
                                                  minute: int.parse(timestart
                                                      .text
                                                      .split(':')[1]
                                                      .toString())),
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
                                                'เวลาเริ่มงาน คือเวลา 08:30 น. ต้องการเริ่มงานเวลา ${result.hour.toString().padLeft(2, '0') + ':' + result.minute.toString().padLeft(2, '0')} น. ใช่หรือไม่',
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
                                  } */
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
                            // Visibility(
                            //     visible: viewVisible,
                            //     child: Container(
                            //       child: Text(
                            //           'วันที่สิ้นสุด : ${datetimesheetend.text}'),
                            //     )),
                            Text('วันที่สิ้นสุด'),
                            SizedBox(
                              width: 150,
                              child: DropdownButtonFormField(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  errorText:
                                      _validate ? 'กรุณากรอกข้อมูล' : null,
                                  // suffixIcon: Icon(Icons.keyboard_arrow_down),
                                ),
                                value: datetimesheetend.text,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: dateOptions
                                    .map((dateend) => DropdownMenuItem(
                                          // alignment: AlignmentDirectional.center,
                                          value: dateend.values,
                                          child: Text(dateend.description!),
                                        ))
                                    .toList(),
                                onChanged: (val) {
                                  setState(() {
                                    datetimesheetend.text = val.toString();
                                    timestart.text = "";
                                    timeend.text = "";
                                    TextHours.text = "00";
                                    TextMinutes.text = "00";
                                    TextHoursEnd.text = "00";
                                    TextMinutesEnd.text = "00";

                                    if (datetimesheetend.text ==
                                        dateOptions[1].values) {
                                      HoursEnd = HoursEndDefault;
                                    } else if (datetimesheetend.text ==
                                        dateOptions[2].values) {
                                      HoursEnd = HoursAfter;
                                    } else {
                                      HoursEnd = HoursEndDefault;
                                    }
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 15),
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
                                  dropdownminout = true;
                                  if (((TextHoursEnd.text == '09') &&
                                          (datetimesheetend.text ==
                                              dateOptions[2].values)) ||
                                      (TextHoursEnd.text == '24')) {
                                    dropdownminout = false;
                                    TextMinutesEnd.text = '00';
                                  } else {
                                    dropdownminout = true;
                                  }
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
                                                "เพิ่มเวลา",
                                                style: Dialogs.titleStyle,
                                              ),
                                            ),
                                            actions: <Widget>[
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
                                                        margin: const EdgeInsets
                                                            .all(2.0),
                                                        // color: Colors.amber[600],
                                                        width: 100.0,
                                                        height: 60.0,
                                                        child:
                                                            DropdownButtonFormField(
                                                          // hint: const Text(''),
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),

                                                            //errorText: _validate
                                                            //    ? 'กรุณากรอกข้อมูล'
                                                            //    : null,
                                                          ),
                                                          value:
                                                              TextHoursEnd.text,
                                                          icon: const Icon(Icons
                                                              .keyboard_arrow_down),
                                                          items: HoursEnd.map((String
                                                                  jobtypeop) =>
                                                              DropdownMenuItem(
                                                                // alignment: AlignmentDirectional.center,
                                                                value:
                                                                    jobtypeop,
                                                                child: Text(
                                                                    jobtypeop),
                                                              )).toList(),
                                                          onChanged: (val) {
                                                            setState(() {
                                                              if (((val ==
                                                                          '09') &&
                                                                      (datetimesheetend
                                                                              .text ==
                                                                          dateOptions[2]
                                                                              .values)) ||
                                                                  (val ==
                                                                      '24')) {
                                                                dropdownminout =
                                                                    false;
                                                                TextMinutesEnd
                                                                        .text =
                                                                    '00';
                                                              } else {
                                                                dropdownminout =
                                                                    true;
                                                              }

                                                              TextHoursEnd
                                                                      .text =
                                                                  val.toString();
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .all(2.0),
                                                        // color: Colors.amber[600],
                                                        width: 100.0,
                                                        height: 60.0,
                                                        child:
                                                            DropdownButtonFormField(
                                                          hint: const Text(
                                                              'เลือกเวลา'),
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                          ),
                                                          value: TextMinutesEnd
                                                              .text,
                                                          icon: const Icon(Icons
                                                              .keyboard_arrow_down),
                                                          items: Miniutes.map((String
                                                                  jobtypeop) =>
                                                              DropdownMenuItem(
                                                                // alignment: AlignmentDirectional.center,
                                                                value:
                                                                    jobtypeop,
                                                                child: Text(
                                                                    jobtypeop),
                                                              )).toList(),
                                                          onChanged:
                                                              dropdownminout
                                                                  ? (val) {
                                                                      setState(
                                                                          () {
                                                                        TextMinutesEnd.text =
                                                                            val.toString();
                                                                      });
                                                                    }
                                                                  : null,
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
                                                        margin: const EdgeInsets
                                                            .all(1.0),
                                                        // color: Colors.amber[600],
                                                        width: 100.0,
                                                        height: 48.0,
                                                        child: Text('ชั่วโมง'),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .all(1.0),
                                                        // color: Colors.amber[600],
                                                        width: 100.0,
                                                        height: 48.0,
                                                        child: Text('นาที'),
                                                      )
                                                    ],
                                                  ),
                                                  Text(''),
                                                  Container(
                                                    padding: EdgeInsets.all(8),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          width: 130.0,
                                                          height: 40.0,
                                                          child:
                                                              IconsOutlineButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  text:
                                                                      'ยกเลิก',
                                                                  iconData: Icons
                                                                      .cancel_outlined,
                                                                  color: Colors
                                                                      .white,
                                                                  textStyle: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                  iconColor:
                                                                      Colors
                                                                          .black),
                                                        ),
                                                        Text('  '),
                                                        Container(
                                                          width: 130.0,
                                                          height: 40.0,
                                                          child: IconsButton(
                                                              onPressed: () {
                                                                if (TextHoursEnd
                                                                        .text
                                                                        .isNotEmpty &&
                                                                    TextMinutesEnd
                                                                        .text
                                                                        .isNotEmpty) {
                                                                  {
                                                                    // if (TextHoursEnd
                                                                    //             .text ==
                                                                    //         '00' &&
                                                                    //     TextMinutesEnd
                                                                    //             .text !=
                                                                    //         '00') {
                                                                    //   // TextHoursEnd
                                                                    //   //     .text = '00';
                                                                    //   // TextMinutesEnd
                                                                    //   //     .text = '00';
                                                                    //   timeend.text = '';
                                                                    // } else

                                                                    // if (int.parse(TextHoursEnd
                                                                    //             .text) >
                                                                    //         17 ||
                                                                    //     (17 ==
                                                                    //             int.parse(TextHoursEnd
                                                                    //                 .text) &&
                                                                    //         int.parse(TextMinutesEnd
                                                                    //                 .text) >
                                                                    //             30)) {
                                                                    //   Dialogs.materialDialog(
                                                                    //       msg:
                                                                    //           'เวลาเลิกงาน คือ เวลา 17:30 น. ต้องการเลิกงานเวลา ${TextHoursEnd.text + ':' + TextMinutesEnd.text} น. ใช่หรือไม่',
                                                                    //       title:
                                                                    //           'ตรวจสอบข้อมูล',
                                                                    //       context:
                                                                    //           context,
                                                                    //       actions: [
                                                                    //         IconsButton(
                                                                    //           onPressed:
                                                                    //               () {
                                                                    //             Navigator.of(context)
                                                                    //                 .pop();

                                                                    //             timeend.text =
                                                                    //                 '';
                                                                    //           },
                                                                    //           text:
                                                                    //               'ไม่',
                                                                    //           iconData:
                                                                    //               Icons
                                                                    //                   .cancel_outlined,
                                                                    //           color: Colors
                                                                    //               .white,
                                                                    //           textStyle:
                                                                    //               TextStyle(
                                                                    //                   color: Colors.black),
                                                                    //           iconColor:
                                                                    //               Colors
                                                                    //                   .black,
                                                                    //         ),
                                                                    //         IconsButton(
                                                                    //           onPressed:
                                                                    //               () {
                                                                    //             Navigator.of(context)
                                                                    //                 .pop();
                                                                    //           },
                                                                    //           text:
                                                                    //               'ใช่',
                                                                    //           iconData:
                                                                    //               Icons
                                                                    //                   .check_circle_outline,
                                                                    //           color: Colors
                                                                    //               .green,
                                                                    //           textStyle:
                                                                    //               TextStyle(
                                                                    //                   color: Colors.white),
                                                                    //           iconColor:
                                                                    //               Colors
                                                                    //                   .white,
                                                                    //         ),
                                                                    //       ]);

                                                                    // } else {
                                                                    timeend.text =
                                                                        '${TextHoursEnd.text}:${TextMinutesEnd.text}';
                                                                    // }

                                                                    //check ห้ามน้อยกว่าเวลาเริ่มงาน
                                                                    if (datetimesheetstart
                                                                            .text ==
                                                                        datetimesheetend
                                                                            .text) {
                                                                      DateTime
                                                                          chktimestart =
                                                                          DateFormat('HH:mm')
                                                                              .parse(timestart.text);
                                                                      if (int.parse(TextHoursEnd.text) <
                                                                              chktimestart
                                                                                  .hour ||
                                                                          (chktimestart.hour == int.parse(TextHoursEnd.text) &&
                                                                              int.parse(TextMinutesEnd.text) < chktimestart.minute)) {
                                                                        Dialogs.materialDialog(
                                                                            // msg:
                                                                            //     'ไม่สามารถเลือก เวลาสิ้นสุด ${TextHoursEnd.text + ':' + TextMinutesEnd.text} น. ก่อนเวลาเริ่มต้น คือ เวลา ${chktimestart.hour.toString().padLeft(2, '0')}.${chktimestart.minute.toString().padLeft(2, '0')} น. ได้',
                                                                            msg: 'กรุณาตรวจสอบเวลาเริ่มต้นและเวลาสิ้นสุดให้ถูกต้อง หรือ หากต้องการบันทึกเวลางานข้ามวัน กรุณาเลือกวันสิ้นสุดให้ถูกต้อง',
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
                                                                        setState(
                                                                            () {
                                                                          timeend.text =
                                                                              "";
                                                                        });
                                                                        //Show Alert
                                                                      } else {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        timeend.text =
                                                                            '${TextHoursEnd.text}:${TextMinutesEnd.text}';
                                                                      }
                                                                    } else {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      timeend.text =
                                                                          '${TextHoursEnd.text}:${TextMinutesEnd.text}';
                                                                    }
                                                                  }
                                                                }
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
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4)),
                                                        ),
                                                        // SizedBox(height: 80),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );

                                  /* final TimeOfDay? result =
                                      await showTimePicker(
                                          context: context,
                                          initialTime: timeend.text.isEmpty
                                              ? TimeOfDay.now()
                                              : TimeOfDay(
                                                  hour: int.parse(timeend.text
                                                      .split(':')[0]
                                                      .toString()),
                                                  minute: int.parse(timeend.text
                                                      .split(':')[1]
                                                      .toString())),
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
                                                'เวลาเลิกงาน คือ เวลา 17:30 น. ต้องการเลิกงานเวลา ${result.hour.toString().padLeft(2, '0') + ':' + result.minute.toString().padLeft(2, '0')} น. ใช่หรือไม่',
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

                                      //check ห้ามน้อยกว่าเวลาเริ่มงาน
                                      if (!isChecked) {
                                        DateTime chktimestart =
                                            DateFormat('hh:mm')
                                                .parse(timestart.text);
                                        if (result.hour < chktimestart.hour ||
                                            (chktimestart.hour == result.hour &&
                                                result.minute <
                                                    chktimestart.minute)) {
                                          Dialogs.materialDialog(
                                              msg:
                                                  'ไม่สามารถเลือก เวลาสิ้นสุด ${result.hour.toString().padLeft(2, '0') + ':' + result.minute.toString().padLeft(2, '0')} น. น้อยกว่าเวลาเริ่มต้น คือ เวลา ${chktimestart.hour}.${chktimestart.minute} น. ได้',
                                              title: 'ตรวจสอบข้อมูล',
                                              context: context,
                                              actions: [
                                                IconsButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    timeend.text = "";
                                                  },
                                                  text: 'ตกลง',
                                                  iconData: Icons
                                                      .check_circle_outline,
                                                  color: Colors.green,
                                                  textStyle: TextStyle(
                                                      color: Colors.white),
                                                  iconColor: Colors.white,
                                                ),
                                              ]);
                                          setState(() {
                                            timeend.text = "";
                                          });
                                          //Show Alert
                                        }
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

                    const SizedBox(height: 15),
                    Text('โครงการ'),
                    DropdownButtonFormField(
                      isExpanded: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        errorText: _validate ? 'กรุณากรอกข้อมูล' : null,
                        // suffixIcon: Icon(Icons.keyboard_arrow_down),
                      ),
                      hint: const Text('เลือกโครงการ'),
                      value: project.text,
                      icon: Icon(Icons.keyboard_arrow_down),
                      items: projectoption
                          .map((DropDownData projectop) => DropdownMenuItem(
                                // alignment: AlignmentDirectional.center,
                                value: projectop.description,
                                child: Text(projectop.description!),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          project.text = val.toString();
                          getDropDowncallbackProject();
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    Text('แผนก'),
                    DropdownButtonFormField(
                      isExpanded: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        errorText: _validate ? 'กรุณากรอกข้อมูล' : null,
                        // suffixIcon: Icon(Icons.keyboard_arrow_down),
                      ),
                      hint: const Text('เลือกแผนก'),
                      value: department.text,
                      icon: Icon(Icons.keyboard_arrow_down),
                      // iconSize: 0.0,
                      items: departmentoption
                          .map((DropDownData departmentop) => DropdownMenuItem(
                                // alignment: AlignmentDirectional.center,
                                value: departmentop.description,
                                child: Text(departmentop.description!),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          department.text = val.toString();
                          getDropDowncallbackProject();
                        });
                      },
                    ),
                    // const SizedBox(height: 15),
                    // Text('แผนก : ${widget.DepCode}'),
                    // const SizedBox(height: 15),
                    // Text('ประเภทงาน'),
                    // DropdownButtonFormField(
                    //   hint: const Text('เลือกประเภทงาน'),
                    //   decoration: InputDecoration(
                    //     border: OutlineInputBorder(),
                    //     errorText: _validate ? 'กรุณากรอกข้อมูล' : null,
                    //   ),
                    //   value: jobtype.text,
                    //   icon: const Icon(Icons.keyboard_arrow_down),
                    //   items: jobtypeoption
                    //       .map((DropDownData jobtypeop) => DropdownMenuItem(
                    //             // alignment: AlignmentDirectional.center,
                    //             value: jobtypeop.description,
                    //             child: Text(jobtypeop.description!),
                    //           ))
                    //       .toList(),
                    //   onChanged: (val) {
                    //     setState(() {
                    //       jobtype.text = val.toString();
                    //       getDropDowncallbackJobType();
                    //     });
                    //   },
                    // ),

                    const SizedBox(height: 15),
                    Text('เนื้องาน'),
                    DropdownButtonFormField(
                      isExpanded: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        errorText: _validate ? 'กรุณากรอกข้อมูล' : null,
                        // suffixIcon: Icon(Icons.keyboard_arrow_down),
                      ),
                      hint: const Text('เลือกรายละเอียด'),
                      value: jobdetail.text,
                      icon: Icon(Icons.keyboard_arrow_down),
                      items: jobdetailoption
                          .map((DropDownData jobdetailtop) => DropdownMenuItem(
                                // alignment: AlignmentDirectional.center,
                                value: jobdetailtop.values,
                                child: Text(jobdetailtop.description!),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          jobdetail.text = val.toString();
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    Text('หมายเหตุ'),
                    TextField(
                      // key: '',
                      controller: remark,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
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
