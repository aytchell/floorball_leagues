import 'package:floorball/api/blocs/game_operations_cubit.dart';
import 'package:floorball/selected_season_cubit.dart';
import 'package:floorball/ui/views/leagues_list/leagues_list_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:floorball/ui/views/landing/game_operation_card.dart';
import 'package:floorball/api/models/season_info.dart';
import 'package:floorball/api/models/game_operation.dart';
import 'package:floorball/ui/app_text_styles.dart';
import 'package:floorball/ui/main_app_scaffold.dart';

final log = Logger('LandingPage');

class LandingPage extends StatelessWidget {
  static const routePath = '/';

  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AvailableOperationsCubit, AvailableOperations>(
      builder: (context, availableOperations) =>
          BlocBuilder<SelectedSeasonCubit, SeasonInfo?>(
            builder: (context, selectedSeason) {
              final subTitle = (selectedSeason == null)
                  ? ""
                  : '\nSaison ${selectedSeason.name}';

              return MainAppScaffold(
                title: 'Floorball Verbände$subTitle',
                isHomePage: true,
                body: _buildBody(availableOperations.operations),
              );
            },
          ),
    );
  }

  Widget _buildBody(List<GameOperation> operations) {
    if (operations.isEmpty) {
      return Center(
        child: Text(
          'No game operations found',
          style: AppTextStyles.gameOpLoadingError,
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
        itemCount: operations.length,
        itemBuilder: (context, index) {
          final gameOp = operations[index];
          return GameOperationCard(
            gameOperation: gameOp,
            onTap: () =>
                LeaguesListPageRoute(gameOperationId: gameOp.id).go(context),
          );
        },
      ),
    );
  }
}
