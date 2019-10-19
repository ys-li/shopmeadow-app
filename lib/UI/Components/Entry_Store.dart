import 'package:flutter/material.dart';
import '../themes.dart';
import '../page_Store.dart';
import '../../Utils/StoreDetails.dart';

import 'NectarImage.dart';

enum StoreEntryType{Fav, Cat, Search}

class Entry_Store extends StatelessWidget {
  StoreDetails storeDetails;
  StoreEntryType entryType;

  Entry_Store.ForFav(StoreDetails _sd) : super(){
    this.entryType = StoreEntryType.Fav;
    storeDetails = _sd;
  }
  Entry_Store.ForCat(StoreDetails _sd) : super(){
    this.entryType = StoreEntryType.Cat;
    storeDetails = _sd;
  }
  Entry_Store.ForSearch(StoreDetails _sd) : super(){
    this.entryType = StoreEntryType.Search;
    storeDetails = _sd;
  }


  @override
  Widget build(BuildContext context){

    String catString = "${storeDetails.mainCategory.nameByPref}";
    if (storeDetails.secondCategory != null) catString += ", ${storeDetails.secondCategory.nameByPref}";
    if (storeDetails.thirdCategory != null) catString += ", ${storeDetails.thirdCategory.nameByPref}";
    List<Widget> content = <Widget>[
      new Text("@${storeDetails.igName}  |  $catString", style: LightStyle.copyWith(fontSize: 10.0)),
      new Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        width: 250.0,
        child: new Text(storeDetails.storeName, style: HeaderStyle.copyWith(color: textColor), overflow: TextOverflow.ellipsis),

      ),



    ];


    if (this.entryType == StoreEntryType.Cat){
      content.add(new Row(
          children: [
            new Padding(
              child: new Icon(Icons.thumb_up, color: Colors.blue, size: 12.0),
              padding: const EdgeInsets.only(left: 0.0, right: 5.0, top: 5.0, bottom: 5.0),
            ),

            new Text(storeDetails.ratingGood.toString(), style: LightStyle.copyWith(fontSize: 10.0)),
            new Padding(
              child: new Icon(Icons.thumb_down, color: Colors.grey, size: 12.0),
              padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
            ),
            new Text(storeDetails.ratingBad.toString(),style: LightStyle.copyWith(fontSize: 10.0)),
          ]
      ));
    }


    Card mainCard = new Card(
      child: new Padding(
        padding: const EdgeInsets.all(5.0),
        child: new InkWell(
          onTap: () => (openStoreDetails(context)),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Hero(
                tag: 'storeAvatar_${storeDetails.storeID}',
                child: new Container(
                  width: 85.0,
                  height: 85.0,
                  child: new NectarImage.loadingScreen(
                      storeDetails.avatarLink,
                      backgroundColor: Colors.transparent,
                      waiting: new Icon(
                          Icons.sync,
                          size: 18.0,
                          color: Colors.grey
                      ),
                    circular: true,
                  ),
                ),
              ),
              new Padding(padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                child: new Column(

                  crossAxisAlignment: CrossAxisAlignment.start,




                  children: content,
                ),
              ),

            ],
          ),
        ),
      ),
    );
    return mainCard;
  }

  void openStoreDetails(BuildContext context){
    Navigator.of(context).push(
      new MaterialPageRoute<Null>(builder: (BuildContext context){
        return new page_Store(storeDetails);
      })
    );
  }

}