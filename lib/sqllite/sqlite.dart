import 'dart:async';
import 'dart:convert';

import 'package:core/extension.dart';
import 'package:core/utils/string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

export 'sqlite.dart';

final QUERY_FIELD = 'query_ascii';

enum SortEnum {
  ASC,
  DESC,
}

class Sqlite {
  static int version = 1;
  static Database? _database;
  static FutureOr Function()? _onUpgrade;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await init();
    return _database!;
  }

  static setVersion(int value, {FutureOr Function()? onUpgrade}) {
    version = value;
    _onUpgrade = onUpgrade;
  }

  static List<SqlTable> tables = [];
  static addTable(SqlTable table) {
    tables.add(table);
  }

  static String fileName = 'app_database.db';
  static setFileName(String value) {
    fileName = value;
  }

  static createDatabase(Database db) async {
    for (var table in tables) {
      await db.execute('DROP TABLE IF EXISTS ${table.name}');
      await createTable(db, table);
    }
  }

  static upgradeDatabase(Database db) async {
    for (var table in tables) {
      if (await isTableExist(db, table.name)) {
      } else {
        await createTable(db, table);
      }
    }
  }

  static Future<void> createTable(Database db, SqlTable table) async {
    if (table.isHaveSearch) {
      await db.execute(table.createSearchQuery);
    } else {
      print(table.createQuery);
      await db.execute(table.createQuery);
      await table.createIndexQuery(db);
    }
  }

  static Future<bool> isTableExist(Database db, String tableName) async {
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      [tableName],
    );
    return result.isNotEmpty;
  }

  static Future<Database> init() async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, fileName);
    print(tables);
    print("init SQLite: $path");

    return await openDatabase(
      path,
      version: version,
      onCreate: (db, version) async {
        print("onCreate");
        await createDatabase(db);
        _onUpgrade?.call();
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        print("onUpgrade");
        await createDatabase(db);
        _onUpgrade?.call();
      },
    );
  }
}

class Field {
  final String name;
  final String type;
  final bool isPrimaryKey;
  final bool isAutoIncrement;
  final bool isSearch;
  final bool isFilter;
  bool isNotNull;
  bool isUnique;
  final dynamic defaultValue;
  final String? relativeTable;
  final bool index;

  Field({
    required this.name,
    required this.type,
    this.isAutoIncrement = false,
    this.isSearch = false,
    this.isFilter = false,
    this.isPrimaryKey = false,
    this.isNotNull = false,
    this.isUnique = false,
    this.index = false,
    this.defaultValue,
    this.relativeTable,
  }) {
    if (isPrimaryKey) {
      isNotNull = true;
    }
  }
}

class Highlight {
  final int index;
  final String prefix;
  final String suffix;
  final String columnName;

  Highlight({
    required this.index,
    required this.prefix,
    required this.suffix,
    required this.columnName,
  });
}

enum WhereOperator {
  EQUAL,
  NOT_EQUAL,
  GREATER_THAN,
  LESS_THAN,
  GREATER_THAN_OR_EQUAL,
  LESS_THAN_OR_EQUAL,
  IN,
  NOT_IN,
  LIKE,
  NOT_LIKE,
  SEARCH,
}

const _WHERE_OPERATOR_MAP = {
  WhereOperator.EQUAL: '=',
  WhereOperator.NOT_EQUAL: '!=',
  WhereOperator.GREATER_THAN: '>',
  WhereOperator.LESS_THAN: '<',
  WhereOperator.GREATER_THAN_OR_EQUAL: '>=',
  WhereOperator.LESS_THAN_OR_EQUAL: '<=',
  WhereOperator.IN: 'IN',
  WhereOperator.NOT_IN: 'NOT IN',
  WhereOperator.LIKE: 'LIKE',
  WhereOperator.NOT_LIKE: 'NOT LIKE',
  WhereOperator.SEARCH: 'MATCH',
};

class Where {
  final String? column;
  final Object? value;
  final WhereOperator? operator;
  final String? raw;

  static Where rawQuery(String raw) => Where(raw: raw);
  static Where equal(String column, Object? value) =>
      Where(column: column, operator: WhereOperator.EQUAL, value: value);
  static Where greaterThanOrEqual(String column, Object? value) => Where(
      column: column,
      operator: WhereOperator.GREATER_THAN_OR_EQUAL,
      value: value);
  static Where lessThanOrEqual(String column, Object? value) => Where(
      column: column, operator: WhereOperator.LESS_THAN_OR_EQUAL, value: value);

