import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// class SQLModel extends Jsonable {
//   final String id;
//   final String type;
//   final String? query;
//   final Map<String, dynamic> value;

//   SQLModel({
//     required this.id,
//     required this.type,
//     required this.value,
//     required this.query,
//   });

//   @override
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'type': type,
//       'value': jsonEncode(value),
//       'query': query,
//     };
//   }

//   static SQLModel fromJson(Map<String, dynamic> json) {
//     return SQLModel(
//       id: json['id'],
//       type: json['type'],
//       value: jsonDecode(json['value']),
//       query: json['query'] ?? '',
//     );
//   }
// }

// final SQLTable = Table<SQLModel>(
//   fields: [
//     Field(name: 'id', type: 'TEXT NOT NULL'),
//     Field(name: 'type', type: 'TEXT NOT NULL'),
//     Field(name: 'value', type: 'TEXT NOT NULL'),
//     Field(name: 'query', type: 'TEXT NOT NULL', isSearch: true),
//   ],
//   name: 'storage',
//   toModel: SQLModel.fromJson,
//   toJson: (item) => item.toJson(),
// );

// class SQLService {
//   static Future<void> createMany({
//     required List<SQLModel> models,
//   }) async {
//     await SQLTable.createMany(models);
//     // final db = await StorageTable.database;
//     // final batch = db.batch();
//     // for (var model in models) {
//     //   batch.insert(StorageTable.name, model.toJson());
//     // }
//     // await batch.commit();
//   }

//   static Future<void> create({
//     required String id,
//     required String type,
//     required Map<String, dynamic> value,
//     required String query,
//   }) async {
//     final db = await SQLTable.database;
//     final oldData = await findById(id: id, type: type);
//     if (oldData != null) {
//       await db.delete(SQLTable.name,
//           where: 'id = ? AND type = ?', whereArgs: [id, type]);
//     }

//     await SQLTable.create(
//         SQLModel(id: id, type: type, value: value, query: query));
//   }

//   static Future<SQLModel?> findById(
//       {required String id, required String type}) async {
//     final db = await SQLTable.database;
//     final result = await db.query(SQLTable.name,
//         where: 'id = ? AND type = ?', whereArgs: [id, type], limit: 1);
//     return result.isNotEmpty ? SQLModel.fromJson(result.first) : null;
//   }

//   static Future<void> delete({required String id, required String type}) async {
//     final db = await SQLTable.database;
//     await db.delete(SQLTable.name,
//         where: 'id = ? AND type = ?', whereArgs: [id, type]);
//   }

//   static Future<List<SQLModel>> findAll({required String type}) async {
//     final db = await SQLTable.database;
//     final result =
//         await db.query(SQLTable.name, where: 'type = ?', whereArgs: [type]);
//     return result.map<SQLModel>((e) => SQLModel.fromJson(e)).toList();
//   }

//   static Future<void> deleteAll({required String type}) async {
//     final db = await SQLTable.database;
//     await db.delete(SQLTable.name, where: 'type = ?', whereArgs: [type]);
//   }

//   static Future<bool> isExist(
//       {required String id, required String type}) async {
//     final db = await SQLTable.database;
//     final result = await db.query(SQLTable.name,
//         where: 'id = ? AND type = ?', whereArgs: [id, type], limit: 1);
//     return result.isNotEmpty;
//   }

//   static Future<bool> isExistByType({required String type}) async {
//     final db = await SQLTable.database;
//     final result = await db.query(
//       SQLTable.name,
//       where: 'type = ?',
//       whereArgs: [type],
//       limit: 1,
//     );
//     return result.isNotEmpty;
//   }

//   static Future<T> cache<T>({
//     required String type,
//     required String id,
//     required T Function(Map<String, dynamic>) fromJson,
//     required Future<T> Function() cacheFunc,
//     String? query,
//   }) async {
//     bool isExist = await SQLService.isExist(id: id, type: type);

//     if (isExist) {
//       final data = await findById(id: id, type: type);
//       return fromJson(data!.value);
//     }

//     final data = await cacheFunc();
//     create(
//         id: id,
//         type: type,
//         value: (data as dynamic).toJson(),
//         query: query ?? '');

//     return data;
//   }

//   static Future<List<T>> cacheList<T>({
//     required String type,
//     required T Function(Map<String, dynamic>) fromJson,
//     required Future<List<T>> Function() cacheFunc,
//     Map<String, String?> Function(T)? filterFn,

//     /// idKey default(id)
//     String idKey = 'id',
//     String? query,
//   }) async {
//     bool isExist = await SQLService.isExistByType(type: type);

//     if (isExist) {
//       final data = await findAll(type: type);
//       return data.map((e) => fromJson(e.value)).toList();
//     }

//     final data = await cacheFunc();

//     createMany(
//         models: data
//             .map((e) => SQLModel(
//                 id: (e as dynamic)[idKey],
//                 type: type,
//                 value: e.toJson(),
//                 query: query ?? ''))
//             .toList());

//     return data;
//   }

//   static Future<List<T>> whereIdIn<T>({
//     required List<String> ids,
//     required String type,
//     required T Function(Map<String, dynamic>) fromJson,
//   }) async {
//     final db = await SQLTable.database;
//     final result = await db.query(SQLTable.name,
//         where: 'type = ? AND id IN (${ids.join(',')})', whereArgs: [type]);
//     return result.map<T>((e) => fromJson(SQLModel.fromJson(e).value)).toList();
//   }

//   static Future<List<SQLModel>> search({
//     required String query,
//     required String type,
//   }) async {
//     final db = await SQLTable.database;
//     final result = await db.query(SQLTable.name,
//         where: 'query LIKE ? AND type = ?', whereArgs: ['%$query%', type]);
//     return result.map<SQLModel>((e) => SQLModel.fromJson(e)).toList();
//   }
// }

final storage = GetStorage();

class StorageService {
  static Future<void> set(String key, dynamic value) async {
    await storage.write(key, value);
  }

  static T? get<T>(String key) {
    final a = storage.read(key);
    return a as T?;
  }

  static Future<void> remove(String key) async {
    await storage.remove(key);
  }

  static Future<void> clear() async {
    await storage.erase();
  }

  static controller<T, R extends RxInterface<T>>({
    required String key,
    required R value,
    Function(T value)? toJson,
    T Function(dynamic value)? fromJson,
    T? defaultValue,
    FutureOr<T> Function(T value)? beforeSave,
    FutureOr<void> Function(T value)? onChanged,
  }) async {
    final _vl = get(key);
    if (_vl != null) {
      try {
        var parse = fromJson?.call(_vl) ?? _vl;
        parse = await beforeSave?.call(parse) ?? parse;
        print("parse: $key --> $parse");
        if (value is RxList) {
          (value as Rx).value = parse;
        } else if (value is RxMap) {
          (value as RxMap).value = parse;
        } else {
          (value as Rx).value = parse;
        }
      } catch (e) {
        print("ERROR: $key: $_vl");
        if (defaultValue != null) {
          (value as Rx).value = defaultValue;
        }
      }
    }else if (defaultValue != null) {
      (value as Rx).value = defaultValue;
    }
    ever(value, (val) async {
      final _vl = await beforeSave?.call(val) ?? val;
      set(key, toJson?.call(_vl) ?? _vl);
      await onChanged?.call(_vl);
    });
  }

  // String? getToken() {
  //   // print(storage.read('token'));
  //   return storage.read('token');
  // }

  // Future<void> removeToken() async {
  //   await storage.remove('token');
  // }
}
