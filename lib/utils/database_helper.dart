import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_database.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  Future<void> removeDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');
    await deleteDatabase(path);
  }

  Future<void> createTable(String tableName, List<Field> fields) async {
    final db = await database;
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $tableName (${fields.map((field) => '${field.name} ${field.type}').join(', ')})');
  }
}

class Field {
  final String name;
  final String type;
  final bool isPrimaryKey;
  final bool isAutoIncrement;

  Field({
    required this.name,
    required this.type,
    this.isPrimaryKey = false,
    this.isAutoIncrement = false,
  });
}

abstract class Model<T> {
  final String tableName;
  final List<Field> fields;
  static Database? _database;

  Model({required this.tableName, required this.fields});

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(_generateCreateTableQuery());
      },
    );
  }

  String _generateCreateTableQuery() {
    final fieldDefinitions = fields.map((field) {
      String definition = "${field.name} ${field.type}";
      if (field.isPrimaryKey) definition += " PRIMARY KEY";
      if (field.isAutoIncrement) definition += " AUTOINCREMENT";
      return definition;
    }).join(", ");
    return "CREATE TABLE IF NOT EXISTS $tableName ($fieldDefinitions)";
  }

  Future<List<Map<String, dynamic>>> find() async {
    final db = await database;
    return await db.query(tableName);
  }

  Future<Map<String, dynamic>?> findOne(String id) async {
    final db = await database;
    final results =
        await db.query(tableName, where: "id = ?", whereArgs: [id], limit: 1);
    return results.isNotEmpty ? results.first : null;
  }

  Future<T> save() async {
    throw UnimplementedError();
  }

  Future<int> delete(String id) async {
    final db = await database;
    return await db.delete(tableName, where: "id = ?", whereArgs: [id]);
  }

  Future<int> deleteOne(String id) async {
    return delete(id);
  }

  Future<int> update(Map<String, dynamic> data, String id) async {
    final db = await database;
    return await db.update(tableName, data, where: "id = ?", whereArgs: [id]);
  }

  Future<int> updateOne(String id, Map<String, dynamic> data) async {
    return update(data, id);
  }

  Future<int> insert(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(tableName, data);
  }

  Future<int> insertMany(List<Map<String, dynamic>> dataList) async {
    final db = await database;
    Batch batch = db.batch();
    for (var data in dataList) {
      batch.insert(tableName, data);
    }
    await batch.commit();
    return dataList.length;
  }
}