  static Where $in(String column, Object? value) =>
      Where(column: column, operator: WhereOperator.IN, value: value);
  static Where notIn(String column, Object? value) =>
      Where(column: column, operator: WhereOperator.NOT_IN, value: value);

  Where({
    this.column,
    this.value,
    this.operator = WhereOperator.EQUAL,
    this.raw,
  });

  String toSql() {
    bool isString = value is String || value is DateTime;
    // if (value is List) {
    //   return '$column ${_WHERE_OPERATOR_MAP[operator]} (${(value as List).map((e) => isString ? '"$e"' : e).join(',')})';
    // }

    if (raw != null) {
      return raw!;
    }

    assert(column != null, 'column is required');

    if (operator == WhereOperator.IN || operator == WhereOperator.NOT_IN) {
      isString = (value as List).any((e) => e is String);

      return '$column ${_WHERE_OPERATOR_MAP[operator]} (${(value as List).map((e) => '"$e"').join(',')})';
    }

    // if (value is bool) {
    //   return '$column = ${(value as bool) ? 1 : 0}';
    // }

    if (value == null) {
      return '$column IS NULL';
    }

    if (operator == WhereOperator.LIKE) {
      return '$column LIKE "%$value%"';
    }

    if (operator == WhereOperator.SEARCH && value is String) {
      var query = value as String;
      query = query.replaceAll(RegExp(r'\s{2,}'), ' ');
      query = removeVietnameseDiacritics(query);

      // final temp = query.split(' ');
      // if (temp.length == 2) {
      //   query = 'NEAR("${temp[0]}*" "${temp[1]}*")';
      // }
      // print(_searchWhere(query));

      // final _columns = ['*', 'bm25($name) as rank', ...columns];

      return '$QUERY_FIELD MATCH "$query*"';
    }

    return '$column ${_WHERE_OPERATOR_MAP[operator] ?? '='} ${isString ? '"$value"' : value}';
  }
}

class SqlTable<T> {
  final List<Field> fields;
  final String name;
  late bool isHaveSearch;
  late List<String> primaryKeys;

  final T Function(Map<String, dynamic>) toModel;
  final Map<String, Object?> Function(T item) toJson;

  static Database? _database;

  SqlTable({
    required this.fields,
    required this.name,
    required this.toModel,
    required this.toJson,
  }) {
    isHaveSearch = fields.any((field) => field.isSearch);

    primaryKeys =
        fields.where((field) => field.isPrimaryKey).map((e) => e.name).toList();
  }

  T toModal(Map<String, dynamic> json) {
    final newJson = {...json};

    for (var field in fields) {
      if (field.type.contains('JSON')) {
        newJson[field.name] = jsonDecode(newJson[field.name]);
      }
    }
    return toModel(newJson);
  }

  Map<String, Object?> _toJson(T item) {
    final newJson = toJson(item);

    for (var entry in newJson.entries.toList()) {
      if (!fields.any((field) => field.name == entry.key)) {
        newJson.remove(entry.key);
      }
    }

    for (var field in fields) {
      if (field.type.contains('JSON')) {
        newJson[field.name] = jsonEncode(newJson[field.name]);
      }

      if (field.type.contains('BOOLEAN')) {
        newJson[field.name] =
            newJson[field.name] == true || newJson[field.name] == 1 ? 1 : 0;
      }

      if (field.defaultValue != null && newJson[field.name] == null) {
        newJson[field.name] = field.defaultValue;
      }
    }

    if (isHaveSearch) {
      String queryAscii = '';
      fields.where((field) => field.isSearch).forEach((field) {
        queryAscii += '${newJson[field.name]} ';
      });
      queryAscii = removeVietnameseDiacritics(queryAscii.trim());
      newJson[QUERY_FIELD] = queryAscii;
    }

    return newJson;
  }

  String _idValues(dynamic item) {
    return primaryKeys.map((e) => '$e = "${item[e]}"').toList().join(' AND ');
  }

  _orderBy(Map<String, SortEnum> sort) {
    return sort.entries
        .map((e) => '${e.key} ${e.value == SortEnum.ASC ? 'ASC' : 'DESC'}')
        .join(', ');
  }

