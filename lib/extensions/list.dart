extension ListX<T> on List<T> {
  void insertAllAndIgnoreDuplicate(List<T> items, dynamic Function(T) field) {
    final map = <dynamic, bool>{};
    for (var i = 0; i < length; i++) {
      map[field(this[i])] = true;
    }
    final newItems = <T>[];
    for (final item in items) {
      if (!map.containsKey(field(item))) {
        newItems.add(item);
      }
    }

    insertAll(0, newItems);
  }
}
