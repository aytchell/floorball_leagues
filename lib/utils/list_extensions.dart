import 'package:flutter/material.dart';

extension MapNotNullExtension<T> on List<T> {
  List<U> mapNotNull<U>(U? Function(T value) mapper) {
    final List<U> result = [];
    forEach((entry) {
      final value = mapper(entry);
      if (value != null) result.add(value);
    });
    return result;
  }
}

extension JoinWidgetsExtension on Iterable<Widget> {
  Iterable<Widget> joinWidgets(Widget separator) {
    if (isEmpty) return [];
    final List<Widget> result = [];
    forEach((widget) {
      if (result.isNotEmpty) {
        result.add(separator);
      }
      result.add(widget);
    });
    return result;
  }
}
