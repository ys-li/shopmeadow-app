import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'utils.dart';
import 'StoreDetails.dart';
import 'Explores.dart';
import 'UserStat.dart';

class NetCode{

  /// with trailing slash
  static String serverUrl = "http://apiox.ib.enchor.tech/";
  static String submitStoreUrl = "https://docs.google.com/forms/d/e/1FAIpQLSeJkFWdn1tphk9oRt5JdNI0_GmW7YVvaI8fuYGfNS5D70obJw/formResponse?entry.1084246014=";
  static String submitReportUrl = "https://docs.google.com/forms/d/e/1FAIpQLScLwnOchAkZ4BWuo2_nUObIVoUt7AAMJoPNF3G2owh82umwzQ/formResponse?entry.605608054=!storeid&entry.318778337=!category&entry.327646093=!content";
  static String submitFeedbackUrl = "https://docs.google.com/forms/d/e/1FAIpQLSeuo5XeQgJrNiC2rn1nSVu7X7bURXJK51EHXDurCEM4tJ2Qlw/formResponse?entry.1631751994=";


  static Future<bool> submitNewStore(String igname) async{
    var url = Uri.encodeFull(submitStoreUrl + igname);
    var response = await http.get(url);
    return (response.statusCode==200);
  }

  static Future<bool> submitFeedback(String content) async{
    var url = Uri.encodeFull(submitFeedbackUrl + content);
    var response = await http.get(url);
    return (response.statusCode==200);
  }

  static Future<List<ExploreEntry>> getExploreEntries(ExploreType type, int startIndex, int catID) async{
    var l = new List<ExploreEntry>();

    var url;
    if (type == ExploreType.Category) {
      url = "explore/$catID";
    }else {
      url = "explore/?type=" + type.index.toString() + "&s=" +
          startIndex.toString();
      if (type == ExploreType.JustForYou) {
        url += "&stat=" + await UserStat.getRepresentation64();
      }
    }

    Map m = await NetCode.getJSONFromServer(url);

    if (m.containsKey("error")) return [];

    var results = m["results"];
    for (var m in results) {
      l.add(new ExploreEntry(
          m["image_link"],
          new StoreDetails.delay(m["store_id"], m["store_igname"]))
      );
    }
    return l;
  }

  static Future<bool> sendReview(int storeID, bool thumbsUp, String content) async{
    var postdata = {
      "store_id": storeID.toString(),
      "thumbs_up": thumbsUp ? '1' : '0',
      "content": content
    };

    try {
      var response = await http.post(serverUrl + 'review/', body: postdata);

      if (json.decode(response.body)["response"] == "OK")
      {
        addReviewed(storeID);
        return true;
      } else return false;

    }catch (e){
      print(e.toString());
      return false;
    }
  }

  static Future<List<StoreDetails>> getSearchResult(int startIndex, String query) async{
    Map m = await NetCode.getJSONFromServer(
        "search?q=" + query + "&s=" + startIndex.toString()
    );

    if (m.containsKey("error")) return [];

    var results = m["results"];
    List<StoreDetails> returnee = new List<StoreDetails>();
    try{
      for (Map mm in results) {
        returnee.add(new StoreDetails.initFromMap(mm));
      }
    } catch (e){
      return [];
    }

    return returnee;
  }

  static Future<List<Review>> getMoreReviews(int storeid, int startIndex) async{

    var l = new List<Review>();
    Map m =  await NetCode.getJSONFromServer(
        "review?store_id=" + storeid.toString() + "&s=" + startIndex.toString()
    );

    if (m.containsKey("error")) return [];

    var results = m["results"];
    try {
      for (Map mm in results) {
        l.add(new Review(
            mm["id"], mm["thumbs_up"] == 1, mm["date"], mm["content"])
        );
      }
    } catch (e){
      return [];
    }

    return l;
  }

  static Future<Map> getJSONFromServer(String afterSlash) async {
    var data = {};
    try {
      String url = Uri.encodeFull(serverUrl + afterSlash);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        data = json.decode(utf8.decode(response.bodyBytes));
      }
    }
    catch (e){
      data = {"error": e.toString()};
    }
    return data;
  }
/*
  static Future<String> dummyFutureMethod() async {


    String url = 'https://httpbin.org/ip';
    url = Uri.encodeFull(url);
    var httpClient = createHttpClient();
    var response = await httpClient.read(url);

    response = "hehehe" + response; //TODO: remove this bit

    if (response.substring(0,6) != "hehehe") return null; //verify normal response

    response = response.substring(6);

    Map data = JSON.decode(response);
    String ip = data['origin'];
    return ip;
    /*// If the widget was removed from the tree while the message was in flight,
    // we want to discard the reply rather than calling setState to update our
    // non-existent appearance.
    if (!mounted) return;

    setState(() {
      _ipAddress = ip;
    });*/
  }
*/
  static Future<bool> submitReport(int storeID, String reportHintText, String text) async {
    var url = submitReportUrl.replaceAll("!storeid", storeID.toString()).replaceAll("!category", reportHintText).replaceAll("!content", Uri.encodeComponent(text));
    var response = await http.get(url);
    return (response.statusCode==200);
  }

}