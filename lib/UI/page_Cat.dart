import 'package:flutter/material.dart';
import 'themes.dart';
import '../Utils/lang.dart';
import 'Components/Entry_Store.dart';
import '../Utils/Categories.dart';
import 'Components/IBLoader.dart';
import 'dart:async';
import 'subpage_Explore.dart';
import '../Utils/Explores.dart';
import '../Utils/UserPref.dart';

class page_Cat extends StatefulWidget {
  Category _category;

  page_Cat(this._category);

  @override
  State<page_Cat> createState() => new page_CatState();
}

class page_CatState extends State<page_Cat> with TickerProviderStateMixin {
  AnimationController _fadeController;
  Animation<double> _opacityTweens;
  ScrollController _scrollController;
  bool _gettingMoreStores = false;
  TabController tabController;
  static const double sizeOfHero = 184.0;

  bool get reachedEnd {
    if (widget._category.storeList.length == 0) return false;
    return widget._category.storeList.last.storeID == -1;
  }

  @override
  void initState() {
    tabController = new TabController(
      length: 2,
      vsync: this,
    );

    if (!widget._category.initialised) widget._category.initialise();

    if (widget._category.storeList.length == 0) getMoreStores();

    _scrollController = new ScrollController();
    _scrollController.addListener(() {
      if (reachedEnd) return;
      if (_scrollController.position.atEdge && _scrollController.position.pixels != 0) {
        if (!_gettingMoreStores) getMoreStores();
      }
    });

    _fadeController = new AnimationController(vsync: this, duration: new Duration(milliseconds: 300));
    _opacityTweens = new Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_fadeController);

    _fadeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    //tabs

    TabBar tabBar = new TabBar(
      controller: tabController,
      indicatorColor: Theme.of(context).accentColor,
      labelColor: Theme.of(context).accentColor,
      unselectedLabelColor: textColor,
      labelStyle: NormalStyle.copyWith(letterSpacing: 2.0, fontWeight: FontWeight.bold, fontSize: (UserPref.langChinese ? 12.0 : 8.0)),
      tabs: [
        new Tab(text: IBLocale.CAT_TAB_STORE),
        new Tab(text: IBLocale.CAT_TAB_EXPLORE),
      ],
    );

    ListView mainListView = new ListView.builder(
        physics: new AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        itemCount: widget._category.storeList.length + 2,
        itemBuilder: (bc, i) {
          if (i == 0) {
            //header
            return new Container(height: sizeOfHero, color: Colors.transparent);
          } else if (i == widget._category.storeList.length + 1) {
            //IBLoader OR end
            if (reachedEnd)
              return new Container();
            else
              return new Container(color: const Color(0xFFFCFCFC), padding: const EdgeInsets.only(top: 7.0, bottom: 20.0), child: new IBLoader());
          } else {
            //stores OR end
            var index = i - 1;
            if (widget._category.storeList[index].storeID == -1) {
              //-1 id = end
              //reachedEnd = true;
              return new Container(
                color: const Color(0xFFFCFCFC),
                padding: const EdgeInsets.only(top: 7.0, bottom: 20.0),
                child: new Text(IBLocale.CAT_END_OF_LIST, style: LightStyle, textAlign: TextAlign.center),
              );
            } else {
              //normal store
              return new Container(color: const Color(0xFFFCFCFC), child: new Entry_Store.ForCat(widget._category.storeList[index]));
            }
          }
        });
    RefreshIndicator refreshIndicator = new RefreshIndicator(child: mainListView, onRefresh: refresh);
    TabBarView tabBarView = new TabBarView(controller: tabController, children: [
      refreshIndicator,
      new explore_Grid(ExploreType.Category, widget._category.catID),
    ]);

    Stack stack = new Stack(children: [
      new SizedBox(
        height: sizeOfHero,
        child: new Stack(
          children: <Widget>[
            //MARK: titles
            new Positioned.fill(
              child: new Hero(tag: "category_${widget._category.catID}", child: widget._category.catImage //new Image.network(widget._category.imageLink,fit: BoxFit.cover),
                  ),
            ),
            new Positioned.fill(child: new Container(color: new Color(0x60FFFFFF))),
            new Positioned(
              bottom: 16.0,
              left: 16.0,
              right: 16.0,
              child: new Align(
                //fit: BoxFit.fitHeight,
                alignment: FractionalOffset.centerLeft,
                child: new Text(
                  widget._category.nameByPref,
                  style: HeaderStyle.copyWith(
                    fontSize: 50.0,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      tabBarView,
    ]);

    return new FadeTransition(
      opacity: _opacityTweens,
      child: Column(
        children:[
          new Container(
            color: Theme.of(context).backgroundColor,
            child: tabBar,
          ),
          Expanded(
            child: stack,
          )
        ]
      ),
    );
  }

/*
  @override
  Widget build(BuildContext context){
    ListView mainListView = new ListView.builder(
      physics: new AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      itemCount: widget._category.storeList.length + 2,
      itemBuilder: (bc, i) {
        if (i == 0){ //header
          return new SizedBox(
            height: sizeOfHero,
            child: new Stack(
              children: <Widget>[ //MARK: titles
                new Positioned.fill(
                  child: new Hero(
                    tag: "category_${widget._category.catID}",
                    child: new Image.network(widget._category.imageLink,fit: BoxFit.cover),
                  ),
                ),
                new Positioned.fill(
                  child: new Container(
                    color: new Color(0x60FFFFFF)
                  )
                ),
                new Positioned(
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0,
                  child: new FittedBox(
                    fit: BoxFit.cover,
                    alignment: FractionalOffset.centerLeft,
                    child: new Text(
                        widget._category.nameByPref,
                        style: HeaderStyle
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        else if (i == widget._category.storeList.length + 1) { //IBLoader OR end
          if (reachedEnd)
            return new Container();
          else
            return new Padding(padding: const EdgeInsets.only(top: 7.0, bottom: 20.0), child: new IBLoader());
        }
        else{ //stores OR end
          var index = i - 1;
          if (widget._category.storeList[index].storeID == -1){ //-1 id = end
            //reachedEnd = true;
            return new Padding(padding: const EdgeInsets.only(top: 7.0, bottom: 20.0),
              child: new Text(IBLocale.CAT_END_OF_LIST, style: LightStyle, textAlign: TextAlign.center),
            );
          }else{ //normal store
            return new Entry_Store.ForCat(widget._category.storeList[index]);
          }
        }
      }

    );
    RefreshIndicator refreshIndicator = new RefreshIndicator(child: mainListView, onRefresh: refresh);

    return new FadeTransition(
      opacity: _opacityTweens,
      child: refreshIndicator,
    );

  }
*/
  void getMoreStores() {
    _gettingMoreStores = true;
    widget._category.moreStores().then((n) {
      setState(() {
        _gettingMoreStores = false;
      });
    });
  }

  Future refresh() async {
    widget._category.initialise();
    await widget._category.moreStores();
    setState(() {});
  }
}
