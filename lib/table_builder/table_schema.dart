class TableSchema {
  final String table;
  final List<String> search;
  final List<String> primaryKey;
  final List<String> unique;
  const TableSchema({
    this.table = '',
    this.search = const [],
    this.unique = const [],
    this.primaryKey = const ['id'],
  });
}
