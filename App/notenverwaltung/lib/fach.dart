import 'package:firebase_database/firebase_database.dart';
import 'package:notenverwaltung/database.dart';

class Fach {
  DatabaseReference id;
  String name;
  int gewichtung;
  double durchschnitt;
  double wunschNote;

  Fach(this.name, this.gewichtung, this.durchschnitt, this.wunschNote);

  void setId(DatabaseReference id) {
    this.id = id;
  }

  void update() {
    //updateF(this, this.id);
  }

  Map<String, dynamic> toJson() {
    return {
      'fach_name': this.name,
      'fach_durchschnitt': this.durchschnitt,
      'fach_gewichtung': this.gewichtung,
      'fach_wunschNote': this.wunschNote
    };
  }
}

Fach createFach(record) {
  String name = record["fach_name"];
  print(name);
  var durchschnitt = record["fach_durchschnitt"];
  if (durchschnitt != null) {
    durchschnitt = double.parse(durchschnitt.toString());
  }
  print(durchschnitt);
  int gewichtung = record["fach_gewichtung"];
  var wunschNote = record["fach_wunschNote"];
  wunschNote = double.parse(wunschNote.toString());
  Fach fach = new Fach(name, gewichtung, durchschnitt, wunschNote);
  return fach;
}
