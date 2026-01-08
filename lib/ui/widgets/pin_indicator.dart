import 'package:floorball/utils/on_pressed_factory.dart';
import 'package:flutter/material.dart';

class PinIndicator extends StatelessWidget {
  final bool isPinned;
  final OnPressedFactory onPressedFactory;

  const PinIndicator({
    super.key,
    required this.isPinned,
    required this.onPressedFactory,
  });

  @override
  Widget build(BuildContext context) =>
      isPinned ? _StarFilled(onPressedFactory) : _StarEmpty(onPressedFactory);
}

class _StarEmpty extends StatelessWidget {
  final OnPressedFactory onPressedFactory;

  const _StarEmpty(this.onPressedFactory);

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onPressedFactory(context),
    child: const Icon(Icons.star_border, size: 16, color: Colors.black),
  );
}

class _StarFilled extends StatelessWidget {
  final OnPressedFactory onPressedFactory;

  const _StarFilled(this.onPressedFactory);

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onPressedFactory(context),
    child: const Stack(
      children: [
        Icon(Icons.star, size: 20, color: Colors.amberAccent),
        Icon(Icons.star_border, size: 20, color: Colors.black),
      ],
    ),
  );
}
