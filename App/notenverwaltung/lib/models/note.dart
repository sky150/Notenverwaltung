import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:notenverwaltung/global.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class Note {
  int id;
  double note;
  String gewichtung;
  String datum;
  String name;
  int fachId;

  Note(
      {this.id,
      this.note,
      this.gewichtung,
      this.datum,
      this.name,
      this.fachId});
  factory Note.fromNote(Note anotherNote) {
    return Note(
      id: anotherNote.id,
      note: anotherNote.note,
      gewichtung: anotherNote.gewichtung,
      datum: anotherNote.datum,
      name: anotherNote.name,
      fachId: anotherNote.fachId,
    );
  }
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
        id: json['note_id'],
        note: json['note'],
        gewichtung: json['note_gewichtung'],
        name: json['note_name'],
        datum: json['note_datum'],
        fachId: json['fach_id']);
  }
}

//Controller
Future<List<Note>> getNoten(int fachId) async {
  final response = await http.get('$URL_NOTEN_BY_FACH$fachId');
  if (response.statusCode == 200) {
    List responseJson = json.decode(response.body.toString());
    List<Note> noteList = createNoteList(responseJson);
    print(noteList);
    for (int i = 0; i < noteList.length; i++) {
      print(noteList[i].id);
      print(noteList[i].note);
      print(noteList[i].gewichtung);
      print(noteList[i].datum);
      print(noteList[i].name);
      print(noteList[i].fachId);
    }

    return noteList;
  } else {
    throw Exception('Failed to load note');
  }
}

//Möchte was ausprobieren: gets anzahlNoten + summe von Noten
Future<dynamic> getNotenschnitt(int fachId, {note}) async {
  final response = await http.get('$URL_NOTEN_BY_FACH$fachId');
  if (response.statusCode == 200) {
    List responseJson = json.decode(response.body.toString());
    double noteList = createDurchschnittList(responseJson);
    print(noteList);

    return noteList;
  } else {
    throw Exception('Failed to load note');
  }
}

double createDurchschnittList(List data) {
  if (data.isEmpty) {
    return 0.0;
  }
  double summeN = 0;
  double summeG = 0;
  double summeNG = 0;

  for (int i = 0; i < data.length; i++) {
    summeG = summeG + double.parse(data[i]["note_gewichtung"]) / 100;
    summeN = summeN + data[i]["note"];
    summeNG = summeNG +
        (data[i]["note"] * (double.parse(data[i]["note_gewichtung"]) / 100));
  }
  // (note*gewichtung)/summeG
  double schnitt = summeNG / summeG;
  return schnitt;
}

List<Note> createNoteList(List data) {
  List<Note> list = new List();
  //DateFormat formatter = DateFormat('yyyy-MM-dd');
  //String dateFormatted = '';

  for (int i = 0; i < data.length; i++) {
    int id = data[i]["note_id"];
    double note = data[i]["note"];
    String gewichtung = data[i]["note_gewichtung"];
    String datum = data[i]["note_datum"];
    //dateFormatted = formatter.format(datum);
    String name = data[i]["note_name"];
    int fachId = data[i]["fach_id"];

    Note noteObject = new Note(
        id: id,
        note: note,
        gewichtung: gewichtung,
        datum: datum,
        name: name,
        fachId: fachId);
    list.add(noteObject);
  }
  return list;
}

Future deleteNote(int id) async {
  String status = '';
  final url = '$URL_NOTEN/$id';
  final response = await http.delete(url, headers: URL_HEADERS);
  if (response.statusCode == 200) {
    print('Note deleted with this id: $id');
    status = 'DONE';
  } else {
    status = 'NOT_DONE';
  }
  return status;
}

Future<Note> getNoteById(int id) async {
  final url = '$URL_NOTEN/$id';
  final response = await http.get(url, headers: URL_HEADERS);
  if (response.statusCode == 200) {
    Map<String, dynamic> mapResponse = json.decode(response.body);
    return Note.fromJson(mapResponse);
  } else {
    return Note();
  }
}

Future updateNote(
    int noteId, TextEditingController note, gewichtung, datum, name) async {
  double newNote = double.parse(note.text);
  final response = await http.put('$URL_NOTEN/$noteId',
      headers: URL_HEADERS,
      body: json.encode({
        'note': newNote,
        'note_gewichtung': gewichtung.text,
        'note_datum': datum.text,
        'note_name': name.text
      }));
  print("id: $noteId name: ${name.text}");
  if (response.statusCode == 200) {
    print(response.statusCode);
    return response;
  } else {
    print(response.statusCode);
    print(response.body);
    //throw Exception('Failes to update a Task. Error${response.toString()}');
  }
}

Future createNote(
    TextEditingController note, gewichtung, datum, name, int fachId) async {
  double newNote = double.parse(note.text);
  //int newGewichtung = int.parse(gewichtung.text);

  //print(newGewichtung);
  final response = await http.post(URL_NOTEN,
      headers: URL_HEADERS,
      body: json.encode({
        'note': newNote,
        'note_gewichtung': gewichtung.text,
        'note_datum': datum.text,
        'note_name': name.text,
        'fach_id': fachId
      }));
  print(
      "note: ${newNote}, gewichtung: ${gewichtung.text}, datum: ${datum.text}, name: ${name.text}, fachId: $fachId");
  print("somethin happend in create NOTE");
  if (response.statusCode == 200) {
    print(response.body.toString());
    return response;
  } else {
    print(response.statusCode);
    print(response.body.toString());
  }
}
