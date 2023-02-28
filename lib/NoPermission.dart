import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:k2mobileapp/login.dart';
import 'package:k2mobileapp/theme.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

class nopermission extends StatefulWidget {
  final String EmpCode;

  const nopermission({Key? key, required this.EmpCode}) : super(key: key);

  @override
  State<nopermission> createState() => _nopermissionState();
}

ThemeData appTheme = ThemeData(
  primaryColor: Color.fromRGBO(114, 41, 34, 1),
  /* Colors.tealAccent,*/
  secondaryHeaderColor: Colors.blue /* Colors.teal*/,
  fontFamily: 'Kanit',
);

int sel = 0;

class _nopermissionState extends State<nopermission> {
  int index = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ไม่มีสิทธิ์'),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.logout,
                size: 30,
              ),
              // tooltip: 'Show Snackbar',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: Center(
            child: Text(
                'คุณไม่มีสิทธิ์ในหน้า Page กรุณาติดต่อ Admin ผู้ดูแลระบบ')));
  }
}
