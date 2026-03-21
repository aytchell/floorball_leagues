import 'package:floorball/ui/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionInfo extends StatefulWidget {
  const VersionInfo({super.key});
  final String gitHash = const String.fromEnvironment('git_hash');

  @override
  State<StatefulWidget> createState() => _VersionInfoState();
}

class _VersionInfoState extends State<VersionInfo> {
  PackageInfo? _appInfo;

  static const enDash = '\u2013';

  @override
  void initState() {
    super.initState();
    _fetchAppInfo();
  }

  @override
  Widget build(BuildContext context) {
    if (_appInfo == null) {
      return SizedBox();
    } else {
      final sep = '  $enDash  ';
      final version = 'Version ${_appInfo!.version}';
      final build = '${sep}build ${_appInfo!.buildNumber}';
      final gitHash = (widget.gitHash.isEmpty) ? '' : '$sep ${widget.gitHash}';
      return Text('$version$build$gitHash', style: TextStyles.aboutVersionText);
    }
  }

  Future<void> _fetchAppInfo() async {
    final appInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appInfo = appInfo;
    });
  }
}
