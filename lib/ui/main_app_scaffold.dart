// main_app_scaffold.dart
import 'package:flutter/material.dart';

class MainAppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? drawer;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool showBottomNavigation;
  final bool isHomePage;

  const MainAppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.drawer,
    this.actions,
    this.showBackButton = false,
    this.showBottomNavigation = true,
    this.isHomePage = false,
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
            offset: Offset(0, -2),
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
            isEnabled: true,
            onTap: () => _navigateToSeasons(context),
          ),
          Spacer(), // Pushes icons to the left
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
      child: Container(
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

  void _navigateToHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  void _navigateToSeasons(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/seasons', (route) => false);
  }
}
