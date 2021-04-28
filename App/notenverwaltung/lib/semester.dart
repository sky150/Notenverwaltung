import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:notenverwaltung/database.dart';
import 'package:notenverwaltung/global.dart';
import 'dart:convert';

class Semester {
  DatabaseReference id;
  String name;
  double durchschnitt;
  String jahr;
  String notiz;

  Semester.empty();
  Semester(this.name, this.durchschnitt, this.jahr, this.notiz);

  void setId(DatabaseReference id) {
    this.id = id;
  }

  void update() {
    print("From Semester.dart : " + this.toString() + " ${this.id}");
    updateS(this, this.id);
  }

  Map<String, dynamic> toJson() {
    return {
      'semester_name': this.name,
      'semester_durchschnitt': this.durchschnitt,
      'semester_jahr': this.jahr,
      'semester_notiz': this.notiz
    };
  }
}

Semester createSemester(record) {
  String name = record["semester_name"];
  print(name);
  var durchschnitt = record["semester_durchschnitt"];
  if (durchschnitt != null) {
    durchschnitt = double.parse(durchschnitt.toString());
  }
  print(durchschnitt);
  String jahr = record["semester_jahr"];
  String notiz = record["semester_notiz"];
  Semester semester = new Semester(name, durchschnitt, jahr, notiz);
  return semester;
}
