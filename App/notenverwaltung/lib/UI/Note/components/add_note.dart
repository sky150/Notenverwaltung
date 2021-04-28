import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:notenverwaltung/UI/TextFields/MyTextFormField.dart';
import 'package:notenverwaltung/components/my_bottom_nav_bar.dart';
import 'package:notenverwaltung/database.dart';
import 'package:notenverwaltung/fach.dart';
import 'package:notenverwaltung/global.dart';
import 'package:intl/intl.dart';
import 'package:notenverwaltung/note.dart';
import 'package:notenverwaltung/note_page.dart';
//import 'package:notenverwaltung/models/fach.dart';
//import 'package:notenverwaltung/models/note.dart';
//import 'package:notenverwaltung/note_screen.dart';

class AddNote extends StatefulWidget {
  final Note note;
  final DatabaseReference fachId;
  AddNote({this.note, this.fachId}) : super();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    print("AddNote id= " + note.toString() + " fachId: " + fachId.toString());
    return TestForm(note: note, fachId: fachId);
  }
}

class TestForm extends State<AddNote> {
  final Note note;
  final DatabaseReference fachId;
  bool isLoadedSemester = false;
  TestForm({this.note, this.fachId}) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: TestFormState(note: note, fachId: fachId),
      /*FutureBuilder(
        future: getNoteById(widget.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (snapshot.hasData) {
            //
            return TestFormState(note: snapshot.data, fachId: fachId);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),*/
      bottomNavigationBar: MyBottomNavBar(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Center(
        child: Text('Neue Note'),
      ),
      //automaticallyImplyLeading: false,
      elevation: 0,
    );
  }
}

class TestFormState extends StatefulWidget {
  final Note note;
  final DatabaseReference fachId;
  TestFormState({this.note, this.fachId}) : super();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TestFormState(note: note, fachId: fachId);
  }
}

class _TestFormState extends State<TestFormState> {
  final Note note;
  final DatabaseReference fachId;
  _TestFormState({this.note, this.fachId}) : super();
  final _formKey = GlobalKey<FormState>();
  //NoteModel model = NoteModel();
  final DateFormat formatter = DateFormat('dd.MM.yyyy');
  DateTime selectedDate = DateTime.now();
  bool isLoadedSemester = false;

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate, // Refer step 1
        firstDate: DateTime(1970),
        lastDate: DateTime(2030),
        helpText: 'Wähle ein Datum aus',
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData(
              primarySwatch: Colors.blue,
              primaryColor: kPrimaryColor,
              accentColor: kPrimaryColor,
            ),
            child: child,
          );
        });
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        print(selectedDate.toString());
      });
  }

  @override
  Widget build(BuildContext context) {
    final halfMediaWidth = MediaQuery.of(context).size.width / 2.0;
    print("ForeignKey fach id: " + this.fachId.toString());

    /*String noteValue = this.note.note.toString();
    if (noteValue == 'null') {
      noteValue = '';
    }*/
    TextEditingController noteNote =
        TextEditingController(); //TextEditingController(text: noteValue);
    TextEditingController noteGewichtung = TextEditingController();
    /*if (this.note.datum != null) {
      String newNote = this.note.gewichtung.toString();
      noteGewichtung = TextEditingController(text: newNote);
    } else {
      noteGewichtung = TextEditingController()..text = "100";
    }*/

    TextEditingController noteDatum = TextEditingController()
      ..text = formatter.format(selectedDate);
    /*if (this.note.datum != null) {
      //var parsedDate = DateTime.parse(this.note.datum);
      noteDatum = TextEditingController(text: this.note.datum);
    } else {
      noteDatum = TextEditingController()
        ..text = formatter.format(selectedDate);
    }*/
    TextEditingController noteName = TextEditingController();
    if (note != null) {
      noteDatum = TextEditingController(text: this.note.datum);
      noteName = TextEditingController(text: this.note.name);
      noteNote = TextEditingController(text: this.note.note.toString());
      noteGewichtung =
          TextEditingController(text: this.note.gewichtung.toString());
      isLoadedSemester = true;
    }
    //TextEditingController(text: this.note.name);
    Fach object; //= new Fach(id: fachId);
    print("fach id für semesterId: " + fachId.toString());

    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.bottomCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  width: halfMediaWidth * 2,
                  child: MyTextNumberField(
                    controller: noteNote,
                    labelText: 'Note',
                    validator: (String value) {
                      double note = double.parse(value);
                      if (note < 0.0 ||
                          note > 6.0 ||
                          note == 0.0 ||
                          value.isEmpty) {
                        return 'Gib eine gültige Note ein';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  width: halfMediaWidth * 2,
                  child: MyTextNumberField(
                    controller: noteGewichtung,
                    labelText: 'Gewichtung',
                    validator: (String value) {
                      int weight = int.parse(value);
                      if (weight < 0 || weight > 100 || value.isEmpty) {
                        return 'Gib eine gültige Gewichtung ein';
                      }
                      return null;
                    },
                    onSaved: (String value) {},
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  width: halfMediaWidth * 2,
                  child: MyTextFormField(
                    controller: noteName,
                    labelText: 'Name',
                    autocorrect: false,
                    textAlign: TextAlign.left,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Gib den Namen ein';
                      }
                      return null;
                    },
                    onSaved: (String value) {
                      //model.fach = value;
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  width: halfMediaWidth * 2,
                  child: Padding(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    child: TextFormField(
                      controller: noteDatum,
                      decoration: InputDecoration(),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: RaisedButton(
                    color: kPrimaryColor,
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        var note;
                        if (isLoadedSemester) {
                          note = new Note(
                              noteName.text,
                              double.parse(noteNote.text),
                              int.parse(noteGewichtung.text),
                              noteDatum.text);
                          updateNote(note, this.note.id);
                        } else {
                          note = new Note(
                              noteName.text,
                              double.parse(noteNote.text),
                              int.parse(noteGewichtung.text),
                              noteDatum.text);
                          note.setId(saveNote(note, fachId));
                        }
                        Timer(Duration(seconds: 1), () {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NoteTest(fachId: fachId),
                            ),
                          );
                        });
                        /*if (isLoadedSemester) {
                          print("entered in update");
                          await updateNote(
                              this.note.id,
                              noteNote,
                              noteGewichtung,
                              noteDatum,
                              noteName,
                              this.note.fachId,
                              object.semesterId);
                          Timer(Duration(seconds: 1), () {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    //Result(model: this.model))
                                    builder: (context) =>
                                        NoteScreen(fachId: this.note.fachId)));
                          });
                        } else {
                          print("the id" + this.fachId.toString());
                          print("the foreignkei semesterId: " +
                              object.semesterId.toString());
                          await createNote(noteNote, noteGewichtung, noteDatum,
                              noteName, this.fachId, object.semesterId);
                          print("entered in create note");
                          Timer(Duration(seconds: 1), () {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    //Result(model: this.model))
                                    builder: (context) =>
                                        NoteScreen(fachId: this.fachId)));
                          });
                        }*/
                      }
                    },
                    child: Text(
                      'Speichern',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
