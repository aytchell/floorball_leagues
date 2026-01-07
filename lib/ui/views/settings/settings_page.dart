import 'package:floorball/ui/main_app_scaffold.dart';
import 'package:floorball/ui/views/settings/nav_app_setting.dart';
import 'package:floorball/utils/navigation_utils.dart';
import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';

class SettingsPage extends StatefulWidget {
  static const String routePath = '/settings';

  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<AvailableMap> _availableNavigationApps = [];
  AvailableMap? selectedNavigationApp;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAvailableNavigationApps();
  }

  Future<void> _loadAvailableNavigationApps() async {
    final apps = await getAvailableNavigations();
    setState(() {
      _availableNavigationApps = apps;
      _isLoading = false;
      // Set default to first available app if not already set
      if (selectedNavigationApp == null && apps.isNotEmpty) {
        selectedNavigationApp = apps.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainAppScaffold(
      title: 'Einstellungen',
      showBackButton: true,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildSettingsList(),
      isSettings: true,
    );
  }

  Widget _buildSettingsList() {
    if (_availableNavigationApps.isEmpty) {
      return const Center(child: Text('Keine Navigations-Apps gefunden'));
    }

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

  String _getSelectedAppName() {
    final selectedApp = _availableNavigationApps.firstWhere(
      (app) => app.mapType == selectedNavigationApp?.mapType,
      orElse: () => _availableNavigationApps.first,
    );
    return selectedApp.mapName;
  }
}
