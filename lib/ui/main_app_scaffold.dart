import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../api_models/entry_info.dart';

class MainAppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final SeasonInfo? selectedSeason;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool showBottomNavigation;
  final bool isHomePage;
  final bool isSeasonPicker;

  const MainAppScaffold({
    super.key,
    required this.title,
    required this.body,
    required this.selectedSeason,
    this.actions,
    this.showBackButton = false,
    this.showBottomNavigation = true,
    this.isHomePage = false,
    this.isSeasonPicker = false,
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
      body: body,
      bottomNavigationBar: showBottomNavigation
          ? _buildBottomNavigationBar(context)
          : null,
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildBottomNavItem(
            icon: Icons.home,
            isEnabled: !isHomePage,
            onTap: isHomePage ? null : () => _navigateToHome(context),
          ),
          _buildBottomNavItem(
            icon: Icons.date_range,
            isEnabled: !isSeasonPicker,
            onTap: isSeasonPicker ? null : () => _navigateToSeasons(context),
          ),
          const Spacer(),
          _buildSeasonIndicator(),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem({
    required IconData icon,
    required bool isEnabled,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 60,
        height: 60,
        child: Icon(
          icon,
          color: isEnabled ? Colors.blue[600] : Colors.grey[400],
          size: 24,
        ),
      ),
    );
  }

  Widget _buildSeasonIndicator() {
    if (selectedSeason != null) {
      return InkWell(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 60,
          height: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: selectedSeason!.name
                .split('/')
                .map(
                  (year) => Text(
                    year,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: (selectedSeason!.current)
                          ? Colors.black
                          : Colors.red,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      );
    } else {
      return const SizedBox(width: 60, height: 60);
    }
  }

  void _navigateToHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  void _navigateToSeasons(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/seasons', (route) => false);
  }
}
