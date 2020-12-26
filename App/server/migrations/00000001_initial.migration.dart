import 'dart:async';
import 'package:aqueduct/aqueduct.dart';

class Migration1 extends Migration {
  @override
  Future upgrade() async {
    database.createTable(SchemaTable(
      "_Noten",
      [
        SchemaColumn("id", ManagedPropertyType.bigInteger,
            isPrimaryKey: true,
            autoincrement: true,
            isIndexed: false,
            isNullable: false,
            isUnique: false),
        SchemaColumn("note", ManagedPropertyType.string,
            isPrimaryKey: false,
            autoincrement: false,
            isIndexed: false,
            isNullable: false,
            isUnique: false),
      ],
    ));
  }

  @override
  Future downgrade() async {}

  @override
  Future seed() async {
    final noten = ["4.6", "5.3", "2.7", "4.0"];

    for (final note in noten) {
      await database.store.execute("INSERT INTO _Noten (note) VALUES (@note)",
          substitutionValues: {"note": note});
    }
  }
}
