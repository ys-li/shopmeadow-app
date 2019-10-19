import 'package:flutter/material.dart';
import '../themes.dart';
import '../../Utils/Explores.dart';
import '../../Utils/UserStat.dart';
import '../page_Store.dart';

import 'NectarImage.dart';

class Entry_Explore extends StatefulWidget{

  ExploreEntry entry;


  Entry_Explore(this.entry);

  @override
  Entry_ExploreState createState() => new Entry_ExploreState();
}

class Entry_ExploreState extends State<Entry_Explore> with TickerProviderStateMixin{

  AnimationController _tapController;
  Animation<double> _tapAnimated;

  void initState(){
    _tapController = new AnimationController(vsync: this, duration: new Duration(milliseconds: 400));
    _tapAnimated = new Tween<double>(begin: 1.0, end: 0.75).animate(new CurvedAnimation(
      parent: _tapController,
      curve: Curves.easeOut,
    ));
  }

  @override
  Widget build(BuildContext context){
    /*Container imageContainer  = new Container(
        decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new NetworkImage(widget.entry.imageLink),
              fit: BoxFit.fill
            )
        )
    );*/

    Widget imageContainer = new NectarImage.loadingScreen(
      widget.entry.imageLink,
      backgroundColor: Theme.of(context).backgroundColor,
      waiting: new Icon(
          Icons.sync,
          size: 18.0,
          color: Colors.grey
      ),

    );


    BorderSide whiteBorder = new BorderSide(
      color: Colors.white,
      width: 1.0,
      style: BorderStyle.solid
    );

    Container gradientContainer = new Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          begin: const FractionalOffset(0.5, 0.85),
          end: const FractionalOffset(0.5, 0.5),
          colors: <Color>[
            const Color(0xaa000000),
            const Color(0x00ffffff)
          ],
        ),
        border: new Border(
          top: whiteBorder,
          left: whiteBorder,
          right: whiteBorder,
          bottom: whiteBorder,
        ),
      ),
      child: new Align(
          alignment: FractionalOffset.bottomRight,
          child: new Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: new Text("@${widget.entry.storeDetails.igName}", style: LightStyle.copyWith(color: Colors.white), overflow: TextOverflow.ellipsis,),
          )
      )
    );

    Stack mainStack = new Stack(
      fit: StackFit.expand,
      children: [
        imageContainer,
        gradientContainer
      ]
    );


    SizeTransition sizeTransition = new SizeTransition(
      child: mainStack,
      sizeFactor: _tapAnimated
    );

    GestureDetector gestureDetector = new GestureDetector(
      onTapUp: tapped,
      child: sizeTransition
    );

    return gestureDetector;

  }

  void tapped(TapUpDetails tud){
    _tapController.forward();
    Navigator.of(context).push(
        new MaterialPageRoute<Null>(builder: (BuildContext context){
          return new page_Store(widget.entry.storeDetails);
        })
    );
    UserStat.addCategoryID(widget.entry.storeDetails.categoryIDs, 1);
  }

}