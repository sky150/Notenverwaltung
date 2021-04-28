import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:notenverwaltung/database.dart';

import 'UI/Fach/components/add_fach.dart';
import 'components/title_with_more_bbtn.dart';
import 'fach.dart';
import 'fachList.dart';

class FachTest extends StatefulWidget {
  final DatabaseReference semesterId;
  FachTest({this.semesterId}) : super();
  @override
  _FachPageState createState() => _FachPageState(semesterId);
}

class _FachPageState extends State<FachTest> {
  List<Fach> fachList = [];
  final DatabaseReference semesterId;

  _FachPageState(this.semesterId);

  void newSemester(
      String name, double durchschnitt, int gewichtung, double wunschNote) {
    var fach = new Fach(name, gewichtung, durchschnitt, wunschNote);
    fach.setId(saveFach(fach, semesterId));
    this.setState(() {
      fachList.add(fach);
    });
  }

  void updateFach() {
    getAllFach(semesterId).then((fachList) => {
          this.setState(() {
            this.fachList = fachList;
          })
        });
  }

  @override
  void initState() {
    super.initState();
    updateFach();
  }

  @override
  Widget build(BuildContext context) {
    var fachSchnitt;
    if (getFachschnitt(this.fachList, semesterId) != 0.00) {
      fachSchnitt = Center(
        child: Column(
          children: [
            Text(" ", textAlign: TextAlign.center),
            Text(
              'Fachschnitt: ' +
                  getFachschnitt(this.fachList, semesterId).toStringAsFixed(2),
              //snapshot.data.toStringAsFixed(2),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else {
      fachSchnitt = Container();
    }
    return Scaffold(
        appBar: buildAppBar(),
        body: Column(
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
              Container(child: FachList(this.fachList)),
              fachSchnitt
            ]));
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
    );
  }
}
