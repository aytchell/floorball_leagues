import 'dart:math';

import 'package:floorball/blocs/pin_variant_cubit.dart';
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

const _starUnpinned = Icon(Icons.star_border, size: 16, color: Colors.black);
const _starPinned = Stack(
  children: [
    Icon(Icons.star, size: 20, color: Colors.amberAccent),
    Icon(Icons.star_border, size: 20, color: Colors.black),
  ],
);

final _pushPinUnpinned = Transform.rotate(
  angle: -pi / 2,
  child: const Icon(Icons.push_pin_outlined, size: 16, color: Colors.black),
);

final _pushPinPinned = Transform.rotate(
  angle: pi / 4,
  child: const Stack(
    children: [
      Icon(Icons.push_pin, size: 20, color: Colors.green),
      Icon(Icons.push_pin_outlined, size: 20, color: Colors.black),
    ],
  ),
);

const _heartUnpinned = Icon(
  Icons.favorite_border,
  size: 16,
  color: Colors.black,
);
const _heartPinned = Stack(
  children: [
    Icon(Icons.favorite, size: 20, color: Colors.red),
    Icon(Icons.favorite_border, size: 20, color: Colors.black),
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
