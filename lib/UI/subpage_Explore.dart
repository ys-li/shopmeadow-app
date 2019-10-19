import 'package:flutter/material.dart';
import 'themes.dart';
import 'Components/IBLoader.dart';
import 'Components/Entry_Explore.dart';
import 'dart:async';
import '../Utils/Explores.dart';
import '../Utils/DataVersionControl.dart';
import '../Utils/lang.dart';

class subpage_Explore extends StatefulWidget{
  int initIndex = 0;
  subpage_Explore({this.initIndex = 0});
  @override
  subpage_ExploreState createState() => new subpage_ExploreState();
}

class subpage_ExploreState extends State<subpage_Explore> with TickerProviderStateMixin{

  TabController tabController;

  @override
  void initState(){
    tabController =  new TabController(initialIndex: widget.initIndex, length: 3, vsync: this);

  }

  @override
  Widget build(BuildContext context){

    if (!DataVersionControl.serverUp && DataVersionControl.finished){
      return cannotConnectWidget();
    }

    TabBar tabBar = new TabBar(
      controller: tabController,
      indicatorColor: Theme.of(context).accentColor,
      labelColor: Theme.of(context).accentColor,
      unselectedLabelColor: Theme.of(context).primaryColor,
      labelStyle: NormalStyle.copyWith(letterSpacing: 1.0, fontWeight: FontWeight.bold, fontSize: 12.0),
      tabs: [
        new Tab(text: "JUST FOR U"),
        new Tab(text: "HOT"),
        new Tab(text: "NEW"),
      ],
    );
    Scaffold scaffold = new Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: tabBar,
      body: new TabBarView(
        controller: tabController,
        children: [
          _buildByTab(ExploreType.JustForYou),
          _buildByTab(ExploreType.Hot),
          _buildByTab(ExploreType.New),
        ]
      ),
    );
    return scaffold;

  }

  Widget _buildByTab(ExploreType type){
    return new explore_Grid(type);
    /*switch (type){
      case ExploreType.JustForYou:
        break;
      case ExploreType.Hot:
        break;
      case ExploreType.New:
        break;
    }*/

  }

}

class explore_Grid extends StatefulWidget{
  ExploreType type;
  int catID;
  explore_Grid(this.type, [this.catID]);

  @override
  explore_GridState createState() => new explore_GridState();
}

class explore_GridState extends State<explore_Grid>{

  ScrollController _scrollController = new ScrollController();
  bool reachedEnd = false;
  bool _gettingMore = false;

  @override
  void initState(){

    if (ExploreHolder.entries[widget.type] == null || ExploreHolder.entries[widget.type].length == 0) getMore();

    _scrollController = new ScrollController();
    _scrollController.addListener(() {

      if (reachedEnd) return;
      if (_scrollController.position.atEdge && _scrollController.position.pixels != 0) {
        if (!_gettingMore) getMore();
      }
    });
  }

  @override
  Widget build(BuildContext context){

    if (ExploreHolder.entries[widget.type] == null){
      return new Center(child: new Container(width: double.infinity, child: new IBLoader()));
    }else {
      //var itemCount = (ExploreHolder.entries[widget.type].length / 2).ceil() + 1;
      GridView mainGrid = new GridView.builder(
        physics: new AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2),
        itemCount: ExploreHolder.entries[widget.type].length,
        itemBuilder: (bc, i) {
          if (ExploreHolder.entries[widget.type][i].storeDetails.storeID == -1) {
            reachedEnd = true;
            return new Container();
          }

          return new Entry_Explore(ExploreHolder.entries[widget.type][i]);
        },
      );
      Scrollbar scrollBar = new Scrollbar(
          child: mainGrid
      );
      RefreshIndicator refreshIndicator = new RefreshIndicator(
          child: scrollBar,
          onRefresh: refresh
      );


      Widget loader;
      if (_gettingMore) {
        loader = new Container(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          width: double.infinity,
          child: new IBLoader(),
          decoration: new BoxDecoration(
              color: Colors.black.withAlpha(60)
          ),
        );
      }else{
        loader = new Container();
      }

      Stack mainStack = new Stack(
        alignment: FractionalOffset.bottomCenter,
        children: <Widget>[
          refreshIndicator,
          loader
        ],
      );
      return mainStack;
    }
  }

  Future refresh() async{
    setState((){ExploreHolder.entries[widget.type] = null;});

    _gettingMore = true;
    ExploreHolder.getMoreExplore(widget.type, widget.catID).then((n){
      setState((){
        _gettingMore = false;
      });
    });
  }

  void getMore(){
    double pos;
    if (ExploreHolder.entries[widget.type] != null) pos = _scrollController.position.pixels;

    setState((){_gettingMore = true;});
    ExploreHolder.getMoreExplore(widget.type, widget.catID).then((n){
      setState((){
        _gettingMore = false;
        if(pos != null)
          _scrollController.animateTo(pos+95.0, duration: new Duration(milliseconds: 200), curve: Curves.easeOut);
      });
    });
  }
}

/*GridView mainGrid = new GridView.builder(
        physics: new AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2),
        itemCount: ExploreHolder.entries[widget.type].length,
        itemBuilder: (bc, i) {
          if (ExploreHolder.entries[widget.type][i].storeDetails.storeID == -1) {
            reachedEnd = true;
            return new Container();
          }

          return new Entry_Explore(ExploreHolder.entries[widget.type][i]);
        },
      );

      if (_gettingMore) {
        Stack mainStack = new Stack(
          alignment: new FractionalOffset(0.5, 0.9),
          children: <Widget>[
            refreshIndicator,
            new Container(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                width: double.INFINITY,
                child: new IBLoader(),
                decoration: new BoxDecoration(
                  color: Colors.black.withAlpha(60)
                ),
            ),
          ],
        );
        return mainStack;
      }

      return refreshIndicator;
      */