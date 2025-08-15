import 'dart:convert';

import 'package:core/utils/sqlite.dart';

class SearchModel {
  final String query;
  final Map<String, dynamic> value;
  final String type;

  SearchModel({required this.query, required this.value, required this.type});

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      query: json['query'],
      value: jsonDecode(json['value']),
      type: json['type'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'query': query};
  }
}

final SearchTable = SqlTable<SearchModel>(
  fields: [
    Field(name: 'query', type: 'TEXT NOT NULL', isSearch: true),
    Field(name: 'value', type: "TEXT NOT NULL"),
    Field(name: 'type', type: "TEXT NOT NULL"),
  ],
  name: 'search',
  toModel: SearchModel.fromJson,
  toJson: (item) => item.toJson(),
);

class Search {
  static Future<void> add({
    required String query,
    required Map<String, dynamic> value,
    required String type,
  }) async {
    final db = await SearchTable.database;
    await db.insert(
      'search',
      {'query': query, 'value': jsonEncode(value), 'type': type},
    );
  }

  static Future<void> delete(String query, String type) async {
    final db = await SearchTable.database;
    await db.delete(
      'search',
      where: 'query = ? AND type = ?',
      whereArgs: [query, type],
    );
  }

  static Future<List<SearchModel>> search(String query, String type) async {
    final db = await SearchTable.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'search',
      where: 'query LIKE ? AND type = ?',
      whereArgs: ['%$query%', type],
    );

    return maps.map<SearchModel>((map) => SearchModel.fromJson(map)).toList();
  }
}
