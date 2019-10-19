import 'package:flutter/material.dart';
import '../Utils/lang.dart';
import 'Components/IBLoader.dart';
import '../Utils/StoreDetails.dart';
import 'Components/Entry_CatGrid.dart';
import 'themes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Components/RatingBar.dart';
import 'Components/ClickablePhoto.dart';
import '../Utils/utils.dart';
import '../Utils/netcode.dart';
import 'page_MoreReviews.dart';
import '../Utils/DataVersionControl.dart';
import 'Components/custom_flexible_space_bar.dart';
import 'Components/custom_app_bar.dart';

class page_Store extends StatefulWidget {
  //static const String routeName = '/store';
  StoreDetails storeDetails;

  page_Store(this.storeDetails);

  @override
  State<page_Store> createState() => new page_StoreState();
}

class page_StoreState extends State<page_Store> {
  final double _appBarHeight = 300.0;
  ScrollController _scrollController = new ScrollController();
  static final GlobalKey<FloatingIconState> _floatingIconKey = new GlobalKey<FloatingIconState>();
  static final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool longerDescription = false;
  bool _ratingPanelOpened = false;

  @override
  void initState() {
    widget.storeDetails.populate().then((c) {
      setState(() {});
    });
    _scrollController.addListener(() {
      _floatingIconKey.currentState.setNewScrollPosition(_scrollController.position);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> bodies;
    if (!widget.storeDetails.populated) {
      bodies = [
        new Align(
            alignment: FractionalOffset.centerLeft,
            child: new Container(
                width: 230.0,
                padding: const EdgeInsets.only(left: 55.0, top: 10.0, bottom: 30.0),
                child: new FlatButton(
                    color: Theme.of(context).accentColor,
                    child: new Text(IBLocale.OPEN_IN_IG, style: LightStyle.copyWith(color: Theme.of(context).backgroundColor)),
                    onPressed: () async {
                      if (await canLaunch("instagram://user?username=${widget.storeDetails.igName}")) launch("instagram://user?username=${widget.storeDetails.igName}");
                      //debugPrint (floatingIcon.toString());
                      //debugPrint (floatingIcon.currentState.toString());
                    }))),
        new Padding(padding: const EdgeInsets.only(top: 50.0, bottom: 30.0), child: new IBLoader())
      ];
    } else {
      //MARK: review widget
      List<Widget> reviewPart = new List<Widget>();

      var reviewHeader = <Widget>[
        new Expanded(child: new Padding(padding: const EdgeInsets.only(top: 20.0, bottom: 10.0), child: new Text(IBLocale.REVIEWS, style: HeaderStyle))),
      ];
      if (!_ratingPanelOpened) {
        reviewHeader.add(
          new Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: new FlatButton(
              onPressed: () => btnWriteReview(context),
              child: new Text(
                IBLocale.RATE_STORE,
                style: LightStyle.copyWith(color: Theme.of(context).accentColor),
              ),
              textColor: Theme.of(context).accentColor,
            ),
          ),
        );
      }

      reviewPart.add(
        new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: reviewHeader,
        ),
      );

      switch (widget.storeDetails.reviews.length) {
        case 0:
          reviewPart.add(new Padding(padding: const EdgeInsets.only(top: 30.0, bottom: 50.0), child: new Text(IBLocale.REVIEWS_NO)));
          break;
        case 1:
          reviewPart.add(new ReviewBlock(widget.storeDetails.reviews[0]));
          break;
        case 2:
          reviewPart.add(new ReviewBlock(widget.storeDetails.reviews[0]));
          reviewPart.add(new ReviewBlock(widget.storeDetails.reviews[1]));
          break;
        case 3:
          reviewPart.add(new ReviewBlock(widget.storeDetails.reviews[0]));
          reviewPart.add(new ReviewBlock(widget.storeDetails.reviews[1]));
          reviewPart.add(new ReviewBlock(widget.storeDetails.reviews[2]));
          break;
        default:
          reviewPart.add(new ReviewBlock(widget.storeDetails.reviews[0]));
          reviewPart.add(new ReviewBlock(widget.storeDetails.reviews[1]));
          reviewPart.add(new ReviewBlock(widget.storeDetails.reviews[2]));
          break;
      }

      reviewPart.add(
        new Padding(
          padding: const EdgeInsets.only(top: 30.0, bottom: 50.0),
          child: new FlatButton(
            onPressed: () => btnMoreReview(context),
            child: new Text(
              IBLocale.SEE_MORE,
              style: LightStyle.copyWith(
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ),
      );

      Widget ratingPanel;

      if (_ratingPanelOpened) {
        ratingPanel = new RatingPanel(widget.storeDetails, () {
          setState(() {
            _ratingPanelOpened = false;
          });
        });
      } else {
        ratingPanel = new Container();
      }

      bodies = [
        //main body of the page
        new Align(
          alignment: FractionalOffset.centerLeft,
          child: new Container(
            width: 230.0,
            padding: const EdgeInsets.only(left: 55.0, top: 10.0, bottom: 30.0),
            child: new FlatButton(
              color: Theme.of(context).accentColor,
              child: new Text(IBLocale.OPEN_IN_IG, style: LightStyle.copyWith(color: Theme.of(context).backgroundColor)),
              onPressed: () async {
                if (await canLaunch("instagram://user?username=${widget.storeDetails.igName}")) launch("instagram://user?username=${widget.storeDetails.igName}");
                //debugPrint (floatingIcon.toString());
                //debugPrint (floatingIcon.currentState.toString());
              },
            ),
          ),
        )
      ];
      if (DataVersionControl.serverUp) {
        bodies.addAll([
          new Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
            child: new RatingBar(widget.storeDetails.ratingGood, widget.storeDetails.ratingBad),
          ),
          new Card(
            //CardBits
            child: new Column(
              children: new List.generate(
                widget.storeDetails.cardBits.length,
                (i) => new ListTile(
                      leading: new Icon(new IconData(widget.storeDetails.cardBits[i].codePoint)),
                      title: new Text(widget.storeDetails.cardBits[i].title),
                      subtitle: new Text(widget.storeDetails.cardBits[i].content),
                    ),
              ),
            ),
          ),
          new Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
            child: new Column(
              children: [
                new Text(longerDescription ? widget.storeDetails.longDescription : widget.storeDetails.shortDescription, style: NormalStyle, textAlign: TextAlign.center),
                widget.storeDetails.longDescription.isEmpty
                    ? Container()
                    : new FlatButton(
                        onPressed: openLongDescription,
                        child: new Text(
                          longerDescription ? IBLocale.LESS : IBLocale.MORE,
                          style: LightStyle.copyWith(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
              ],
            ),
          ),
          new Container(
              height: 150.0,
              child: new ListView.builder(
                scrollDirection: Axis.horizontal,
                itemExtent: 150.0,
                itemCount: widget.storeDetails.gallery.length,
                itemBuilder: (bc, i) {
                  return new ClickablePhoto(padding: const EdgeInsets.all(5.0), imageLink: widget.storeDetails.gallery[i]);
                },
              )),
          new Divider(),
          ratingPanel,
          new Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: new Column(
              children: reviewPart,
            ),
          ),
        ]);
      }
    }

    //chunk
    CustomScrollView scrollView = new CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        new CustomSliverAppBar(
          brightness: Brightness.dark,
          iconTheme: new IconThemeData(color: Colors.white),
          expandedHeight: _appBarHeight,
          pinned: true,
          actions: <Widget>[
            //action buttons
            new IconButton(
                icon: widget.storeDetails.favourite ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border),
                tooltip: IBLocale.BAR_FAV,
                color: widget.storeDetails.favourite ? new Color.fromARGB(255, 255, 102, 107) : textColor,
                onPressed: () {
                  if (widget.storeDetails.populated) {
                    //addToFavourite();
                    setState(() {
                      widget.storeDetails.favourite = !widget.storeDetails.favourite;
                    });
                  }
                }),
            new PopupMenuButton<String>(
              onSelected: (String value) {
                if (value == "report") {
                  showReportForm(context);
                } else if (value == "submitchanges") {
                  showAmendForm(context);
                } else if (value == "requestdel") {
                  showDialog(
                      context: context,
                      child: new AlertDialog(
                        title: new Text(IBLocale.DELETE_STORE_OWNER),
                        content: new Text(IBLocale.DELETE_STORE_OWNER_DIALOG, style: LightStyle),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text(IBLocale.CONFIRM),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ));
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                    new PopupMenuItem<String>(value: 'report', child: new Text(IBLocale.REPORT_AMEND_STORE)),
                    new PopupMenuItem<String>(value: 'requestdel', child: new Text(IBLocale.DELETE_STORE_OWNER)), /*
                const PopupMenuItem<String>(
                    value: 'submitchanges',
                    child: const Text('更正商店資料')
                ),*/
                  ],
            ),
          ],
          flexibleSpace: new CustomFlexibleSpaceBar(
            centerTitle: false,
            title: new Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, mainAxisSize: MainAxisSize.min, children: <Widget>[
              new Text("@${widget.storeDetails.igName}", style: LightStyle.copyWith(color: Colors.white), textScaleFactor: 0.9),
              new Container(
                width: 250.0,
                child: new Text(widget.storeDetails.storeName, style: LightStyle.copyWith(color: Colors.white), textScaleFactor: 0.5, overflow: TextOverflow.ellipsis),
              )
            ]),
            background: new Stack(
              fit: StackFit.expand,
              children: <Widget>[
                new Image.network(
                  widget.storeDetails.gallery.length > 0 ? widget.storeDetails.gallery[0].replaceAll("s150x150", "s640x640") : "https://ihappyu.org/assets/1.png",
                  fit: BoxFit.cover,
                  height: _appBarHeight,
                ),
                // This gradient ensures that the toolbar icons are distinct
                // against the background image.
                const DecoratedBox(
                    decoration: const BoxDecoration(
                  color: Colors.black38,
                )),
                const DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: const LinearGradient(
                      begin: const FractionalOffset(0.5, 0.0),
                      end: const FractionalOffset(0.5, 0.50),
                      colors: const <Color>[const Color(0x60000000), const Color(0x00000000)],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        new SliverList(
          delegate: new SliverChildListDelegate(bodies),
        ),
      ],
    );

    Scaffold bounder = new Scaffold(key: _scaffoldKey, body: scrollView, backgroundColor: Theme.of(context).backgroundColor,);

    Theme themedContent = new Theme(
        data: new ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.cyan,
          platform: Theme.of(context).platform,
        ),
        child: bounder);

    FloatingIcon floatingIcon = new FloatingIcon(
      storeDetails: widget.storeDetails,
      appBarHeight: _appBarHeight,
      key: _floatingIconKey,
    );

    return new Stack(alignment: FractionalOffset.center, children: <Widget>[themedContent, floatingIcon]);
  }

  @override
  void dispose() {
    ratingTextHolder = "";
    ratingThumbsUpHolder = true;
    _scrollController.dispose();
    super.dispose();
  }

  void openLongDescription() {
    setState(() => longerDescription = !longerDescription);
  }

  void btnWriteReview(BuildContext bc) {
    checkReviewed(widget.storeDetails.storeID).then((reviewed) {
      if (reviewed) {
        _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(IBLocale.REVIEW_SUBMITTED_BEFORE)));
      } else {
        setState(() {
          _ratingPanelOpened = true;
        });
      }
    });
  }

  void btnMoreReview(BuildContext bc) {
    Navigator.of(bc).push(new MaterialPageRoute(builder: (bc) {
      return new page_MoreReviews(widget.storeDetails);
    }));
  }

  String reportHintText = IBLocale.REPORT_HINT_TEXT;
  void showReportForm(BuildContext context) {
    List<DropdownMenuItem> items = new List<DropdownMenuItem>();
    int i = 0;
    for (String s in IBLocale.REPORT_LIST) {
      items.add(new DropdownMenuItem(child: new Text(s), value: i));
      i++;
    }
    showModalBottomSheet(
        context: context,
        builder: (context) {
          TextEditingController _reportTxtController = new TextEditingController();
          Column col = new Column(children: [
            new Text(IBLocale.REPORT_AMEND_STORE, style: HeaderStyle),
            new Divider(),
            new DropdownButton(
                hint: new Text(reportHintText),
                items: items,
                onChanged: (v) {
                  setState(() {
                    reportHintText = IBLocale.REPORT_LIST[v];
                  });
                }),
            new Expanded(
                child: new TextField(
              decoration: new InputDecoration.collapsed(hintText: IBLocale.SUPPLEMENTARY),
              maxLines: 100,
              controller: _reportTxtController,
            )),
            new FlatButton(
              onPressed: () {
                if (reportHintText != IBLocale.REPORT_HINT_TEXT) {
                  Navigator.of(context).pop();
                  NetCode.submitReport(widget.storeDetails.storeID, reportHintText, _reportTxtController.text).then((s) {
                    _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(IBLocale.SUBMITTED)));
                  });
                }
                reportHintText = IBLocale.REPORT_HINT_TEXT;
              },
              child: new Text(IBLocale.SUBMIT),
              textColor: Colors.blue,
            )
          ]);
          return new Padding(
            padding: const EdgeInsets.all(15.0),
            child: col,
          );
        });
  }

