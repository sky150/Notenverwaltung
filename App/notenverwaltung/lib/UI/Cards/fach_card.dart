import 'package:flutter/material.dart';
import 'package:notenverwaltung/global.dart';

class FachCard extends StatelessWidget {
  const FachCard(
      {Key key,
      this.fachName,
      this.weight,
      this.fachAvg,
      this.press,
      this.longPress})
      : super(key: key);

  final String fachName, weight;
  final double fachAvg;
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
                            text: "$fachName\n".toUpperCase(),
                            style: Theme.of(context).textTheme.button),
                        TextSpan(
                          text: "Gewichtung: $weight \%".toUpperCase(),
                          style: TextStyle(
                            color: kPrimaryColor.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Text('$fachAvg',
                      style: Theme.of(context).textTheme.button.copyWith(
                            color: ((this.fachAvg == null)
                                ? Colors.transparent
                                : (this.fachAvg < 4.0)
                                    ? kTextRed
                                    : (this.fachAvg < 5.0 && this.fachAvg > 4.0)
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
// FachCard(
//   fachName: "Englisch",
//   weight: "100",
//   fachAvg: 5.67,
//   press: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         //DetailsScreen()
//         builder: (context) => null,
//       ),
//     );
//   },
// ),
// FachCard(
//   fachName: "Deutsch",
//   weight: "100",
//   fachAvg: 3.95,
//   press: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         //DetailsScreen()
//         builder: (context) => null,
//       ),
//     );
//   },
// ),
// FachCard(
//   fachName: "Musik",
//   weight: "0",
//   fachAvg: 3.40,
//   press: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         //DetailsScreen()
//         builder: (context) => null,
//       ),
//     );
//   },
// ),
// FachCard(
//   fachName: "Wirtschaft",
//   weight: "100",
//   fachAvg: 5.00,
//   press: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         //DetailsScreen()
//         builder: (context) => null,
//       ),
//     );
//   },
// ),
