import 'package:flutter/material.dart';
import 'package:notenverwaltung/UI/TextFields/MyTextFormField.dart';
import 'package:notenverwaltung/models/semester.dart';
import 'package:notenverwaltung/semester_screen.dart';
import 'package:notenverwaltung/UI/home/home_screen.dart';
import 'package:notenverwaltung/components/my_bottom_nav_bar.dart';
import 'package:notenverwaltung/global.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddSemester extends StatefulWidget {
  final int id;
  AddSemester({this.id}) : super();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TestFormState();
  }
}

class _TestFormState extends State<AddSemester> {
  Semester semester = new Semester();
  bool isLoadedSemester = false;
  static const _semesterUrl = 'http://10.0.2.2:8888/semester';
  static final _headers = {'Content-Type': 'application/json'};

  createSemester() async {
    final response = await http.post(_semesterUrl,
        headers: _headers,
        body: json.encode({
          'name': name.text,
          'durchschnitt': 0.0,
          'jahr': jahr.text,
          'notiz': notiz.text
        }));
    if (response.statusCode == 200) {
      print(response.body.toString());
      return response;
    } else {
      print(response.statusCode);
      print(response.body);
    }
  }

  final _formKey = GlobalKey<FormState>();
  AddSemester model;
  var name = TextEditingController();
  var jahr = TextEditingController();
  var notiz = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: FutureBuilder(
        future: getSemesterById(widget.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (snapshot.hasData) {
            return DetailSemester(semester: snapshot.data);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Neues Semester'),
      elevation: 0,
    );
  }
}

class DetailSemester extends StatefulWidget {
  final Semester semester;
  DetailSemester({Key key, this.semester}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DetailSemesterState();
  }
}

class _DetailSemesterState extends State<DetailSemester> {
  Semester semester = new Semester();
  bool isLoadedSemester = false;

  @override
  Widget build(BuildContext context) {
    final halfMediaWidth = MediaQuery.of(context).size.width / 2.0;
    // TODO: implement build
    if (isLoadedSemester == false) {
      setState(() {
        this.semester = Semester.fromFach(widget.semester);
        this.isLoadedSemester = true;
      });
    }
    final MyTextFormField txtName = MyTextFormField(
      controller: TextEditingController(text: this.semester.name),
      labelText: 'Semester Name',
      validator: (String value) {
        if (value.isEmpty) {
          return 'Gib den Semester Name ein';
        }
        return null;
      },
      onChanged: (text) {
        setState(() {
          this.semester.name = text;
        });
      },
    );
    final MyTextFormField txtJahr = MyTextFormField(
      controller: TextEditingController(text: this.semester.jahr),
      labelText: 'Jahr',
      validator: (String value) {
        if (value.isEmpty) {
          return 'Gib den Jahr ein';
        }
        return null;
      },
      onChanged: (text) {
        setState(() {
          this.semester.jahr = text;
        });
      },
    );
    final MyTextArea txtNotiz = MyTextArea(
      labelText: 'Notiz',
      controller: TextEditingController(text: this.semester.notiz),
      onChanged: (text) {
        setState(() {
          this.semester.notiz = text;
        });
      },
    );
    final btnSave = RaisedButton(
      color: kPrimaryColor,
      onPressed: () async {
        Map<String, dynamic> params = Map<String, dynamic>();
        params["id"] = this.semester.id.toString();
        params["name"] = this.semester.name;
        params["jahr"] = this.semester.jahr;
        params["durchschnitt"] = this.semester.durchschnitt;
        params["notiz"] = this.semester.notiz;
        await updateSemester(params);
        //Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      },
      child: Text(
        'Speichern',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
    final container = Container(
        alignment: Alignment.bottomCenter,
        width: halfMediaWidth * 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                alignment: Alignment.topCenter,
                width: halfMediaWidth * 2,
                child: txtName),
            Container(
                alignment: Alignment.topCenter,
                width: halfMediaWidth * 2,
                child: txtJahr),
            Container(
                alignment: Alignment.topCenter,
                width: halfMediaWidth * 2,
                child: txtNotiz),
            Container(
                alignment: Alignment.topCenter,
                width: halfMediaWidth * 2,
                child: btnSave)
          ],
        ));
    return container;
  }
}
