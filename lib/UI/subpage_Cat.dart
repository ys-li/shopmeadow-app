import 'package:flutter/material.dart';
import 'Components/Entry_CatGrid.dart';
import '../Utils/Categories.dart';
import 'Components/IBLoader.dart';
import '../Utils/DataVersionControl.dart';
import 'themes.dart';
import '../Utils/lang.dart';
import '../main.dart';

class subpage_Cat extends StatefulWidget{
  subpage_CatState createState() => new subpage_CatState();
}


class subpage_CatState extends State<subpage_Cat>{

  @override
  void initState(){
    if (!Categories.populated){
      Categories.initialise().then((b){
        setState((){});
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context){

    // For server down:
    if (!DataVersionControl.serverUp && DataVersionControl.finished){
      return cannotConnectWidget();
    }
    // Start real stuff

    if (Categories.populated && Categories.categoryList.length > 0){
      return new GridView.builder(
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: Categories.categoryList.length,
        itemBuilder: (bc, i){
          return new Entry_CatGrid(Categories.categoryList[i]);
        },
      );
    }else{
      return new Center(child: new Container(width: double.infinity, child: new IBLoader()));
    }
  }

}

/*class subpage_CatState extends State<subpage_Cat> with TickerProviderStateMixin{
  AnimationController _fadeController;
  Animation<double> _opacityTweens;

  int currentCatID = -1; //-1 means not yet clicked

  @override
  void initState(){
    _fadeController = new AnimationController(
        vsync: this,
        duration: new Duration(milliseconds: 300)
    );
    _opacityTweens = new Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_fadeController);
    for(var i=0;i<15;i++){
      sampleList.add(new Entry_CatGrid(i, disappear));
    }
  }

  @override
  List<Entry_CatGrid> sampleList = new List<Entry_CatGrid>();
  Widget build(BuildContext context){
    Widget returnee;

    if (currentCatID == -1) {

      returnee = new FadeTransition(opacity: _opacityTweens,
          child: new GridView.count(
            //mainAxisSpacing: 10.0,
            //crossAxisSpacing: 10.0,

            crossAxisCount: 3,
            children: sampleList,
          )
      );
    }else{
      return new page_Cat(currentCatID);
    }

    return returnee;
  }

  void disappear(int _catIDClicked){
    _fadeController.forward().then((c) {setState((){currentCatID = _catIDClicked;});});
  }

  @override
  void dispose(){
    _fadeController.dispose();
    super.dispose();
  }
}*/