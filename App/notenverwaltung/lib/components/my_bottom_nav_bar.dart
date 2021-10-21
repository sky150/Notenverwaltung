import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notenverwaltung/UI/Statistiken/donutChart.dart';
import 'package:notenverwaltung/UI/Statistiken/page.dart';
import 'package:notenverwaltung/UI/Statistiken/statistiken_screen.dart';
import 'package:notenverwaltung/UI/User/user_screen.dart';
import 'package:notenverwaltung/UI/home/home_screen.dart';
import 'package:notenverwaltung/global.dart';

class MyBottomNavBar extends StatelessWidget {
  const MyBottomNavBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: kDefaultPadding * 2,
        right: kDefaultPadding * 2,
        bottom: kDefaultPadding / 4,
      ),
      height: 50,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -10),
            blurRadius: 35,
            color: kPrimaryColor.withOpacity(0.38),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: SvgPicture.asset("assets/icons/hinzufugen.svg"),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ));
            },
          ),
          IconButton(
            icon: SvgPicture.asset("assets/icons/bar_chart.svg"),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Statistiken(),
                  ));
            },
          ),
          IconButton(
            icon: SvgPicture.asset("assets/icons/user-icon.svg"),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserScreen(),
                  ));
            },
          ),
        ],
      ),
    );
  }
}
