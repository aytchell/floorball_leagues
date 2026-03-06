import 'package:floorball/blocs/pin_variant_cubit.dart';
import 'package:floorball/ui/views/settings/pin_variant_picker.dart';
import 'package:floorball/ui/widgets/pin_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PinVariantSetting extends StatelessWidget {
  const PinVariantSetting({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<PinVariantCubit, PinVariantState>(
        builder: (_, state) {
          final available = FavoritesIndicator.availableVariants();
          final selected = available[state.variantIdent];
          return _buildTile(context, selected, available.values.toList());
        },
      );

  Widget _buildTile(
    BuildContext context,
    PinVariant? selected,
    List<PinVariant> available,
  ) {
    return ListTile(
      title: const Text('Favoriten-Icon'),
      subtitle: selected != null
          ? Text(selected.name)
          : const Text('Keine Variante präferriert'),
      leading: (selected == null) ? null : selected.pinned,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        final cubit = BlocProvider.of<PinVariantCubit>(context);
        showPinVariantPicker(context, selected, available).then((variant) {
          if (variant != null) cubit.changePinVariant(variant.ident);
        });
      },
    );
  }
}
