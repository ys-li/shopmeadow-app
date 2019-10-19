import 'package:flutter/material.dart';
import 'dart:async';
import 'utils.dart';
import 'netcode.dart';

class HomeDetails{
  int id;
  String shortDescription;
  String title;
  String date;
  String heroLink;


  HomeDetails(this.id, this.title, this.date, this.heroLink, this.shortDescription);

  HomeDetails.initFromMap(Map m){
    id = m["id"];
    shortDescription = m["short_description"];
    title = m["title"];
    date = m["date"];
    heroLink = m["hero_link"];
  }

  bool _populated = false;
  bool get populated => _populated;

  List<Widget> contents;

  Future populate() async{
    try {
      Map m = await NetCode.getJSONFromServer('home/' + id.toString() + '/');
      contents = parseRawToWidgets(m["content"]);
      _populated = true;
    }catch (e){
      contents = [new Center(child: new Text("Oops! Something went wrong!"))]; //only called when the s is null
    }
  }


}