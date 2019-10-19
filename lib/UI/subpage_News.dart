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



class subpage_News extends StatefulWidget{
  subpage_NewsState createState() => new subpage_NewsState();
}

class subpage_NewsState extends State<subpage_News> with TickerProviderStateMixin {
  //List<Widget> widgetLists = new List<Widget>();
  List<int> homeDetailsShown;
  ScrollController _scrollController;
  bool _gettingNewFeed = false;
  List<AnimationController> _toBeDisposed;
  bool reachedEnd = false;

  @override
  void initState(){
    _toBeDisposed = new List<AnimationController>();

    homeDetailsShown = new List<int>();
    if (HomeHolder.holderHomeDetails.length == 0) {
      getNewFeed();
    }

    _scrollController = new ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge && _scrollController.position.pixels != 0) {
        if (!reachedEnd && !_gettingNewFeed) getNewFeed();
      }
    });
  }

  @override
  Widget build(BuildContext context){

    /*widgetLists = new List<Widget>();
    for (int i = 0; i<holderHomeDetails.length;i++){
      AnimationController _controller = new AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );
      widgetLists.add(new Entry_Home(_controller, holderHomeDetails[i]));
    }

    debugPrint (widgetLists.toString());
    debugPrint ("_gettingNewFeed $_gettingNewFeed");
    //if (_gettingNewFeed)
      widgetLists.add(new IBLoader());*/

    // For server down:
    if (!DataVersionControl.serverUp && DataVersionControl.finished){
      return cannotConnectWidget();
    }
    // Start real stuff

    Scaffold returnee = new Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: new RefreshIndicator(child: new ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        itemCount: HomeHolder.holderHomeDetails.length + 1,
        itemBuilder: (context, i){
          if (i < HomeHolder.holderHomeDetails.length){
            if (HomeHolder.holderHomeDetails[i].id == -1){ //last entry
              reachedEnd = true;
              return new Padding(padding: const EdgeInsets.only(top: 7.0, bottom: 20.0),
                child: new Text(IBLocale.NEWS_END, style: LightStyle, textAlign: TextAlign.center),
              );
            }else { //normal entry
              AnimationController _controller;
              if (!homeDetailsShown.contains(i)) {
                _controller = new AnimationController(
                  vsync: this,
                  duration: const Duration(milliseconds: 500),
                );
                _toBeDisposed.add(_controller);
              }
              return new Entry_Home(_controller, HomeHolder.holderHomeDetails[i], ()=>homeDetailsShown.add(i));
            }
          }else{
            if (reachedEnd)
              return new Container();
            else
              return new Padding(padding: const EdgeInsets.only(top: 7.0, bottom: 20.0), child: new IBLoader());
          }
        },
        controller: _scrollController,
      ),
          onRefresh: () async {
            HomeHolder.holderHomeDetails.clear();
            homeDetailsShown.clear();
            getNewFeed();
          }
      )
    );

    return returnee;
  }

  void getNewFeed() {
    setState(() {_gettingNewFeed = true;});
    HomeHolder.moreHomeDetails().then((l) {
      setState(() {
        _gettingNewFeed = false;
      });
    });
  }

  @override
  void dispose(){

    for (int i = _toBeDisposed.length - 1; i > -1;i--){
      if (_toBeDisposed[i] != null){
        _toBeDisposed[i].dispose();
        _toBeDisposed.removeAt(i);
      }
    }
    super.dispose();
  }

}