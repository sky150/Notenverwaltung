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
}

Future<List<Semester>> getSemester() async {
  final response = await http.get(URL_SEMESTER);
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

Future deleteSemester(int id) async {
  String status = '';
  final url = '$URL_SEMESTER/$id';
  final response = await http.delete(url, headers: URL_HEADERS);
  if (response.statusCode == 200) {
    print('Semester deleted with this id: $id');
    status = 'DONE';
  } else {
    status = 'NOT_DONE';
  }
  return status;
}
