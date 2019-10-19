import 'package:flutter/material.dart';
import 'themes.dart';
import '../Utils/lang.dart';
import '../Utils/DataVersionControl.dart';

class modal_about extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    List<Widget> children = new List<Widget>();
    children=[
      new Expanded(child: new Container()),
      new Container(
        alignment: const FractionalOffset(0.5, 0.3),
        padding: const EdgeInsets.all(20.0),
        child: new Image.asset('assets/images/rawLogoAlpha.png', width: 300.0),
      ),
      new Text(
          "ShopMeadow, v" + DataVersionControl.version + ", ©2017 Y. Li",
          style: LightStyle.copyWith(fontSize: 12.0, color: Colors.grey),
          textAlign: TextAlign.center,
      ),
      new Container(height:10.0),
      new Text(
        "Sorry for any bugs, one-man projects are tough",
        style: LightStyle.copyWith(fontSize: 12.0, color: Colors.grey),
        textAlign: TextAlign.center,
      ),new Container(height:10.0),
      new Text(
        "//made with \u{2764} in Hong Kong",
        style: LightStyle.copyWith(fontSize: 12.0, color: Colors.grey),
        textAlign: TextAlign.center,
      ),
      new Expanded(child: new Container()),
    ];
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        title: new Text(IBLocale.ABOUT)
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,

        children: children,
    ));
  }
}