import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:notenverwaltung/UI/Cards/note_card.dart';
import 'package:notenverwaltung/UI/Note/components/add_note.dart';
import 'package:notenverwaltung/database.dart';
import 'package:notenverwaltung/note_page.dart';

import 'global.dart';
import 'note.dart';

class NoteListe extends StatefulWidget {
  final List<Note> listItems;
  final String fachId;

  NoteListe(this.listItems, this.fachId);

  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<NoteListe> {
  void like(Function callBack) {
    this.setState(() {
      callBack();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(this.widget.fachId + "/note/")
            .orderBy(FieldPath.documentId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemBuilder: (context, index) {
                DocumentSnapshot note = snapshot.data.docs[index];
                //var note = this.widget.listItems[index];
                return GestureDetector(
                    child: Container(
                  margin: EdgeInsets.only(
                    left: kDefaultPadding / 4,
                    top: kDefaultPadding / 4,
                    bottom: kDefaultPadding / 4,
                  ),
                  width: size.width * 0.9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Dismissible(
                          key: Key(note.id),
                          background: Container(color: Colors.red),
                          child: NoteCard(
                            noteName: note.get("note_name"),
                            note: note.get("note_note"),
                            press: () {
                              //DatabaseReference selectedId = note.id;
                              var obj = Note(
                                  note.get("note_name"),
                                  note.get("note_note"),
                                  note.get("note_gewichtung"),
                                  note.get("note_datum"));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  //DetailsScreen()
                                  builder: (context) => AddNote(
                                      note: obj,
                                      fachId: this.widget.fachId,
                                      noteId: note.id),
                                ),
                              );
                            },
                          ),
                          confirmDismiss: (direction) async {
                            final bool res = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  var name = note.get("note_name");
                                  return AlertDialog(
                                    title: new Text("${name}"),
                                    content: Text(
                                        "Wollen sie ${name} wirklich löschen?"),
                                    actions: <Widget>[
                                      FlatButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text("ABBRECHEN")),
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          deleteNote(
                                              this.widget.fachId, note.id);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          NoteTest(
                                                            fachId: this
                                                                .widget
                                                                .fachId,
                                                          )));
                                          /*NoteTest(
                                                fachId: this.widget.fachId,
                                              )));*/
                                        },
                                        child: const Text("LÖSCHEN"),
                                      ),
                                    ],
                                  );
                                });
                            return res;
                          })
                    ],
                  ),
                ));
              },
              itemCount: snapshot.data.docs.length,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
            );
          }
        });
  }
}
