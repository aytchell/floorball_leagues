import 'package:flutter/material.dart';

extension MapNotNullExtension<T> on Iterable<T> {
  Iterable<U> mapNotNull<U>(U? Function(T value) mapper) {
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

extension ToMapExtension<K, V> on Iterable<MapEntry<K, V>> {
  Map<K, V> toMap() => Map.fromEntries(this);
}

extension ToggleExtension on List<int> {
  List<int> toggle(int element) {
    final List<int> result = where((elem) => elem != element).toList();
    if (result.length == length) {
      // the above line didn't remove any element so we have to add it
      result.add(element);
    }
    return result;
  }
}
