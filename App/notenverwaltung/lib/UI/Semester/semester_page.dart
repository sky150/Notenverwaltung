import 'package:flutter/material.dart';
import 'package:notenverwaltung/models/global.dart';

//Später mit REST JSON: https://flutter.dev/docs/development/data-and-backend/json
class Semester extends StatefulWidget {
  //final List<Semester> semesterList;
  //final <SupportFile> supportFile;
  //final String semesterId;
  final String semesterName;
  final double semesterDurchschnitt;
  final String jahr;

  Semester(this.semesterName, this.semesterDurchschnitt, this.jahr);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

}
