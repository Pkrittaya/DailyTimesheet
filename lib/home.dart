import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:k2mobileapp/login.dart';
import 'package:k2mobileapp/models/TimesheetData.dart';
import 'package:k2mobileapp/pages/employee_list.dart';
import 'package:k2mobileapp/pages/manpower_list.dart';
import 'package:k2mobileapp/pages/timesheet.dart';
import 'package:k2mobileapp/profile.dart';
import 'package:k2mobileapp/theme.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

class homepage extends StatefulWidget {
  final List<TimesheetData> listtimesheet;
  final int index;
  final String EmpCode;
  final String ShowPopup;
  final String url;

  const homepage(
      {Key? key,
      required this.listtimesheet,
      required this.index,
      required this.EmpCode,
      required this.ShowPopup,
      required this.url})
      : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

ThemeData appTheme = ThemeData(
  primaryColor: Color.fromRGBO(114, 41, 34, 1),
  /* Colors.tealAccent,*/
  secondaryHeaderColor: Colors.blue /* Colors.teal*/,
  fontFamily: 'Kanit',
);

int sel = 0;

class _homepageState extends State<homepage> {
  int index = 0;
  @override
  void initState() {
    super.initState();
    //getlsttimesheet();
    // _data = widget.listtimesheet;
    index = widget.index;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.ShowPopup == "1") {
        Dialogs.materialDialog(
            msg:
                'กรุณากรอกข้อมูลที่เป็นจริงเท่านั้น\nหากทางบริษัทตรวจสอบและพบว่า\nข้อมูลที่ท่านบันทึกในระบบเป็นเท็จ\nทางบริษัทจะมีบทลงโทษในลำดับถัดไป',
            title: 'แจ้งเตือน',
            context: context,
            actions: [
              IconsButton(
                onPressed: () async {
                  Navigator.of(context).pop();
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

  late TabController _tabController;

  int _selectedTab = 0;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screen = [
      ManpowerList(
        index: widget.index,
        listtimesheet: widget.listtimesheet,
        EmpCode: widget.EmpCode,
        url: widget.url,
      ),
    ];

    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Tab Demo"),
      // ),
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: currentIndex,
        children: screen,
      ),
    );
  }
}
