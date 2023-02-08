import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:k2mobileapp/example/datepicker.dart';
import 'package:k2mobileapp/example/expandable-demo.dart';
import 'package:k2mobileapp/example/expandable.dart';
import 'package:k2mobileapp/home.dart';
import 'package:k2mobileapp/models/TimesheetData.dart';
import 'package:k2mobileapp/pages/timesheet.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'main.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  static const String id = 'mentor sample 1';
  String? myurl, para1;
  Login({Key? key, this.myurl, this.para1}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with WidgetsBindingObserver {
  bool _validate = false;

  TextEditingController controllerUser = TextEditingController();
  TextEditingController controllerPwd = TextEditingController();
  var webconfig = "";
  var _domain = r"Unique\";

  bool Flag = false;
  var _Emp_code = '';
  var _Showpopup = '';

  loadJson() async {
    String data = await rootBundle.loadString('assets/config.json');
    final parsedJson = jsonDecode(data);
    webconfig = parsedJson['WebAPIConfig'];

    // return parsedJson['WebAPIConfig'];
  }

  void ValidateLogIn() async {
    try {
      String ShowPopUp = "";
      String UserName = ""; //_domain + controllerUser.text;
      String _authEncode = _authAPI(UserName, controllerPwd.text);
      var _baseUrl =
          "${webconfig}/api/Interface/GetLogOn?Username=${controllerUser.text}&Password=${controllerPwd.text}";
      final res = await http.get(
        Uri.parse("$_baseUrl"),
        // headers: <String, String>{'authorization': _authEncode},
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        //   print(res.body);

        final parsedJson = jsonDecode(res.body);
        // print(parsedJson['description']);
        // remark.text = parsedJson['type'];
        // remark.text = parsedJson['description'];

        if (parsedJson['type'] == "S") {
          Flag = true;
          if (parsedJson['typeCode'] == "S001") {
            ShowPopUp = "1";
          }
          UserName = parsedJson['description'];
          // getlsttimesheet();
        } else {
          Flag = false;
        }

        //  var sessionManager = SessionManager();
        //   var at = await sessionManager.get("authorization");
        //   await sessionManager.set("authorization", _authEncode);
        //  await sessionManager.set("username", controllerUser.text);
        //   await sessionManager.set("password", controllerPwd.text);

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => homepage()),
        // );
      } else {
        Flag = false;
      }

      setState(() {
        if (res.statusCode == 200) {
          final jsonData = json.decode(res.body);
          //   print(res.body);

          final parsedJson = jsonDecode(res.body);
          // print(parsedJson['description']);
          // remark.text = parsedJson['type'];
          // remark.text = parsedJson['description'];
          if (parsedJson['type'] == "S") {
            Flag = true;
            _Emp_code = UserName;
            _Showpopup = ShowPopUp;
            getlsttimesheet();
          } else {
            Flag = false;

            Dialogs.materialDialog(
                msg: 'login ไม่สำเร็จ',
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
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => homepage()),
          // );
        } else {
          Flag = false;
        }
      });
    } catch (err) {
      Flag = false;
      print('Something went wrong');
    }
  }

  void ValidateToken() async {
    try {
      var _baseUrl = "https://dev-unique.com:9018/api/Interface/GetUserByToken";

      Map<String, String> body = {
        'method': '${widget.para1!}',
      };
      print(json.encode(body));
      var UserName = '';
      final res = await http.post(Uri.parse("${_baseUrl}"),
          headers: {"Content-Type": "application/json"},
          body: json.encode(body));

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        //   print(res.body);

        final parsedJson = jsonDecode(res.body);
        // print(parsedJson['description']);
        // remark.text = parsedJson['type'];
        // remark.text = parsedJson['description'];

        if (parsedJson['code'] == "200") {
          Flag = true;

          UserName = parsedJson['messages'];
          // getlsttimesheet();
        } else {
          Flag = false;
        }

        //  var sessionManager = SessionManager();
        //   var at = await sessionManager.get("authorization");
        //   await sessionManager.set("authorization", _authEncode);
        //  await sessionManager.set("username", controllerUser.text);
        //   await sessionManager.set("password", controllerPwd.text);

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => homepage()),
        // );
      } else {
        Flag = false;
      }

      setState(() {
        if (res.statusCode == 200) {
          final jsonData = json.decode(res.body);
          //   print(res.body);

          final parsedJson = jsonDecode(res.body);
          // print(parsedJson['description']);
          // remark.text = parsedJson['type'];
          // remark.text = parsedJson['description'];
          if (parsedJson['code'] == "200") {
            Flag = true;
            _Emp_code = UserName;
            // _Showpopup = ShowPopUp;
            getlsttimesheet();
          }
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => homepage()),
          // );
        } else {
          Flag = false;
        }
      });
    } catch (err) {
      Flag = false;
      print('Something went wrong');
    }
  }

  String _authAPI(_username, _password) {
    String _baase64encode = '${_username}:${_password}';
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(_baase64encode);
    String basicAuth = 'Basic ${encoded}';

    return basicAuth;
  }

  bool _isObscure = true;
  void getlsttimesheet() async {
    var client = http.Client();
    DateTime NewDate = DateTime.now();

    Duration work_yesterday = Duration(hours: 9, minutes: 00);

    if ((NewDate.hour < work_yesterday.inHours) ||
        ((NewDate.hour == work_yesterday.inHours) &&
            (NewDate.minute <= work_yesterday.inMinutes.remainder(60)))) {
      NewDate = DateTime.now().add(new Duration(days: -1));
    } else {
      NewDate = DateTime.now();
    }

    String formattedDate = DateFormat('yyyy-MM-dd').format(NewDate);

    formattedDate = '2022-11-08';

    var uri = Uri.parse(
        "${webconfig}/api/Interface/GetListTimesheeet?Emp_Code=${_Emp_code}&dataTime=${formattedDate}");
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
                EmpCode: _Emp_code,
                ShowPopup: _Showpopup,
                url: webconfig)),
      );
    }
  }

  @override
  void initState() {
    loadJson();

    if (widget.para1 != null || widget.para1 != '') ValidateToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          // Color.fromRGBO(94, 33, 35, 1),
          // Color.fromRGBO(118, 41, 40, 1),
          // Color.fromRGBO(120, 42, 33, 1),
          Color.fromARGB(255, 255, 255, 255),
          Color.fromARGB(255, 255, 255, 255),
          Color.fromARGB(255, 255, 255, 255),
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            // #login, #welcome
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset('assets/images/Logo.png',
                        width: 500, height: 150),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60)),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        // #email, #password
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(171, 171, 171, .7),
                                  blurRadius: 20,
                                  offset: Offset(0, 10)),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200)),
                                ),
                                child: TextField(
                                  controller: controllerUser,
                                  decoration: InputDecoration(
                                    hintText: "ชื่อผู้ใช้งาน",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                    errorText: _validate
                                        ? 'กรุณากรอกข้อมูล ข้อมูลห้ามเป็นค่าว่าง'
                                        : null,
                                  ),
                                ),
                              ),
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.shade200)),
                                  ),
                                  child: TextField(
                                    controller: controllerPwd,
                                    obscureText: _isObscure,
                                    decoration: InputDecoration(
                                      // labelText: 'Password',
                                      hintText: "รหัสผ่าน",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                      suffixIcon: IconButton(
                                          icon: Icon(_isObscure
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                          onPressed: () {
                                            setState(() {
                                              _isObscure = !_isObscure;
                                            });
                                          }),
                                      errorText: _validate
                                          ? 'กรุณากรอกข้อมูล ข้อมูลห้ามเป็นค่าว่าง'
                                          : null,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          height: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 50),
                          child: ElevatedButton(
                            onPressed: () {
                              if (controllerPwd.text.isNotEmpty &&
                                  controllerUser.text.isNotEmpty)
                                ValidateLogIn();

                              setState(() {
                                (controllerPwd.text.isEmpty ||
                                        controllerUser.text.isEmpty)
                                    ? _validate = true
                                    : _validate = false;
                              });
                              //  Navigator.push(
                              //    context,
                              //    MaterialPageRoute(
                              //       builder: (context) => Timesheet()),
                              //  );
                            },
                            child: Text(
                              'เข้าสู่ระบบ',
                              style: GoogleFonts.getFont('Kanit'),
                            ),
                            style: ElevatedButton.styleFrom(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(50),
                                ),
                                primary: Color.fromRGBO(114, 41, 34, 1),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 10),
                                textStyle: TextStyle(
                                  fontSize: 18,
                                )),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Version 0.2.0',
                          style: TextStyle(
                            // fontSize: 40,
                            color: Colors.grey,
                          ),
                        ),
                        // #login SNS
                        // const Text(
                        //   "ลืมรหัสผ่าน ใช่หรือไม่?",
                        //   style: TextStyle(
                        //       color: Colors.grey, fontWeight: FontWeight.bold),
                        // ),
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
}
