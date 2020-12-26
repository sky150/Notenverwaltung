import 'package:flutter/material.dart';
import 'package:notenverwaltung/UI/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/global.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'package:notenverwaltung/bloc/blocs/user_bloc_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
      /*home: FutureBuilder(
            future: getUser(), // a previously-obtained Future<String> or null
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.none &&
                  snapshot.hasData == null) {
                //print('project snapshot data is: ${projectSnap.data}');
                return Container();
              }
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      // Widget to display the list of project
                    ],
                  );
                },
              );
            })*/
    );
  }

  Future getUser() async {
    log("message is working");
    var result = await http.get('http://10.0.2.2:8888/example');
    log('Body: $result');
    print(result);
    return result;
    /*String apiKey = await getApiKey();
    if (apiKey.length <= 0) {
      //login user/user is not logged in
      // login the user
    } else {
      //get()
    }*/
  }

  asyncFunc() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
  }

  Future<String> getApiKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiKey;
    try {
      apiKey = (prefs.getString('API_Token'));
    } catch (Exception) {
      apiKey = "";
    }
    return apiKey;
  }
}
