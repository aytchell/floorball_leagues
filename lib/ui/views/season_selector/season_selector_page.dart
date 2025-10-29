import 'package:floorball/api/blocs/available_seasons_cubit.dart';
import 'package:floorball/selected_season_cubit.dart';
import 'package:floorball/ui/views/landing/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:floorball/ui/main_app_scaffold.dart';
import 'package:floorball/api/models/season_info.dart';

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
            builder: (_, selectedSeason) => _buildBodyWithState(
              context,
              availableSeasons.seasons,
              selectedSeason,
            ),
          ),
    );
  }

  Widget _buildBodyWithState(
    BuildContext context,
    List<SeasonInfo> availableSeasons,
    SeasonInfo? selectedSeason,
  ) {
    if (availableSeasons.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today, size: 64, color: Colors.grey[400]),
              SizedBox(height: 16),
              Text(
                'Keine Saisons verfügbar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Header with count
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.0),
          color: Colors.grey[50],
          child: Text(
            '${availableSeasons.length} Saison${availableSeasons.length == 1 ? '' : 'en'} verfügbar',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        // Seasons list
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            itemCount: availableSeasons.length,
            itemBuilder: (context, index) {
              final season = availableSeasons[index];
              return _buildSeasonTile(
                context,
                season,
                season.id == selectedSeason?.id,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSeasonTile(
    BuildContext context,
    SeasonInfo season,
    bool isSelected,
  ) {
    final isCurrent = season.current;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: isSelected ? Colors.blue[50] : Colors.transparent,
        border: isSelected
            ? Border.all(color: Colors.blue[300]!, width: 1.5)
            : null,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        leading: _buildLeadingIcon(isSelected, isCurrent),
        title: Text(
          season.name,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.blue[700] : Colors.black87,
            fontSize: 16,
          ),
        ),
        trailing: _buildTrailingWidget(isCurrent),
        onTap: () {
          // Update the global state
          BlocProvider.of<SelectedSeasonCubit>(context).seasonSelected(season);
          context.go(LandingPage.routePath);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        selected: isSelected,
        selectedTileColor: Colors.transparent, // We handle this with Container
      ),
    );
  }

  Widget _buildLeadingIcon(bool isSelected, bool isCurrent) {
    if (isSelected) {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.blue[600],
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.check, color: Colors.white, size: 16),
      );
    } else {
      return Icon(
        Icons.calendar_today,
        color: isCurrent ? Colors.green[600] : Colors.grey[500],
        size: 22,
      );
    }
  }

  Widget _buildTrailingWidget(bool isCurrent) {
    if (isCurrent) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.green[600],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          'Aktuell',
          style: TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
    return SizedBox.shrink();
  }
}
