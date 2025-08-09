// main_app_scaffold.dart
import 'package:flutter/material.dart';

class MainAppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? drawer;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool showBottomNavigation;

  const MainAppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.drawer,
    this.actions,
    this.showBackButton = false,
    this.showBottomNavigation = true,
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
      bottomNavigationBar: showBottomNavigation ? _buildBottomNavigationBar() : null,
    );
  }

  Widget _buildBottomNavigationBar() {
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
            onTap: () {
              // TODO: Add home navigation functionality
            },
          ),
          _buildBottomNavItem(
            icon: Icons.date_range,
            onTap: () {
              // TODO: Add date range functionality
            },
          ),
          Spacer(), // Pushes icons to the left
        ],
      ),
    );
  }

  Widget _buildBottomNavItem({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 60,
        height: 60,
        child: Icon(
          icon,
          color: Colors.blue[600],
          size: 24,
        ),
      ),
    );
  }
}
