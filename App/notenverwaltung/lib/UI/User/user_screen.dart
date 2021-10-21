import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notenverwaltung/components/my_bottom_nav_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notenverwaltung/authentication_service.dart';

import '../../authentication_service.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String username;
  String email;

  @override
  Widget build(BuildContext context) {
    String name;
    return Scaffold(
      appBar: buildAppBar(),
      body: Center(
          child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        children: <Widget>[
          Text(
            auth.currentUser.displayName != null
                ? auth.currentUser.displayName
                : null,
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(height: 48.0),
          Text('${auth.currentUser.email}',
              style: TextStyle(fontFamily: 'Arial', fontSize: 15)),
          SizedBox(height: 48.0),
          RaisedButton(
              child: Text('Ausloggen'),
              onPressed: () {
                context.read<AuthenticationService>().signOut();
                context.read<AuthenticationService>().signOutGoogle();
              }),
        ],
      )),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset("assets/icons/menu.svg"),
        onPressed: () {},
      ),
    );
  }
}
