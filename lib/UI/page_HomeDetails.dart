import 'package:flutter/material.dart';
import 'Components/IBLoader.dart';
import 'themes.dart';
import '../Utils/HomeDetails.dart';

class page_HomeDetails extends StatefulWidget {
  HomeDetails homeDetails;
  page_HomeDetails(this.homeDetails);

  @override
  page_HomeDetailsState createState() => new page_HomeDetailsState();

}
class page_HomeDetailsState extends State<page_HomeDetails>{

  @override
  void initState(){
    super.initState();
    if (!widget.homeDetails.populated){
      widget.homeDetails.populate().then((n){
        setState((){});
      });
    }
  }

  @override
  Widget build(BuildContext build){

    Widget body;
    if (widget.homeDetails.populated){

      List<Widget> bodyAsList = new List<Widget>();
      bodyAsList.add(new Padding( //date
        padding: const EdgeInsets.only(bottom :8.0),
        child: new Text(
          widget.homeDetails.date,
          style: LightStyle.copyWith(color: Colors.black45, fontSize: 10.0),
        ),
      ));
      bodyAsList.addAll(widget.homeDetails.contents);

      body = new Container(
        child: new Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
          child: new DefaultTextStyle(
            style: NormalStyle,
            softWrap: true,
            //overflow: TextOverflow.ellipsis,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: bodyAsList,
            ),
          ),
        )
      );
    }else{
      body = new Padding(padding: const EdgeInsets.only(top: 7.0, bottom: 20.0), child: new IBLoader());
    }


    ListView mainListView = new ListView(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new SizedBox(
        height: 184.0,
          child: new Stack(
            children: <Widget>[ //MARK: titles
              new Positioned.fill(
                  child: new Image.network(widget.homeDetails.heroLink,fit: BoxFit.cover)
              ),
              new Positioned(
                bottom: 16.0,
                left: 16.0,
                right: 16.0,
                child: new FittedBox(
                  fit: BoxFit.cover,
                  alignment: FractionalOffset.centerLeft,
                  child: new Text(
                      widget.homeDetails.title,
                      style: HeaderStyle
                  ),
                ),
              ),
            ],
          ),
        ),
        body

      ]
    );

    Scaffold mainScaffold = new Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: new Text(widget.homeDetails.title),
        backgroundColor: Colors.orangeAccent,
      ),
      body: mainListView,
    );

    return mainScaffold;
  }
}