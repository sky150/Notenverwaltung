import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  String colorVal;

  Semester.empty();
  Semester(this.name, this.durchschnitt, this.jahr, this.notiz);

  Semester.fromMap(Map<String, dynamic> map) {
    /*assert(map['semester_name'] != null);
    assert(map['semester_durchschnitt'] != null);
    assert(map['semester_jahr'] != null);
    assert(map['semester_notiz'] != null);*/
    print(map);
    name = map['name'];
    durchschnitt = map['durchschnitt'];
    jahr = map['jahr'];
    notiz = map['notiz'];
    print("COME ON" + name);
  }

  void setId(DatabaseReference id) {
    this.id = id;
  }

  void update() {
    print("From Semester.dart : " + this.toString() + " ${this.id}");
    //updateS(this, this.id);
  }

  Map<String, dynamic> toJson() {
    return {
      'semester_name': this.name,
      'semester_durchschnitt': this.durchschnitt,
      'semester_jahr': this.jahr,
      'semester_notiz': this.notiz
    };
  }

  @override
  String toString() => "Semester<$name:$durchschnitt:$jahr>";
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

class PieDeutsch {
  static List<Deutsch> data = [
    Deutsch(schnitt: 4.2, prozent: 15, color: const Color(0xff13d38e)),
    Deutsch(schnitt: 4.75, prozent: 40, color: const Color(0xff0293ee)),
    Deutsch(schnitt: 6.0, prozent: 30, color: const Color(0xffe76f51)),
    Deutsch(schnitt: 3.9, prozent: 15, color: const Color(0xfff4a261)),
  ];
}

class Deutsch {
  final double schnitt;
  final double prozent;
  final Color color;

  Deutsch({this.schnitt, this.prozent, this.color});
}
