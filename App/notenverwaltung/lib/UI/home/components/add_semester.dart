import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:notenverwaltung/UI/TextFields/MyTextFormField.dart';
import 'package:notenverwaltung/database.dart';
import 'package:notenverwaltung/semester.dart';
import 'package:notenverwaltung/semester_screen.dart';
import 'package:notenverwaltung/UI/home/home_screen.dart';
import 'package:notenverwaltung/components/my_bottom_nav_bar.dart';
import 'package:notenverwaltung/global.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddSemester extends StatefulWidget {
  final Semester semester;
  String id;
  AddSemester({this.semester, this.id}) : super();

  @override
  State<StatefulWidget> createState() {
    return _TestFormState(semester, id);
  }
}

class _TestFormState extends State<AddSemester> {
  final Semester semester;
  String id;
  bool isLoadedSemester = false;
  final _formKey = GlobalKey<FormState>();

  _TestFormState(this.semester, this.id);

  @override
  Widget build(BuildContext context) {
    final halfMediaWidth = MediaQuery.of(context).size.width / 2.0;
    TextEditingController semesterName;
    TextEditingController semesterJahr;
    TextEditingController semesterNotiz;

    semesterName = TextEditingController();
    semesterJahr = TextEditingController();
    semesterNotiz = TextEditingController();
    if (semester != null) {
      semesterName = TextEditingController(text: this.semester.name);
      semesterJahr = TextEditingController(text: this.semester.jahr);
      semesterNotiz = TextEditingController(text: this.semester.notiz);
      isLoadedSemester = true;
    }

    final MyTextFormField txtName = MyTextFormField(
      controller: semesterName,
      labelText: 'Semester Name',
      validator: (String value) {
        if (value.isEmpty) {
          return 'Gib den Semester Name ein';
        }
        if (value.length > 40) {
          return 'Semester Name zu lang';
        }
        return null;
      },
      textAlign: TextAlign.left,
      autocorrect: false,
      onChanged: (text) {
        print(text);
      },
    );
    final MyTextFormField txtJahr = MyTextFormField(
      controller: semesterJahr,
      labelText: 'Jahr',
      validator: (String value) {
        if (value.isEmpty) {
          return 'Gib den Jahr ein';
        }
        if (value.length != 4) {
          return 'Ungültiges Jahr';
        }
        return null;
      },
      textAlign: TextAlign.left,
      autocorrect: false,
      onChanged: (text) {
        print(text);
      },
    );
    final MyTextArea txtNotiz = MyTextArea(
      labelText: 'Notiz',
      controller: semesterNotiz,
      onChanged: (text) {
        print(text);
      },
    );
    final btnSave = RaisedButton(
      color: kPrimaryColor,
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          var semester;
          if (isLoadedSemester) {
            print("entered in update");
            semester = new Semester(
                semesterName.text,
                this.semester.durchschnitt,
                semesterJahr.text,
                semesterNotiz.text);
            //semester.setId(this.semester.id);
            print(semester);
            updateS(semester, this.id);
          } else {
            semester = new Semester(
                semesterName.text, null, semesterJahr.text, semesterNotiz.text);
            semester.setId(saveSemester(semester));
          }
          Timer(Duration(seconds: 1), () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          });
        }
      },
      child: Text(
        'Speichern',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
    final container = Container(
        alignment: Alignment.bottomCenter,
        width: halfMediaWidth * 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(alignment: Alignment.topCenter, child: txtName),
            Container(alignment: Alignment.topCenter, child: txtJahr),
            Container(alignment: Alignment.topCenter, child: txtNotiz),
            Container(alignment: Alignment.topCenter, child: btnSave)
          ],
        ));

    return Scaffold(
      appBar: buildAppBar(),
      body: Form(key: _formKey, child: container),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Neues Semester'),
      elevation: 0,
    );
  }
}
