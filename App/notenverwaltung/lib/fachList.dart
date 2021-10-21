import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:notenverwaltung/database.dart';
import 'package:notenverwaltung/fach_page-test.dart';
import 'package:notenverwaltung/note_page.dart';

import 'UI/Cards/fach_card.dart';
import 'UI/Fach/components/add_fach.dart';
import 'fach.dart';
import 'package:flutter/material.dart';

import 'global.dart';

class FachList extends StatefulWidget {
  List<Fach> listItems;
  final String semesterId;

  FachList(this.listItems, this.semesterId);

  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<FachList> {
  void like(Function callBack) {
    this.setState(() {
      callBack();
    });
  }

  void updateFach() {
    if (this.widget.semesterId != null) {
      getAllFach(this.widget.semesterId).then((fachList) => {
            this.setState(() {
              this.widget.listItems = fachList;
            })
          });
    }
  }

  @override
  void initState() {
    super.initState();
    updateFach();
    //refreshSchnitt();
    //setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print('updated Fachschnitt in FachList');
    print(getFachschnitt(this.widget.listItems, this.widget.semesterId));

    print("semester/" + this.widget.semesterId + "/fach");
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("semester/" + this.widget.semesterId + "/fach")
            .orderBy(FieldPath.documentId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemBuilder: (context, index) {
                DocumentSnapshot fach = snapshot.data.docs[index];
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
                          key: Key(fach.id),
                          background: Container(color: Colors.red),
                          child: FachCard(
                            fachName: fach.get("fach_name"),
                            weight: fach.get("fach_gewichtung").toString(),
                            fachAvg: fach.get("fach_durchschnitt") != null
                                ? double.parse(fach
                                    .get("fach_durchschnitt")
                                    .toStringAsPrecision(2))
                                : null,
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  //DetailsScreen()
                                  builder: (context) => NoteTest(
                                      fachId: "semester/" +
                                          this.widget.semesterId +
                                          "/fach/" +
                                          fach.id),
                                ),
                              );
                            },
                            longPress: () {
                              Fach fach0 = new Fach(
                                  fach.get("fach_name"),
                                  fach.get("fach_gewichtung"),
                                  fach.get("fach_durchschnitt"),
                                  fach.get("fach_wunschNote"));
                              print(fach.id);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddFach(
                                      fach: fach0,
                                      semesterId: this.widget.semesterId,
                                      fachId: fach.id),
                                ),
                              );
                            },
                          ),
                          confirmDismiss: (direction) async {
                            var name = fach.get("fach_name");
                            final bool res = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
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
                                          Navigator.of(context).pop(true);
                                          deleteFach(
                                              this.widget.semesterId, fach.id);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          FachTest(
                                                            semesterId: this
                                                                .widget
                                                                .semesterId,
                                                          )));
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
