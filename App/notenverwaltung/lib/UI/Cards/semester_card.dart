import 'package:flutter/material.dart';
import 'package:notenverwaltung/global.dart';

class SemesterCard extends StatelessWidget {
  const SemesterCard(
      {Key key,
      this.semesterName,
      this.year,
      this.semesterAvg,
      this.press,
      this.longPress})
      : super(key: key);

  final String semesterName, year;
  final double semesterAvg;
  final Function press;
  final Function longPress;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
        left: kDefaultPadding,
        top: kDefaultPadding / 2,
        bottom: kDefaultPadding / 2,
      ),
      width: size.width * 0.9,
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: press,
            onLongPress: longPress,
            child: Container(
              padding: EdgeInsets.all(kDefaultPadding / 2),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50,
                    color: kPrimaryColor.withOpacity(0.23),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "$semesterName\n".toUpperCase(),
                            style: Theme.of(context).textTheme.button),
                        TextSpan(
                          text: "$year".toUpperCase(),
                          style: TextStyle(
                            color: kTextColor.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Text('$semesterAvg',
                      style: Theme.of(context).textTheme.button.copyWith(
                            color: ((this.semesterAvg == null)
                                ? Colors.transparent
                                : (this.semesterAvg < 4.0)
                                    ? kTextRed
                                    : (this.semesterAvg < 5.0 &&
                                            this.semesterAvg > 4.0)
                                        ? kTextYellow
                                        : kTextGreen),
                          ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
