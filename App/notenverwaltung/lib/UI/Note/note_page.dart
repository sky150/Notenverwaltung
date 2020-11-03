import 'package:flutter/material.dart';
import 'package:notenverwaltung/models/global.dart';

//Später mit REST JSON: https://flutter.dev/docs/development/data-and-backend/json
class Note extends StatefulWidget {

  @override
  _Note createState() => _Note();

}


class _Note extends State<Note> {

  @override
  Widget build(BuildContext context){
      return new Scaffold(
      appBar: new AppBar(
        title: Text(
          'Noten',
          style:fontStyle,
          ),
          centerTitle: false,
          elevation: 0,
      ),
      body: new Center(
        child: new Text("Noten"),
      ),
    );
  }

}