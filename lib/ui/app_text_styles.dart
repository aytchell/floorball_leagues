import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle get federationLoadingError =>
      TextStyle(fontSize: 18, color: Colors.grey);

  static TextStyle get federationName =>
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black);

  static TextStyle get gameCardResultFont => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.blue.shade700,
  );

  static TextStyle get gameCardTeamFont =>
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black);

  static TextStyle get gameDayTitleExpanded => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.blue[700],
  );

  static TextStyle get gameDayTitleCollapsed => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static TextStyle get gameDaySubTitleExpanded => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.blue[700],
  );

  static TextStyle get gameDaySubTitleCollapsed => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static TextStyle get gameSubDayTitle => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static TextStyle get gameSubDaySubTitle => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );
}
