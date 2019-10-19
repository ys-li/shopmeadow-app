import 'package:flutter/material.dart';
import 'Components/IBLoader.dart';
import 'dart:async';
import 'themes.dart';

class Splash_Screen extends StatefulWidget{

  Splash_Screen({Key key}) : super(key: key);

  @override
  State createState() {
    return new Splash_ScreenState();
  }


}

class Splash_ScreenState extends State<Splash_Screen>{

  String helpText = "";

  @override
  Widget build(BuildContext context) {
    Stack mainStack = new Stack(
      fit: StackFit.expand,
      textDirection: TextDirection.ltr,
      children:[
        new Container(
          constraints: new BoxConstraints.expand(),
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              begin: const FractionalOffset(0.5, 0.0),
              end: const FractionalOffset(0.5, 0.8),
              colors: <Color>[
                mainTheme.primaryColor,//const Color(0xff2e6191),
                mainTheme.primaryColor,//const Color(0xff791d7c)
              ],
            ),
          ),
        ),
        new Center(
            child: new Column(
                textDirection: TextDirection.ltr,
                children: [
                  new Expanded(child: new Container()),
                  new Container(
                    child: new Image.asset('assets/images/onlyWhiteAlpha.png',width: 90.0),
                    padding: const EdgeInsets.all(20.0),
                  ),
                  new Text("Getting ready...", textDirection: TextDirection.ltr),
                  new Container(height: 10.0),
                  new Text("準備緊，請等等 真係好快", textDirection: TextDirection.ltr),
                  new Container(height: 10.0),
                  new Text(helpText, style: LightStyle.copyWith(fontSize: 13.0), textDirection: TextDirection.ltr),
                  new Container(
                    width: 300.0,
                    padding: const EdgeInsets.all(10.0),
                    child: new IBLoader(),
                  ),
                  new Expanded(child: new Container()),
                ]
            )
        ),
      ]
    );

    return mainStack;
  }

  void setHelpText(String msg){
    setState(() => helpText = msg);
  }
}

