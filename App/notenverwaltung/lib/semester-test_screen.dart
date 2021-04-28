import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notenverwaltung/database.dart';
import 'package:notenverwaltung/semesterList-test.dart';
import 'semester.dart';

class SemesterTest extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SemesterTest> {
  List<Semester> semesterList = [];

  void newSemester(
      String name, double durchschnitt, String jahr, String notiz) {
    var semester = new Semester(name, durchschnitt, jahr, notiz);
    semester.setId(saveSemester(semester));
    this.setState(() {
      semesterList.add(semester);
    });
  }

  void updateSemester() {
    getAllSemester().then((semesterList) => {
          this.setState(() {
            this.semesterList = semesterList;
          })
        });
  }

  @override
  void initState() {
    super.initState();
    updateSemester();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(child: SemesterList(this.semesterList)),
      //TextInputWidget(this.newPost)
    );
  }
}
