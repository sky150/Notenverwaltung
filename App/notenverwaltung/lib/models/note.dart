import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:notenverwaltung/database_helper.dart';
import 'package:notenverwaltung/global.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:notenverwaltung/models/fach.dart';
import 'package:postgres/postgres.dart';

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
  final response = await http.get(Uri.parse('$URL_NOTEN_BY_FACH$fachId'));
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
    double notenschnitt = await getNotenschnitt(fachId);
    if (notenschnitt == 0.0 || notenschnitt.isNaN) {
      notenschnitt = 0.00;
    }
    DatabaseHelper.instance.updateFachGetNote(notenschnitt, fachId);

    return noteList;
  } else {
    throw Exception('Failed to load note');
  }
}

//Möchte was ausprobieren: gets anzahlNoten + summe von Noten
Future<dynamic> getNotenschnitt(int fachId) async {
  final response = await http.get(Uri.parse('$URL_NOTEN_BY_FACH$fachId'));
  if (response.statusCode == 200) {
    List responseJson = json.decode(response.body.toString());
    double noteList = createDurchschnittList(responseJson);
    return noteList;
  } else {
    throw Exception('Failed to load note');
  }
}

Future<dynamic> getWunschNote(int fachId) async {
  var wunsch = await DatabaseHelper.instance.selectWunschNote(fachId);
  print("Thats the final note" + wunsch.toString());
  double wunschNote = double.parse(wunsch.toString());
  print("Thats the final note" + wunschNote.toString());
  return wunschNote;
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
  if (schnitt.isNaN) {
    schnitt = 0.0;
  }
  return schnitt;
}

Future<dynamic> getNotenschnittFachinNote(int semesterId) async {
  final response =
      await http.get(Uri.parse('$URL_FAECHER_BY_SEMESTER$semesterId'));
  if (response.statusCode == 200) {
    List responseJson = json.decode(response.body.toString());
    double noteList = createDurchschnittList(responseJson);
    print(noteList);
    if (noteList == 0.0 || noteList == double.nan) {
      noteList = 0.00;
    }

    return noteList;
  } else {
    throw Exception('Failed to load note');
  }
}

double createDurchschnittListFach(List data) {
  double summeN = 0;
  double summeG = 0;
  double summeNG = 0;

  for (int i = 0; i < data.length; i++) {
    if (data[i]["fach_durchschnitt"] != null &&
        data[i]["fach_gewichtung"] != null) {
      summeN = summeN + data[i]["fach_durchschnitt"];
      summeG = summeG + double.parse(data[i]["fach_gewichtung"]) / 100;
      summeNG = summeNG +
          (data[i]["fach_durchschnitt"] *
              (double.parse(data[i]["fach_gewichtung"]) / 100));
    }
  }
  // (note*gewichtung)/summeG
  double schnitt = summeNG / summeG;
  if (schnitt.isNaN) {
    schnitt = 0.0;
  }
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

Future deleteNote(int id, int fachId, int semesterId) async {
  String status = '';
  final url = Uri.parse('$URL_NOTEN/$id');
  final response = await http.delete(url, headers: URL_HEADERS);
  if (response.statusCode == 200) {
    double semesterSchnitt = await getNotenschnittFach(semesterId);
    double notenschnitt = await getNotenschnitt(fachId);
    DatabaseHelper.instance
        .updateFachSchnitt(notenschnitt, semesterSchnitt, fachId, semesterId);
    print('Note deleted with this id: $id');
    status = 'DONE';
  } else {
    status = 'NOT_DONE';
  }
  return status;
}

Future<Note> getNoteById(int id) async {
  final url = Uri.parse('$URL_NOTEN/$id');
  final response = await http.get(url, headers: URL_HEADERS);
  if (response.statusCode == 200) {
    Map<String, dynamic> mapResponse = json.decode(response.body);
    return Note.fromJson(mapResponse);
  } else {
    return Note();
  }
}

Future updateNote(int noteId, TextEditingController note, gewichtung, datum,
    name, int fachId, int semesterId) async {
  double newNote = double.parse(note.text);
  final response = await http.put(Uri.parse('$URL_NOTEN/$noteId'),
      headers: URL_HEADERS,
      body: json.encode({
        'note': newNote,
        'note_gewichtung': gewichtung.text,
        'note_datum': datum.text,
        'note_name': name.text
      }));
  print("id: $noteId name: ${name.text}");
  if (response.statusCode == 200) {
    double semesterSchnitt = await getNotenschnittFach(semesterId);

    double notenschnitt = await getNotenschnitt(fachId);
    DatabaseHelper.instance
        .updateFachSchnitt(notenschnitt, semesterSchnitt, fachId, semesterId);
    print(response.statusCode);
    return response;
  } else {
    print('fachId vor notenschnitt' + fachId.toString());
    double semesterSchnitt = await getNotenschnittFach(semesterId);
    double notenschnitt = await getNotenschnitt(fachId);
    print('Fehler ' +
        fachId.toString() +
        ' notenschnitt' +
        notenschnitt.toString());
    DatabaseHelper.instance
        .updateFachSchnitt(notenschnitt, semesterSchnitt, fachId, semesterId);
    print(response.statusCode);
    print(response.body);
    return response;
    //throw Exception('Failes to update a Task. Error${response.toString()}');
  }
}

Future createNote(TextEditingController note, gewichtung, datum, name,
    int fachId, int semesterId) async {
  double newNote = double.parse(note.text);
  //int newGewichtung = int.parse(gewichtung.text);

  //print(newGewichtung);
  final response = await http.post(Uri.parse(URL_NOTEN),
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
  Fach fach = await getFachById(fachId);
  if (response.statusCode == 200) {
    print(response.body.toString());

    /*double notenschnitt = await getNotenschnittFach(semesterId);
    DatabaseHelper.instance.updateSemesterSchnitt(notenschnitt, semesterId);*/
    double semesterSchnitt = await getNotenschnittFach(fach.semesterId);
    double notenschnitt = await getNotenschnitt(fachId);
    DatabaseHelper.instance.updateFachSchnitt(
        notenschnitt, semesterSchnitt, fachId, fach.semesterId);
    return response;
  } else {
    double semesterSchnitt = await getNotenschnittFach(fach.semesterId);

    double notenschnitt = await getNotenschnitt(fachId);
    DatabaseHelper.instance.updateFachSchnitt(
        notenschnitt, semesterSchnitt, fachId, fach.semesterId);
    print(response.statusCode);
    print(response.body.toString());
    return response;
  }
}
