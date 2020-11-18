import 'package:flutter/material.dart';
import 'package:notenverwaltung/UI/Note/components/note.dart';
import 'package:notenverwaltung/components/title_with_more_bbtn.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // It will provie us total height  and width of our screen
    Size size = MediaQuery.of(context).size;
    // it enable scrolling on small device
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TitleWithMoreBtn(title: "Noten", press: () {}),
          Note(),
        ],
      ),
    );
  }
}
