import 'package:flutter/material.dart';
import 'package:notenverwaltung/global.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum HttpRequestStatus { NOT_DONE, DONE, ERROR }

class Note extends StatelessWidget {
  Note({this.id, this.note});
  final int id;
  String note;
  static const _notenUrl = 'http://10.0.2.2:8888/noten';
  static final _headers = {'Content-Type': 'application/json'};
  //const Note({
  //  Key key,
  //}) : super(key: key);
  HttpRequestStatus httpRequestStatus = HttpRequestStatus.NOT_DONE;

  Future<List<Note>> readNoten() async {
    final response = await http.get(_notenUrl);
    print(response.body);
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body.toString());
      List<Note> notenList = createNotenList(responseJson);
      return notenList;
    } else {
      throw Exception('Failed to load note');
    }
  }

  List<Note> createNotenList(List data) {
    List<Note> list = new List();
    print(data);

    for (int i = 0; i < data.length; i++) {
      String note = data[i]["note"];
      int id = data[i]["id"];
      Note noteObject = new Note(id: id, note: note);
      list.add(noteObject);
    }
    for (int i = 0; i < list.length; i++) {
      print(list[i].id);
      print(list[i].note);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    //SingleChildScrollView
    return Container(
      //scrollDirection: Axis.horizontal,
      child: new FutureBuilder<List<Note>>(
        future: readNoten(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return new ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(snapshot.data[index].note,
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                        new Divider()
                      ]);
                });
          } else if (snapshot.hasError) {
            return new Text("${snapshot.error}");
          }

          // By default, show a loading spinner
          return new CircularProgressIndicator();
        },
        //children: <Widget>[
        //  NoteCard(
        //    noteName: "Abschreibung",
        //    note: 4.50,
        //    press: () {
        //      Navigator.push(
        //        context,
        //        MaterialPageRoute(
        //         //DetailsScreen()
        //         builder: (context) => null,
        //       ),
        //     );
        //   },
        //),
        //Text(" "),
        //Text('Notenschnitt: 4.45'),
        //Text('Wunschnote: -0.5'),
        //],
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  const NoteCard({
    Key key,
    this.noteName,
    this.weight,
    this.note,
    this.press,
  }) : super(key: key);

  final String noteName, weight;
  final double note;
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
                            text: "$noteName\n".toUpperCase(),
                            style: Theme.of(context).textTheme.button),
                      ],
                    ),
                  ),
                  Spacer(),
                  Text('$note',
                      style: Theme.of(context).textTheme.button.copyWith(
                            color: kPrimaryColor,
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
