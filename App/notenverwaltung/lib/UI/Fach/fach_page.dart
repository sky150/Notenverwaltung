import 'package:flutter/material.dart';
import 'package:notenverwaltung/UI/Fach/components/body.dart';
import 'package:notenverwaltung/components/my_bottom_nav_bar.dart';
import 'package:notenverwaltung/models/global.dart';

//Später mit REST JSON: https://flutter.dev/docs/development/data-and-backend/json
class FachScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
    );
  }
}
