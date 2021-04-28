import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:notenverwaltung/UI/Cards/note_card.dart';
import 'package:notenverwaltung/UI/Note/components/add_note.dart';
import 'package:notenverwaltung/database.dart';

import 'global.dart';
import 'note.dart';

class NoteListe extends StatefulWidget {
  final List<Note> listItems;

  NoteListe(this.listItems);

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
    return ListView.builder(
      itemBuilder: (context, index) {
        var note = this.widget.listItems[index];
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
                  key: Key(note.id.key),
                  background: Container(color: Colors.red),
                  child: NoteCard(
                    noteName: note.name,
                    note: note.note,
                    press: () {
                      DatabaseReference selectedId = note.id;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          //DetailsScreen()
                          builder: (context) =>
                              AddNote(note: note, fachId: selectedId),
                        ),
                      );
                    },
                  ),
                  confirmDismiss: (direction) async {
                    final bool res = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text("${note.name}"),
                            content: Text(
                                "Wollen sie ${note.name} wirklich löschen?"),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text("ABBRECHEN")),
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                  deleteNote(note.id);
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
      itemCount: this.widget.listItems.length,
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }
}
