import 'StoreDetails.dart';
import 'dart:async';
import 'utils.dart';
import 'dart:convert';

class Favourites{

  static bool _populated = false;
  static bool get populated => _populated;

  static List<StoreDetails> _storeDetailsList = new List<StoreDetails>();
  static List<StoreDetails> get getStoreDetails {
    if (_populated) return _storeDetailsList;
    else {
      initialise(); //TODO: BUG: low priority, not initialised before returning
      return _storeDetailsList;
    }
  }

  static Future<bool> add(StoreDetails sd) async{
    try {
      //print(getStoreDetails);
      getStoreDetails.add(sd);
      return await saveToStorage();

    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future<bool> remove(int storeID) async{
    try{

      int index = -1;
      for (int i = 0; i < getStoreDetails.length; i++){
        if (storeID == getStoreDetails[i].storeID){
          index = i;
        }
      } if(index == -1) {print("no entry found"); return false;}

      getStoreDetails.removeAt(index);
      return await saveToStorage();
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future<bool> initialise() async{
    _storeDetailsList = new List<StoreDetails>();
    String s = await readFromFile('favourites');
    if (s != null && s.isNotEmpty){
      for (Map m in getMapByNodeFromJSON(s)["favourites"]){
        _storeDetailsList.add(new StoreDetails.initFromMap(m,true));
      }
    }
    _populated = true;
    return _populated;
  }

  static Future<bool> clear() async{
    _storeDetailsList = new List<StoreDetails>();
    return writeFile('favourites', "");
  }

  static Future<bool> saveToStorage() async{



    List<Map> maps = new List<Map>();
    for (StoreDetails sd in getStoreDetails){
      maps.add(sd.getFavAsMap());
    }

    var toBeWritten = "";
    if (maps == null || maps.length == 0)
      toBeWritten = "";
    else
      toBeWritten = json.encode({'favourites': maps});


    return await writeFile('favourites', toBeWritten);
  }
}