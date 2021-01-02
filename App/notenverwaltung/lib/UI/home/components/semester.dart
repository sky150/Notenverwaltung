import 'package:flutter/material.dart';
import 'package:notenverwaltung/UI/Fach/fach_page.dart';
import 'package:notenverwaltung/UI/home/components/add_semester.dart';
import 'package:notenverwaltung/models/global.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'body.dart';

class SemesterModel {
  SemesterModel({this.id, this.name, this.durchschnitt, this.jahr, this.notiz});
  final int id;
  String name;
  double durchschnitt;
  String jahr;
  String notiz;
}

enum HttpRequestStatus { NOT_DONE, DONE, ERROR }

class Semester extends StatelessWidget {
  static const _semesterUrl = 'http://10.0.2.2:8888/semester';
  static final _headers = {'Content-Type': 'application/json'};

  const Semester({
    Key key,
  }) : super(key: key);

  Future<List<SemesterModel>> getSemester() async {
    final response = await http.get(_semesterUrl);
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body.toString());
      List<SemesterModel> semesterList = createSemesterList(responseJson);
      print(semesterList);
      for (int i = 0; i < semesterList.length; i++) {
        print(semesterList[i].id);
        print(semesterList[i].name);
        print(semesterList[i].durchschnitt);
        print(semesterList[i].jahr);
        print(semesterList[i].notiz);
      }

      return semesterList;
    } else {
      throw Exception('Failed to load note');
    }
  }

  Future deleteSemester(int id) async {
    String status = '';
    final url = '$_semesterUrl/$id';
    final response = await http.delete(url, headers: _headers);
    if (response.statusCode == 200) {
      print('Semester deleted with this id: $id');
      status = 'DONE';
    } else {
      status = 'NOT_DONE';
    }
    return status;
  }

  List<SemesterModel> createSemesterList(List data) {
    List<SemesterModel> list = new List();

    for (int i = 0; i < data.length; i++) {
      int id = data[i]["id"];
      String name = data[i]["name"];
      double durchschnitt = data[i]["durchschnitt"];
      String jahr = data[i]["jahr"];
      String notiz = data[i]["notiz"];
      SemesterModel semesterObject = new SemesterModel(
          id: id,
          name: name,
          durchschnitt: durchschnitt,
          jahr: jahr,
          notiz: notiz);
      list.add(semesterObject);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        margin: EdgeInsets.only(
          left: kDefaultPadding / 2,
          top: kDefaultPadding / 2,
          bottom: kDefaultPadding / 2,
        ),
        width: size.width * 0.9,
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: new FutureBuilder(
              future: getSemester(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    child: Container(
                      child: Text("Loading..."),
                    ),
                  );
                } else if (snapshot.hasData) {
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        var semester = snapshot.data[index];
                        return Dismissible(
                            key: Key(semester.id.toString()),
                            background: Container(color: Colors.red),
                            child: SemesterCard(
                              semesterName: semester.name,
                              year: semester.jahr,
                              semesterAvg: semester.durchschnitt,
                              press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    //DetailsScreen()
                                    builder: (context) => FachScreen(),
                                  ),
                                );
                              },
                              longPress: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    //DetailsScreen()
                                    builder: (context) => AddSemester(
                                        semesterId: semester.id,
                                        name: semester.name,
                                        jahr: semester.jahr,
                                        notiz: semester.notiz),
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
                                      title: new Text("${semester.name}"),
                                      content: Text(
                                          "Wollen sie ${semester.name} wirklich löschen?"),
                                      actions: <Widget>[
                                        FlatButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text("ABBRECHEN")),
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                            if ('DONE' ==
                                                deleteSemester(semester.id)) {
                                              snapshot.data.removeAt(index);
                                            }
                                          },
                                          child: const Text("LÖSCHEN"),
                                        ),
                                      ],
                                    );
                                  });
                              return res;
                            });
                        // return Dismissible(
                        //   key: Key(semester.id.toString()),
                        //   onDismissed: (direction) async {
                        //     var httpRequestStatus =
                        //         await deleteSemester(semester.id);
                        //     if (httpRequestStatus == 'DONE') {
                        //       return AlertDialog(
                        //         title: new Text("SemesterName"),
                        //         content: Text("Semester wirklich löschen?"),
                        //         actions: <Widget>[
                        //           FlatButton(
                        //               onPressed: () =>
                        //                   Navigator.of(context).pop(false),
                        //               child: const Text("ABBRECHEN")),
                        //           FlatButton(
                        //             onPressed: () =>
                        //                 snapshot.data.removeAt(index),
                        //             child: const Text("LÖSCHEN"),
                        //           ),
                        //         ],
                        //       );
                        //     }
                        //   },
                        //   background: Container(color: Colors.red),
                        //   child: SemesterCard(
                        //       semesterName: semester.name,
                        //       year: semester.jahr,
                        //       semesterAvg: semester.durchschnitt,
                        //       press: () {
                        //         Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //             //DetailsScreen()
                        //             builder: (context) => FachScreen(),
                        //           ),
                        //         );
                        //       }),
                        // );
                      });
                } else {
                  return new CircularProgressIndicator();
                }
              },
            )));
  }
}

class SemesterCard extends StatelessWidget {
  const SemesterCard(
      {Key key,
      this.semesterName,
      this.year,
      this.semesterAvg,
      this.press,
      this.longPress})
      : super(key: key);

  final String semesterName, year;
  final double semesterAvg;
  final Function press;
  final Function longPress;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
        left: kDefaultPadding,
        top: kDefaultPadding / 2,
        bottom: kDefaultPadding / 2,
      ),
      width: size.width * 0.9,
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: press,
            onLongPress: longPress,
            child: Container(
              padding: EdgeInsets.all(kDefaultPadding / 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50,
                    color: kPrimaryColor.withOpacity(0.23),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "$semesterName\n".toUpperCase(),
                            style: Theme.of(context).textTheme.button),
                        TextSpan(
                          text: "$year".toUpperCase(),
                          style: TextStyle(
                            color: kPrimaryColor.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Text('$semesterAvg',
                      style: Theme.of(context).textTheme.button.copyWith(
                            color: ((this.semesterAvg < 4.0)
                                ? kTextRed
                                : (this.semesterAvg < 5.0 &&
                                        this.semesterAvg > 4.0)
                                    ? kTextYellow
                                    : kTextGreen),
                          ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
