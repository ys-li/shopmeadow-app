import 'package:flutter/material.dart';
import '../Utils/lang.dart';
import '../main.dart';

ThemeData mainTheme = new ThemeData(
  primarySwatch: MaterialColor(0xff464b5a,
      {
        50: const Color(0xffe9e9eb),
        100: const Color(0xffc8c9ce),
        200: const Color(0xffa3a5ad),
        300: const Color(0xff7e818c),
        400: const Color(0xff626673),
        500: const Color(0xff464b5a),
        600: const Color(0xff3f4452),
        700: const Color(0xff373b48),
        800: const Color(0xff2f333f),
        900: const Color(0xff20232e),
      }
  ),
  accentColor: const Color(0xff64beaf),
  primaryColorBrightness: Brightness.dark,
  backgroundColor: const Color(0xfff5f0e6),
  canvasColor: const Color(0xfff5f0e6),

);

Color textColor = const Color(0xff646464);

TextStyle NormalStyle = new TextStyle(
  fontFamily: "Lota",
  fontWeight: FontWeight.normal,
  color: textColor,

);

TextStyle LightStyle = new TextStyle(
  fontFamily: "Lota",
  fontWeight: FontWeight.w300,
  color: textColor,
);

TextStyle HeaderStyle = new TextStyle(
  fontFamily: "Lota",
  fontWeight: FontWeight.w300,
  fontSize: 18.0,
  color: Colors.white,
  //color: Colors.cyanAccent
);

Widget cannotConnectWidget(){
  return new Scaffold(
      body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Text(IBLocale.SERVER_UNAVA, style: LightStyle),
              new FlatButton(onPressed: main, child: new Icon(Icons.repeat, color: Colors.lightBlue))
            ]
          ),
      )
  );
}
