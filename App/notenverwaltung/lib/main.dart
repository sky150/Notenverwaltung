import 'package:flutter/material.dart';
import 'models/global.dart';
import 'package:flutter/foundation.dart';
import 'UI/Note/note_page.dart';
import 'UI/Semester/semester_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notenverwaltung',
      theme: ThemeData(
        primarySwatch: blueColorCustom,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        backgroundColor: whiteColorCustom,
        primaryColor: defaultTargetPlatform == TargetPlatform.iOS
        ? Colors.grey[50]
        : null),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Semester> semesterList = [
    Semester('BZZ Semester 1',4.25,'2017'),
    Semester('KVB Semester 3',5.67,'2019'),
    Semester('ETH Semester 5',3.95,'2020'),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notenverwaltung',
          style: fontStyle,
          ),
          elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
        ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text("Natalie Sumbo"),
              accountEmail: new Text("nathaliesumbo@gmail.com"),
              currentAccountPicture: new CircleAvatar(
                backgroundColor:
                  Theme.of(context).platform == TargetPlatform.iOS
                  ? blueColorCustom
                  : Colors.white,
                child: new Text("N"),
              ),
              otherAccountsPictures: <Widget>[
                new CircleAvatar(
                  backgroundColor:
                    Theme.of(context).platform == TargetPlatform.iOS
                    ? blueColorCustom
                    : Colors.white,
                  child: new Text("S"),
                ),
              ],
            ),
            new ListTile(
              title: new Text("Semester"),
              trailing: new Icon(Icons.subject),
              onTap: (){
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) =>
                    Note()));
              },
            ),
            new ListTile(
              title: new Text("Einstellungen"),
              trailing: new Icon(Icons.settings),
              onTap: (){
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) =>
                    Note()));
              },
            ),
            new Divider(),
            new ListTile(
              title: new Text("Feedback"),
              trailing: new Icon(Icons.border_color),
              onTap: (){
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) =>
                    Note()));
              },
            ),

          ],
        ),
      ),
      body:
        ListView.builder(
            itemCount: semesterList.length,
            itemBuilder: (context, index){
              return Card(
                child: ListTile(
                  onTap:() {},
                  title: Text(semesterList[index].semesterName),
                ),
              );
            }
          ),

/**
        FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: blueColorCustom,
          onPressed: () {}
        ),
 */
    );
  }
}
