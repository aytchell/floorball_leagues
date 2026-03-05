import 'package:flutter/material.dart';
import 'package:floorball/ui/main_app_scaffold.dart';

class HistoryPage extends StatelessWidget {
  static const routePath = '/history';

  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainAppScaffold(
      title: 'Zuletzt angesehen',
      isHistoryPage: true,
      body: Center(child: Text('History Page - Coming Soon')),
    );
  }
}
