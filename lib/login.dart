import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:k2mobileapp/home.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

class Login extends StatefulWidget {
  static const String id = 'mentor sample 1';
  final String? myUrl, para1;

  const Login({Key? key, this.myUrl, this.para1}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with WidgetsBindingObserver {
  bool _validate = false;

  TextEditingController controllerUser = TextEditingController();
  TextEditingController controllerPwd = TextEditingController();
  var webConfig = "";

  bool flag = false;
  var _empCode = '';
  var _showPopup = '';

  loadJson() async {
    String data = await rootBundle.loadString('assets/config.json');
    final parsedJson = jsonDecode(data);
    webConfig = parsedJson['WebAPIConfig'];
  }

  void validateLogin() async {
    try {
      String showPopUp = "";
      String username = "";
      String authEncode = _authAPI(username, controllerPwd.text);
      var baseUrl =
          "$webConfig/api/Interface/GetLogOn?Username=${controllerUser.text}&Password=${controllerPwd.text}";
      final res = await http.get(
        Uri.parse(baseUrl),
      );

      if (res.statusCode == 200) {
        final parsedJson = jsonDecode(res.body);

        if (parsedJson['type'] == "S") {
          flag = true;
          if (parsedJson['typeCode'] == "S001") {
            showPopUp = "1";
          }
          username = parsedJson['description'];
        } else {
          flag = false;
        }
      } else {
        flag = false;
      }

      setState(() {
        if (res.statusCode == 200) {
          final parsedJson = jsonDecode(res.body);
          if (parsedJson['type'] == "S") {
            flag = true;
            _empCode = username;
            _showPopup = showPopUp;
            loadPage();
          } else {
            flag = false;

            Dialogs.materialDialog(
                msg: 'login ไม่สำเร็จ',
                title: 'ตรวจสอบข้อมูล',
                context: context,
                actions: [
                  IconsButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    text: 'ตกลง',
                    iconData: Icons.check_circle_outline,
                    color: Colors.green,
                    textStyle: const TextStyle(color: Colors.white),
                    iconColor: Colors.white,
                  ),
                ]);
          }
        } else {
          flag = false;
        }
      });
    } catch (err) {
      flag = false;
      print('Something went wrong');
    }
  }

  void validateToken() async {
    try {
      var baseUrl = "https://dev-unique.com:9018/api/Interface/GetUserByToken";

      Map<String, String> body = {
        'method': widget.para1!,
      };
      print(json.encode(body));
      var username = '';
      final res = await http.post(Uri.parse(baseUrl),
          headers: {"Content-Type": "application/json"},
          body: json.encode(body));

      if (res.statusCode == 200) {
        final parsedJson = jsonDecode(res.body);

        if (parsedJson['code'] == "200") {
          flag = true;

          username = parsedJson['messages'];
        } else {
          flag = false;
        }
      } else {
        flag = false;
      }

      setState(() {
        if (res.statusCode == 200) {
          final parsedJson = jsonDecode(res.body);

          if (parsedJson['code'] == "200") {
            flag = true;
            _empCode = username;

            loadPage();
          }
        } else {
          flag = false;
        }
      });
    } catch (err) {
      flag = false;
      print('Something went wrong');
    }
  }

  String _authAPI(username, password) {
    String base64Encode = '$username:$password';
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(base64Encode);
    String basicAuth = 'Basic $encoded';

    return basicAuth;
  }

  bool _isObscure = true;

  void loadPage() async {
    //var client = http.Client();
    DateTime newDate = DateTime.now();

    Duration workYesterday = const Duration(hours: 9, minutes: 00);

    if ((newDate.hour < workYesterday.inHours) ||
        ((newDate.hour == workYesterday.inHours) &&
            (newDate.minute <= workYesterday.inMinutes.remainder(60)))) {
      newDate = DateTime.now().add(const Duration(days: -1));
    } else {
      newDate = DateTime.now();
    }

    //String formattedDate = DateFormat('yyyy-MM-dd').format(newDate);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => homepage(
          index: 1,
          listtimesheet: const [],
          EmpCode: _empCode,
          ShowPopup: _showPopup,
          url: webConfig,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadJson();

    if (widget.para1 != null || widget.para1 != '') validateToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
            ],
          ),
        ),
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
                    child: Image.asset(
                      'assets/images/Logo.png',
                      width: 500,
                      height: 150,
                    ),
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
                    topRight: Radius.circular(60),
                  ),
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
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom:
                                        BorderSide(color: Colors.grey.shade200),
                                  ),
                                ),
                                child: TextField(
                                  controller: controllerUser,
                                  decoration: InputDecoration(
                                    hintText: "ชื่อผู้ใช้งาน",
                                    hintStyle:
                                        const TextStyle(color: Colors.grey),
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
                                          color: Colors.grey.shade200),
                                    ),
                                  ),
                                  child: TextField(
                                    controller: controllerPwd,
                                    obscureText: _isObscure,
                                    decoration: InputDecoration(
                                      // labelText: 'Password',
                                      hintText: "รหัสผ่าน",
                                      hintStyle:
                                          const TextStyle(color: Colors.grey),
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
                                  controllerUser.text.isNotEmpty) {
                                validateLogin();
                              }

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
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 50,
                                  vertical: 10,
                                ),
                                textStyle: const TextStyle(fontSize: 18)),
                            child: const Text('เข้าสู่ระบบ'),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Version 0.2.0',
                          style: TextStyle(color: Colors.grey),
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
