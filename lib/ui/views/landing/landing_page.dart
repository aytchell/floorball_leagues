import 'package:collection/collection.dart';
import 'package:floorball/blocs/pinned_federations_cubit.dart';
import 'package:floorball/utils/list_extensions.dart';
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
                body: _buildBody(
                  availableFederations.federations,
                  selectedSeason,
                ),
              );
            },
          ),
    );
  }

  Widget _buildBody(List<Federation> federations, SeasonInfo? selectedSeason) {
    return BlocBuilder<PinnedFederationsCubit, PinnedFederations>(
      builder: (_, state) => (selectedSeason == null)
          ? Text(
              'Lade Liste der Spielbetriebe',
              style: TextStyles.genericLoadingData,
            )
          : _buildSortedBody(
              _tagAndReorder(
                federations,
                state.getPinnedFederations(selectedSeason.id),
              ),
              selectedSeason,
            ),
    );
  }

  List<FederationWithPin> _tagAndReorder(
    List<Federation> federations,
    List<int> pinnedFedIds,
  ) {
    final List<FederationWithPin> pinned = pinnedFedIds
        .mapNotNull((id) => federations.firstWhereOrNull((fed) => fed.id == id))
        .map((fed) => FederationWithPin(fed, true))
        .toList();
    final List<FederationWithPin> unPinned = federations
        .where((fed) => !pinnedFedIds.contains(fed.id))
        .map((fed) => FederationWithPin(fed, false))
        .toList();
    pinned.addAll(unPinned);
    return pinned;
  }

  Widget _buildSortedBody(
    List<FederationWithPin> federations,
    SeasonInfo? selectedSeason,
  ) {
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
          final fwp = federations[index];
          return FederationCard(
            seasonId: selectedSeason!.id,
            federation: fwp.federation,
            isPinned: fwp.isPinned,
            onTap: () => LeaguesListPageRoute(
              federationId: fwp.federation.id,
            ).push(context),
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

class FederationWithPin {
  final Federation federation;
  final bool isPinned;

  FederationWithPin(this.federation, this.isPinned);
}
