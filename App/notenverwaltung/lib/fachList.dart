import 'package:firebase_database/firebase_database.dart';
import 'package:notenverwaltung/database.dart';
import 'package:notenverwaltung/note_page.dart';

import 'UI/Cards/fach_card.dart';
import 'UI/Fach/components/add_fach.dart';
import 'fach.dart';
import 'package:flutter/material.dart';

import 'global.dart';

class FachList extends StatefulWidget {
  final List<Fach> listItems;

  FachList(this.listItems);

  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<FachList> {
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
        var fach = this.widget.listItems[index];
        @override
        void initState() {
          super.initState();
        }

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
                  key: Key(fach.id.key),
                  background: Container(color: Colors.red),
                  child: FachCard(
                    fachName: fach.name,
                    weight: fach.gewichtung.toString(),
                    fachAvg: fach.durchschnitt != null
                        ? double.parse(fach.durchschnitt.toStringAsPrecision(2))
                        : null,
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          //DetailsScreen()
                          builder: (context) => NoteTest(fachId: fach.id),
                        ),
                      );
                    },
                    longPress: () {
                      DatabaseReference selectedId = fach.id;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddFach(fach: fach, semesterId: selectedId),
                        ),
                      );
                    },
                  ),
                  confirmDismiss: (direction) async {
                    final bool res = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text("${fach.name}"),
                            content: Text(
                                "Wollen sie ${fach.name} wirklich löschen?"),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text("ABBRECHEN")),
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                  deleteFach(fach.id);
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
