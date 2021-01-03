import 'package:flutter/material.dart';
import 'package:notenverwaltung/components/my_bottom_nav_bar.dart';
import 'package:notenverwaltung/UI/Fach/components/add_fach.dart';
import 'package:notenverwaltung/components/title_with_more_bbtn.dart';
import 'package:notenverwaltung/global.dart';
import 'package:notenverwaltung/note_screen.dart';
import 'UI/Cards/fach_card.dart';
import 'models/fach.dart';

class SemesterList extends StatelessWidget {
  final List<Fach> fach;

  SemesterList({Key key, this.fach}) : super(key: key);
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddFach(),
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
            Text(" "),
            Text('Notenschnitt: 4.45'),
            Text('Pluspunkte: -0.5'),

            //       Text("List task here"),
            //       Text('Notenschnitt: 4.45'),
            //       Text('Pluspunkte: -0.5'),
            //     ],
            //   ),
            // ),
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
