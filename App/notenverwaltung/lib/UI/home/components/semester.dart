import 'package:flutter/material.dart';
import 'package:notenverwaltung/models/global.dart';
//import 'package:plant_app/screens/details/details_screen.dart';

class Semester extends StatelessWidget {
  const Semester({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: <Widget>[
          SemesterCard(
            semesterName: "BZZ Semester 1",
            year: "2017",
            semesterAvg: 4.25,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  //DetailsScreen()
                  builder: (context) => null,
                ),
              );
            },
          ),
          SemesterCard(
            semesterName: "KVB Semester 3",
            year: "2019",
            semesterAvg: 5.67,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  //DetailsScreen()
                  builder: (context) => null,
                ),
              );
            },
          ),
          SemesterCard(
            semesterName: "ETH Semester 5",
            year: "2020",
            semesterAvg: 3.95,
            press: () {},
          ),
        ],
      ),
    );
  }
}

class SemesterCard extends StatelessWidget {
  const SemesterCard({
    Key key,
    this.semesterName,
    this.year,
    this.semesterAvg,
    this.press,
  }) : super(key: key);

  final String semesterName, year;
  final double semesterAvg;
  final Function press;

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
            child: Container(
              padding: EdgeInsets.all(kDefaultPadding / 2),
              decoration: BoxDecoration(
                color: Colors.white,
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
                            color: kPrimaryColor.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Text('$semesterAvg',
                      style: Theme.of(context).textTheme.button.copyWith(
                            color: ((this.semesterAvg < 4.0)
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