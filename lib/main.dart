import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:k2mobileapp/login.dart';
import 'package:k2mobileapp/theme.dart';

void main() {
  String? myurl = Uri.base.toString(); //get complete url
  String? para1 =
      Uri.base.queryParameters["para1"]; //get parameter with attribute "para1"

  runApp(MyApp(myurl: myurl, para1: para1)); //pass to MyApp class
}

class MyApp extends StatelessWidget {
  String? myurl, para1;
  MyApp({Key? key, this.myurl, this.para1}) : super(key: key);

  //con MyApp({this.myurl, this.para1});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [const Locale('en'), const Locale('th', 'TH')],
      title: 'Daily Timesheet',
      theme: basicTheme(),
      home: Login(myurl: myurl, para1: para1),
    );
  }
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}


// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
