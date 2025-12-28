import 'package:floorball/api/blocs/available_seasons_cubit.dart';
import 'package:floorball/api/models/season_info.dart';
import 'package:floorball/selected_season_cubit.dart';
import 'package:floorball/ui/main_app_scaffold.dart';
import 'package:floorball/ui/theme/global_colors.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/views/landing/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SeasonSelectorPage extends StatelessWidget {
  const SeasonSelectorPage({super.key});

  static const routePath = '/seasons';

  @override
  Widget build(BuildContext context) {
    return MainAppScaffold(
      title: 'Saison auswählen',
      isSeasonPicker: true,
      showBackButton: true,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<AvailableSeasonsCubit, AvailableSeasons>(
      builder: (_, availableSeasons) =>
          BlocBuilder<SelectedSeasonCubit, SeasonInfo?>(
            builder: (_, selectedSeason) => _SeasonList(
              availableSeasons: availableSeasons.seasons,
              selectedSeason: selectedSeason,
            ),
          ),
    );
  }
}

class _SeasonList extends StatelessWidget {
  final List<SeasonInfo> availableSeasons;
  final SeasonInfo? selectedSeason;

  const _SeasonList({required this.availableSeasons, this.selectedSeason});

  @override
  Widget build(BuildContext context) {
    if (availableSeasons.isNotEmpty) {
      return _buildSeasonList();
    } else {
      return _buildNothingFoundInfo();
    }
  }

  Widget _buildSeasonList() {
    return Container(
      color: FloorballColors.gray231,
      padding: EdgeInsetsGeometry.symmetric(vertical: 32.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('SAISONS', style: TextStyles.seasonListHeader),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: availableSeasons.length,
              itemBuilder: (context, index) {
                final season = availableSeasons[index];
                bool isSelected = (season.id == selectedSeason?.id);
                return _printSeasonEntry(context, season, isSelected);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNothingFoundInfo() => const Center(
    child: Padding(
      padding: EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today, size: 64, color: FloorballColors.gray153),
          SizedBox(height: 16),
          Text('Keine Saisons verfügbar', style: TextStyles.genericNoData),
        ],
      ),
    ),
  );

  static final _regEx = RegExp(r'^20(\d{2})/20(\d{2})$');

  Widget _printSeasonEntry(
    BuildContext context,
    SeasonInfo season,
    bool isSelected,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
      decoration: isSelected ? _seasonEntryHighlightingBox() : null,
      child: ListTile(
        leading: const SizedBox(width: 6),
        title: _printSeasonTextButton(context, season),
      ),
    );
  }

  Decoration _seasonEntryHighlightingBox() => BoxDecoration(
    borderRadius: BorderRadius.circular(8.0),
    color: FloorballColors.gray250,
    border: Border.all(color: FloorballColors.gray153, width: 1.5),
  );

  Widget _printSeasonTextButton(BuildContext context, SeasonInfo season) =>
      TextButton(
        onPressed: () {
          BlocProvider.of<SelectedSeasonCubit>(context).seasonSelected(season);
          context.push(LandingPage.routePath);
        },
        style: TextButton.styleFrom(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.zero,
        ),
        child: _printSeasonName(season),
      );

  Widget _printSeasonName(SeasonInfo season) {
    final match = _regEx.firstMatch(season.name);

    if (match == null) {
      return Text(season.name, style: TextStyles.seasonListLight);
    } else {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(text: 'Saison 20', style: TextStyles.leaguesListLight),
            TextSpan(text: match.group(1), style: TextStyles.leaguesListDark),
            TextSpan(text: ' / 20', style: TextStyles.leaguesListLight),
            TextSpan(text: match.group(2), style: TextStyles.leaguesListDark),
          ],
        ),
      );
    }
  }
}
