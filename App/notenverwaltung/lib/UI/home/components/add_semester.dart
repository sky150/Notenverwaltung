import 'package:flutter/material.dart';
import 'package:notenverwaltung/UI/TextFields/MyTextFormField.dart';
import 'package:notenverwaltung/models/semester.dart';
import 'package:notenverwaltung/semester_screen.dart';
import 'package:notenverwaltung/UI/home/home_screen.dart';
import 'package:notenverwaltung/components/my_bottom_nav_bar.dart';
import 'package:notenverwaltung/global.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddSemester extends StatefulWidget {
  final int id;
  AddSemester({this.id}) : super();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TestFormState();
  }
}

class _TestFormState extends State<AddSemester> {
  Semester semester = new Semester();
  bool isLoadedSemester = false;

  AddSemester model;
  var name = TextEditingController();
  var jahr = TextEditingController();
  var notiz = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: FutureBuilder(
        future: getSemesterById(widget.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (snapshot.hasData) {
            return DetailSemester(semester: snapshot.data);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
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

class DetailSemester extends StatefulWidget {
  final Semester semester;
  DetailSemester({Key key, this.semester}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DetailSemesterState();
  }
}

class _DetailSemesterState extends State<DetailSemester> {
  Semester semester = new Semester();
  bool isLoadedSemester = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final halfMediaWidth = MediaQuery.of(context).size.width / 2.0;
    // TODO: implement build
    if (widget.semester.id == null) {
      setState(() {
        this.isLoadedSemester = false;
      });
    } else {
      setState(() {
        this.semester = Semester.fromFach(widget.semester);
        this.isLoadedSemester = true;
      });
    }

    TextEditingController semesterName =
        TextEditingController(text: this.semester.name);
    TextEditingController semesterJahr =
        TextEditingController(text: this.semester.jahr);
    TextEditingController semesterNotiz =
        TextEditingController(text: this.semester.notiz);

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
          if (isLoadedSemester) {
            print("entered in update");
            await updateSemester(this.semester.id, this.semester.durchschnitt,
                semesterName, semesterJahr, semesterNotiz);
          } else {
            await createSemester(semesterName, semesterJahr, semesterNotiz);
            print("entered in create");
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
    return Form(key: _formKey, child: container);
  }
}
