import 'package:flutter/material.dart';
import 'package:notenverwaltung/UI/home/components/add_semester.dart';
import 'package:notenverwaltung/authentication_service.dart';
import 'package:notenverwaltung/global.dart';
import 'package:notenverwaltung/semester-test_screen.dart';

import 'featurred_plants.dart';
import 'header_with_seachbox.dart';
import '../../../semester_screen.dart';
import '../../../components/title_with_more_bbtn.dart';
import 'package:provider/provider.dart';

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
          HeaderWithSearchBox(size: size),
          TitleWithMoreBtn(
              title: "Semester",
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddSemester(),
                    ));
              }),
          SemesterTest(),
          //TitleWithMoreBtn(title: "Statistiken", press: () {}),
          //FeaturedPlants(),
          SizedBox(height: kDefaultPadding),
        ],
      ),
    );
  }
}
