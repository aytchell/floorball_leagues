// main_app_scaffold.dart
import 'package:flutter/material.dart';

class MainAppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? drawer;
  final List<Widget>? actions;
  final bool showBackButton;

  const MainAppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.drawer,
    this.actions,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, maxLines: 2),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        automaticallyImplyLeading: showBackButton,
        actions: actions,
      ),
      drawer: drawer,
      body: body,
    );
  }
}
