import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:notenverwaltung/global.dart';
import 'dart:convert';

class Semester {
  int id;
  String name;
  double durchschnitt;
  String jahr;
  String notiz;

  Semester({this.id, this.name, this.durchschnitt, this.jahr, this.notiz});

  factory Semester.fromJson(Map<String, dynamic> json) {
    return Semester(
      id: json['semester_id'],
      name: json['semester_name'],
      durchschnitt: json['semester_durchschnitt'],
      jahr: json['semester_jahr'],
      notiz: json['semester_notiz'],
    );
  }
  factory Semester.fromFach(Semester anotherSemester) {
    return Semester(
      id: anotherSemester.id,
      name: anotherSemester.name,
      jahr: anotherSemester.jahr,
      durchschnitt: anotherSemester.durchschnitt,
      notiz: anotherSemester.notiz,
    );
  }
}

Future<List<Semester>> getSemester() async {
  final response = await http.get(Uri.parse(URL_SEMESTER));
  if (response.statusCode == 200) {
    List responseJson = json.decode(response.body.toString());
    List<Semester> semesterList = createSemesterList(responseJson);
    print(semesterList);
    for (int i = 0; i < semesterList.length; i++) {
      print(semesterList[i].id);
      print(semesterList[i].name);
      print(semesterList[i].durchschnitt);
      print(semesterList[i].jahr);
      print(semesterList[i].notiz);
    }

    return semesterList;
  } else {
    throw Exception('Failed to load note');
  }
}

List<Semester> createSemesterList(List data) {
  List<Semester> list = new List();

  for (int i = 0; i < data.length; i++) {
    int id = data[i]["semester_id"];
    String name = data[i]["semester_name"];
    double durchschnitt = data[i]["semester_durchschnitt"];
    String jahr = data[i]["semester_jahr"];
    String notiz = data[i]["semester_notiz"];
    Semester semesterObject = new Semester(
        id: id,
        name: name,
        durchschnitt: durchschnitt,
        jahr: jahr,
        notiz: notiz);
    list.add(semesterObject);
  }
  return list;
}

/*Future<double> getAvg(int id) async {
  final response = await http.get('$URL_FAECHER_BY_SEMESTER$id');
  List responseJson = json.decode(response.body.toString());
  String res =
      responseJson.map((e) => e['fach_durchschnitt']).reduce((a, b) => a + b) /
          responseJson.length;
  print(res);
  double avg = double.parse(res);
  if (response.statusCode == 200) {
    return avg;
  } else {
    throw Exception('Failed to load note');
  }
}

double avg(int id) {
  double avg = double.parse(getAvg(id).toString());

  /*for (int i = 0; i < data.length; i++) {
    double durchschnitt = data[i]["semester_durchschnitt"];
    list.add(durchschnitt);
  }*/
  return avg;
}*/

Future deleteSemester(int id) async {
  String status = '';
  final url = Uri.parse('$URL_SEMESTER/$id');
  final response = await http.delete(url, headers: URL_HEADERS);
  if (response.statusCode == 200) {
    print('Semester deleted with this id: $id');
    status = 'DONE';
  } else {
    status = 'NOT_DONE';
  }
  return status;
}

Future<Semester> getSemesterById(int id) async {
  final url = Uri.parse('$URL_SEMESTER/$id');
  final response = await http.get(url, headers: URL_HEADERS);
  if (response.statusCode == 200) {
    Map<String, dynamic> mapResponse = json.decode(response.body);
    return Semester.fromJson(mapResponse);
  } else {
    return Semester();
  }
}

Future updateSemester(int semesterId, double durchschnitt,
    TextEditingController name, jahr, notiz) async {
  final response = await http.put(Uri.parse('$URL_SEMESTER/$semesterId'),
      headers: URL_HEADERS,
      body: json.encode({
        'semester_name': name.text,
        'semester_durchschnitt': durchschnitt,
        'semester_jahr': jahr.text,
        'semester_notiz': notiz.text
      }));
  print("id: $semesterId name: ${name.text}");
  if (response.statusCode == 200) {
    print(response.statusCode);
    return response;
  } else {
    print(response.statusCode);
    print(response.body);
    //throw Exception('Failes to update a Task. Error${response.toString()}');
  }
}

Future createSemester(TextEditingController name, jahr, notiz) async {
  print("Semester eingaben: " + name.text + " " + jahr.text + " " + notiz.text);
  final response = await http.post(Uri.parse(URL_SEMESTER),
      headers: URL_HEADERS,
      body: json.encode({
        'semester_name': name.text,
        'semester_durchschnitt': null,
        'semester_jahr': jahr.text,
        'semester_notiz': notiz.text
      }));
  print("somethin happend in create");
  if (response.statusCode == 200) {
    print(response.body.toString());
    return response;
  } else {
    print(response.statusCode);
    print(response.body);
  }
}
