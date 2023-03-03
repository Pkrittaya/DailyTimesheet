import 'package:flutter/material.dart';
import 'package:k2mobileapp/login.dart';

class MyScaffold extends StatelessWidget {
  final String empCode;
  final String? empName;
  final Widget? child;
  final Widget? actionButton;

  const MyScaffold({
    Key? key,
    required this.empCode,
    required this.empName,
    this.child,
    this.actionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 28.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'บันทึกเวลาทำงาน',
                        style: titleStyle!.copyWith(
                          fontSize: 22.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(empCode, style: titleStyle),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('สำหรับรายวัน', style: titleStyle),
                      Text(empName ?? '', style: titleStyle),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 14),
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                        ),
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        label: Text('ออกจากระบบ', style: titleStyle),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ),
                          );
                        },
                      ),
                      if (actionButton != null) actionButton!,
                    ],
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  /*borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),*/
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 0.0),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
