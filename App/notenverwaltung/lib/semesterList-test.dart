import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:notenverwaltung/fach_page-test.dart';
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
    return ListView.builder(
      itemBuilder: (context, index) {
        var semester = this.widget.listItems[index];
        print("im Listview builder : " + semester.durchschnitt.toString());
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
                  key: Key(semester.id.key),
                  background: Container(color: Colors.red),
                  child: SemesterCard(
                    semesterName: semester.name,
                    year: semester.jahr,
                    semesterAvg: semester.durchschnitt != null
                        ? double.parse(
                            semester.durchschnitt.toStringAsPrecision(2))
                        : null,
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          //DetailsScreen()
                          builder: (context) =>
                              FachTest(semesterId: semester.id),
                        ),
                      );
                    },
                    longPress: () {
                      print(semester.durchschnitt);
                      //int selectedId = semester.id;
                      //Semester selected = semester;
                      print(semester.name);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddSemester(semester: semester),
                        ),
                      );
                    },
                  ),
                  confirmDismiss: (direction) async {
                    final bool res = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text("${semester.name}"),
                            content: Text(
                                "Wollen sie ${semester.name} wirklich löschen?"),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () => Navigator.of(context).pop(),
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
      },
      itemCount: this.widget.listItems.length,
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }
}
