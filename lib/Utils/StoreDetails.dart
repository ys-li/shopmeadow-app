import 'dart:async';
import 'Favourites.dart';
import 'netcode.dart';
import 'Categories.dart';

class StoreDetails{

  bool _favourite = false;
  bool get favourite => _favourite;
  void set favourite(bool value) {
    if (value != _favourite) {
      _favourite = value;
      if (_favourite)
        Favourites.add(this);
      else
        Favourites.remove(storeID);
    }
  }

  bool _populated = false;
  bool get populated => _populated;

  int storeID;

  List<int> categoryIDs;

  Category get mainCategory {
    return Categories.getCategoryByID(categoryIDs[0]);
  }


  Category get secondCategory {
    if (categoryIDs.length < 2) return null;
    return Categories.getCategoryByID(categoryIDs[1]);
  }

  Category get thirdCategory {
    if (categoryIDs.length < 3) return null;
    return Categories.getCategoryByID(categoryIDs[2]);
  }

  String avatarLink = "";

  String storeName = "";

  String igName;

  int ratingGood = 0, ratingBad = 0;

  String shortDescription = "Fetching";

  String longDescription = "Fetching";

  List<CardBit> cardBits = new List<CardBit>();

  List<String> gallery = new List<String>();

  List<Review> reviews = new List<Review>();

  StoreDetails(this.storeID, this.storeName, this.igName, this.categoryIDs, this.avatarLink);
  StoreDetails.delay(this.storeID, this.igName);
  StoreDetails.initFromMap(Map data, [bool fav = false]){
    storeID = data["store_id"];
    avatarLink = data["avatar_link"] ?? "";
    igName = data["ig_name"];
    categoryIDs = (data["category_ids"] as List).cast<int>() ?? null;
    storeName = data["store_name"] ?? "";
    ratingBad = data["rating_bad"] ?? null;
    ratingGood = data["rating_good"] ?? null;

    if (fav) {
      _favourite = true;
    }
    else {
      for (StoreDetails sd in Favourites.getStoreDetails) {
        if (sd.storeID == storeID) {
          _favourite = true;
          break;
        }
      }
    }

  }

  Future<bool> populate() async { //return false if fetch error
    //TODO: netcode for getting AND VERIFYING data
    _populated = false;
    cardBits = new List<CardBit>();
    gallery = new List<String>();
    reviews = new List<Review>();

    Map m = await NetCode.getJSONFromServer('stores/' + storeID.toString() + '/');

    storeName = m["store_name"];
    igName = m["ig_name"];
    categoryIDs = (m["category_ids"] as List).cast<int>();
    avatarLink = m["avatar_link"];

    ratingGood = m["rating_good"];
    ratingBad = m["rating_bad"];
    for (Map cb in (m["card_bits"] as List).cast<Map>()){
      if (cb != null) {
        cardBits.add(new CardBit(
            codePoint: cb["code_point"],
            title: cb["title"],
            content: cb["subtitle"]
        ));
      }
    }
    shortDescription = m["short_description"];
    longDescription = m["long_description"];
    if (longDescription == "!!SAME_AS_SHORT"){
      longDescription = shortDescription;
    }
    for (String link in (m["gallery"] as List).cast<String>()){
      if (link.isNotEmpty)
        gallery.add(link);
    }
    for (Map r in (m["reviews"] as List).cast<Map>()){
      reviews.add(new Review(r["id"], r["thumbs_up"] == 1, r["date"], r["content"]));
    }

    _populated = true;
    return _populated;
  }




  Map getFavAsMap(){
    return
      { "store_id": storeID,
        "avatar_link": avatarLink,
        "ig_name": igName,
        "category_ids": categoryIDs,
        "store_name": storeName};
  }


}

class CardBit {
  int codePoint;
  String title;
  String content;
  CardBit({int codePoint, String title, String content}){
    this.codePoint = codePoint;
    this.title = title;
    this.content = content;
    if (this.title == null) this.title = "";
    if (this.content == null) this.content = "";

  }

}

class Review {
  bool thumbsUp;
  String date;
  String content;
  int id;

  Review(this.id, this.thumbsUp, this.date, this.content);
}