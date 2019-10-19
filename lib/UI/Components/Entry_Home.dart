import 'package:flutter/material.dart';
import '../themes.dart';
import '../../Utils/lang.dart';
import '../page_HomeDetails.dart';
import '../../Utils/HomeDetails.dart';
import 'NectarImage.dart';

class Entry_Home extends StatelessWidget{
  AnimationController controller;
  Animation<Offset> _offset;
  HomeDetails homeDetails;
  VoidCallback cbShown;


  Entry_Home(this.controller, this.homeDetails, this.cbShown);
  @override
  Widget build(BuildContext context){
    Card mainCard = new Card(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new SizedBox(
            height: 184.0,
            child: new Stack(
              children: <Widget>[ //MARK: titles
                new Positioned.fill(
                  child: new NectarImage.loadingScreen(homeDetails.heroLink,fit: BoxFit.cover,backgroundColor: Colors.transparent,)
                ),
                new Positioned(
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0,
                  child: new FittedBox(
                    fit: BoxFit.fitWidth,
                    alignment: FractionalOffset.centerLeft,
                    child: new Text(
                      homeDetails.title,
                      style: HeaderStyle
                    ),
                  ),
                ),
              ],
            ),
          ),
          new Container(
            child: new Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
              child: new DefaultTextStyle(
                  style: NormalStyle,
                  softWrap: true,
                  //overflow: TextOverflow.ellipsis,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[ //MARK: Content
                      new Padding(
                        padding: const EdgeInsets.only(bottom:8.0),
                        child: new Text(
                          homeDetails.date,
                          style: LightStyle.copyWith(color: Colors.black45, fontSize: 10.0),
                        ),
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(bottom:8.0),
                        child: new Text(
                          homeDetails.shortDescription,
                          style: LightStyle.copyWith(color: textColor),
                        ),
                      ),

                    ],
                  ),
              ),
            )
          ),
          new ButtonTheme.bar(
            child: new ButtonBar(
              alignment: MainAxisAlignment.start,
              children: <Widget>[
                new FlatButton(
                  child: new Text(IBLocale.SEE_MORE),
                  textColor: Theme.of(context).accentColor,
                  onPressed: () {
                    Navigator.of(context).push(
                      new MaterialPageRoute<Null>(builder: (BuildContext context) => new page_HomeDetails(homeDetails))
                    );
                  },
                ),
                /*new FlatButton(
                  child: const Text('EXPLORE'),
                  textColor: Colors.amber.shade500,
                  onPressed: () { /* do nothing */ },
                ),*/
              ],
            ),
          ),
        ],
      ),
    );
    Container container = new Container(
      padding: const EdgeInsets.only(top:10.0),
      child: mainCard,
    );
    
    //Animation
    Widget returnee = container;
    if (controller != null) {
      _offset = new Tween<Offset>(
          begin: const Offset(-1.0, 0.0),
          end: const Offset(0.0, 0.0)
      ).animate(new CurvedAnimation(
          parent: controller,
          curve: Curves.easeOut)
      );

      returnee = new SlideTransition(
        position: _offset,
        child: container,
      );
      controller.forward();
      cbShown();
    }
    return returnee;
  }
}

