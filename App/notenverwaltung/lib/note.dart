import 'package:firebase_database/firebase_database.dart';
import 'package:notenverwaltung/database.dart';

class Note {
  DatabaseReference id;
  String name;
  double note;
  int gewichtung;
  String datum;

  Note(this.name, this.note, this.gewichtung, this.datum);

  void setId(DatabaseReference id) {
    this.id = id;
  }

  void update() {
    //updateF(this, this.id);
  }

  Map<String, dynamic> toJson() {
    return {
      'note_name': this.name,
      'note_note': this.note,
      'note_gewichtung': this.gewichtung,
      'note_datum': this.datum
    };
  }
}

Note createNote(record) {
  String name = record["note_name"];
  print(name);
  var note = record["note_note"];
  note = double.parse(note.toString());
  print(note);
  int gewichtung = record["note_gewichtung"];
  String datum = record["note_datum"];
  Note object = new Note(name, note, gewichtung, datum);
  return object;
}
