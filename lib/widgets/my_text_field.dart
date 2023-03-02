import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final Widget? prefixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLines;
  final void Function(String)? onChanged;

  const MyTextField({
    Key? key,
    required this.controller,
    this.hintText,
    this.prefixIcon,
    this.contentPadding,
    this.maxLines = 1,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(
              vertical: 2.0,
              horizontal: prefixIcon == null ? 12.0 : 0.0,
            ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(4.0),
          ),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
