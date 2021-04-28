import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:notenverwaltung/database_helper.dart';

import '../global.dart';

class Fach {
  int id;
  String name;
  String gewichtung;
  double durchschnitt;
  double wunschNote;
  int semesterId;

  Fach(
      {this.id,
      this.name,
      this.gewichtung,
      this.durchschnitt,
      this.wunschNote,
      this.semesterId});

  factory Fach.fromJson(Map<String, dynamic> json) {
    Fach newFach = Fach(
      id: json['fach_id'],
      name: json['fach_name'],
      gewichtung: json['fach_gewichtung'],
      durchschnitt: json['fach_durchschnitt'],
      wunschNote: json['fach_wunschnote'],
      semesterId: json['semester_id'],
    );
    return newFach;
  }
  factory Fach.fromFach(Fach anotherFach) {
    return Fach(
      id: anotherFach.id,
      name: anotherFach.name,
      gewichtung: anotherFach.gewichtung,
      durchschnitt: anotherFach.durchschnitt,
      wunschNote: anotherFach.wunschNote,
      semesterId: anotherFach.semesterId,
    );
  }
}

Future<dynamic> getNotenschnittFach(int semesterId) async {
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

double createDurchschnittList(List data) {
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

//Controller
Future<List<Fach>> getFaecher(int semesterId) async {
  final response =
      await http.get(Uri.parse('$URL_FAECHER_BY_SEMESTER$semesterId'));
  if (response.statusCode == 200) {
    List responseJson = json.decode(response.body.toString());
    List<Fach> fachList = createFachList(responseJson);
    print(fachList);
    for (int i = 0; i < fachList.length; i++) {
      print(fachList[i].id);
      print(fachList[i].name);
      print(fachList[i].durchschnitt);
      print(fachList[i].gewichtung);
      print(fachList[i].wunschNote);
      print(fachList[i].semesterId);
    }
    double notenschnitt = await getNotenschnittFach(semesterId);
    if (notenschnitt == 0.0 || notenschnitt == double.nan) {
      notenschnitt = 0.00;
    } else {
      DatabaseHelper.instance.updateSemesterSchnitt(notenschnitt, semesterId);
    }

    return fachList;
  } else {
    throw Exception('Failed to load note');
  }
}

List<Fach> createFachList(List data) {
  List<Fach> list = new List();

  for (int i = 0; i < data.length; i++) {
    int id = data[i]["fach_id"];
    String name = data[i]["fach_name"];
    String gewichtung = data[i]["fach_gewichtung"];
    double durchschnitt = data[i]["fach_durchschnitt"];
    double wunschNote = data[i]["fach_wunschnote"];
    int semesterId = data[i]["semester_id"];
    Fach fachObject = new Fach(
        id: id,
        name: name,
        durchschnitt: durchschnitt,
        gewichtung: gewichtung,
        wunschNote: wunschNote,
        semesterId: semesterId);
    list.add(fachObject);
  }
  return list;
}

Future deleteFach(int id, int semesterId) async {
  String status = '';
  final url = Uri.parse('$URL_FAECHER/$id');
  final response = await http.delete(url, headers: URL_HEADERS);
  if (response.statusCode == 200) {
    double notenschnitt = await getNotenschnittFach(semesterId);
    DatabaseHelper.instance.updateSemesterSchnitt(notenschnitt, semesterId);
    print('Fach deleted with this id: $id');
    status = 'DONE';
  } else {
    status = 'NOT_DONE';
  }
  return status;
}

Future<Fach> getFachById(int id) async {
  final url = Uri.parse('$URL_FAECHER/$id');
  final response = await http.get(url, headers: URL_HEADERS);
  if (response.statusCode == 200) {
    Map<String, dynamic> mapResponse = json.decode(response.body);
    return Fach.fromJson(mapResponse);
  } else {
    return Fach();
  }
}

Future updateFach(int fachId, double durchschnitt, double wunschNote,
    TextEditingController name, gewichtung, int semesterId) async {
  final response = await http.put(Uri.parse('$URL_FAECHER/$fachId'),
      headers: URL_HEADERS,
      body: json.encode({
        'fach_name': name.text,
        'fach_gewichtung': gewichtung.text,
        'fach_durchschnitt': durchschnitt,
        'fach_wunschnote': wunschNote
        //'semester_id': semesterId
      }));
  print("id: $fachId name: ${name.text}");
  if (response.statusCode == 200) {
    print(response.statusCode);
    print("Fix load thing " + response.reasonPhrase);
    return response;
  } else {
    print("Fix load thing " + response.reasonPhrase);
    print(response.statusCode);
    print(response.body);
    //throw Exception('Failes to update a Task. Error${response.toString()}');
  }
}

Future createFach(
    TextEditingController name, gewichtung, wunschNote, int semesterId) async {
  print("Wunsch note in create fach " + wunschNote.text);
  final response = await http.post(Uri.parse('$URL_FAECHER'),
      headers: URL_HEADERS,
      body: json.encode({
        'fach_name': name.text,
        'fach_gewichtung': gewichtung.text,
        'fach_durchschnitt': null,
        'fach_wunschnote': double.parse(wunschNote.text),
        'semester_id': semesterId,
      }));
  print("somethin happend in create");
  print(name.text + "  " + gewichtung.text + "  " + semesterId.toString());
  double notenschnitt = await getNotenschnittFach(semesterId);
  DatabaseHelper.instance.updateSemesterSchnitt(notenschnitt, semesterId);
  if (response.statusCode == 200 || response.statusCode == 201) {
    print(response.body.toString());
    print("200Fix load thing " + response.toString());
    return response;
  } else {
    print("500Fix load thing " + response.reasonPhrase);
    print(response.statusCode);
    print(response.body);
  }
}