  void showAmendForm(BuildContext context) {}
}

class ReviewBlock extends StatelessWidget {
  Review source;

  ReviewBlock(this.source);

  @override
  Widget build(BuildContext context) {
    /*Row r = new Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Container(
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.all(new Radius.circular(100.0)),
                color: source.thumbsUp ? Colors.green : Colors.red,
              ),
              child: new Padding(padding: const EdgeInsets.all(10.0), child: new Icon(
                source.thumbsUp ? Icons.thumb_up : Icons.thumb_down,
                color: Colors.white,
                size: 20.0,
              )),
            )
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 10.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              new Text("${source.date}    #${source.id}", style: LightStyle.copyWith(color: Colors.black45, fontSize: 13.0)),
              new SizedBox(height: 20.0),
              new Container(child: new Text(source.content, style: NormalStyle)),
            ]
          )
        )
      ]
    );
    return r;*/
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new Container(
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(new Radius.circular(100.0)),
                    color: source.thumbsUp ? Colors.green : Colors.red,
                  ),
                  child: new Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: new Icon(
                        source.thumbsUp ? Icons.thumb_up : Icons.thumb_down,
                        color: Colors.white,
                        size: 20.0,
                      )),
                )),
            new Expanded(child: new Text("${source.date}    #${source.id}", style: LightStyle.copyWith(color: Colors.black45, fontSize: 13.0))),
          ],
        ),
        new Row(
          children: [
            new SizedBox(width: 60.0),
            new Flexible(
              child: new Text(source.content, style: NormalStyle),
            ),
          ],
        )
      ],
    );
  }
}

