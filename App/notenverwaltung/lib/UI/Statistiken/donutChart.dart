/// Donut chart with labels example. This is a simple pie chart with a hole in
/// the middle.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:notenverwaltung/components/my_bottom_nav_bar.dart';
import 'package:notenverwaltung/database.dart';

import '../../pie_chart_section.dart';
import '../../semester.dart';

class DonutAutoLabelChart extends StatelessWidget {
  /// Creates a [PieChart] with sample data and no transition.
  /*factory DonutAutoLabelChart.withSampleData() {
    return new DonutAutoLabelChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }*/
  //  Future<List<charts.Series<Semester, dynamic>>> _createSampleData() async {
  List<charts.Series<Semester, dynamic>> listData = [];
  List<Semester> myData = [];

  generateDAta(myData) {
    listData.add(charts.Series<Semester, dynamic>(
      id: 'Semester',
      domainFn: (Semester semester, _) => semester.jahr,
      measureFn: (Semester semester, _) => semester.durchschnitt,
      data: myData,
      colorFn: (Semester semester, _) =>
          charts.ColorUtil.fromDartColor(Color(int.parse(semester.colorVal))),
      // Set a label accessor to control the text of the arc label.
      labelAccessorFn: (Semester row, _) => '${row.durchschnitt}',
    ));
  }

  //}

// Hier war ein SCafold blblbala
  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(conext) {
    return FutureBuilder(
      future: getAllSemester(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
        } else if (snapshot.data == null) {
          return Container(
            child: Container(
              child: Text("Loading..."),
            ),
          );
        }
        print("Pipi pupup ${snapshot.data[1].name}");
        List<Semester> semesterList = [];
        /*=
            snapshot.data.map<Semester>((x) => Semester.fromMap(x)).toList();*/
        print(snapshot.data.length);
        Semester o;
        for (int i = 0; i < snapshot.data.length; i++) {
          String name = snapshot.data[i].name;
          double durchschnitt = snapshot.data[i].durchschnitt;
          String jahr = snapshot.data[i].jahr;
          String notiz = snapshot.data[i].notiz;
          print("Print name :$name, $durchschnitt, $jahr, $notiz");

          o = new Semester(name, durchschnitt, jahr, notiz);
          semesterList.add(o);
        }
        //print(semesterList);
        //snapshot.data.map((x) => Semester.fromMap(x.data)).toList();
        return _buildChart(conext, semesterList);
      },
    );
  }

  Widget _buildChart(BuildContext context, List<Semester> semester) {
    myData = semester;
    generateDAta(myData);
    return Container(
      height: 250,
      width: 250,
      child: Column(
        children: <Widget>[
          Container(
            height: 200,
            width: 200,
            child: PieChart(PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (pieTouchResponse) {
                  //
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 5,
              centerSpaceRadius: 40,
              sections: getSections(),
            )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: IndicatorWidget(),
              )
            ],
          )
        ],
      ),
    );
  }
}
