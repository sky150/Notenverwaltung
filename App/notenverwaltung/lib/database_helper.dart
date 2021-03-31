import 'dart:io' show Directory;
import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:postgres/postgres.dart';

class DatabaseHelper {
  static final _databaseName = "notenverwaltung.db";
  static final _databaseVersion = 1;

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path, version: _databaseVersion);
  }

  insertFach(String name, String gewichtung, semesterId) async {
    var connection = PostgreSQLConnection("10.0.2.2", 5433, "notenverwaltung",
        username: "nv_user", password: "1234");
    await connection.open();
    await connection.query(
        'INSERT INTO _fach (fach_name,fach_gewichtung,fach_durchschnitt,semester_id) VALUES ("' +
            name +
            '","' +
            gewichtung +
            '');
    await connection.close();
    // Get a reference to the database.
  }

  updateFachSchnitt(double nr, int id) async {
    var connection = PostgreSQLConnection("10.0.2.2", 5433, "notenverwaltung",
        username: "nv_user", password: "1234");
    await connection.open();
    if (nr == 0.0) {
      await connection.query(
          'UPDATE _fach SET fach_durchschnitt = \'\' where fach_id = ' +
              id.toString() +
              ';');
    }
    await connection.query('UPDATE _fach SET fach_durchschnitt = ' +
        nr.toStringAsFixed(2) +
        ' where fach_id = ' +
        id.toString() +
        ';');
    await connection.close();
    // Get a reference to the database.
  }

  Future<dynamic> selectWunschNote(int id) async {
    var connection = PostgreSQLConnection("10.0.2.2", 5433, "notenverwaltung",
        username: "nv_user", password: "1234");
    await connection.open();
    var wunschnote = await connection.query(
        'SELECT fach_wunschnote from _fach where fach_id = ' +
            id.toString() +
            ';');
    print("bro what is going on " + wunschnote.toString());
    print(wunschnote[0][0]);
    await connection.close();
    return wunschnote[0][0];

    // Get a reference to the database.
  }

  updateSemesterSchnitt(double nr, int id) async {
    var connection = PostgreSQLConnection("10.0.2.2", 5433, "notenverwaltung",
        username: "nv_user", password: "1234");
    await connection.open();
    if (nr == 0.0) {
      await connection.query(
          'UPDATE _semester SET semester_durchschnitt = \'\' where semester_id = ' +
              id.toString() +
              ';');
    }
    await connection.query('UPDATE _semester SET semester_durchschnitt = ' +
        nr.toStringAsFixed(2) +
        'where semester_id = ' +
        id.toString() +
        ';');
    await connection.close();
    // Get a reference to the database.
  }
}
