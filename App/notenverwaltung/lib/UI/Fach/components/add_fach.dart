import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:notenverwaltung/UI/TextFields/MyTextFormField.dart';
import 'package:notenverwaltung/database.dart';
import 'package:notenverwaltung/fach.dart';
import 'package:notenverwaltung/fach_page-test.dart';
import 'package:notenverwaltung/fach_page.dart';
import 'package:notenverwaltung/components/my_bottom_nav_bar.dart';
import 'package:notenverwaltung/global.dart';
import 'package:notenverwaltung/models/note.dart';
import 'dart:async';

class AddFach extends StatefulWidget {
  final Fach fach;
  final String semesterId;
  String fachId;
  AddFach({this.fach, this.semesterId, this.fachId}) : super();

  @override
  State<StatefulWidget> createState() {
    return _FormState(fach: fach, semesterId: semesterId, fachId: fachId);
  }
}

class _FormState extends State<AddFach> {
  final String semesterId;
  String fachId;
  final Fach fach;
  _FormState({this.fach, this.semesterId, this.fachId}) : super();
  bool isLoadedSemester = false;

  @override
  Widget build(BuildContext context) {
    print("Semester id: " + semesterId.toString());
    return Scaffold(
      appBar: buildAppBar(),
      body: DetailFach(fach: fach, semesterId: semesterId, fachId: fachId),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Neues Fach'),
      elevation: 0,
    );
  }
}

class DetailFach extends StatelessWidget {
  final Fach fach;
  final String semesterId;
  String fachId;
  bool isLoadedSemester = false;
  final _formKey = GlobalKey<FormState>();

  DetailFach({Key key, this.fach, this.semesterId, this.fachId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final halfMediaWidth = MediaQuery.of(context).size.width / 2.0;

    TextEditingController fachName = TextEditingController();
    TextEditingController fachGewichtung = TextEditingController();
    TextEditingController fachWunschNote = TextEditingController();
    if (fach != null) {
      fachName = TextEditingController(text: this.fach.name);
      fachGewichtung =
          TextEditingController(text: this.fach.gewichtung.toString());
      fachWunschNote =
          TextEditingController(text: this.fach.wunschNote.toString());
      isLoadedSemester = true;
      print(
          "From Add Fach: " + this.fach.name + this.fach.gewichtung.toString());
    }

    final MyTextFormField txtName = MyTextFormField(
      controller: fachName,
      labelText: 'Fach Name',
      validator: (String value) {
        if (value.isEmpty) {
          return 'Gib den Fach Name ein';
        }
        if (value.length > 40) {
          return 'Fach Name zu lang';
        }
        return null;
      },
      textAlign: TextAlign.left,
      autocorrect: false,
      onChanged: (text) {
        print(text);
      },
    );
    final MyTextFormField txtGewichtung = MyTextFormField(
      controller: fachGewichtung,
      labelText: 'Gewichtung',
      validator: (String value) {
        if (value.isEmpty) {
          return 'Gib die Gewichtung ein';
        }
        if (value.length > 3) {
          return 'Ungültige Gewichtung';
        }
        return null;
      },
      textAlign: TextAlign.left,
      autocorrect: false,
      onChanged: (text) {
        print(text);
      },
    );
    final MyTextFormField txtWunschNote = MyTextFormField(
      controller: fachWunschNote,
      labelText: 'Wunschnote',
      validator: (String value) {
        if (value.isEmpty) {
          return 'Gib die Gewichtung ein';
        }
        return null;
      },
      textAlign: TextAlign.left,
      autocorrect: false,
    );
    final btnSave = RaisedButton(
      color: kPrimaryColor,
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          var fach;
          if (isLoadedSemester) {
            fach = new Fach(fachName.text, int.parse(fachGewichtung.text),
                this.fach.durchschnitt, double.parse(fachWunschNote.text));
            updateFach(fach, this.fachId, this.semesterId);
          } else {
            fach = new Fach(fachName.text, int.parse(fachGewichtung.text), null,
                double.parse(fachWunschNote.text));
            fach.setId(saveFach(fach, semesterId));
          }
          Timer(Duration(seconds: 1), () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => FachTest(semesterId: semesterId),
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
            Container(alignment: Alignment.topCenter, child: txtGewichtung),
            Container(alignment: Alignment.topCenter, child: txtWunschNote),
            Container(alignment: Alignment.topCenter, child: btnSave)
          ],
        ));
    return Form(key: _formKey, child: container);
  }
}
