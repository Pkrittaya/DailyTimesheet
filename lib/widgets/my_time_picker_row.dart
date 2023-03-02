import 'package:flutter/material.dart';
import 'package:k2mobileapp/widgets/my_picker_button.dart';

class MyTimePickerRow extends StatelessWidget {
  final String labelStart;
  final String labelEnd;
  final String textStart;
  final String textEnd;
  final VoidCallback onPressedStart;
  final VoidCallback onPressedEnd;

  const MyTimePickerRow({
    Key? key,
    required this.labelStart,
    required this.labelEnd,
    required this.textStart,
    required this.textEnd,
    required this.onPressedStart,
    required this.onPressedEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MyPickerButton(
          label: labelStart,
          text: textStart,
          onPressed: onPressedStart,
        ),
        const SizedBox(width: 16.0),
        MyPickerButton(
          label: labelEnd,
          text: textEnd,
          onPressed: onPressedEnd,
        ),
        const SizedBox(width: 16.0),
      ],
    );
  }
}
