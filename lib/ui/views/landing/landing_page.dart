import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import 'package:floorball/blocs/federations_cubit.dart';
import 'package:floorball/blocs/selected_season_cubit.dart';
import 'package:floorball/api/models/federation.dart';
import 'package:floorball/api/models/season_info.dart';
import 'package:floorball/routes.dart';
import 'package:floorball/ui/main_app_scaffold.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/views/landing/federation_card.dart';

final log = Logger('LandingPage');

class LandingPage extends StatelessWidget {
  static const routePath = '/';

  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AvailableFederationsCubit, AvailableFederations>(
      builder: (context, availableFederations) =>
          BlocBuilder<SelectedSeasonCubit, SeasonInfo?>(
            builder: (context, selectedSeason) {
              return MainAppScaffold(
                title: 'Floorball Spielbetriebe',
                subtitle: _createSeasonSubtitle(selectedSeason),
                isHomePage: true,
                body: _buildBody(availableFederations.federations),
              );
            },
          ),
    );
  }

  Widget _buildBody(List<Federation> federations) {
    if (federations.isEmpty) {
      return Center(
        child: Text(
          'Keine Spielbetriebe verfügbar',
          style: TextStyles.genericLoadingData,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two columns
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8, // Adjust based on your needs
        ),
        itemCount: federations.length,
        itemBuilder: (context, index) {
          final federation = federations[index];
          return FederationCard(
            federation: federation,
            onTap: () =>
                LeaguesListPageRoute(federationId: federation.id).push(context),
          );
        },
      ),
    );
  }

  String? _createSeasonSubtitle(SeasonInfo? selectedSeason) {
    if (selectedSeason == null) {
      return null;
    }
    if (selectedSeason.current) {
      return 'laufende Saison (${selectedSeason.name})';
    }
    return 'Saison ${selectedSeason.name}';
  }
}