  _searchWhere(String searchValue) {
    // return '${QUERY_FIELD} MATCH "$searchValue*"';
    return fields
        .where((field) => field.isSearch)
        .map((field) => "${field.name} MATCH '$searchValue*'")
        .join(" OR ");
  }

  _where(List<Where> where) {
    return where.map((e) => e.toSql()).join(" AND ");
  }

  _columns({List<Where>? where}) {
    if (where?.any((e) => e.operator == WhereOperator.SEARCH) ?? false) {
      return ['*', 'bm25($name) as rank'];
    }
    return ['*'];
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await Sqlite.init();
    return _database!;
  }

  bool get isTableSearch => fields.any((field) => field.isSearch);

  String get createQuery {
    final primaryKeys = fields.where((field) => field.isPrimaryKey);

    return '''
CREATE TABLE IF NOT EXISTS $name (
  ${fields.map((field) => '${field.name} ${field.type} ${field.isNotNull ? 'NOT NULL' : ''} ${field.isUnique ? 'UNIQUE' : ''} ${primaryKeys.length == 1 && field.isPrimaryKey ? 'PRIMARY KEY' : ''} ${field.defaultValue != null ? 'DEFAULT ${field.defaultValue}' : ''}').join(', ')}
  ${primaryKeys.length > 1 ? ', PRIMARY KEY (${primaryKeys.map((field) => field.name).join(', ')})' : ''}
);


''';
  }

  Future<void> createIndexQuery(Database db) async {
    for (var field in fields) {
      if (field.index) {
        await db.execute(
            'CREATE INDEX IF NOT EXISTS idx_${name}_${field.name}_index ON ${name} (${field.name});');
      }
    }
  }

  String get createSearchQuery {
    return '''
CREATE VIRTUAL TABLE IF NOT EXISTS ${name} USING fts5(
${fields.map((field) => field.name).join(', ')}, ${QUERY_FIELD}
);

// CREATE TRIGGER ${name}_i AFTER INSERT ON ${name}
// BEGIN
//     INSERT INTO ${name}_search(${fields.map((field) => field.name).join(', ')})
//     VALUES (new.id, ${fields.map((field) => 'new.${field.name}').join(', ')});
// END;

// CREATE TRIGGER ${name}_ad AFTER DELETE ON ${name}
// BEGIN
//     INSERT INTO ${name}_search(${name}_search, rowid, title, content)
//     VALUES ('delete', old.id, old.title, old.content);
// END;
''';
  }

  Future<void> create(T data) async {
    final db = await database;
    final json = _toJson(data);

    await db.insert(name, json);
  }

  Future<void> insert(T data) async {
    final db = await database;
    final json = _toJson(data);

    await db.insert(name, json);
  }

  Future<void> createMany(List<T> data) async {
    final db = await database;
    final batch = db.batch();
    for (var item in data) {
      final json = _toJson(item);
      // if (isHaveSearch) {
      //   String queryAscii = '';
      //   fields.where((field) => field.isSearch).forEach((field) {
      //     queryAscii += '${json[field.name]} ';
      //   });
      //   queryAscii = removeDiacritics(queryAscii.trim());
      //   // for (var field in fields) {
      //   //   if (field.isSearch) {
      //   //     queryAscii += '${field.name} ';
      //   //   }
      //   // }
      //   json['query_ascii'] = queryAscii;
      // }
      batch.insert(name, json);
    }
    await batch.commit();
  }

  Future<void> insertMany(List<T> data) async {
    final db = await database;
    final batch = db.batch();
    for (var item in data) {
      final json = _toJson(item);
      batch.insert(name, json);
    }
    await batch.commit();
  }

  Future<List<Map<String, dynamic>>> rawQuery(String query,
      [List<Object?>? arguments]) async {
    final db = await database;
    return await db.rawQuery(query, arguments);
  }

  Future<List<T>> find({
    Map<String, SortEnum>? sort,
    int? limit,
    List<Where>? where,
  }) async {
    final db = await database;
    // final _columns = ['*', 'bm25($name) as rank'];
    // if (where != null) {
    //   print(_where(where!));
    // }
    final List<Map<String, dynamic>> maps = await db.query(
      name,
      orderBy: sort != null ? _orderBy(sort) : null,
      limit: limit,
      where: where.isNotNullOrEmpty ? _where(where!) : null,
      columns: _columns(where: where),
    );

    return maps.map<T>((map) => toModal(map)).toList();
  }

