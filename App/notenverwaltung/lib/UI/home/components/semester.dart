import 'package:flutter/material.dart';
import 'package:notenverwaltung/UI/Fach/fach_page.dart';
import 'package:notenverwaltung/models/global.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

//import 'package:plant_app/screens/details/details_screen.dart';
class SemesterModel {
  SemesterModel({this.id, this.name, this.durchschnitt, this.jahr, this.notiz});
  final int id;
  String name;
  double durchschnitt;
  String jahr;
  String notiz;
}

class Semester extends StatelessWidget {
  //SemesterModel model;
  static const _semesterUrl = 'http://10.0.2.2:8888/semester';
  static final _headers = {'Content-Type': 'application/json'};

  const Semester({
    Key key,
  }) : super(key: key);

  Future<List<SemesterModel>> getSemester() async {
    final response = await http.get(_semesterUrl);
    //print(response.body);
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

  List<SemesterModel> createSemesterList(List data) {
    List<SemesterModel> list = new List();
    //print(data);

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
    // for (int i = 0; i < list.length; i++) {
    //   print(list[i].id);
    //   print(list[i].name);
    //   print(list[i].durchschnitt);
    //   print(list[i].jahr);
    //   print(list[i].notiz);
    // }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //     child: new FutureBuilder<List<SemesterModel>>(
    //   future: readSemester(),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       Expanded(
    //         child: SizedBox(
    //           height: 200.0,
    //           child: new ListView.builder(
    //             scrollDirection: Axis.horizontal,
    //             itemCount: snapshot.data.length,
    //             itemBuilder: (BuildContext ctxt, int index) {
    //               return new Text(snapshot.data[index].name);
    //             },
    //           ),
    //         ),
    //       );
    //     } else if (snapshot.hasError) {
    //       return new Text("${snapshot.error}");
    //     }
    //     return new Text(snapshot.data[0].name);
    //   },
    // ));

    return Container(
        //scrollDirection: Axis.horizontal,
        child: new FutureBuilder(
      future: getSemester(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Container(
            child: Container(
              child: Text("Loading..."),
            ),
          );
          // print(snapshot.data);
          // Expanded(
          //     child: new ListView.builder(
          //         itemCount: snapshot.data.length,
          //         itemBuilder: (context, index) {
          //           return new Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: <Widget>[
          //                 SemesterCard(
          //                   semesterName: snapshot.data[index].name,
          //                   year: snapshot.data[index].jahr,
          //                   semesterAvg: snapshot.data[index].durchschnitt,
          //                   press: () {
          //                     Navigator.push(
          //                       context,
          //                       MaterialPageRoute(
          //                         //DetailsScreen()
          //                         builder: (context) => FachScreen(),
          //                       ),
          //                     );
          //                   },
          //                 ),
          //               ]);
          //         }));
        } else {
          Expanded(
              child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(snapshot.data[index].name),
                    );
                  }));
        }
        // By default, show a loading spinner
        return new Text(snapshot.data[3].name);
      },
    ));

    //Column(
    // children: <Widget>[
    //   SemesterCard(
    //     semesterName: "BZZ Semester 1",
    //     year: "2017",
    //     semesterAvg: 4.25,
    //     press: () {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           //DetailsScreen()
    //           builder: (context) => FachScreen(),
    //         ),
    //       );
    //     },
    //   ),
    //   SemesterCard(
    //     semesterName: "KVB Semester 3",
    //     year: "2019",
    //     semesterAvg: 5.67,
    //     press: () {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           //DetailsScreen()
    //           builder: (context) => FachScreen(),
    //         ),
    //       );
    //     },
    //   ),
    //   SemesterCard(
    //     semesterName: "ETH Semester 5",
    //     year: "2020",
    //     semesterAvg: 3.95,
    //     press: () {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           //DetailsScreen()
    //           builder: (context) => FachScreen(),
    //         ),
    //       );
    //     },
    //   ),
    // ],
    //),
    //);
  }
}

class SemesterCard extends StatelessWidget {
  const SemesterCard({
    Key key,
    this.semesterName,
    this.year,
    this.semesterAvg,
    this.press,
  }) : super(key: key);

  final String semesterName, year;
  final double semesterAvg;
  final Function press;

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
