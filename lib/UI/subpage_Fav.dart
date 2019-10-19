import 'package:flutter/material.dart';
import 'Components/Entry_Store.dart';
import '../Utils/lang.dart';
import 'themes.dart';
import '../Utils/StoreDetails.dart';
import 'Components/IBLoader.dart';
import '../Utils/Favourites.dart';
import '../main.dart';


class subpage_Fav extends StatefulWidget{
  subpage_FavState createState() => new subpage_FavState();
}

class subpage_FavState extends State<subpage_Fav> {

  @override
  void initState() {
    if (!Favourites.populated){
      Favourites.initialise().then((b){
        setState((){});
      });
    }
  }

  @override
  Widget build(BuildContext context){

    Widget returnee;
    if (Favourites.populated){
      List<Widget> list = _buildFavList();
      if (list.length > 0) {
        returnee = new Scrollbar(
          child: new ListView(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
            children: _buildFavList(),
          ),
        );
      } else {
        returnee = new Center(
          child: new Text(
            IBLocale.FAV_EMPTY,
            style: LightStyle,
          )
        );
      }
    }else{
      return new Center(child: new Container(width: double.infinity, child: new IBLoader()));
    }
    return returnee;
  }

  List<Widget> _buildFavList(){
    List<Widget> list = new List<Widget>();
    //TODO: get list of fav stores
    for (StoreDetails sd in Favourites.getStoreDetails){
      list.add(new Entry_Store.ForFav(sd));
    }
    return list;
  }
}