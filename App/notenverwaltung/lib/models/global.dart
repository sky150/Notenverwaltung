import 'package:flutter/material.dart';
Map<int, Color> color ={50:Color.fromRGBO(136,14,79, .1),100:Color.fromRGBO(136,14,79, .2),200:Color.fromRGBO(136,14,79, .3),300:Color.fromRGBO(136,14,79, .4),400:Color.fromRGBO(136,14,79, .5),500:Color.fromRGBO(136,14,79, .6),600:Color.fromRGBO(136,14,79, .7),700:Color.fromRGBO(136,14,79, .8),800:Color.fromRGBO(136,14,79, .9),900:Color.fromRGBO(136,14,79, 1),};
Color blueColor = new Color(0xFF4E6AEE);
Color whiteColor = new Color(0xFFFFFFFF);
MaterialColor blueColorCustom = MaterialColor(0xFF4E6AEE, color);
MaterialColor whiteColorCustom = MaterialColor(0xFFF4F3F8, color);

TextStyle fontStyle = new TextStyle(fontFamily: 'Segoe UI', fontWeight: FontWeight.normal, color: whiteColor, fontSize: 25);