class RatingPanel extends StatefulWidget {
  StoreDetails storeDetails;
  VoidCallback finishRating;
  RatingPanel(this.storeDetails, this.finishRating);
  @override
  RatingPanelState createState() => new RatingPanelState();
}

class RatingPanelState extends State<RatingPanel> with TickerProviderStateMixin {
  AnimationController _controller;
  TextEditingController _txtController;
  @override
  void initState() {
    _controller = new AnimationController(vsync: this, duration: new Duration(milliseconds: 600));
    _controller.forward();
    _txtController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> body = new List<Widget>();

    body.add(
      new Center(
        child: new Container(
          child: new Text(
            IBLocale.RATE_STORE,
            style: HeaderStyle.copyWith(
              fontWeight: FontWeight.w300,
              color: textColor,
            ),
          ),
          padding: const EdgeInsets.only(top: 20.0, left: 60.0, right: 60.0),
        ),
      ),
    );

    body.add(new ThumbsButton());

    body.add(
      new Container(
        padding: const EdgeInsets.only(bottom: 20.0, left: 50.0, right: 50.0),
        child: new Center(
          child: new Container(
            decoration: new BoxDecoration(border: new Border(bottom: new BorderSide(color: Colors.black38, width: 0.4))),
            padding: const EdgeInsets.only(bottom: 3.5),
            child: new TextField(
              maxLines: 5,
              controller: _txtController,
              onChanged: (s) {
                ratingTextHolder = s;
              },
              decoration: new InputDecoration.collapsed(hintText: IBLocale.REVIEW_HINT_TEXT),
            ),
          ),
        ),
      ),
    );
    _txtController.text = ratingTextHolder;

    body.add(
      new Align(
        alignment: FractionalOffset.centerRight,
        child: new Padding(
          padding: const EdgeInsets.all(15.0),
          child: new FlatButton(
            onPressed: submitReview,
            child: new Text(
              IBLocale.SUBMIT.toUpperCase(),
              style: LightStyle.copyWith(color: Theme.of(context).accentColor),
            ),
          ),
        ),
      ),
    );

    Column mainColumn = new Column(children: body);

    SizeTransition withTransition = new SizeTransition(
      sizeFactor: new CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      child: new Container(
        child: mainColumn,
        color: new Color.fromARGB(10, 0, 0, 0),
      ),
    );

    return withTransition;
  }

