import 'package:floorball/selected_season_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:floorball/api/models/season_info.dart';
import 'package:go_router/go_router.dart';

import 'package:floorball/ui/views/landing/landing_page.dart';
import 'package:floorball/ui/views/season_selector/season_selector_page.dart';

final Color headerGrey = Color.fromARGB(255, 231, 231, 231);
final Color backgroundColor = Color.fromARGB(255, 255, 255, 255);

class MainAppScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget body;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool showBottomNavigation;
  final bool isHomePage;
  final bool isSeasonPicker;

  static const _titleTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w700,
    fontSize: 18,
  );

  static const _subTitleTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.normal,
    fontSize: 14,
  );

  const MainAppScaffold({
    super.key,
    required this.title,
    this.subtitle,
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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: _createTitle(title, subtitle),
        backgroundColor: headerGrey,
        foregroundColor: Colors.black,
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
      decoration: BoxDecoration(
        color: Colors.grey[50],
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
                    : () => context.push(SeasonSelectorPage.routePath),
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

  Widget? _createTitle(String title, String? subtitle) {
    if (subtitle == null) {
      return Text(title, style: _titleTextStyle, maxLines: 2);
    } else {
      return RichText(
        text: TextSpan(
          text: title,
          style: _titleTextStyle,
          children: <TextSpan>[
            TextSpan(text: subtitle, style: _subTitleTextStyle),
          ],
        ),
      );
    }
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
