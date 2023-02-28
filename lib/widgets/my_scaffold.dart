import 'package:flutter/material.dart';
import 'package:k2mobileapp/login.dart';

class MyScaffold extends StatelessWidget {
  final Widget child;
  final String empCode;
  final String empName;

  const MyScaffold({
    Key? key,
    required this.child,
    required this.empCode,
    required this.empName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Color.fromARGB(255, 165, 29, 8),
              Color.fromARGB(255, 165, 29, 8),
              Color.fromARGB(255, 165, 29, 8),
              Color.fromARGB(255, 165, 29, 8),
              Color.fromARGB(255, 165, 29, 8),
              Color.fromARGB(255, 165, 29, 8),
              Color.fromARGB(255, 165, 29, 8),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                        const Text(
                          'บันทึกเวลาทำงาน',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const Text(
                          'สำหรับรายวัน',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 14),
                            padding: EdgeInsets.zero,
                            alignment: Alignment.centerLeft,
                            // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          icon: const Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'ออกจากระบบ',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Center(
                          child: Text(
                            '$empCode  $empName',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
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
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.all(10),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
