import 'package:floorball/selected_season_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:floorball/api/models/season_info.dart';
import 'package:go_router/go_router.dart';

import 'package:floorball/ui/views/landing/landing_page.dart';
import 'package:floorball/ui/views/season_selector/season_selector_page.dart';

class MainAppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool showBottomNavigation;
  final bool isHomePage;
  final bool isSeasonPicker;

  const MainAppScaffold({
    super.key,
    required this.title,
    required this.body,
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
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
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
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              _buildBottomNavItem(
                icon: Icons.home,
                isEnabled: !isHomePage,
                onTap: isHomePage
                    ? null
                    : () => context.go(LandingPage.routePath),
              ),
              _buildBottomNavItem(
                icon: Icons.date_range,
                isEnabled: !isSeasonPicker,
                onTap: isSeasonPicker
                    ? null
                    : () => context.go(SeasonSelectorPage.routePath),
              ),
              const Spacer(),
              BlocBuilder<SelectedSeasonCubit, SeasonInfo?>(
                builder: (_, state) => _SeasonIndicator(state),
              ),
            ],
          ),
        ),
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
}

class _SeasonIndicator extends StatelessWidget {
  const _SeasonIndicator(this.selectedSeason);
  final SeasonInfo? selectedSeason;

  @override
  Widget build(BuildContext context) {
    if (selectedSeason == null) {
      return const SizedBox(width: 60, height: 60);
    }

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
  }
}
