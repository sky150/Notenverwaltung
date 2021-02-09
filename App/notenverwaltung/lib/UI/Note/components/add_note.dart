import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notenverwaltung/UI/TextFields/MyTextFormField.dart';
import 'package:notenverwaltung/components/my_bottom_nav_bar.dart';
import 'package:notenverwaltung/global.dart';
import 'package:intl/intl.dart';
import 'package:notenverwaltung/models/note.dart';
import 'package:notenverwaltung/note_screen.dart';

class AddNote extends StatefulWidget {
  final int id;
  final int fachId;
  AddNote({this.id, this.fachId}) : super();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    print("AddNote id= " + id.toString() + " fachId: " + fachId.toString());
    return TestForm(fachId: fachId);
  }
}

class TestForm extends State<AddNote> {
  final int fachId;
  //Note note = Note();
  bool isLoadedSemester = false;
  TestForm({this.fachId}) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: FutureBuilder(
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
      ),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Neue Note'),
      elevation: 0,
    );
  }
}

class TestFormState extends StatefulWidget {
  final Note note;
  final int fachId;
  TestFormState({this.note, this.fachId}) : super();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TestFormState(fachId: fachId);
  }
}

class _TestFormState extends State<TestFormState> {
  Note note = new Note();
  final int fachId;
  _TestFormState({this.fachId}) : super();
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
    if (widget.note.id == null) {
      setState(() {
        this.isLoadedSemester = false;
      });
    } else {
      setState(() {
        this.note = Note.fromNote(widget.note);
        this.isLoadedSemester = true;
      });
    }
    print("ForeignKey fach id: " + this.fachId.toString());

    String noteValue = this.note.note.toString();
    TextEditingController noteNote = TextEditingController(text: noteValue);
    TextEditingController noteGewichtung;
    if (this.note.datum != null) {
      noteGewichtung = TextEditingController(text: this.note.gewichtung);
    } else {
      noteGewichtung = TextEditingController()..text = "100";
    }

    TextEditingController noteDatum;
    if (this.note.datum != null) {
      //var parsedDate = DateTime.parse(this.note.datum);
      noteDatum = TextEditingController(text: this.note.datum);
    } else {
      noteDatum = TextEditingController()
        ..text = formatter.format(selectedDate);
    }
    TextEditingController noteName =
        TextEditingController(text: this.note.name);

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
                      //Validation läuft nur BE weiss nicht warum
                      double note = double.parse(value);
                      if (note < 0.0 ||
                          note > 6.0 ||
                          note == 0.0 ||
                          value.isEmpty) {
                        return 'Gib eine gültige Note ein';
                      }
                      return null;
                    },
                    // onSaved: (String value) {
                    //   //model.note = double.parse(value);
                    // },
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
                    onSaved: (String value) {
                      //model.weight = int.parse(value);
                    },
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
                      // onTap: () {
                      //   setState(() {
                      //     _selectDate(context);
                      //   });
                      // },
                      decoration: InputDecoration(
                          //suffixIcon: Icon(Icons.arrow_drop_down),
                          //hintText: formatter.format(selectedDate),
                          // contentPadding: EdgeInsets.all(10.0),
                          // border: InputBorder.none,
                          // filled: true,
                          // fillColor: Colors.grey[200],
                          ),
                      // validator: (String value) {
                      //   if (value.isEmpty) {
                      //     return 'Gib den Datum ein';
                      //   }
                      //   return null;
                      // },
                      //initialValue: "selectedDate.toString()",
                      // onSaved: (String value) {
                      //   value = selectedDate.toString();
                      // },
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: RaisedButton(
                    color: kPrimaryColor,
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        //_formKey.currentState.save();
                        if (isLoadedSemester) {
                          print("entered in update");
                          await updateNote(this.note.id, noteNote,
                              noteGewichtung, noteDatum, noteName);
                        } else {
                          print("the id" + this.fachId.toString());
                          await createNote(noteNote, noteGewichtung, noteDatum,
                              noteName, this.fachId);
                          print("entered in create note");
                        }
                        Timer(Duration(seconds: 1), () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  //Result(model: this.model))
                                  builder: (context) =>
                                      NoteScreen(fachId: this.note.fachId)));
                        });
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
