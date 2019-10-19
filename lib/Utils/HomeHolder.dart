import 'HomeDetails.dart';
import 'netcode.dart';
import 'dart:async';



class HomeHolder{

  static List<HomeDetails> holderHomeDetails = new List<HomeDetails>();

  static Future moreHomeDetails () async{

    try {
      var startIndex = holderHomeDetails.length;
      Map m = await NetCode.getJSONFromServer("home/?s=" + startIndex.toString());
      List<HomeDetails> returnee = new List<HomeDetails>();
      var results = m["results"];
        for (Map mm in results) {
          returnee.add(new HomeDetails(
              mm["id"],
              mm["title"],
              mm["date"],
              mm["hero_link"],
              mm["short_description"]
          ));
        }

      holderHomeDetails.addAll(returnee);
    }
    catch (e){
      print(e.toString());
    }
  }
}