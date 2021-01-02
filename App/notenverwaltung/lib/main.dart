import 'package:flutter/material.dart';
import 'package:notenverwaltung/UI/home/home_screen.dart';
import 'models/global.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //bloc.registerUser(
    //   "username", "second", "lastname", "1234232", "username@gmail.com");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notenverwaltung',
      theme: ThemeData(
        scaffoldBackgroundColor: kBackgroundColor,
        primaryColor: kPrimaryColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}
