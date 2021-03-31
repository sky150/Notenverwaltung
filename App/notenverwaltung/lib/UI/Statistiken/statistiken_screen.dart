import 'package:flutter/material.dart';
import 'package:notenverwaltung/UI/Statistiken/body.dart';
import 'package:notenverwaltung/components/my_bottom_nav_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StatistikenScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: CustomRoundedBars(_createSampleData(), animate: true),
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

/// Create one series with sample hard coded data.

List<charts.Series<Grade, String>> _createSampleData() {
  final data = [
    new Grade(1, 5.0),
    new Grade(2, 4.5),
    new Grade(3, 6),
    new Grade(4, 2),
    new Grade(5, 3),
    new Grade(6, 5.5),
  ];

  return [
    new charts.Series<Grade, String>(
      id: 'Sales',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (Grade sales, _) => sales.grade.toString(),
      measureFn: (Grade sales, _) => sales.count,
      data: data,
    )
  ];
}

/// Sample ordinal data type.
class Grade {
  final int count;
  final double grade;

  Grade(this.count, this.grade);
}
