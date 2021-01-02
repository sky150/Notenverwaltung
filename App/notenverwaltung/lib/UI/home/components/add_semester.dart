import 'package:flutter/material.dart';
import 'package:notenverwaltung/UI/home/components/model/semester.dart';
import 'package:notenverwaltung/UI/home/components/semester.dart';
import 'package:notenverwaltung/UI/home/home_screen.dart';
import 'package:notenverwaltung/components/my_bottom_nav_bar.dart';
import 'package:notenverwaltung/models/global.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum HttpRequestStatus { NOT_DONE, DONE, ERROR }

class SemesterModel {
  int semesterId;
  String name;
  String jahr;
  String notiz;

  SemesterModel({this.semesterId, this.name, this.jahr, this.notiz}) : super();
}

class AddSemester extends StatelessWidget {
  int semesterId;
  String name;
  String jahr;
  String notiz;

  AddSemester({this.semesterId, this.name, this.jahr, this.notiz}) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: TestForm(),
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

class TestForm extends StatefulWidget {
  @override
  _TestFormState createState() => _TestFormState();
}

class _TestFormState extends State<TestForm> {
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

  Future updateSemester(int id, String name, String jahr, String notiz) async {
    String status = '';
    final url = '$_semesterUrl/$id';
    final response = await http.put(url,
        headers: _headers,
        body: json
            .encode({'id': id, 'name': name, 'jahr': jahr, 'notiz': notiz}));
    if (response.statusCode == 201) {
      print(response.body.toString());
      status = 'DONE';
    } else {
      status = 'NOT_DONE';
    }
    return status;
  }

  final _formKey = GlobalKey<FormState>();
  AddSemester model;
  //AddSemester semester = AddSemester();
  var name = TextEditingController();
  var jahr = TextEditingController();
  var notiz = TextEditingController();
  // String updateName;
  // String updateJahr;
  // String updateNotiz;
  //bool canSave = false;

  @override
  Widget build(BuildContext context) {
    final halfMediaWidth = MediaQuery.of(context).size.width / 2.0;

    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.bottomCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  width: halfMediaWidth * 2,
                  child: MyTextFormField(
                    controller: name,
                    labelText: 'Semester Name',
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Gib den Semester Name ein';
                      }
                      return null;
                    },
                    onChanged: (text) {
                      setState(() {
                        text = this.model.name;
                      });
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  width: halfMediaWidth * 2,
                  child: MyTextFormField(
                    controller: jahr,
                    labelText: 'Jahr',
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Gib den Jahr ein';
                      }
                      return null;
                    },
                    onChanged: (text) {
                      setState(() {
                        text = this.model.jahr;
                      });
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  width: halfMediaWidth * 2,
                  child: MyTextArea(
                    labelText: 'Notiz',
                    controller: notiz,
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: RaisedButton(
                    color: kPrimaryColor,
                    onPressed: () {
                      createSemester();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              //Result(model: this.model))
                              builder: (context) => HomeScreen()));
                    },
                    child: Text(
                      'Speichern',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final Function validator;
  final Function onSaved;
  final Function onChanged;
  final String labelText;

  MyTextFormField({
    this.onChanged,
    this.controller,
    this.labelText,
    this.validator,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(kDefaultPadding),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            labelText: labelText,
            hoverColor: kPrimaryColor,
            focusColor: kPrimaryColor,
            fillColor: kPrimaryColor
            //contentPadding: EdgeInsets.all(10.0),
            //border: InputBorder.none,
            //filled: true,
            //fillColor: Colors.grey[200],
            ),
        validator: validator,
        onSaved: onSaved,
        onChanged: onChanged,
      ),
    );
  }
}

class MyTextArea extends StatelessWidget {
  final TextEditingController controller;
  final Function onSaved;
  final String labelText;

  MyTextArea({
    this.controller,
    this.labelText,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(kDefaultPadding),
      child: TextFormField(
        controller: controller,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: labelText,
          //contentPadding: EdgeInsets.all(15.0),
          //border: InputBorder.none,
          //filled: true,
          //fillColor: Colors.grey[200],
        ),
        onSaved: onSaved,
      ),
    );
  }
}
