import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:k2mobileapp/login.dart';
import 'package:k2mobileapp/models/EmployeeData.dart';
import 'package:http/http.dart' as http;

class profileDetail extends StatefulWidget {
  final String EmpCode;

  const profileDetail({Key? key, required this.EmpCode}) : super(key: key);

  @override
  State<profileDetail> createState() => _profileDetailState();
}

EmployeeData empdata = new EmployeeData(
    empCode: '',
    empCompName: '',
    empDepartmentName: '',
    empName: '',
    empNationality: '',
    empPositionName: '');

class _profileDetailState extends State<profileDetail> {
  void GetEmpProfile() async {
    var client = http.Client();
    var uri = Uri.parse(
        "https://dev-unique.com:9012/api/Interface/GetEmployeeData?EmpCode=${widget.EmpCode}");
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

  @override
  void initState() {
    GetEmpProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('ข้อมูลส่วนตัว'),
          // backgroundColor: Color.fromRGBO(114, 41, 34, 1),
        ),
        body: SingleChildScrollView(
          // reverse: true,
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              // mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 115,
                  width: 115,
                  child: Stack(
                    fit: StackFit.expand,
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.amber,
                        backgroundImage: NetworkImage(
                            'https://www.woolha.com/media/2020/03/eevee.png'),
                      ),
                      // Positioned(
                      //   right: -16,
                      //   bottom: 0,
                      //   child: SizedBox(
                      //     height: 46,
                      //     width: 46,
                      //     child: TextButton(
                      //       style: TextButton.styleFrom(
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(50),
                      //           side: BorderSide(color: Colors.white),
                      //         ),
                      //         primary: Colors.white,
                      //         backgroundColor: Color(0xFFF5F6F9),
                      //       ),
                      //       onPressed: () {},
                      //       // child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
                      //       child: Icon(
                      //         Icons.photo_camera,
                      //         color: Colors.black,
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  child: Table(
                    columnWidths: {
                      0: FlexColumnWidth(0.5),
                      // 1: FlexColumnWidth(4),
                    },
                    children: [
                      TableRow(children: [
                        Text("ชื่อ"),
                        Text("${empdata.empName}"),
                      ]),
                      TableRow(children: [
                        Text("รหัสพนักงาน"),
                        Text("${empdata.empCode}"),
                      ]),
                      TableRow(children: [
                        Text("ตำแหน่ง"),
                        Text("${empdata.empPositionName}"),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
