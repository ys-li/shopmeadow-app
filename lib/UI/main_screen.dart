import 'package:flutter/material.dart';
import 'themes.dart';
import '../Utils/lang.dart';
import 'subpage_News.dart';
import 'subpage_Fav.dart';
import 'subpage_Cat.dart';
import 'subpage_Search.dart';
import 'subpage_Explore.dart';
import 'subpage_Home.dart';
import 'modal_submitNewStore.dart';
import 'modal_settings.dart';
import 'modal_about.dart';
import 'package:url_launcher/url_launcher.dart';

class MyApp extends StatelessWidget {
  static GlobalKey<_HomePageState> _mainkey = new GlobalKey<_HomePageState>();

  static void setPage(Pages i, {int extras = 0}) => _mainkey.currentState.setPage(i, extras);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MaterialApp mainApp = new MaterialApp(
      title: 'ShopMeadow',
      theme: mainTheme,
      home: new HomePage(title: 'ShopMeadow', key: _mainkey),
      debugShowCheckedModeBanner: false,
    );

    return mainApp;
  }
}

class HomePage extends StatefulWidget {
  final String title;
  HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  Pages _currentPageID = Pages.Home; // 0=home, 1=fav, 2=cat, 3=search
  int extras = 0;
  bool drawerOpened = false;
  void setPage(Pages i, int extras) {
    this.extras = extras;
    setState(() => _currentPageID = i);
  }

  String getHeaderByPage(Pages p) {
    switch (p) {
      case Pages.Home:
        return IBLocale.BAR_HOME;
      case Pages.Fav:
        return IBLocale.BAR_FAV;
      case Pages.Cat:
        return IBLocale.BAR_CAT;
      case Pages.Search:
        return IBLocale.BAR_SEARCH;
      case Pages.Explore:
        return IBLocale.BAR_EXPLORE;
      case Pages.News:
        return IBLocale.BAR_NEWS;
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
/*
    Container btnMore = new Container(
        margin: const EdgeInsets.symmetric(horizontal: 0.4),
        child: new PopupMenuButton<PopUpMenuEntries>(
            itemBuilder: (BuildContext context) => <PopupMenuEntry<PopUpMenuEntries>>[
              new PopupMenuItem<PopUpMenuEntries>(value: PopUpMenuEntries.Settings, child: new Text(IBLocale.MENU_SETTINGS)),
              new PopupMenuItem<PopUpMenuEntries>(value: PopUpMenuEntries.About, child: new Text(IBLocale.MENU_ABOUT)),
              new PopupMenuItem<PopUpMenuEntries>(value: PopUpMenuEntries.NewStore, child: new Text(IBLocale.MENU_NEWSTORE)),
              new PopupMenuItem<PopUpMenuEntries>(value: PopUpMenuEntries.Feedback, child: new Text(IBLocale.MENU_FEEDBACK)),
              new PopupMenuItem<PopUpMenuEntries>(value: PopUpMenuEntries.Terms, child: new Text(IBLocale.MENU_TERMS)),

            ],
            onSelected: (PopUpMenuEntries i) {
              //TODO: implement popupmenu
              Widget toBePushed;
              switch (i){
                case PopUpMenuEntries.Settings:
                  toBePushed = new modal_settings();
                  break;
                case PopUpMenuEntries.NewStore:
                  toBePushed = new modal_submitNewStore();
                  break;
                case PopUpMenuEntries.About:
                  toBePushed = new modal_about();
                  break;
                case PopUpMenuEntries.Feedback:
                  launch("http://ib.enchorhk.tech/feedback");
                  break;
                case PopUpMenuEntries.Terms:
                  launch("http://ib.enchorhk.tech/terms");
                  break;

                default:
                  toBePushed = new modal_submitNewStore();
                  break;
              }

              if(toBePushed != null)
                Navigator.of(context).push(
                    new MaterialPageRoute<Null>(builder: (BuildContext context){
                      return toBePushed;
                    })
                );
            }
        )
    );*/

    AppBar appBar = new AppBar(
        elevation: 0.0,
        title: new Container(
          child: new Text(
            getHeaderByPage(_currentPageID),
            style: HeaderStyle.copyWith(color: Colors.white, fontSize: 20.0),
          ),
        ),
        centerTitle: false,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.favorite_border),
              color: Colors.white,
              onPressed: () {
                MyApp.setPage(Pages.Fav);
              }),
          new IconButton(
              icon: new Icon(Icons.search),
              color: Colors.white,
              onPressed: () {
                MyApp.setPage(Pages.Search);
              }),
        ],
    );

    BottomNavigationBar bottomNavigationBar = new BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 20.0,

        items: <BottomNavigationBarItem>[
          new BottomNavigationBarItem(icon: new Icon(Icons.home), title: new Text(IBLocale.BAR_HOME)),
          new BottomNavigationBarItem(icon: new Icon(Icons.explore), title: new Text(IBLocale.BAR_EXPLORE)),
          new BottomNavigationBarItem(icon: new Icon(Icons.category), title: new Text(IBLocale.BAR_CAT)),
          new BottomNavigationBarItem(icon: new Icon(Icons.favorite), title: new Text(IBLocale.BAR_FAV)),
          new BottomNavigationBarItem(icon: new Icon(Icons.search), title: new Text(IBLocale.BAR_SEARCH)),
        ],
        onTap: (i) => setState( () => _currentPageID = Pages.values[i]),
        currentIndex: _currentPageID.index
    );

    Scaffold mainScaffold = new Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: appBar,
      body: _getNewSubPage(),
      drawer: new Drawer(
        child: new DrawerContent(),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
    this.extras = 0;

    return new WillPopScope(
        child: mainScaffold,
        onWillPop: () async {

          if (_currentPageID != Pages.Home) {
            setState(() => _currentPageID = Pages.Home);
          } else {
            return true;
            /*showDialog(
                  context: context,
                  child: new AlertDialog(
                    title: new Text('Byeeee?'),
                    content: new Text('Are you sure you want to quit? \n真的要離開嗎？'),
                    actions: <Widget>[
                      new FlatButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: new Text('No'),
                      ),
                      new FlatButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: new Text('Yes'),
                      ),
                    ],
                  ),
                ) ??
                false;*/
          }
        });
  }

  //MARK: navigation

  Widget _getNewSubPage() {
    switch (_currentPageID) {
      case Pages.Explore:
        return new subpage_Explore(initIndex: extras);
      case Pages.Fav:
        return new subpage_Fav();
      case Pages.Cat:
        return new subpage_Cat();
      case Pages.Search:
        return new subpage_Search();
      case Pages.News:
        return new subpage_News();
      default:
        return new subpage_Home();
    }
  }
}

