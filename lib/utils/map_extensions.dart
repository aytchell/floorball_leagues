extension MapValuesExtension<K, V1> on Map<K, V1> {
  Map<K, V2> mapValues<V2>(V2 Function(V1 value) mapper) {
    return map((k, v) => MapEntry(k, mapper(v)));
  }
}

extension ToListExtension<K, V> on Map<K, V> {
  List<MapEntry<K, V>> toList() {
    final List<MapEntry<K, V>> result = [];
    forEach((key, value) => result.add(MapEntry(key, value)));
    return result;
  }
}
