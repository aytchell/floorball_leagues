import 'package:floorball/api/models/season_info.dart';
import 'package:floorball/blocs/selected_season_cubit.dart';
import 'package:floorball/ui/theme/global_colors.dart';
import 'package:floorball/ui/theme/icons.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/views/landing/landing_page.dart';
import 'package:floorball/ui/views/history/history_page.dart';
import 'package:floorball/ui/views/season_selector/season_selector_page.dart';
import 'package:floorball/ui/views/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MainAppScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget body;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool showBottomNavigation;
  final bool isHomePage;
  final bool isHistoryPage;
  final bool isSeasonPicker;
  final bool isSettings;

  const MainAppScaffold({
    super.key,
    required this.title,
    this.subtitle,
    required this.body,
    this.actions,
    this.showBackButton = false,
    this.showBottomNavigation = true,
    this.isHomePage = false,
    this.isHistoryPage = false,
    this.isSeasonPicker = false,
    this.isSettings = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FloorballColors.mainBackgroundColor,
      appBar: AppBar(
        title: _createTitle(title, subtitle),
        backgroundColor: FloorballColors.mainHeaderGray,
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
    return SafeArea(
      top: false,
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            _buildBottomNavItem(
              icon: FloorballIcons.home,
              isEnabled: !isHomePage,
              onTap: isHomePage
                  ? null
                  : () => context.go(LandingPage.routePath),
            ),
            _buildBottomNavItem(
              icon: FloorballIcons.history,
              isEnabled: !isHistoryPage,
              onTap: isHistoryPage
                  ? null
                  : () => context.push(HistoryPage.routePath),
            ),
            const Spacer(),
            _buildBottomNavItem(
              icon: FloorballIcons.settings,
              isEnabled: !isSettings,
              onTap: isSettings
                  ? null
                  : () => context.push(SettingsPage.routePath),
            ),
            SizedBox(width: 12),
            BlocBuilder<SelectedSeasonCubit, SeasonInfo?>(
              builder: (_, state) => _SeasonIndicator(
                selectedSeason: state,
                isEnabled: !isSeasonPicker,
              ),
            ),
          ],
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
          color: isEnabled
              ? FloorballColors.mainNavIconEnabled
              : FloorballColors.mainNavIconDisabled,
          size: 30,
        ),
      ),
    );
  }

  Widget? _createTitle(String title, String? subtitle) {
    if (subtitle == null) {
      return Text(title, style: TextStyles.mainScaffoldTitle, maxLines: 2);
    } else {
      return RichText(
        text: TextSpan(
          text: '$title\n',
          style: TextStyles.mainScaffoldTitle,
          children: <TextSpan>[
            TextSpan(text: subtitle, style: TextStyles.mainScaffoldSubTitle),
          ],
        ),
      );
    }
  }
}

class _SeasonIndicator extends StatelessWidget {
  final SeasonInfo? selectedSeason;
  final bool isEnabled;

  const _SeasonIndicator({this.selectedSeason, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    if (selectedSeason == null) {
      return const SizedBox(width: 60, height: 60);
    }

    final textStyle = isEnabled
        ? (selectedSeason!.current)
              ? TextStyles.mainScaffoldSeason
              : TextStyles.mainScaffoldPastSeason
        : TextStyles.mainScaffoldDisabledSeason;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: isEnabled ? _gotoSeasonSelector(context) : null,
      child: SizedBox(
        width: 60,
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: selectedSeason!.name
              .split('/')
              .map((year) => Text(year, style: textStyle))
              .toList(),
        ),
      ),
    );
  }

  static void Function() _gotoSeasonSelector(BuildContext context) =>
      () => context.push(SeasonSelectorPage.routePath);
}
