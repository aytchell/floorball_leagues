import 'package:floorball/api/models/federation.dart';
import 'package:floorball/blocs/pinned_federations_cubit.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/widgets/cached_network_image.dart';
import 'package:floorball/ui/widgets/pin_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FederationCard extends StatelessWidget {
  final int seasonId;
  final Federation federation;
  final bool isPinned;
  final VoidCallback onTap;

  const FederationCard({
    super.key,
    required this.seasonId,
    required this.federation,
    required this.isPinned,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 12),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: federation.logoUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: federation.logoUrl,
                              fit: BoxFit.contain,
                              showProgress: true,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey[600],
                            ),
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        federation.name,
                        style: TextStyles.landingFederationName,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: _FederationPinIndicator(
                seasonId: seasonId,
                federationId: federation.id,
                isPinned: isPinned,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FederationPinIndicator extends FavoritesIndicator {
  final int seasonId;
  final int federationId;

  _FederationPinIndicator({
    required this.seasonId,
    required this.federationId,
    required super.isPinned,
  }) : super(
         onPressedFactory: (context) {
           return () => BlocProvider.of<PinnedFederationsCubit>(
             context,
           ).toggle(seasonId, federationId);
         },
       );
}
