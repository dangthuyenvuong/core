extension MapX<K, V> on Map<K, V>? {
  List<V> toList() {
    return this?.values.toList() ?? [];
  }

  Map<K, V> mergeSkipNull(Map a) {
    final result = Map<K, V>.from(this ?? {});

    a.forEach((key, value) {
      if (value != null) {
        result[key] = value;
      }
    });

    return result;
  }

  Map<K, V> mergeSkipFalsy(Map a) {
    final result = Map<K, V>.from(this ?? {});

    a.forEach((key, value) {
      if (!isFalsyValue(value)) {
        result[key] = value;
      }
    });

    return result;
  }

  V? firstWhereOrNull(bool Function(V element) test) {
    if (this == null) return null;
    for (var element in this!.values) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }

  int count(bool Function(V) countFunc) {
    int count = 0;
    for (var element in this!.values) {
      if (countFunc(element)) {
        count++;
      }
    }
    return count;
  }
}

bool isFalsyValue(dynamic value) {
  if (value == null) {
    return true;
  }
  if (value is String) {
    return value.isEmpty;
  }

  if (value is num) {
    return value == 0;
  }

  if (value is List) {
    return value.isEmpty;
  }

  if (value is Map) {
    return value.isEmpty;
  }

  return false;
}
