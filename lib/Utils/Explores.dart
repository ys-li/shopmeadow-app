import 'StoreDetails.dart';
import 'dart:async';
import 'netcode.dart';

class ExploreEntry{

  String imageLink;
  StoreDetails storeDetails;
  ExploreEntry(this.imageLink, this.storeDetails);
}


enum ExploreType{
  JustForYou,
  Hot,
  New,
  Category
}

class ExploreHolder{
  static var entries = new Map<ExploreType, List<ExploreEntry>>();


  static Future<bool> getMoreExplore(ExploreType type, int catID) async{
    try {
      if (entries[type] == null) entries[type] = new List<ExploreEntry>();

      var newEntries = await NetCode.getExploreEntries(
          type, entries[type].length, catID);
      entries[type].addAll(newEntries);
      return true;
    }
    catch (e){
      print(e.toString());
      return false;
    }
  }




}