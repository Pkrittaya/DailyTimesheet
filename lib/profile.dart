import 'package:flutter/material.dart';
import 'package:k2mobileapp/login.dart';
import 'package:k2mobileapp/pages/profile_detail.dart';

class profile extends StatefulWidget {
  final String EmpCode;

  const profile({Key? key, required this.EmpCode}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('ข้อมูลผู้ใช้งาน'),
          // backgroundColor: Color.fromRGBO(114, 41, 34, 1),
        ),
        body: SingleChildScrollView(
          // reverse: true,
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              // mainAxisSize: MainAxisSize.max,
              // mainAxisAlignment: MainAxisAlignment.center,
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
                  child: Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        clipBehavior: Clip.antiAlias,
                        elevation: 0,
                        color: Colors.grey.shade200,
                        child: new InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      profileDetail(EmpCode: widget.EmpCode)),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Icon(Icons.account_circle_outlined),
                                SizedBox(width: 20),
                                Expanded(child: Text('ข้อมูลส่วนตัว')),
                                Icon(Icons.arrow_forward_ios),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(height: 5),
                      // Card(
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(15.0),
                      //   ),
                      //   clipBehavior: Clip.antiAlias,
                      //   elevation: 0,
                      //   color: Colors.grey.shade200,
                      //   child: new InkWell(
                      //     onTap: () {
                      //       print("tapped");
                      //     },
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(16.0),
                      //       child: Row(
                      //         children: [
                      //           Icon(Icons.question_mark),
                      //           SizedBox(width: 20),
                      //           Expanded(child: Text('แจ้งปัญหา')),
                      //           Icon(Icons.arrow_forward_ios),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 5),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        clipBehavior: Clip.antiAlias,
                        elevation: 0,
                        color: Colors.grey.shade200,
                        child: new InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Icon(Icons.logout),
                                SizedBox(width: 20),
                                Expanded(child: Text('ออกจากระบบ')),
                                Icon(Icons.arrow_forward_ios),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
