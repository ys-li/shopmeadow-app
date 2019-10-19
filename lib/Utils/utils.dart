import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'StoreDetails.dart';
import '../UI/themes.dart';
import '../UI/Components/ClickablePhoto.dart';
import '../UI/Components/Entry_Store.dart';

String mainDir;

Future utilsInit() async{
  mainDir = (await getApplicationDocumentsDirectory()).path;
  //print(mainDir);
}

List<Widget> parseRawToWidgets(List<Map> maps){
  List<Widget> returnee = new List<Widget>();
    for (var m in maps){
      returnee.add(_parseMapToWidget(m));
    }
    return returnee;

}

Widget _parseMapToWidget(Map m){
  if (m.containsKey("type")){
    switch (m["type"]){
      case "text":
        return new Padding(
          padding: const EdgeInsets.only(bottom:8.0),
          child: new Text(
            m["content"],
            style: LightStyle.copyWith(color: Colors.black87),
          ),
        );
        break;
      case "photorow":
        List<Widget> photos = new List<Widget>();

        var i = 0;
        do {
          photos.add(
              new Expanded(child: new ClickablePhoto(
                  imageLink: m["photo$i"]
              ))
          );
        }while(m.containsKey("photo${++i}"));

        return new Padding(padding: const EdgeInsets.symmetric(vertical: 15.0), child: new Row(children: photos));
        break;
      case "store":
        return new Entry_Store.ForSearch(new StoreDetails(m["store_id"], m["store_name"], m["ig_name"], m["category_ids"], m["avatar_link"]));
      default:
        return new Center(child: new Text("Please update the app to view this content.", style: LightStyle.copyWith(color: Colors.black87)));
    }
  }else{
    return new Center(child: new Text("Please update the app to view this content."));
  }
}

Map getMapByNodeFromJSON(String s){
  try {
    return json.decode(s);
  }catch (e){
    debugPrint(e.toString());
    return null;
  }
}


Future<bool> checkReviewed(int storeID) async{
  String match = storeID.toString();
  String s = await readFromFile('reviewed');
  var ss = s.split(',');
  for (var sss in ss){
    if (match == sss){
      return true;
    }
  }
  return false;
}

Future addReviewed(int storeID) async{
  String s = await readFromFile('reviewed');
  s += ",$storeID";
  await writeFile('reviewed', s);
}

//MARK: IO operations
Future<String> readFromFile(String filename) async{
  String content;
  //String dir = (await getApplicationDocumentsDirectory()).path;
  File file = new File('$mainDir/$filename');

  //create if not found
  if (!(await file.exists())){
    writeFile(filename, "", file);
    return "";
  }

  //read
  try{
    content = await file.readAsString();
  } catch (e) {
    debugPrint(e.toString());
  }
  return content;
}

Future<bool> writeFile(String filename, String content, [File file = null]) async{
  if (file == null){ //write without prior read
    //String dir = (await getApplicationDocumentsDirectory()).path;
    file = new File('$mainDir/$filename');
  }

  try {
    await file.writeAsString(content);
    return true;
  } catch (e) {
    debugPrint(e.toString());
    return false;
  }
}

Future<bool> writeAsByteFile(String filename, List<int> content) async{
  var file = new File('$mainDir/$filename');
  try {
    await file.writeAsBytes(content);
    return true;
  } catch (e) {
    debugPrint(e.toString());
    return false;
  }
}

/*Future<bool> downloadFile(String url, String filename) async{
  HttpClientRequest hcreq = await new HttpClient().getUrl(Uri.parse(url));
  HttpClientResponse hcresp = await hcreq.close();

  //String dir = (await getApplicationDocumentsDirectory()).path;
  var file = new File('$mainDir/$filename');
  try {
    await hcresp.pipe(file.openWrite());
    return true;
  } catch (e) {
    debugPrint(e.toString());
    return false;
  }

}*/