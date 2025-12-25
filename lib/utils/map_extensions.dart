extension MapValuesExtension<K, V1> on Map<K, V1> {
  Map<K, V2> mapValues<V2>(V2 Function(V1 value) mapper) {
    return map((k, v) => MapEntry(k, mapper(v)));
  }
}
