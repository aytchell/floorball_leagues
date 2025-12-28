import 'package:flutter/material.dart';

class PanelTitle extends StatelessWidget {
  const PanelTitle({super.key, required this.text, required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) =>
      ListTile(title: Text(text, style: style));
}
