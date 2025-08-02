import 'package:flutter/material.dart';

class CustomTextTheme extends TextTheme {
    final gameCardTeamFont = TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black);
}

class AppTextTheme {
    static final theme = CustomTextTheme();
}
