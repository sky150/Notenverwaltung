import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:notenverwaltung/components/my_bottom_nav_bar.dart';
import 'package:notenverwaltung/UI/Note/components/add_note.dart';
import 'package:notenverwaltung/components/title_with_more_bbtn.dart';
import 'package:notenverwaltung/models/fach.dart';
import 'package:notenverwaltung/models/note.dart';
import 'models/note.dart';
import 'package:notenverwaltung/global.dart';
import 'UI/Cards/note_card.dart';

class NoteList extends StatelessWidget {
  final List<Note> note;

  NoteList({Key key, this.note}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
      itemBuilder: (context, index) {
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
                    key: Key(note[index].id.toString()),
                    background: Container(color: Colors.red),
                    child: NoteCard(
                      noteName: note[index].name,
                      note: note[index].note,
                      press: () {
                        //int selectedId = note[index].id;
                        DatabaseReference id;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Container(), //AddNote(id: id),
                          ),
                        );
                      },
                    ),
                    confirmDismiss: (direction) async {
                      //if (direction == DismissDirection.endToStart) {
                      Fach object = new Fach();
                      object.id = this.note[index].fachId;
                      final bool res = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: new Text("${note[index].name}"),
                              content: Text(
                                  "Wollen sie ${note[index].name} wirklich löschen?"),
                              actions: <Widget>[
                                FlatButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text("ABBRECHEN")),
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                    if ('DONE' ==
                                        deleteNote(
                                            note[index].id,
                                            note[index].fachId,
                                            object.semesterId)) {
                                      note.removeAt(index);
                                    }
                                  },
                                  child: const Text("LÖSCHEN"),
                                ),
                              ],
                            );
                          });
                      return res;
                    }),
              ],
            ),
          ),
        );
      },
      itemCount: note.length,
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }
}

class NoteScreen extends StatelessWidget {
  final int fachId;
  NoteScreen({this.fachId}) : super();

  Fach object = new Fach();
  @override
  Widget build(BuildContext context) {
    object.id = 3;
    return Scaffold(
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TitleWithMoreBtn(
                title: "Noten",
                press: () {
                  print("Notescreen id: " + fachId.toString());
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Container(), //AddNote(fachId: fachId),
                      ));
                }),
            FutureBuilder(
              future: getNoten(3),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                } else if (snapshot.data == null) {
                  return Container(
                    child: Container(
                      child: Text("Loading..."),
                    ),
                  );
                }
                return snapshot.hasData
                    ? NoteList(note: snapshot.data)
                    : Center(child: CircularProgressIndicator());
              },
            ),
            FutureBuilder(
              future: getNotenschnitt(3),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                } else if (snapshot.data == null) {
                  return Container(
                    child: Container(
                      child: Text("Loading..."),
                    ),
                  );
                }
                return snapshot.hasData
                    ? Center(
                        child: Column(
                          children: [
                            Text(" ", textAlign: TextAlign.center),
                            Text(
                              'Notenschnitt: ' +
                                  snapshot.data.toStringAsFixed(2),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : Center();
              },
            ),
            FutureBuilder(
              future: getWunschNote(3),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                } else if (snapshot.data == null) {
                  return Container(
                    child: Container(
                      child: Text(""),
                    ),
                  );
                }
                return snapshot.hasData
                    ? Center(
                        child: Column(
                          children: [
                            Text(" ", textAlign: TextAlign.center),
                            Text(
                              'Wunschnote: ' + snapshot.data.toString(),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : Center();
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
    );
  }
}
