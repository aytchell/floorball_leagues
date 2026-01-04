import 'package:floorball/api/models/federation.dart';
import 'package:floorball/blocs/pinned_federations_cubit.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/widgets/cached_network_image.dart';
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
              top: 6,
              right: 6,
              child: isPinned
                  ? _StarFilled(seasonId, federation.id)
                  : _StarEmpty(seasonId, federation.id),
            ),
          ],
        ),
      ),
    );
  }
}

class _StarEmpty extends StatelessWidget {
  final int seasonId;
  final int federationId;

  const _StarEmpty(this.seasonId, this.federationId);

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => BlocProvider.of<PinnedFederationsCubit>(
      context,
    ).toggle(seasonId, federationId),
    child: const Icon(Icons.star_border, size: 16, color: Colors.black),
  );
}

class _StarFilled extends StatelessWidget {
  final int seasonId;
  final int federationId;

  const _StarFilled(this.seasonId, this.federationId);

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => BlocProvider.of<PinnedFederationsCubit>(
      context,
    ).toggle(seasonId, federationId),
    child: const Stack(
      children: [
        Icon(Icons.star, size: 20, color: Colors.amberAccent),
        Icon(Icons.star_border, size: 20, color: Colors.black),
      ],
    ),
  );
}
