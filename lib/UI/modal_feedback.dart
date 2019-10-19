/*import 'package:flutter/material.dart';
import 'package:instabazaar_codebase/UI/themes.dart';
import 'package:instabazaar_codebase/Utils/lang.dart';
import 'Components/Entry_Store.dart';
import 'package:instabazaar_codebase/Utils/StoreDetails.dart';
import 'package:instabazaar_codebase/Utils/Categories.dart';
import 'package:instabazaar_codebase/UI/Components/IBLoader.dart';
import 'dart:async';
import 'package:instabazaar_codebase/Utils/netcode.dart';

class modal_feedback extends StatelessWidget{

  static final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _submitting = false;
  TextEditingController _txtController;
  @override
  Widget build(BuildContext context) {
    _txtController = new TextEditingController();
    TextField textField = new TextField(
        //onSubmitted: (s) => submitStore(s,context),
        autofocus: true,
        controller: _txtController,
        decoration: new InputDecoration.collapsed(hintText: IBLocale.DEFAULT_HINT_TEXT),
        maxLines: 100,

    );

    /*Container finalContainer = new Container(

      decoration: new BoxDecoration(
        border: new Border.all(width: 1.0, color: Colors.black12),
        borderRadius: const BorderRadius.all(const Radius.circular(18.0)),
        color: Colors.white70,
      ),
      child: textField,
    );*/

    Widget inputBar = new Padding(padding: const EdgeInsets.all(20.0), child: textField);

    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(IBLocale.MENU_FEEDBACK),
      ),
      body: new ListView(
          children:[
            new Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0, bottom: 10.0),
              child: new Card(child: new Padding(padding: const EdgeInsets.all(20.0), child: new Text(IBLocale.FEEDBACK_HEADER, style: HeaderStyle.copyWith(color: Colors.blueAccent), textAlign: TextAlign.center,))),
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
      NetCode.submitFeedback(s).then((success) {
        if (success) {
          _scaffoldKey.currentState.showSnackBar(
              new SnackBar(content: new Text("Thanks! Feedback submitted.")));
          Navigator.of(context).pop();
        } else {
          _scaffoldKey.currentState.showSnackBar(
              new SnackBar(content: new Text("Oops! Something went wrong!")));
        }
      });
    } else {
      _scaffoldKey.currentState.showSnackBar(
          new SnackBar(content: new Text("Please type something lol"))
      );
    }
  }
}**/