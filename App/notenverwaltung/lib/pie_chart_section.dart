import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:notenverwaltung/semester.dart';

List<PieChartSectionData> getSections() => PieDeutsch.data
    .asMap()
    .map<int, PieChartSectionData>((key, value) {
      final piee = PieChartSectionData(
        color: value.color,
        value: value.prozent,
        title: '${value.schnitt}',
        titleStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff)),
      );
      return MapEntry(key, piee);
    })
    .values
    .toList();

class IndicatorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: PieDeutsch.data
            .map((data) => Container(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: buildIndicator(color: data.color, text: data.schnitt),
                ))
            .toList(),
      );
  Widget buildIndicator({
    @required Color color,
    @required double text,
    bool isSquare = false,
    double size = 10,
    Color textColor = const Color(0xff505050),
  }) =>
      Row(
        children: <Widget>[
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
                shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
                color: color),
          ),
          const SizedBox(width: 8),
          Text(
            text.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          )
        ],
      );
}
