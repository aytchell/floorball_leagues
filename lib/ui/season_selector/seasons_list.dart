import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main_app_scaffold.dart';
import '../../api/models/entry_info.dart';
import '../../app_state.dart';

class SeasonSelectionScreen extends StatelessWidget {
  const SeasonSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    return MainAppScaffold(
      title: 'Saison auswählen',
      isSeasonPicker: true,
      showBackButton: true,
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return _buildBody(appState);
        },
      ),
      selectedSeason: appState.selectedSeason,
    );
  }

  Widget _buildBody(AppState appState) {
    final seasons = appState.allSeasons;

    if (seasons.isEmpty) {
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
            '${seasons.length} Saison${seasons.length == 1 ? '' : 'en'} verfügbar',
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
            itemCount: seasons.length,
            itemBuilder: (context, index) {
              final season = seasons[index];
              return _buildSeasonTile(context, appState, season);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSeasonTile(
    BuildContext context,
    AppState appState,
    SeasonInfo season,
  ) {
    final isSelected = appState.selectedSeason?.id == season.id;
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
          appState.setSelectedSeason(season);
          _navigateToHome(context);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        selected: isSelected,
        selectedTileColor: Colors.transparent, // We handle this with Container
      ),
    );
  }

  void _navigateToHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
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
