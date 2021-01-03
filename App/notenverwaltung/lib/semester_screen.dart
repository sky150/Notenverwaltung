import 'package:flutter/material.dart';
import 'package:notenverwaltung/fach_page.dart';
import 'package:notenverwaltung/UI/home/components/add_semester.dart';
import 'package:notenverwaltung/global.dart';
import 'UI/Cards/semester_card.dart';
import 'models/semester.dart';

class SemesterList extends StatelessWidget {
  final List<Semester> semester;

  SemesterList({Key key, this.semester}) : super(key: key);
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
                  key: Key(semester[index].id.toString()),
                  background: Container(color: Colors.red),
                  child: SemesterCard(
                    semesterName: semester[index].name,
                    year: semester[index].jahr,
                    semesterAvg: semester[index].durchschnitt,
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          //DetailsScreen()
                          builder: (context) =>
                              FachScreen(semesterId: semester[index].id),
                        ),
                      );
                    },
                    longPress: () {
                      int selectedId = semester[index].id;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddSemester(id: selectedId),
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
                            title: new Text("${semester[index].name}"),
                            content: Text(
                                "Wollen sie ${semester[index].name} wirklich löschen?"),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text("ABBRECHEN")),
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                  if ('DONE' ==
                                      deleteSemester(semester[index].id)) {
                                    semester.removeAt(index);
                                  }
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
      itemCount: semester.length,
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }

  // scrollDirection: Axis.vertical,
  // physics: NeverScrollableScrollPhysics(),
  // shrinkWrap: true,
  // itemCount: snapshot.data.length,
  // itemBuilder: (context, index) {
  //   var semester = snapshot.data[index];
  //   return Dismissible(
  //       key: Key(semester.id.toString()),
  //       background: Container(color: Colors.red),
  //       child: SemesterCard(
  //         semesterName: semester.name,
  //         year: semester.jahr,
  //         semesterAvg: semester.durchschnitt,
  //         press: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               //DetailsScreen()
  //               builder: (context) => FachScreen(),
  //             ),
  //           );
  //         },
  //         longPress: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               //DetailsScreen()
  //               builder: (context) => AddSemester(
  //                   semesterId: semester.id,
  //                   name: semester.name,
  //                   jahr: semester.jahr,
  //                   notiz: semester.notiz),
  //             ),
  //           );
  //         },
  //       ),
  //       confirmDismiss: (direction) async {
  //         //if (direction == DismissDirection.endToStart) {
  //         final bool res = await showDialog(
  //             context: context,
  //             builder: (BuildContext context) {
  //               return AlertDialog(
  //                 title: new Text("${semester.name}"),
  //                 content: Text(
  //                     "Wollen sie ${semester.name} wirklich löschen?"),
  //                 actions: <Widget>[
  //                   FlatButton(
  //                       onPressed: () => Navigator.of(context).pop(),
  //                       child: const Text("ABBRECHEN")),
  //                   FlatButton(
  //                     onPressed: () {
  //                       Navigator.of(context).pop(true);
  //                       if ('DONE' == deleteSemester(semester.id)) {
  //                         snapshot.data.removeAt(index);
  //                       }
  //                     },
  //                     child: const Text("LÖSCHEN"),
  //                   ),
  //                 ],
  //               );
  //             });
  //         return res;
  //       });
  // });
}

enum HttpRequestStatus { NOT_DONE, DONE, ERROR }

class SemesterScreen extends StatelessWidget {
  const SemesterScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: getSemester(),
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
            ? SemesterList(semester: snapshot.data)
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}
