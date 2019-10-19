import 'dart:async';
import 'netcode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataVersionControl{
  static int newestCat;
  static int newestBinary;
  static final String version = "0.5";
  static bool serverUp = false;
  static bool finished = false;
  static Future synchronise() async{


    SharedPreferences prefs = await SharedPreferences.getInstance();
    NetCode.serverUrl = prefs.getString('serverUrl') ?? NetCode.serverUrl;
    try {
      Map result = await NetCode.getJSONFromServer('version/');

      if (result.containsKey("error")) {throw new Exception();}

      prefs.setString('serverUrl', result["server_url"]);
      prefs.setString('submitStoreUrl', result["submit_store_url"]);
      prefs.setString('submitReportUrl', result["submit_report_url"]);
      prefs.setString('submitFeedbackUrl', result["submit_feedback_url"]);
      prefs.commit();

      NetCode.serverUrl = prefs.getString('serverUrl') ?? NetCode.serverUrl;
      NetCode.submitStoreUrl = prefs.getString('submitStoreUrl') ?? NetCode.submitStoreUrl;
      NetCode.submitReportUrl = prefs.getString('submitReportUrl') ?? NetCode.submitReportUrl;
      NetCode.submitFeedbackUrl = prefs.getString('submitFeedbackUrl') ?? NetCode.submitFeedbackUrl;

      //print(NetCode.serverUrl);

      serverUp = (result["server_up"] == 1);
      newestCat = result["category_ver"];
      newestBinary = result["binary_ver"];

      finished = true;
    } catch (e){
      serverUp = false;
      finished = true;
    }
  }


}
