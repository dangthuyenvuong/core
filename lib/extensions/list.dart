import 'package:flutter/material.dart';
import 'package:get/utils.dart';

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

  void replace(T item, T newItem) {
    final index = indexOf(item);
    if (index != -1) {
      this[index] = newItem;
    }
  }

  void replaceBy(T newItem, bool Function(T) checkCallback) {
    final t = checkCallback(newItem);
    final index = indexWhere((element) => checkCallback(element) == t);
    if (index != -1) {
      this[index] = newItem;
    }
  }

  bool containsElement(bool Function(T) checkCallback) {
    return indexWhere((element) => checkCallback(element)) != -1;
  }

  void reorder(int oldIndex, int newIndex) {
    final item = removeAt(oldIndex);
    insert(newIndex > oldIndex ? newIndex - 1 : newIndex, item);
  }

  bool has(bool Function(T) checkCallback) {
    return firstWhereOrNull((element) => checkCallback(element)) != null;
  }

  List<T> sublistIf(int start, int end) {
    if (start < 0 || end > length) return [];
    return sublist(start, end);
  }

  List<T> clone({T Function(T)? cloneCallback}) {
    if (cloneCallback != null) {
      return map((e) => cloneCallback(e)).toList();
    }
    return List.from(this);
  }

  void removeFirstWhere(bool Function(T) checkCallback) {
    final index = indexWhere((element) => checkCallback(element));
    if (index != -1) {
      removeAt(index);
    }
  }
}

extension ListX2<T> on List<T>? {
  T? get lastOrNull {
    if (this == null || this!.isEmpty) return null;
    return this!.last;
  }

  Map<String, T> toMap(String Function(T) keyCallback) {
    final map = <String, T>{};
    for (final item in this ?? []) {
      map[keyCallback(item)] = item;
    }
    return map;
  }

  List<T> filter(bool Function(T) checkCallback) {
    return this?.where(checkCallback).toList() ?? [];
  }

  Set<E> toSet2<E>(E Function(T) keyCallback) {
    final set = <E>{};
    for (final item in this ?? []) {
      set.add(keyCallback(item));
    }
    return set;
  }

  Map<E, T> toMap2<E>(E Function(T) keyCallback) {
    final map = <E, T>{};
    for (final item in this ?? []) {
      map[keyCallback(item)] = item;
    }
    return map;
  }

  List<Widget> widgets(Widget Function(T) widgetCallback) {
    return this?.map((item) => widgetCallback(item)).toList() ?? [];
  }

  Set<String> toSet(String Function(T) keyCallback) {
    final set = <String>{};
    for (final item in this ?? []) {
      set.add(keyCallback(item));
    }
    return set;
  }

  T? at(int index) {
    if (index < 0 || this == null || this!.isEmpty || this!.length <= index)
      return null;
    return this![index];
  }

  V safeReduce<V>(V defaultValue, V Function(V, T) combine) {
    if (this == null || this!.isEmpty) return defaultValue;
    return this!.fold(defaultValue, combine);
  }

  int count(bool Function(T) checkCallback) {
    return this?.where(checkCallback).length ?? 0;
  }
}

extension IterableX<T> on Iterable<T> {
  // T safeReduce(T defaultValue, T Function(T, T) combine) {
  //   if (isEmpty) return defaultValue;
  //   return reduce(combine);
  // }

  T? firstWhereOrNull(bool Function(T) checkCallback) {
    for (final item in this) {
      if (checkCallback(item)) return item;
    }
    return null;
  }
}
