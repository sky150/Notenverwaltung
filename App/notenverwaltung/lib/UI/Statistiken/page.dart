import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notenverwaltung/UI/Cards/fach_card.dart';
import 'package:notenverwaltung/UI/Cards/semester_card.dart';
import 'package:notenverwaltung/UI/Statistiken/donutChart.dart';
import 'package:notenverwaltung/components/my_bottom_nav_bar.dart';
import 'package:notenverwaltung/semester.dart';

import '../../database.dart';
import '../../global.dart';

class Statistiken extends StatefulWidget {
  @override
  StateStat createState() => StateStat();
}

class StateStat extends State<Statistiken> {
  String _chosenValue;
  String semesterId;
  List<Semester> semesterList = [];

  void newSemester(
      String name, double durchschnitt, String jahr, String notiz) {
    var semester = new Semester(name, durchschnitt, jahr, notiz);
    semester.setId(saveSemester(semester));
    this.setState(() {
      semesterList.add(semester);
    });
  }

  void updateSemester() {
    getAllSemester().then((semesterList) => {
          this.setState(() {
            this.semesterList = semesterList;
          })
        });
  }

  @override
  void initState() {
    super.initState();
    updateSemester();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('DropDown'),
        ),
        bottomNavigationBar: MyBottomNavBar(),
        body: SingleChildScrollView(
            child: Container(
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Container(
                  height: 500,
                  width: 300,
                  padding: const EdgeInsets.all(0.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("semester")
                            .orderBy(FieldPath.documentId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            List<String> semesterList;
                            List<DropdownMenuItem<String>> dropDown = [];
                            print(snapshot.data.docs[0].id);
                            for (int i = 0;
                                i < snapshot.data.docs.length;
                                i++) {
                              DocumentSnapshot snap = snapshot.data.docs[i];
                              print(snapshot.data.docs[i].get("semester_name"));
                              print(i);
                              if (snapshot.data.docs[i].get("semester_name") ==
                                  null) {
                                break;
                              } else {
                                dropDown.add(DropdownMenuItem(
                                    value: snapshot.data.docs[i]
                                        .get("semester_name"),
                                    child: Text(
                                      snapshot.data.docs[i]
                                          .get("semester_name"),
                                      style: TextStyle(color: Colors.white),
                                    )));
                              }
                              semesterId = snapshot.data.docs[i].id;
                            }
                            for (var i = 0; i < dropDown.length; i++) {
                              print(dropDown[i]);
                            }
                            return SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    DropdownButton<String>(
                                      value: _chosenValue,
                                      style: TextStyle(color: Colors.black),
                                      items: dropDown ?? [],
                                      hint: Text(
                                        "Wähle ein Semester aus",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      dropdownColor: Colors.black,
                                      onChanged: (String value) {
                                        print("The chosen Value: " +
                                            value.toString());
                                        setState(() {
                                          _chosenValue = value;
                                        });
                                      },
                                    ),
                                    Container(
                                      height: 500,
                                      width: 300,
                                      //color: Colors.red,
                                      child: ListView.builder(
                                          itemBuilder: (context, index) {
                                        DocumentSnapshot semester =
                                            snapshot.data.docs[index];
                                        if (_chosenValue ==
                                            semester.get("semester_name")) {
                                          print(semester.id);
                                          print("hello got in");
                                          print("semester/" +
                                              semester.id +
                                              "/fach");
                                          StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection("semester/" +
                                                      semester.id +
                                                      "/fach")
                                                  .orderBy(FieldPath.documentId)
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  print("is on");
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                } else {
                                                  print("is out");
                                                }
                                              });
                                          /*StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection("semester/" +
                                                      semester.id +
                                                      "/fach")
                                                  .orderBy(FieldPath.documentId)
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  print("is on");
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                } else {
                                                  print("is on");
                                                  return ListView.builder(
                                                      itemBuilder:
                                                          (context, index) {
                                                    DocumentSnapshot fach =
                                                        snapshot
                                                            .data.docs[index];
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        FachCard(
                                                            fachName: fach.get(
                                                                "fach_name"),
                                                            weight: fach
                                                                .get(
                                                                    "fach_gewichtung")
                                                                .toString(),
                                                            fachAvg: fach.get(
                                                                        "fach_durchschnitt") !=
                                                                    null
                                                                ? double.parse(fach
                                                                    .get(
                                                                        "fach_durchschnitt")
                                                                    .toStringAsPrecision(
                                                                        2))
                                                                : null,
                                                            press: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  //DetailsScreen()
                                                                  builder:
                                                                      (context) =>
                                                                          null,
                                                                ),
                                                              );
                                                            }),
                                                      ],
                                                    );
                                                  });
                                                }
                                              });*/
                                          /**/
                                        }
                                      }),
                                    )
                                  ]),
                            );
                          }
                        },
                      ),
                      //ysdf
                      /*DropdownButton<String>(
                        value: _chosenValue,
                        elevation: 5,
                        style: TextStyle(color: Colors.grey),
                        items: <String>["semesterList[index].name"]
                            .map<DropdownMenuItem<String>>((String value) {
                          print("DDDDDDDDDDDDDDDDDDDDDDDD");
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        hint: Text(
                          "Please choose a langauage",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        onChanged: (String value) {
                          setState(() {
                            _chosenValue = value;
                          });
                        },
                      ),*/
                      //}),
                    ],
                  )),
              //Spacer(),
              //DonutAutoLabelChart()
            ],
          ),
        )));
  }
}
