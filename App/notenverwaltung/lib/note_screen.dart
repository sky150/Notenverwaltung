import 'package:flutter/material.dart';
import 'package:notenverwaltung/components/my_bottom_nav_bar.dart';
import 'package:notenverwaltung/UI/Note/components/add_note.dart';
import 'package:notenverwaltung/components/title_with_more_bbtn.dart';
import 'package:notenverwaltung/models/note.dart';
import 'models/note.dart';
import 'package:notenverwaltung/global.dart';
import 'UI/Cards/note_card.dart';

class NoteList extends StatelessWidget {
  final List<Note> note;

  NoteList({Key key, this.note}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            //DetailsScreen()
                            builder: (context) => null,
                          ),
                        );
                      },
                      longPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              //DetailsScreen()
                              // builder: (context) => AddSemester(
                              //     semesterId: semester.id,
                              //     name: semester.name,
                              //     jahr: semester.jahr,
                              //     notiz: semester.notiz),
                              ),
                        );
                      },
                    ),
                    confirmDismiss: (direction) async {
                      //if (direction == DismissDirection.endToStart) {
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
                                    if ('DONE' == deleteNote(note[index].id)) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TitleWithMoreBtn(
                title: "Noten",
                press: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddNote(),
                      ));
                }),
            FutureBuilder(
              future: getNoten(fachId),
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
            Text(" "),
            Text('Notenschnitt: 4.45'),
            Text('Wunschnote: -0.5'),
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