  void submitReview() {
    _controller.reverse();
    NetCode.sendReview(widget.storeDetails.storeID, ratingThumbsUpHolder, ratingTextHolder).then((success) {
      if (success) {
        page_StoreState._scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(IBLocale.SUBMITTED)));
        widget.storeDetails.populate().then((b) {
          widget.finishRating();
        });
      } else {
        page_StoreState._scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(IBLocale.SOMETHING_WRONG)));
      }
    });
  }

  @override
  void dispose() {
    _txtController.dispose();
    _controller.dispose();
    super.dispose();
  }
}

class ThumbsButton extends StatefulWidget {
  @override
  ThumbsButtonState createState() => new ThumbsButtonState();
}

class ThumbsButtonState extends State<ThumbsButton> with TickerProviderStateMixin {
  AnimationController _controller;
  CurvedAnimation _curved;
  @override
  void initState() {
    _controller = new AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _curved = new CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    Color mainColor = ratingThumbsUpHolder ? Colors.green : Colors.red;
    return new InkWell(
      onTap: () {
        if (ratingThumbsUpHolder) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
        setState(() {
          ratingThumbsUpHolder = !ratingThumbsUpHolder;
        });
      },
      child: new RotationTransition(
        turns: new Tween<double>(begin: 0.0, end: 0.5).animate(_curved),
        child: new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Container(
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.all(new Radius.circular(100.0)),
                border: new Border.all(
                  color: mainColor,
                ),
              ),
              child: new Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: new Icon(
                    Icons.thumb_up,
                    color: mainColor,
                    size: 20.0,
                  )),
            )),
      ),
    );
  }
}

