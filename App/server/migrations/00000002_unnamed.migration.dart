import 'dart:async';
import 'package:aqueduct/aqueduct.dart';

class Migration2 extends Migration {
  @override
  Future upgrade() async {
    database.createTable(SchemaTable(
      "_Semester",
      [
        SchemaColumn("id", ManagedPropertyType.bigInteger,
            isPrimaryKey: true,
            autoincrement: true,
            isIndexed: false,
            isNullable: false,
            isUnique: false),
        SchemaColumn("name", ManagedPropertyType.string,
            isPrimaryKey: false,
            autoincrement: false,
            isIndexed: false,
            isNullable: false,
            isUnique: false),
        SchemaColumn("durchschnitt", ManagedPropertyType.doublePrecision,
            isPrimaryKey: false,
            autoincrement: false,
            isIndexed: false,
            isNullable: false,
            isUnique: false),
        SchemaColumn("jahr", ManagedPropertyType.string,
            isPrimaryKey: false,
            autoincrement: false,
            isIndexed: false,
            isNullable: true,
            isUnique: false),
        SchemaColumn("notiz", ManagedPropertyType.string,
            isPrimaryKey: false,
            autoincrement: false,
            isIndexed: false,
            isNullable: true,
            isUnique: false),
      ],
    ));
  }

  @override
  Future downgrade() async {}

  @override
  Future seed() async {
    final namen = [
      "BZZ Semester 2",
      "KVB Semester 5",
      "ETH Semester 1",
      "ETH Semester 3"
    ];
    final jahren = ["2012", "2014", "2016", "2018"];
    final durchschnitte = [4.25, 5.67, 3.95, 3.0];

    for (int i = 0; i < namen.length; i++) {
      final name = namen[i];
      final jahr = jahren[i];
      final durchschnitt = durchschnitte[i];
      await database.store.execute(
          "INSERT INTO _Semester (name, durchschnitt, jahr) VALUES (@name, @durchschnitt, @jahr)",
          substitutionValues: {
            "name": name,
            "durchschnitt": durchschnitt,
            "jahr": jahr
          });
    }
  }
}
