import 'package:flutter/material.dart';
import 'package:k2mobileapp/widgets/my_scaffold.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      empCode: '[empCode]',
      empName: '[empName]',
      child: Container(
        color: Colors.pink,
      ),
    );
  }
}
