import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:notenverwaltung/components/my_bottom_nav_bar.dart';
import 'package:notenverwaltung/UI/Fach/components/add_fach.dart';
import 'package:notenverwaltung/components/title_with_more_bbtn.dart';
import 'package:notenverwaltung/global.dart';
import 'package:notenverwaltung/note_screen.dart';
import 'UI/Cards/fach_card.dart';
import 'database_helper.dart';
import 'models/fach.dart';
import 'models/note.dart';

class SemesterList extends StatelessWidget {
  final List<Fach> fach;

  SemesterList({Key key, this.fach}) : super(key: key);
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
                    key: Key(fach[index].id.toString()),
                    background: Container(color: Colors.red),
                    child: FachCard(
                      fachName: fach[index].name,
                      weight: fach[index].gewichtung,
                      fachAvg: fach[index].durchschnitt,
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            //DetailsScreen()
                            builder: (context) =>
                                NoteScreen(fachId: fach[index].id),
                          ),
                        );
                      },
                      longPress: () {
                        int selectedId = fach[index].id;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Container(), //AddFach(id: selectedId),
                          ),
                        );
                      },
                    ),
                    confirmDismiss: (direction) async {
                      final bool res = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: new Text("${fach[index].name}"),
                              content: Text(
                                  "Wollen sie ${fach[index].name} wirklich löschen?"),
                              actions: <Widget>[
                                FlatButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text("ABBRECHEN")),
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                    if ('DONE' ==
                                        deleteFach(fach[index].id,
                                            fach[index].semesterId)) {
                                      fach.removeAt(index);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => FachScreen(
                                                    semesterId:
                                                        fach[index].semesterId,
                                                  )));
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
      itemCount: fach.length,
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }
}

class FachScreen extends StatelessWidget {
  final int semesterId;
  FachScreen({this.semesterId}) : super();
  DatabaseReference semesterIdw;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TitleWithMoreBtn(
                title: "Fächer",
                press: () {
                  print("Fachscreen id: " + semesterId.toString());
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddFach(semesterId: semesterIdw),
                      ));
                }),
            FutureBuilder(
              future: getFaecher(semesterId),
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
                    ? SemesterList(fach: snapshot.data)
                    : Center(child: CircularProgressIndicator());
              },
            ),
            FutureBuilder(
              future: getNotenschnittFach(semesterId),
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
                            Text(
                              'Pluspunkte: -0.5',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : Center(child: CircularProgressIndicator());
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
