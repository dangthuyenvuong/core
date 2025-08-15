import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension ListT<T> on List<T>? {
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  List<List<T>> chunk(int size) {
    if (this == null) return [];

    return [
      for (int i = 0; i < this!.length; i += size)
        this!.sublist(i, i + size > this!.length ? this!.length : i + size)
    ];
  }

  List<A> mapV2<A>(A Function(T value, int index) callback) {
    return this
            ?.asMap()
            ?.entries
            ?.map((value) => callback(value.value, value.key))
            .toList() ??
        [];
  }
}

extension ListX<T> on List<T> {
  bool hasIndex(int index) => index >= 0 && index < length;
  List<int> whereKeys(bool Function(T) test) {
    List<int> result = [];

    for (int i = 0; i < length; i++) {
      if (test(this[i])) {
        result.add(i);
      }
    }

    return result;
  }

  bool compare(List<T> other) {
    if (length != other.length) return false;

    final list1 = this.map((e) => e.toString()).toList();
    final list2 = other.map((e) => e.toString()).toList();

    list1.sort();
    list2.sort();

    for (int i = 0; i < length; i++) {
      if (this[i] != other[i]) return false;
    }
    return true;
  }

  List<T> getRandom(int count) {
    final result = <T>[];
    final random = Random();
    final shuffled = this.toList()..shuffle(random);
    for (int i = 0; i < count && i < shuffled.length; i++) {
      result.add(shuffled[i]);
    }
    return result;
  }

  List<T> exclude(T exclude) {
    return this.where((element) => element != exclude).toList();
  }

  Map<K, List<T>> groupBy<K>(Function(T) callback) {
    final result = <K, List<T>>{};
    for (final element in this) {
      final valueofKey = callback(element);
      if (result[valueofKey] == null) {
        result[valueofKey] = [];
      }
      result[valueofKey]!.add(element);

      // final valueofKey = (element as Map<String, dynamic>)[key];
      // if (result[valueofKey] == null) {
      //   result[valueofKey] = [];
      // }
      // result[valueofKey]!.add(element);
    }
    return result;
  }

  int index(bool Function(T) callback) {
    return this.indexWhere(callback);
  }

  void replaceById(T newItem) {
    final index = this
        .index((element) => (element as dynamic).id == (newItem as dynamic).id);
    if (index != -1) {
      this[index] = newItem;
    }
  }
}

extension MapY<K, V> on Map<K, V> {
  List<A> mapV2<A>(A Function(V value, K key) callback) {
    return entries.map((entry) => callback(entry.value, entry.key)).toList();
  }
}

extension MapX<K, bool> on Map<K, bool> {
  void toggle(K key) {
    if (this[key] == null) {
      this[key] = true as bool;
    } else {
      this[key] = this[key] == true ? false as bool : true as bool;
    }
  }

  bool check(K key) => this[key] ?? false as bool;

  List<K> trueValues() =>
      this.keys.where((value) => this[value] == true).toList() as List<K>;

  List<K> keys() => this.keys.toList();

  // bool where(bool Function(K item) test) =>
  //     this.keys.where((value) => test(value)).toList().isNotEmpty;
}

extension NullableStringX on String? {
  bool isNullOrEmpty() => this == null || this!.isEmpty;
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;
  bool checkRequired() => this != null && this!.isNotEmpty;
  String orDefault(String defaultValue) =>
      checkRequired() ? this! : defaultValue;

  String slugify() {
    return (this ?? "")
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s-]'), '') // bỏ ký tự đặc biệt
        .replaceAll(RegExp(r'\s+'), '-') // đổi space thành dấu "-"
        .replaceAll(RegExp(r'-+'), '-'); // bỏ trùng dấu "-"
  }
}

extension NumberFormatting on int {
  String formatNumber() {
    final formatter = NumberFormat("#,###");
    return formatter.format(this);
  }
}

extension ColorExtension on Color {
  /// Làm màu đậm hơn, [amount] từ 0.0 đến 1.0 (0 không thay đổi, 1 là đen hoàn toàn)
  Color darker([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1, 'amount phải từ 0.0 đến 1.0');
    final hsl = HSLColor.fromColor(this);
    final darkerHsl =
        hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return darkerHsl.toColor();
  }
}

extension BoolX on bool? {
  bool isTrue() => this != null ? this == true : false;
  bool isFalse() => this != null && this == false;
}

extension DateTimeX on DateTime {
  DateTime startOfMonth() => DateTime(year, month, 1, 0, 0, 0, 0);
  DateTime endOfMonth() => DateTime(year, month + 1, 0, 23, 59, 59, 999);

  DateTime startOfDay() => DateTime(year, month, day, 0, 0, 0, 0);
  DateTime endOfDay() => DateTime(year, month, day, 23, 59, 59, 999);

  String format(String format) => DateFormat(format).format(this);
}

extension AlignmentX on Alignment {
  bool isTop() =>
      this == Alignment.topLeft ||
      this == Alignment.topCenter ||
      this == Alignment.topRight;
  bool isBottom() =>
      this == Alignment.bottomLeft ||
      this == Alignment.bottomCenter ||
      this == Alignment.bottomRight;
  bool isLeft() =>
      this == Alignment.centerLeft ||
      this == Alignment.topLeft ||
      this == Alignment.bottomLeft;
  bool isRight() =>
      this == Alignment.centerRight ||
      this == Alignment.topRight ||
      this == Alignment.bottomRight;
  bool isCenter() =>
      this == Alignment.centerLeft ||
      this == Alignment.centerRight ||
      this == Alignment.center;
}
