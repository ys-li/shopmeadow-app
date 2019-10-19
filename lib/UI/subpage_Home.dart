import 'package:flutter/material.dart';
import 'Components/Entry_Home.dart';
import 'Components/IBLoader.dart';
import '../Utils/HomeHolder.dart';
import 'themes.dart';
import '../Utils/DataVersionControl.dart';
import '../Utils/Favourites.dart';
import '../Utils/UserStat.dart';
import '../Utils/Categories.dart';
import '../Utils/lang.dart';
import 'main_screen.dart';
import 'Components/NectarImage.dart';
import '../Utils/lang.dart';
import 'page_HomeDetails.dart';
import '../Utils/HomeDetails.dart';
import '../Utils/Explores.dart';
import 'Components/Entry_Explore.dart';
import 'Components/Entry_CatGrid.dart';


class subpage_Home extends StatefulWidget{

  @override
  State createState() {
    return new subpage_HomeState();
  }
}

class subpage_HomeState extends State<subpage_Home>{

  @override
  Widget build(BuildContext context) {
    Widget buildHeader (String header, VoidCallback onTap){
      return new Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: new Row(
          children: [
            new Container(width: 10.0),
            new Text(header, style: LightStyle),
            new Expanded(child: new Container()),
            new FlatButton(onPressed: onTap, child: new Text(IBLocale.SEE_MORE, style: LightStyle.copyWith(fontWeight: FontWeight.w600, color: Theme.of(context).accentColor))),
          ]
        ),
      );
    }
    return new ListView(
      children: <Widget>[
        // News
        //buildHeader("", () => MyApp.setPage(Pages.News)),
        new Home_News(),
        buildHeader(IBLocale.CATS_YOU_LIKE, () => MyApp.setPage(Pages.Cat)),
        new Home_Cat(),
        buildHeader(IBLocale.JUST_FOR_YOU, () => MyApp.setPage(Pages.Explore)),
        new Home_JFY(),
        buildHeader(IBLocale.NEW_IN_TOWN, () => MyApp.setPage(Pages.Explore, extras: 2)),
        new Home_New(),
      ],
    );
  }
}

class Home_News extends StatefulWidget{

  @override
  State createState() {
    return new Home_NewsState();
  }
}

class Home_NewsState extends State<Home_News>{
  HomeDetails homeDetails;

  @override
  void initState() {
    if (HomeHolder.holderHomeDetails.length == 0){
      HomeHolder.moreHomeDetails().then((b){
        homeDetails = HomeHolder.holderHomeDetails[0];
        setState((){});
      });
    } else {
      homeDetails = HomeHolder.holderHomeDetails[0];
      setState((){});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (homeDetails != null){
      var box = new SizedBox(
        height: 184.0,
        child: new Stack(
          children: <Widget>[ //MARK: titles
            new Positioned.fill(
                child: new NectarImage.loadingScreen(homeDetails.heroLink,fit: BoxFit.cover,backgroundColor: Colors.transparent,)
            ),
            new Align(
              alignment: FractionalOffset.bottomLeft,
              child: new Container(
                width: double.infinity,
                height: 50.0,
                color: Colors.black38,
                child: new Row(children: [
                  new Expanded(child: new Container()),
                  new Text(
                    homeDetails.title,
                    style: LightStyle.copyWith(color: Colors.white, fontSize: 18.0)
                  ),
                  new Container(width: 10.0),
                  new Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 20.0),
                  new Container(width: 10.0),
                ])
              ),
            ),

          ],
        ),
      );
      var material = new Material(
          type: MaterialType.transparency,
          child: new SizedBox(
            height: 184.0,
            width: double.infinity,
            child: new InkWell(
              onTap: () => Navigator.of(context).push(
                  new MaterialPageRoute<Null>(builder: (BuildContext context) => new page_HomeDetails(homeDetails))
              ),
            )
        ),
      );
      return new Stack(
        children: [
          box,
          material
        ]
      );
    } else {
      return new Container(height: 184.0, child: new Center(child: new Container(width: 100.0, child: new IBLoader())));
    }
  }
}

class Home_JFY extends StatefulWidget{

  @override
  State createState() {
    return new Home_JFYState();
  }
}

class Home_JFYState extends State<Home_JFY>{

  @override
  void initState() {
    if (ExploreHolder.entries[ExploreType.JustForYou] == null || ExploreHolder.entries[ExploreType.JustForYou].length == 0)
      ExploreHolder.getMoreExplore(ExploreType.JustForYou, 0).then((n){
        setState((){

        });
      });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if (ExploreHolder.entries[ExploreType.JustForYou] == null || ExploreHolder.entries[ExploreType.JustForYou].length == 0){
      //still loading
      return new Container(height: 170.0, child: new Center(child: new Container(width: 100.0, child: new IBLoader())));
    }else {
      return new Container(height: 170.0, child: new ListView.builder(scrollDirection: Axis.horizontal , itemCount: 15, itemExtent: 170.0,itemBuilder: (bc, i){
        return new Entry_Explore(ExploreHolder.entries[ExploreType.JustForYou][i]);
      }));
    }
  }
}

class Home_New extends StatefulWidget{

  @override
  State createState() {
    return new Home_NewState();
  }
}

class Home_NewState extends State<Home_New>{

  @override
  void initState() {
    if (ExploreHolder.entries[ExploreType.New] == null || ExploreHolder.entries[ExploreType.New].length == 0)
      ExploreHolder.getMoreExplore(ExploreType.New, 0).then((n){
        setState((){

        });
      });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if (ExploreHolder.entries[ExploreType.New] == null || ExploreHolder.entries[ExploreType.New].length == 0){
      //still loading
      return new Container(height: 140.0, child: new Center(child: new Container(width: 100.0, child: new IBLoader())));
    }else {
      return new Container(height: 140.0, child: new ListView.builder(scrollDirection: Axis.horizontal , itemCount: 15, itemExtent: 140.0,itemBuilder: (bc, i){
        return new Entry_Explore(ExploreHolder.entries[ExploreType.New][i]);
      }));
    }
  }
}

class Home_Cat extends StatefulWidget{

  @override
  State createState() {
    return new Home_CatState();
  }
}

class Home_CatState extends State<Home_Cat>{

  @override
  void initState() {
    if (!Categories.populated){
      Categories.initialise().then((b){
        setState((){});
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Categories.populated){
      //sort out the <7 highest accessed cats
      var catsToShow = new List<int>();
      if (UserStat.CategoryID.length > 0) {
        List<int> sortedFreq = UserStat.CategoryID.values.toList();
        sortedFreq.sort();
        print (sortedFreq.length);
        var cutoff = sortedFreq[sortedFreq.length > 7 ? 7 : sortedFreq.length -
            1];
        for (String k in UserStat.CategoryID.keys) {
          if (UserStat.CategoryID[k] > cutoff) {
            catsToShow.add(int.parse(k));
          }
        }
      }
      var goodPicks = [1,6,8,11,9, 21,15];
      for (var s in goodPicks){
        if (!catsToShow.contains(s)){
          catsToShow.add(s);
        }
      }


      return new Container(height: 160.0, child: new ListView.builder(scrollDirection: Axis.horizontal , itemCount: 7, itemExtent: 160.0,itemBuilder: (bc, i){
        return new Entry_CatGrid(Categories.getCategoryByID(catsToShow[i]));
      }));
    } else{
      return new Container(height: 160.0, child: new Center(child: new Container(width: 100.0, child: new IBLoader())));
    }
  }

}
