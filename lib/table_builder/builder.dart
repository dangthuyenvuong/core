import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'table_generator.dart';

Builder tableBuilder(BuilderOptions options) =>
    PartBuilder([TableSchemaBuilder()], '.table.dart');
