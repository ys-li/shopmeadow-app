import 'package:flutter/material.dart';
import '../page_Cat.dart';
import '../../Utils/Categories.dart';
import '../../Utils/Explores.dart';
//typedef void CatCallback(int catID);

class Entry_CatGrid extends StatefulWidget{
  final Category _category;


  Entry_CatGrid(this._category);

  @override
  Entry_CatGridState createState() => new Entry_CatGridState();

}

class Entry_CatGridState extends State<Entry_CatGrid>{
  bool _clicking = false;

  @override
  Widget build(BuildContext context){



    Widget childOfGrid;

    if (_clicking){
      childOfGrid = new Stack(
          children: <Widget>[
            new Hero(
              tag: "category_${widget._category.catID}",
              child: widget._category.catImage
            ),
            new Container(
                width: double.infinity,
                height: double.infinity,
                decoration: new BoxDecoration(color: Colors.black45)
            )
          ]
      );
    }else{
      childOfGrid = new Hero(
        tag: "category_${widget._category.catID}",
        child: widget._category.catImage
      );
    }
    GridTile gridTile = new GridTile(
        footer: new GridTileBar(
          title: new Text(widget._category.nameByPref),
          backgroundColor: Colors.black45,
        ),
        child: childOfGrid
    );

    GestureDetector gestureDetector = new GestureDetector(
      onTapDown: (cb) {setState(() => _clicking = true);},
      onTapUp: (cb) {_handleClick(context);},
      onTapCancel: () {setState(() => _clicking = false);},
      child: gridTile,
    );

    Container paddedTile = new Container(
      padding: new EdgeInsets.all(3.5),
      child: gestureDetector,
    );
    return paddedTile;
  }

  void _handleClick(BuildContext context){

    ExploreHolder.entries[ExploreType.Category] = null;

    setState(() => _clicking = false);
    Navigator.of(context).push(new PageRouteBuilder(
      pageBuilder: (c, _, __){
        return new Scaffold(appBar: new AppBar(
          title: new Container(child: new Image.asset('assets/sample/title.png'), padding: const EdgeInsets.all(7.0)),
          centerTitle: true,
          ),
          body: new page_Cat(widget._category));
      },
      transitionsBuilder: (_, Animation<double> animation, __, Widget child){
        return new FadeTransition(opacity: animation, child: child);
      }
      ),
    );
  }


}
/*
  @override
  Widget build(BuildContext context){



    Widget childOfGrid;

    if (_clicking){
      childOfGrid = new Stack(
        children: <Widget>[
          new Hero(
            tag: "category_${widget._category.catID}",
            child: new Image.network(
              widget._category.imageLink,
        fit: BoxFit.cover,
      ),
          ),
          new Container(
            width: double.INFINITY,
            height: double.INFINITY,
            decoration: new BoxDecoration(color: Colors.black45)
          )
        ]
      );
    }else{
      childOfGrid = new Hero(
        tag: "category_${widget._category.catID}",
        child: new Image.network(
          widget._category.imageLink,
          fit: BoxFit.cover,
        ),
      );
    }
    GridTile gridTile = new GridTile(
        footer: new GridTileBar(
          title: new Text(widget._category.nameByPref),
          backgroundColor: Colors.black45,
        ),
        child: childOfGrid
    );

    GestureDetector gestureDetector = new GestureDetector(
      onTapDown: (cb) {setState(() => _clicking = true);},
      onTapUp: (cb) {_handleClick(context);},
      onTapCancel: () {setState(() => _clicking = false);},
      child: gridTile,
    );

    Container paddedTile = new Container(
      padding: new EdgeInsets.all(3.5),
      child: gestureDetector,
    );
    return paddedTile;
  }
*/
/*
class Entry_CatGridState extends State<Entry_CatGrid>{
  bool _clicking = false;
  @override
  Widget build(BuildContext context){
    Widget childOfGrid;

    /*if (_clicking){
      childOfGrid = new Stack(
        children: <Widget>[
          new Image.asset(
          "assets/sample/1.jpg",
            fit: BoxFit.cover,
          ),
          new Container(
            width: double.INFINITY,
            height: double.INFINITY,
            decoration: new BoxDecoration(color: Colors.black45)
          )
        ]
      );
    }else{
      childOfGrid = new Image.asset(
        "assets/sample/1.jpg",
        fit: BoxFit.cover,
      );
    }*/

    childOfGrid = new Hero(
      tag: "category_${widget._catID}",
      child: new Image.asset(
        "assets/sample/1.jpg",
        fit: BoxFit.cover,
      ),
    );

    GridTile gridTile = new GridTile(
      footer: new GridTileBar(
        title: new Text("Apparels"),
        backgroundColor: Colors.black45,
      ),
      child: childOfGrid
    );

    GestureDetector gestureDetector = new GestureDetector(
      onTapDown: (cb) {setState(() => _clicking = true);},
      onTapUp: (cb) {_handleClick(context);},
      onTapCancel: () {setState(() => _clicking = false);},
      child: gridTile,
    );

    Container paddedTile = new Container(
      padding: new EdgeInsets.all(3.5),
      child: gestureDetector,
    );
    return paddedTile;
  }

  void _handleClick(BuildContext context){
    debugPrint("Cat: ${widget._catID}");
    //setState(() => _clicking = false);
    /*Navigator.of(context).push(new MaterialPageRoute<Null>(
      builder: (c){
        return new page_Cat(widget._catID);
      }),
    );*/
    widget._closeSubPage(widget._catID);
  }


}*/