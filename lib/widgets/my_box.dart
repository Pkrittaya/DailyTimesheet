import 'package:flutter/material.dart';

class MyBox extends StatelessWidget {
  final String title;
  final Widget child;
  final Color? borderColor;

  const MyBox({
    Key? key,
    required this.title,
    required this.child,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: 2.0),
        Container(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 16.0,
            top: 16.0,
          ),
          decoration: BoxDecoration(
            border: borderColor != null
                ? Border.all(color: borderColor!)
                : Border.all(),
            borderRadius: const BorderRadius.all(
              Radius.circular(4),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [child],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