enum PopUpMenuEntries { Settings, About, NewStore, Feedback, Terms }
enum Pages { Home, Explore, Cat, Fav, Search, News }
enum ModalPages { Settings, NewStore, About, Feedback, Terms }

class DrawerContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 100.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          new Container(
              child: new Image.asset(
                "assets/sample/title.png",
                height: 40.0,
                color: Theme.of(context).accentColor,
              ),
              padding: const EdgeInsets.only(right: 10.0, left: 5.0)),
          new Divider(color: Colors.white, height: 24.0),
          new ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
              dense: true,
              title: Row(
                children: [
                  new Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  new Container(width: 10.0),
                  new Text(
                    IBLocale.BAR_HOME,
                    style: NormalStyle.copyWith(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
              onTap: () {
                MyApp.setPage(Pages.Home);
                Navigator.of(context).pop();
              }),
          new ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
              dense: true,
              title: Row(
                children: [
                  new Icon(
                    Icons.explore,
                    color: Colors.white,
                  ),
                  new Container(width: 10.0),
                  new Text(
                    IBLocale.BAR_EXPLORE,
                    style: NormalStyle.copyWith(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
              onTap: () {
                MyApp.setPage(Pages.Explore);
                Navigator.of(context).pop();
              }
              //onTap: (){setState(() => widget.buinessPage = false);
              //Navigator.of(context).pop();},
              ),
          new ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
              dense: true,
              title: Row(
                children: [
                  new Icon(
                    Icons.category,
                    color: Colors.white,
                  ),
                  new Container(width: 10.0),
                  new Text(
                    IBLocale.BAR_CAT,
                    style: NormalStyle.copyWith(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
              onTap: () {
                MyApp.setPage(Pages.Cat);
                Navigator.of(context).pop();
              }),
          new ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
              dense: true,
              title: Row(
                children: [
                  new Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),
                  new Container(width: 10.0),
                  new Text(
                    IBLocale.BAR_NEWS,
                    style: NormalStyle.copyWith(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
              onTap: () {
                MyApp.setPage(Pages.News);
                Navigator.of(context).pop();
              }
              //onTap: (){setState(() => widget.buinessPage = false);
              //Navigator.of(context).pop();},
              ),
          new Divider(color: Colors.white, height: 24.0),
          new ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
              dense: true,
              title: Row(
                children: [
                  new Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  new Container(width: 10.0),
                  new Text(
                    IBLocale.MENU_SETTINGS + " & " + IBLocale.MORE,
                    style: NormalStyle.copyWith(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
              onTap: () {
                PushModal(ModalPages.Settings, context);
              }
              //Navigator.of(context).pop();},
              ),
        ]),
      ),
    );
  }

  void PushModal(ModalPages p, BuildContext c) {
    Widget toBePushed;
    switch (p) {
      case ModalPages.Settings:
        toBePushed = new modal_settings();
        break;
      case ModalPages.NewStore:
        toBePushed = new modal_submitNewStore();
        break;
      case ModalPages.About:
        toBePushed = new modal_about();
        break;
      case ModalPages.Feedback:
        launch("http://ib.enchorhk.tech/feedback");
        break;
      case ModalPages.Terms:
        launch("http://ib.enchorhk.tech/terms");
        break;

      default:
        toBePushed = new modal_submitNewStore();
        break;
    }

    if (toBePushed != null)
      Navigator.of(c).push(new MaterialPageRoute<Null>(builder: (BuildContext context) {
        return toBePushed;
      }));
  }
}

/*new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(image: new AssetImage('assets/images/bg.jpg'), fit: BoxFit.cover),
            ),
            height: 150.0,
            child: new Align(
              alignment: FractionalOffset.bottomRight,
              child: new Container(
                  child: new Row(mainAxisSize: MainAxisSize.min, children: [
                    new Container(
                      child: new Image.asset("assets/images/onlyWhiteAlpha.png", width: 40.0),
                      padding: const EdgeInsets.all(5.0),
                    ),
                    new Container(child: new Image.asset("assets/sample/title.png", height: 40.0), padding: const EdgeInsets.only(right: 10.0, left: 5.0)),
                  ])),
            )),*/
