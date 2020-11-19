import 'package:flutter/material.dart';
import 'package:notenverwaltung/models/global.dart';

class Note extends StatelessWidget {
  const Note({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: <Widget>[
          NoteCard(
            noteName: "Abschreibung",
            note: 4.50,
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
          Text(" "),
          Text('Notenschnitt: 4.45'),
          Text('Wunschnote: -0.5'),
        ],
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  const NoteCard({
    Key key,
    this.noteName,
    this.weight,
    this.note,
    this.press,
  }) : super(key: key);

  final String noteName, weight;
  final double note;
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
                            text: "$noteName\n".toUpperCase(),
                            style: Theme.of(context).textTheme.button),
                      ],
                    ),
                  ),
                  Spacer(),
                  Text('$note',
                      style: Theme.of(context).textTheme.button.copyWith(
                            color: kPrimaryColor,
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
