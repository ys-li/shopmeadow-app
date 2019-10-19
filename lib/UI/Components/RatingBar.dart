import 'package:flutter/material.dart';
import '../themes.dart';
import '../../Utils/lang.dart';

class RatingBar extends StatefulWidget{

  int greenFlex = 0;
  int redFlex = 0;
  bool get nullFlex => (greenFlex == 0 && redFlex == 0);

  RatingBar(int _greenFlex, int _redFlex) : super(){
    greenFlex = _greenFlex;
    redFlex = _redFlex;
  }

  @override
  RatingBarState createState() => new RatingBarState();
}

class RatingBarState extends State<RatingBar>{

  @override
  Widget build(BuildContext context){
    Row row = new Row(
      children: [
        new Icon(Icons.thumb_up, color: Colors.black38),
        new SizedBox(width: 7.0),
        new Expanded(
          flex: widget.greenFlex,
          child: new Container(
            height: 15.0,
            color: widget.nullFlex ? Colors.black38 : Colors.lightBlue,
          ),
        ),
        new Expanded(
          flex: widget.redFlex,
          child: new Container(
            height: 15.0,
            color: widget.nullFlex ? Colors.black38 : new Color.fromARGB(60, 0, 0, 0),
          ),
        ),
        new Expanded(
          flex: widget.nullFlex?1:0,
          child: new Container(
            height: 20.0,
            color: Colors.black38,
          ),
        ),
        new SizedBox(width: 7.0),
        new Icon(Icons.thumb_down, color: Colors.black38),
      ]
    );
    Widget overlayWords;
    if (widget.nullFlex){
      overlayWords = new Center(
        child: new Text(
          IBLocale.NO_RATING_AVA,
          style: LightStyle.copyWith(color: Colors.white),
        )
      );
    }else if (widget.redFlex > widget.greenFlex){
      overlayWords = new Align(
        alignment: FractionalOffset.centerRight,
        child: new Padding(padding: const EdgeInsets.only(right: 40.0), child: new Text(
          "${widget.redFlex} thumbs down",
          style: LightStyle.copyWith(color: Colors.white, fontSize: 12.0),
        )
      ));
    }else{
      overlayWords = new Align(
        alignment: FractionalOffset.centerLeft,
        child: new Padding(padding: const EdgeInsets.only(left: 40.0), child: new Text(
          "${widget.greenFlex} thumbs up",
          style: LightStyle.copyWith(color: Colors.white, fontSize: 12.0),
        )
      ));
    }

    Stack finalStack = new Stack(
      alignment: FractionalOffset.center,
      children: [
        row,
        overlayWords
      ],
    );
    return finalStack;
  }
}