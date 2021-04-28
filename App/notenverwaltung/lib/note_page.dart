import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:notenverwaltung/UI/Note/components/add_note.dart';
import 'package:notenverwaltung/database.dart';
import 'package:notenverwaltung/note_screen.dart';

import 'components/title_with_more_bbtn.dart';
import 'note.dart';
import 'noteList.dart';

class NoteTest extends StatefulWidget {
  final DatabaseReference fachId;
  NoteTest({this.fachId}) : super();
  @override
  _NotePageState createState() => _NotePageState(fachId);
}

class _NotePageState extends State<NoteTest> {
  List<Note> noteList = [];
  final DatabaseReference fachId;

  _NotePageState(this.fachId);

  void newNote(String name, double note, int gewichtung, String datum) {
    var obj = new Note(name, note, gewichtung, datum);
    obj.setId(saveNote(obj, fachId));
    this.setState(() {
      noteList.add(obj);
    });
  }

  void updateNote() {
    getAllNote(fachId).then((noteList) => {
          this.setState(() {
            this.noteList = noteList;
          })
        });
  }

  @override
  void initState() {
    super.initState();
    updateNote();
  }

  @override
  Widget build(BuildContext context) {
    //print(getNotenschnitt(this.noteList).toString());
    var noteSchnitt;
    if (getNotenschnitt(this.noteList, fachId) != 0.00) {
      noteSchnitt = Center(
        child: Column(
          children: [
            Text(" ", textAlign: TextAlign.center),
            Text(
              'Notenschnitt: ' +
                  getNotenschnitt(this.noteList, fachId).toStringAsFixed(2),
              //snapshot.data.toStringAsFixed(2),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else {
      noteSchnitt = Container();
    }

    return Scaffold(
        appBar: buildAppBar(),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TitleWithMoreBtn(
                  title: "Note",
                  press: () {
                    print("Notepage id: " + fachId.toString());
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNote(fachId: fachId),
                        ));
                  }),
              Container(child: NoteListe(this.noteList)),
              noteSchnitt
            ]));
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
    );
  }
}
