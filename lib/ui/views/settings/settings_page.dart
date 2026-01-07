import 'package:floorball/ui/main_app_scaffold.dart';
import 'package:floorball/ui/views/settings/nav_app_setting.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  static const String routePath = '/settings';

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainAppScaffold(
      title: 'Einstellungen',
      showBackButton: true,
      body: _buildSettingsList(),
      isSettings: true,
    );
  }

  Widget _buildSettingsList() {
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Navigation',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        NavAppSetting(),
        const Divider(height: 1),
      ],
    );
  }
}
