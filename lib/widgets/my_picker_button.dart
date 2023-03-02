import 'package:flutter/material.dart';

class MyPickerButton extends StatelessWidget {
  final String label;
  final String text;
  final VoidCallback onPressed;

  const MyPickerButton({
    Key? key,
    required this.label,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            //padding: const EdgeInsets.all(2.0),
            minimumSize: const Size(100.0, 40.0),
          ),
          child: SizedBox(
            width: 70.0,
            child: Row(
              children: [
                Expanded(child: Text(text)),
                const Icon(
                  Icons.access_time,
                  size: 16.0,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
