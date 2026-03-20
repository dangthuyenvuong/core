import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/type.dart';
import 'table_schema.dart';

class TableSchemaBuilder extends GeneratorForAnnotation<TableSchema> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) return '';

    final table = annotation.peek('table')?.stringValue;
    final searchFields = annotation
            .peek('search')
            ?.listValue
            .map((e) => e.toStringValue())
            .toList() ??
        [];
    final uniqueFields = annotation
            .peek('unique')
            ?.listValue
            .map((e) => e.toStringValue())
            .toList() ??
        [];

    final className = element.displayName;
    final tableName = table?.isNotEmpty ?? false
        ? table
        : _toSnakeCase(className); // e.g. Task → task

    final buffer = StringBuffer();

    buffer.writeln("final ${className}Table = SqlTable<$className>(");
    buffer.writeln("  name: '$tableName',");
    buffer.writeln("  fields: [");

    final constructor = element.constructors.firstWhere(
      (c) => c.name.isEmpty,
      orElse: () => throw Exception('No unnamed constructor found'),
    );

    // for (final field in element.fields.where((f) => !f.isStatic)) {
    // final fieldName = field.name;
    // final isNotNull = !field.type.nullabilitySuffix.name.contains('question');
    // final type = _mapTypeToSql(field.type);

    final fields = constructor.parameters;
    // fields.add(ParameterElement(
    //   name: 'is_sync',
    //   type: DartType.fromString('bool'),
    //   isRequired: false,
    // ));

    var haveID = false;

    for (final param in fields) {
      final fieldName = param.name;

      if (fieldName == 'id') {
        haveID = true;
      }

      final type = _mapTypeToSql(param.type);
      final isNotNull =
          !param.type.getDisplayString(withNullability: true).endsWith('?');

      final isPrimaryKey = fieldName == 'id';
      final isSearch = searchFields.contains(fieldName);
      final isUnique = uniqueFields.contains(fieldName);

      buffer.writeln("    Field(");
      buffer.writeln("      name: '$fieldName',");
      buffer.writeln("      type: '$type',");
      if (isSearch) buffer.writeln("      isSearch: true,");
      if (isUnique) buffer.writeln("      isUnique: true,");
      if (isPrimaryKey) buffer.writeln("      isPrimaryKey: true,");
      if (isNotNull) buffer.writeln("      isNotNull: true,");
      buffer.writeln("    ),");
    }

    buffer.writeln(
        "    Field(name: 'sync_status', type: 'VARCHAR(100)', defaultValue: 'pending')");
    buffer.writeln("  ],");
    buffer.writeln("  toJson: ($className model) => model.toJson(),");
    buffer.writeln("  toModel: $className.fromJson,");
    buffer.writeln(");");
    buffer.writeln("");
    buffer.writeln("extension ${className}TableExtension on $className {");
    buffer.writeln("  Future<void> syncLocal() async {");
    buffer.writeln("    ${className}Table.syncLocal(this);");
    buffer.writeln("  }");
    if (haveID) {
      buffer.writeln('''
                    Future<void> delete() async {
                      final id = toJson()['id'];
                      if (id != null) {
                        ${className}Table.deleteById(id);
                      }
                    }''');
      buffer.writeln('''
                    Future<void> syncDone() async {
                      ${className}Table.rawQuery('UPDATE \${${className}Table.name} SET sync_status = ? WHERE id = ?', ['done', id]);
                    }''');
    }

    // buffer.writeln("    ${className}Table.deleteById(this.id);");
    // buffer.writeln("  }");
    buffer.writeln("}");

    buffer.writeln('''
      extension ${className}Extension on ${className} {
        ${className} clone() {
          return ${className}.fromJson(toJson());
        }
      }
    ''');

    return buffer.toString();
  }

  String _mapTypeToSql(DartType type) {
    final typeStr = type.getDisplayString(withNullability: false);

    if (typeStr.contains('List')) {
      return 'JSON';
    }

    // print(typeStr);

    switch (typeStr) {
      case 'int':
        return 'INTEGER';
      case 'String':
        return 'TEXT';
      case 'double':
        return 'REAL';
      case 'bool':
        return 'BOOLEAN';
      case 'DateTime':
        return 'DATETIME';
      default:
        if (isEnumType(type)) {
          return 'TEXT';
        }
        return 'JSON';
    }
  }

  String _toSnakeCase(String input) {
    final regex = RegExp(r'(?<=[a-z])[A-Z]');
    return input.replaceAllMapped(regex, (m) => '_${m.group(0)}').toLowerCase();
  }
}

bool isEnumType(DartType type) {
  final element = type.element3;

  return element?.kind == ElementKind.ENUM;
}
