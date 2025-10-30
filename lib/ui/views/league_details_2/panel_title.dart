import 'package:flutter/material.dart';

class PanelTitle extends StatelessWidget {
  const PanelTitle({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
}