class FloatingIcon extends StatefulWidget {
  StoreDetails storeDetails;
  double _appBarHeight;
  FloatingIcon({StoreDetails storeDetails, double appBarHeight, Key key}) : super(key: key) {
    this.storeDetails = storeDetails;
    this._appBarHeight = appBarHeight;
  }

  @override
  State<FloatingIcon> createState() => new FloatingIconState();
}

class FloatingIconState extends State<FloatingIcon> {
  double _iconOffset = 50.0, _iconOpacity = 1.0;

  @override
  Widget build(BuildContext context) {
    if (_iconOpacity > 0.0) {
      Center icon = new Center(
          child: new Column(mainAxisSize: MainAxisSize.min, children: [
        new Row(children: [
          new Expanded(
            child: new SizedBox(height: 150.0),
          ),
          new Hero(
            tag: 'storeAvatar_${widget.storeDetails.storeID}',
            child: new Container(
              width: 130.0,
              height: 130.0,
              margin: const EdgeInsets.all(20.0),
              decoration: new BoxDecoration(borderRadius: new BorderRadius.all(new Radius.circular(65.0)), image: new DecorationImage(image: new NetworkImage(widget.storeDetails.avatarLink)), boxShadow: [
                new BoxShadow(
                  color: Colors.black,
                  blurRadius: 10.0,
                  spreadRadius: 1.0,
                ),
              ]),
            ),
          ),
        ]),
        new SizedBox(height: _iconOffset),
      ]));

      //Control icon
      Opacity controlIcon = new Opacity(
        opacity: _iconOpacity,
        child: icon,
      );
      return controlIcon;
    } else {
      //does not draw it if opacity < 0
      return new SizedBox(width: 0.1, height: 0.1);
    }
  }

  void setNewScrollPosition(ScrollPosition _scrollPosition) {
    setState(() {
      _iconOffset = 50.0 + _scrollPosition.pixels * 1.6;
      if (_iconOffset < 0.0) _iconOffset = 0.0;
      num temp = 1.0 - (_scrollPosition.pixels / (widget._appBarHeight - 30.0));
      if (temp < 0.0)
        temp = 0.0;
      else if (temp > 1.0) temp = 1.0;
      _iconOpacity = temp;
    });
  }
}

String ratingTextHolder = "";
bool ratingThumbsUpHolder = true;
