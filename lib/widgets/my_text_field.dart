import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLines;
  final void Function(String)? onChanged;
  final void Function()? onTap;

  const MyTextField({
    Key? key,
    required this.controller,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding,
    this.maxLines = 1,
    this.onChanged,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
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
      onTap: onTap,
    );
  }
}
