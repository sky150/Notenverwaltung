import 'package:flutter/material.dart';
import 'package:notenverwaltung/UI/Note/components/body.dart';
import 'package:notenverwaltung/components/my_bottom_nav_bar.dart';

class NoteScreen extends StatelessWidget {
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
