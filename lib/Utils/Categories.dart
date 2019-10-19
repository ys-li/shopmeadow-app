import 'StoreDetails.dart';
import 'dart:async';
import 'utils.dart';
import 'netcode.dart';
import 'dart:convert';
import 'DataVersionControl.dart';
import 'UserStat.dart';
import 'UserPref.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../UI/splash_screen.dart';
import 'package:http/http.dart' as http;

class Categories{
  static bool _populated = false;
  static bool get populated => _populated;

  static List<Category> _categoryList;
  static List<Category> get categoryList {
    if (_categoryList == null || _categoryList.isEmpty){
      initialise();
    }
    return _categoryList;
  }



  static Future initialise({LabeledGlobalKey<Splash_ScreenState> splashKey}) async {
    _categoryList = new List<Category>();



    String s = await readFromFile('categories');
    if (s != null && s.isNotEmpty) {
      Map ms = getMapByNodeFromJSON(s);
      //print("${ms["version"]} and ${DataVersionControl.newestCat}");
      if (ms["version"] == DataVersionControl.newestCat) {
        for (Map m in ms["results"]) {
          _categoryList.add(new Category(
              m["category_name"], m["category_id"], m["image_link"],
              m["category_name_zh"]));
        }
      } else
        await _syncWithServerNew(splashKey);
    } else
      await _syncWithServerNew(splashKey);

    _populated = true;
  }

  static Future _syncWithServerNew(LabeledGlobalKey<Splash_ScreenState> splashKey) async {
    splashKey.currentState.setHelpText("Performing first time setup...");
    Map m = await NetCode.getJSONFromServer("categories/");

    List<Category> returnee = new List<Category>();
    var i = 1;
    try {
      var results = m["results"];
      var response = await http.get(Uri.parse(NetCode.serverUrl + "static/categories/full.jps"));
      List<int> bytes = response.bodyBytes;
      var jpsplit = new List<List<int>>();
      jpsplit.add([]);
      jpsplit.addAll(splitByBytes(bytes, ascii.encode("SHOPMEADOWSHOPMEADOW")));
     // writeFile("full.jps", bytes);
      //print(jpsplit.length);
      //print(jpsplit[2].length);

      for (Map mm in results) {

        writeAsByteFile(mm["category_id"].toString()+".jpg", jpsplit[mm["category_id"]]);
        mm["image_link"] = "file:${mm["category_id"].toString()+".jpg"}";
        returnee.add(new Category(
            mm["category_name"],
            mm["category_id"],
            mm["image_link"],
            mm["category_name_zh"]
        ));

        if (splashKey != null) {
          splashKey.currentState.setHelpText("$i/${results.length}");
        }

        i++;
      }

      _categoryList = returnee;
      await writeFile('categories', json.encode(m));


    }
    catch (e){
      print(e.toString());
    }
  }

  static List<List<int>> splitByBytes(List<int> source, List<int> marker){
    var markerLen = marker.length;
    List<int> temp = new List<int>();
    List<List<int>> returnee = new List<List<int>>();
    for (var cur = 0; cur < source.length; cur++){
      if (cur + markerLen > source.length) break;
      bool match = true;
      temp.add(source[cur]);
      for (var i = 0; i < markerLen; i++){
        if (source[cur + i] != marker[i]){
          match = false;
          break;
        }
      }
      if (match){
        cur += markerLen - 1;
        returnee.add(temp);
        temp = new List<int>();
      }
    }
    return returnee;
  }

  /*static Future _syncWithServer(LabeledGlobalKey<Splash_ScreenState> splashKey) async{
    Map m = await NetCode.getJSONFromServer("categories/");
    try {
      List<Category> returnee = new List<Category>();
      var results = m["results"];
      var i = 1;

      for(Map mm in results){

        // download categories photos
        List<String> urlsplit = mm["image_link"].split('/');

        if (await downloadFile(mm["image_link"], urlsplit[urlsplit.length - 1])) {
          mm["image_link"] = "file:${urlsplit[urlsplit.length - 1]}";
        }

        returnee.add(new Category(
            mm["category_name"],
            mm["category_id"],
            mm["image_link"],
            mm["category_name_zh"]
        ));


        if (splashKey != null) {
          splashKey.currentState.setHelpText("$i/${results.length}");
        }
        i++;

      }

      _categoryList = returnee;



      print(await writeFile('categories', JSON.encode(m)));
      //print(JSON.encode(m));
    }
    catch (e){
      print(e.toString());
    }
  }*/

  static Category getCategoryByID(int catID){

    for (var c in _categoryList){
      if (catID == c.catID)
        return c;
    }
    return new Category("...", -1, "", "...");
  }

}

class Category{

  String get nameByPref {
    if (UserPref.langChinese) return _name_zh;
    return _name;
  }

  String get nameForSearch{
    return _name;
  }

  String _name;
  String _name_zh;
  String imageLink;
  int catID;
  Image catImage;


  Category(this._name, this.catID, this.imageLink, [this._name_zh = ""]){
    this._name_zh = this._name_zh.replaceAll('\n', '');
    setImage();
  }

  Category.initFromMap(Map map){
    _name = map["category_name"];
    _name_zh = (map["category_name_zh"] ?? _name);
    imageLink = map["image_link"];
    catID = map["category_id"];
    setImage();
  }

  void setImage(){

    if (imageLink.startsWith("file:")){

      //print("$mainDir/${imageLink.replaceAll("file:","")}");
      catImage = new Image.file(
        new File("$mainDir/${imageLink.replaceAll("file:","")}"),
        fit: BoxFit.cover
      );
    }else {

      catImage = new Image.network(
          imageLink,
          fit: BoxFit.cover
      );
    }
  }

  List<StoreDetails> storeList;

  bool _initialised = false;
  bool get initialised => _initialised;

  void initialise(){
    storeList = new List<StoreDetails>();
    _initialised = true;
  }


  Future<Null> moreStores () async{

    Map m = await NetCode.getJSONFromServer(
        'categories/' + catID.toString() +
        '/?s=' + storeList.length.toString()
    );

    var result = m["results"];
    for (Map m in result){
      storeList.add(new StoreDetails.initFromMap(m));
    }

    UserStat.addCategoryID([catID], 1);
  }
}