  Future<T?> findOne({
    List<Where>? where,
  }) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      name,
      where: where != null ? _where(where) : null,
      limit: 1,
    );
    return maps.isNotEmpty ? toModal(maps.first) : null;
  }

  Future<int> count({List<Where>? where}) async {
    final db = await database;
    final result = await db.query(name,
        where: where != null ? _where(where) : null, columns: ['COUNT(*)']);
    return result.isNotEmpty ? result.first['COUNT(*)'] as int : 0;
  }

  Future<List<T>> random({
    required int count,
    List<Where>? where,
  }) async {
    final db = await database;
    final maps = await db.query(
      name,
      orderBy: 'RANDOM()',
      limit: count,
      where: where != null ? _where(where) : null,
    );
    return maps.isNotEmpty ? maps.map<T>((map) => toModal(map)).toList() : [];
  }

  Future<T?> findById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(name, where: 'id = ?', whereArgs: [id], limit: 1);
    return maps.isNotEmpty ? toModal(maps.first) : null;
  }

  Future<void> deleteById(String id) async {
    final db = await database;
    await db.delete(name, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> delete({List<Where>? where}) async {
    final db = await database;
    await db.delete(name, where: where != null ? _where(where) : null);
  }

  Future<void> deleteOne({List<Where>? where}) async {
    final db = await database;
    await db.rawDelete(
        "DELETE FROM $name WHERE ${where != null ? _where(where) : ''} LIMIT 1");
  }

  Future<List<T>> whereIdIn<T>({
    required List<String> ids,
    required String type,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final db = await database;
    final result = await db.query(name,
        where: 'type = ? AND id IN (${ids.join(',')})', whereArgs: [type]);
    return result.map<T>((e) => fromJson(e)).toList();
  }

  Future<bool> isExist({String? id}) async {
    if (id != null) {
      final db = await database;
      final result =
          await db.query(name, where: 'id = ?', whereArgs: [id], limit: 1);
      return result.isNotEmpty;
    }

    final db = await database;
    final result = await db.query(name, limit: 1);
    return result.isNotEmpty;
  }

  Future<void> updateOrCreate(T data) async {
    final db = await database;
    final dataUpdate = _toJson(data);
    await db.insert(name, dataUpdate,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertOrUpdate(T data) async {
    final db = await database;
    final dataUpdate = _toJson(data);
    await db.insert(name, dataUpdate,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> syncLocal(T data) async {
    final db = await database;
    final dataUpdate = {..._toJson(data), "sync_status": "pending"};
    await db.insert(name, dataUpdate,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> update(T data) async {
    final db = await database;
    final dataUpdate = _toJson(data);
    await db.update(name, dataUpdate, where: _idValues(dataUpdate));
  }

  Future<void> updateMany(List<T> data) async {
    final db = await database;
    final batch = db.batch();
    final primaryKeys = fields.where((field) => field.isPrimaryKey);
    final whereStr =
        primaryKeys.map((field) => '${field.name} = ?').join(' AND ');

    for (var item in data) {
      final json = _toJson(item);
      final whereArgs = primaryKeys.map((field) => json[field.name]).toList();

      batch.update(name, _toJson(item), where: whereStr, whereArgs: whereArgs);
    }
    await batch.commit();
  }

  Future<List<T>> search({
    String? query,
    int limit = 1,
    List<Highlight> highlights = const [],
    List<String> columns = const [],
    String groupBy = '',
    Map<String, SortEnum>? sort,
    List<Where>? where,
  }) async {
    final orginalQuery = query;
    // final _query = removeDiacritics(query);

    query = query?.replaceAll(RegExp(r'\s{2,}'), ' ');
    query = removeVietnameseDiacritics(query ?? '');

    // final temp = query.split(' ');
    // if (temp.length == 2) {
    //   query = 'NEAR("${temp[0]}*" "${temp[1]}*")';
    // }
    // print(_searchWhere(query));

    final db = await database;
    final _columns = ['*', 'bm25($name) as rank', ...columns];

    // if (highlights.isNotEmpty) {
    //   for (var highlight in highlights) {
    //     _columns.add(
    //         "highlight(${name},${highlight.index}, '${highlight.prefix}', '${highlight.suffix}') as ${highlight.columnName}");
    //   }
    // }

    // final _highlightColumn = [];

    // for (var highlight in highlights) {
    //   _highlightColumn.add(
    //       "highlight(${name},${highlight.index}, '${highlight.prefix}', '${highlight.suffix}') as ${highlight.columnName}");
    // }

    var result = await db.query(
      name,
      columns: _columns,
      where:
          '${QUERY_FIELD} MATCH "$query*" ${where.isNotNullOrEmpty ? "& ${_where(where!)}" : ''}',
      // whereArgs: [query],
      limit: limit,
      orderBy:
          sort != null ? _orderBy(sort) : _orderBy({'rank': SortEnum.DESC}),
    );

    result = result.map((row) {
      return {
        ...row, // Giữ nguyên các giá trị khác
      };
    }).toList();

    // if (highlights.isNotEmpty) {
    //   for (var item in result) {
    //     for (var highlight in highlights) {
    //       item[highlight.columnName] =
    //           hightlight(item[highlight.columnName] as String, orginalQuery);
    //     }
    //   }
    // }

//     final result = await db.rawQuery('''
// WITH search_result AS (
//   SELECT ${_columns.join(', ')} FROM $name WHERE ${QUERY_FIELD} MATCH "$query*" OR ${_searchWhere(orginalQuery)} ORDER BY rank ASC LIMIT $limit
// )

// SELECT * FROM search_result;
// ''');

    return result.map<T>((e) => toModal(e)).toList();
  }

  //----------------------------------------------------------------------------

  Future<T> cache({
    // required String type,
    String? id,
    // required T Function(Map<String, dynamic>) fromJson,
    required Future<T> Function() cacheFunc,
    // String? query,
  }) async {
    final data = id == null ? await findOne() : await findById(id);

    if (data != null) {
      return data;
    }

    final newData = await cacheFunc();

    create(newData);
    return newData;
  }

  // FutureOr<T> cacheOr(Future<T> Function() cacheFunc) async {
  //   final data = await cache();
  //   return data;
  // }

  Map<String, dynamic> _data = {};

  Future<T> remember<T>({
    required String key,
    required Future<T> Function() rememberFunc,
  }) async {
    if (!_data.containsKey(key)) {
      final data = await rememberFunc();
      _data[key] = data;
    }
    return _data[key] as T;
  }

  Future<List<T>> cacheList({
    // required String type,
    // required T Function(Map<String, dynamic>) fromJson,
    required Future<List<T>> Function() cacheFunc,
    // Map<String, String?> Function(T)? filterFn,

    /// idKey default(id)
    // String idKey = 'id',
    // String? query,
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      await delete();
    }

    bool isExist = await this.isExist();

    if (isExist) {
      final data = await find();
      return data;
    }

    final data = await cacheFunc();

    createMany(data);

    return data;
  }

  Future<void> safeRequest(Future<void> Function() request) async {
    try {
      await request();
    } catch (e) {
      print(e);
    }
  }
}

class DateTimeConverter extends JsonConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json).toLocal();

  // @override
  // DateTime fromJson(String json) => DateTime.parse(json);

  @override
  String toJson(DateTime object) => object.toUtc().toIso8601String();
}

class BooleanConverter extends JsonConverter<bool, dynamic> {
  const BooleanConverter();
  // Hàm chuyển đổi từ int -> bool
  @override
  bool fromJson(dynamic json) => json == true || json == 1;

  @override
  dynamic toJson(dynamic object) =>
      (object == true || object == 1) ? true : false;
}

class EnumConverter<T extends Enum> extends JsonConverter<T, String> {
  final T? defaultValue;
  const EnumConverter({this.defaultValue});

  @override
  T fromJson(String? json) {
    if ((json == null || json == '') && defaultValue != null) {
      return defaultValue!;
    }

    return json as T;
  }

  @override
  String toJson(T object) => object.name;
}

class ColorConverter extends JsonConverter<Color, String> {
  const ColorConverter();

  @override
  Color fromJson(String json) => Color(int.parse(json, radix: 16));

  @override
  String toJson(Color color) => color.toARGB32().toRadixString(16);
}

class IconConverter extends JsonConverter<IconData, String> {
  const IconConverter();

  @override
  IconData fromJson(String json) {
    final parts = json.split(',');
    return IconData(int.parse(parts[0]), fontFamily: parts[1]);
  }

  @override
  String toJson(IconData object) => "${object.codePoint},${object.fontFamily}";
}
