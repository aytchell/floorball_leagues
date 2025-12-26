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
