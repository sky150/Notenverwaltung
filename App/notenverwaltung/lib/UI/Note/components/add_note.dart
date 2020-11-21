import 'package:flutter/material.dart';
import 'package:notenverwaltung/UI/Note/components/model/Note.dart';
import 'package:notenverwaltung/components/my_bottom_nav_bar.dart';
import 'package:notenverwaltung/models/global.dart';
import 'package:intl/intl.dart';

class AddNote extends StatelessWidget {
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
      title: Text('Neue Note'),
      elevation: 0,
    );
  }
}

class TestForm extends StatefulWidget {
  @override
  _TestFormState createState() => _TestFormState();
}

class _TestFormState extends State<TestForm> {
  final _formKey = GlobalKey<FormState>();
  NoteModel model = NoteModel();
  final DateFormat formatter = DateFormat('dd.MM.yyyy');
  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate, // Refer step 1
        firstDate: DateTime(1970),
        lastDate: DateTime(2030),
        helpText: 'Wähle ein Datum aus',
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData(
              primarySwatch: Colors.blue,
              primaryColor: kPrimaryColor,
              accentColor: kPrimaryColor,
            ),
            child: child,
          );
        });
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        print(selectedDate.toString());
      });
  }

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
                  child: MyTextNumberField(
                    labelText: 'Note',
                    validator: (String value) {
                      double note = double.parse(value);
                      if (note < 0.0 || note > 6.0 || note == 0.0) {
                        return 'Gib eine gültige Note ein';
                      }
                      return null;
                    },
                    onSaved: (String value) {
                      model.note = double.parse(value);
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  width: halfMediaWidth * 2,
                  child: MyTextNumberField(
                    labelText: 'Gewichtung',
                    validator: (String value) {
                      int weight = int.parse(value);
                      if (weight < 0 || weight > 100 || value.isEmpty) {
                        return 'Gib eine gültige Gewichtung ein';
                      }
                      return null;
                    },
                    onSaved: (String value) {
                      model.weight = int.parse(value);
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  width: halfMediaWidth * 2,
                  child: MyTextFormField(
                    labelText: 'Fach',
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Gib den Fach ein';
                      }
                      return null;
                    },
                    onSaved: (String value) {
                      model.fach = value;
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  width: halfMediaWidth * 2,
                  child: Padding(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    child: TextFormField(
                      onTap: () {
                        setState(() {
                          _selectDate(context);
                        });
                      },
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.arrow_drop_down),
                        hintText: formatter.format(selectedDate),
                        contentPadding: EdgeInsets.all(10.0),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Gib den Datum ein';
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        model.fach = value;
                      },
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  width: halfMediaWidth * 2,
                  child: MyTextArea(
                    labelText: 'Notiz',
                    onSaved: (String value) {
                      model.notes = value;
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: RaisedButton(
                    color: kPrimaryColor,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                //Result(model: this.model))
                                builder: (context) => null));
                      }
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
  final Function validator;
  final Function onSaved;
  final String labelText;

  MyTextFormField({
    this.labelText,
    this.validator,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(kDefaultPadding),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          contentPadding: EdgeInsets.all(10.0),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.grey[200],
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}

class MyTextNumberField extends StatelessWidget {
  final Function validator;
  final Function onSaved;
  final String labelText;

  MyTextNumberField({
    this.labelText,
    this.validator,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(kDefaultPadding),
      child: TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: labelText,
          contentPadding: EdgeInsets.all(10.0),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.grey[200],
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}

class MyTextArea extends StatelessWidget {
  final Function onSaved;
  final String labelText;

  MyTextArea({
    this.labelText,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(kDefaultPadding),
      child: TextFormField(
        maxLines: 4,
        decoration: InputDecoration(
          labelText: labelText,
          contentPadding: EdgeInsets.all(15.0),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.grey[200],
        ),
        onSaved: onSaved,
      ),
    );
  }
}