import 'package:flutter/material.dart';

class PanelTitle extends StatelessWidget {
  const PanelTitle({
    super.key,
    required this.text,
    this.bold = true,
    this.color = Colors.black87,
  });

  final String text;
  final Color color;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
          color: color,
        ),
      ),
    );
  }
}
