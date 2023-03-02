import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final Color? buttonColor;
  final Color textColor;
  final double verticalPadding;
  final TextStyle? textStyle;
  final VoidCallback onPressed;

  static const minimumWidth = 120.0;
  static const defaultPadding = 8.0;

  const MyButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.buttonColor,
    this.textColor = Colors.white,
    this.verticalPadding = defaultPadding,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: buttonColor ?? Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minimumSize: const Size(minimumWidth, 0.0),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: defaultPadding,
          vertical: verticalPadding,
        ),
        child: Text(
          text,
          style: textStyle ??
              Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: textColor),
        ),
      ),
    );
  }
}
