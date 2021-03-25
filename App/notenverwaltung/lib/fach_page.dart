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
  //List<double> number;
  //bool isNumber = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Size size = MediaQuery.of(context).size;
    //print("Anfang im number" + this.number.toString());
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
                /*FutureBuilder(
                    future: getNotenschnitt(fach[index].id),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                      } else if (snapshot.data == null) {
                        return null;
                      }
                      if (index == null) {
                        return null;
                      } else {
                        this.number.add(
                            double.parse(snapshot.data.toStringAsFixed(2)));
                      }
                      for (int i = 0; i < fach.length; i++) {
                        /*print("Nummer" +
                            fach[index].id.toString() +
                            " double: " +
                            this.number.toString());*/
                        print("For schleife");
                        print(this.number[index]);
                      }
                      print("WAs in der Variable number steht:" +
                          this.number.toString());
                      return snapshot.hasData
                          ? Container(width: 0.0, height: 0.0)
                          : null;
                    }),*/
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
                            builder: (context) => AddFach(id: selectedId),
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
                                    if ('DONE' == deleteFach(fach[index].id)) {
                                      fach.removeAt(index);
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
                        builder: (context) => AddFach(semesterId: semesterId),
                      ));
                }),
            //FachScreen(),
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
