import 'package:flutter/material.dart';
import 'themes.dart';
import '../Utils/lang.dart';
import '../Utils/netcode.dart';

class modal_submitNewStore extends StatelessWidget{

  static final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _submitting = false;
  TextEditingController _txtController;
  @override
  Widget build(BuildContext context) {
    _txtController = new TextEditingController();
    TextField textField = new TextField(
      onSubmitted: (s) => submitStore(s,context),
      controller: _txtController,
      decoration: new InputDecoration(icon: new Icon(Icons.store), border: null,hintText: IBLocale.IG_NAME)
    );

    Container finalContainer = new Container(

      decoration: new BoxDecoration(
        border: new Border.all(width: 1.0, color: Colors.black12),
        borderRadius: const BorderRadius.all(const Radius.circular(18.0)),
        color: Colors.white70,
      ),
      child: textField,
    );

    Widget inputBar = new Padding(padding: const EdgeInsets.all(20.0), child: finalContainer);

    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        elevation: 0.0,
        title: new Text(IBLocale.SUBMIT_NEW_STORE),
      ),
      body: new ListView(
        children:[
          new Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0, bottom: 10.0),
            child: new Card(child: new Padding(padding: const EdgeInsets.all(20.0), child: new Text(IBLocale.SUBMIT_NEW_STORE_HEADER, style: HeaderStyle.copyWith(color: Colors.blueAccent), textAlign: TextAlign.center,))),
          ),
          new Divider(),
          new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Text(IBLocale.SUBMIT_NEW_STORE_INSTRUCTIONS, style: LightStyle.copyWith(fontStyle: FontStyle.italic)),
          ),
          new Divider(),
          inputBar,
          new Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: new FlatButton(
              onPressed: () => submitStore(_txtController.text, context),
              child: new Text(IBLocale.SUBMIT),
              textColor: Colors.blue

            )
          )
        ]
      ),
    );
  }

  void submitStore(String s,context) {
    if (s.isNotEmpty) {
      NetCode.submitNewStore(s).then((success) {
        if (success) {
          _scaffoldKey.currentState.showSnackBar(
              new SnackBar(content: new Text(IBLocale.SUBMIT_NEW_STORE_THANKS)));
          Navigator.of(context).pop();
        } else {
          _scaffoldKey.currentState.showSnackBar(
              new SnackBar(content: new Text(IBLocale.SOMETHING_WRONG)));
        }
      });
    } else {
      _scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text(IBLocale.SUBMIT_NEW_STORE_NOT_VALID))
      );
    }
  }
}