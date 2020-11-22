import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notenverwaltung/UI/authentication/login_screen.dart';
import 'UI/home/home_screen.dart';
import 'models/global.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notenverwaltung',
        theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          primaryColor: kPrimaryColor,
          textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder(
            future:
                _calculation, // a previously-obtained Future<String> or null
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('Press button to Start.');
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Text('Awaiting result..');
                case ConnectionState.done:
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  return Text('Error: ${snapshot.data}');
              }
              return null;
            }));
  }
}
