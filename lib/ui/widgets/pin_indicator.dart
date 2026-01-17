import 'dart:math';

import 'package:floorball/blocs/pin_variant_cubit.dart';
import 'package:floorball/ui/theme/icons.dart';
import 'package:floorball/utils/on_pressed_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PinIndicator extends StatelessWidget {
  final bool isPinned;
  final OnPressedFactory onPressedFactory;

  const PinIndicator({
    super.key,
    required this.isPinned,
    required this.onPressedFactory,
  });

  static Map<String, PinVariant> availableVariants() => variants;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<PinVariantCubit, PinVariantState>(
        builder: (_, state) {
          final variant = variants[state.variantIdent] ?? variants.values.first;
          return isPinned
              ? _PinTemplate(onPressedFactory, variant.pinned)
              : _PinTemplate(onPressedFactory, variant.unpinned);
        },
      );
}

class _PinTemplate extends StatelessWidget {
  final OnPressedFactory onPressedFactory;
  final Widget icon;

  const _PinTemplate(this.onPressedFactory, this.icon);

  @override
  Widget build(BuildContext context) =>
      InkWell(onTap: onPressedFactory(context), child: icon);
}

class PinVariant {
  final String ident;
  final String name;
  final Widget pinned;
  final Widget unpinned;

  PinVariant({
    required this.ident,
    required this.name,
    required this.pinned,
    required this.unpinned,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PinVariant && other.ident == ident;
  }

  @override
  int get hashCode => ident.hashCode;
}

final _starUnpinned = Icon(
  FloorballIcons.starBorder,
  size: 16,
  color: Colors.black,
);
final _starPinned = Stack(
  children: [
    Icon(FloorballIcons.star, size: 20, color: Colors.amberAccent),
    Icon(FloorballIcons.starBorder, size: 20, color: Colors.black),
  ],
);

final _pushPinUnpinned = Transform.rotate(
  angle: -pi / 2,
  child: Icon(FloorballIcons.pinBorder, size: 16, color: Colors.black),
);

final _pushPinPinned = Transform.rotate(
  angle: pi / 4,
  child: Stack(
    children: [
      Icon(FloorballIcons.pin, size: 20, color: Colors.green),
      Icon(FloorballIcons.pinBorder, size: 20, color: Colors.black),
    ],
  ),
);

final _heartUnpinned = Icon(
  FloorballIcons.heartBorder,
  size: 16,
  color: Colors.black,
);
final _heartPinned = Stack(
  children: [
    Icon(FloorballIcons.heart, size: 20, color: Colors.red),
    Icon(FloorballIcons.heartBorder, size: 20, color: Colors.black),
  ],
);

final variants = Map.fromEntries(
  [
    PinVariant(
      ident: 'heart',
      name: 'Herz',
      pinned: _heartPinned,
      unpinned: _heartUnpinned,
    ),
    PinVariant(
      ident: 'star',
      name: 'Stern',
      pinned: _starPinned,
      unpinned: _starUnpinned,
    ),
    PinVariant(
      ident: 'pin',
      name: 'Pinnadel',
      pinned: _pushPinPinned,
      unpinned: _pushPinUnpinned,
    ),
  ].map((entry) => MapEntry(entry.ident, entry)),
);
