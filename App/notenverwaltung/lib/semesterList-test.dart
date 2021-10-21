//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:notenverwaltung/fach_page-test.dart';
import 'package:notenverwaltung/semester-test_screen.dart';
import 'UI/Cards/semester_card.dart';
import 'UI/home/components/add_semester.dart';
import 'database.dart';
import 'fach_page.dart';
import 'global.dart';
import 'semester.dart';

class SemesterList extends StatefulWidget {
  final List<Semester> listItems;

  SemesterList(this.listItems);

  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<SemesterList> {
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
            .collection("semester")
            .orderBy(FieldPath.documentId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            //List<Semester> semester = snapshot.data;
            return ListView.builder(
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  //var semesterO = this.widget.listItems[index];

                  for (var i = 0; i < snapshot.data.size; i++) {}
                  DocumentSnapshot semester = snapshot.data.docs[index];
                  //var semester = snapshot.data[index];
                  /*print("semesterList-test = semester.durchschnitt: " +
                      semester.durchschnitt.toString());*/
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
                            key: Key(semester.id),
                            background: Container(color: Colors.red),
                            child: SemesterCard(
                              semesterName: semester.get("semester_name"),
                              year: semester.get("semester_jahr"),
                              semesterAvg:
                                  semester.get("semester_durchschnitt") != null
                                      ? double.parse(semester
                                          .get("semester_durchschnitt")
                                          .toStringAsPrecision(2))
                                      : null,
                              press: () {
                                print(snapshot.data.docs[index].id);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    //DetailsScreen()
                                    builder: (context) => FachTest(
                                        semesterId:
                                            snapshot.data.docs[index].id),
                                  ),
                                );
                              },
                              longPress: () {
                                Semester semester0 = new Semester(
                                    semester.get("semester_name"),
                                    semester.get("semester_durchschnitt"),
                                    semester.get("semester_jahr"),
                                    semester.get("semester_notiz"));
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddSemester(
                                        semester: semester0, id: semester.id),
                                  ),
                                );
                              },
                            ),
                            confirmDismiss: (direction) async {
                              final bool res = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    var name = semester.get("semester_name");
                                    return AlertDialog(
                                      title: new Text("$name"),
                                      content: Text(
                                          "Wollen sie $name wirklich löschen?"),
                                      actions: <Widget>[
                                        FlatButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text("ABBRECHEN")),
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                            deleteSemester(semester.id);
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
                });
          }
        }
        /*itemCount: this.widget.listItems.length,
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,*/
        );
    // }
    //});
  }
}
