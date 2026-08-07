import 'package:floorball/api/models/detailed_game.dart';
import 'package:floorball/blocs/ref_license_cubit.dart';
import 'package:floorball/api/models/referee.dart';
import 'package:floorball/ui/theme/global_colors.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/utils/list_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void Function()? showRefereeLicenseDetails(
  BuildContext context,
  DetailedGame game,
) {
  _ensureLicenseIdsAvailable(context, game);
  return () {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: BlocBuilder<RefLicenseCubit, RefLicenseState>(
          builder: (context, state) => _buildRefInfo(state, game),
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: FloorballColors.gray231, width: 1),
        ),
        duration: const Duration(seconds: 60),
        backgroundColor: FloorballColors.gray250,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.black,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  };
}

void _ensureLicenseIdsAvailable(BuildContext context, DetailedGame game) {
  final refCubit = BlocProvider.of<RefLicenseCubit>(context);
  for (final referee in game.referees) {
    if (referee.licenseId != null) {
      refCubit.ensureRefId(referee.licenseId!);
    }
  }
}

Widget _buildRefInfo(RefLicenseState state, DetailedGame game) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: game.referees
      .map((ref) => _buildBoxedRefDetailLines(state, ref))
      .joinWidgets(SizedBox(height: 24))
      .toList(),
);

Widget _buildBoxedRefDetailLines(RefLicenseState state, Referee ref) =>
    Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: FloorballColors.gray153, width: 2.0),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildRefDetailLines(state, ref),
      ),
    );

List<Widget> _buildRefDetailLines(RefLicenseState state, Referee ref) {
  if (ref.licenseId == null || ref.licenseId == 0) {
    return _buildRefDetailErrorMessage(ref, 'Keine Lizenz-ID hinterlegt');
  }

  final license = (ref.licenseId != null)
      ? state.getLicense(ref.licenseId!)
      : null;

  if (license == null) {
    return _buildRefDetailErrorMessage(
      ref,
      'Keine Lizenz-Information für (${ref.licenseId}) verfügbar',
    );
  }

  return [
    Text(
      '${ref.firstName} ${ref.lastName}',
      style: TextStyles.gameMetadataRefDetailsBold,
    ),
    Text(
      license.club,
      overflow: TextOverflow.ellipsis,
      style: TextStyles.gameMetadataRefDetails,
    ),
    SizedBox(height: 8),
    Text(
      'Lizenz: ${license.licenseType} (${license.licenseId})',
      style: TextStyles.gameMetadataRefDetails,
    ),
    Text(
      'Gültig bis ${license.validUntil}',
      style: TextStyles.gameMetadataRefDetails,
    ),
  ];
}

List<Widget> _buildRefDetailErrorMessage(Referee ref, String message) => [
  Text(
    '${ref.firstName} ${ref.lastName}',
    style: TextStyles.gameMetadataRefDetailsBold,
  ),
  SizedBox(height: 8),
  Text(message, style: TextStyles.gameMetadataRefDetailsMessage),
];
