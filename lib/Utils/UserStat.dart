import 'utils.dart';
import 'dart:async';
import 'dart:convert';

class UserStat {
  static bool _ready = false;
  static Map<String, int> _searchQuery;
  static Map<String, int> _categoryID;

  static Map<String, int> get CategoryID => _categoryID;

  static Future<bool> load() async {
    _searchQuery = new Map<String, int>();
    _categoryID = new Map<String, int>();

    _ready = false;

    try {
      String raw = await readFromFile('userstat');
      if (raw.isNotEmpty) {
        var _json = json.decode(raw);
        _searchQuery = (_json["search_query"] as Map).cast<String, int>();
        _categoryID = (_json["category_ids"] as Map).cast<String, int>();
      }
      _ready = true;
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static void startSave() {
    writeFile('userstat', json.encode({"search_query": _searchQuery, "category_ids": _categoryID}));
  }

  static Future<String> getRepresentation64() async {
    if (!_ready) await load();

    Map getPrepared(Map from, int cutoff) {
      if (from.length > 10) {
        Map prepared = new Map<dynamic, int>();
        List<int> sortedFreq = from.values.toList();
        sortedFreq.sort();
        var cutoff = sortedFreq[10];
        for (var k in from.keys) {
          if (from[k] > cutoff) {
            prepared[k] = from[k];
          }
        }
        return prepared;
      } else {
        return from;
      }
    }

    Map preparedCat = getPrepared(_categoryID, 10);
    Map preparedQuery = getPrepared(_searchQuery, 10);

    return utf8.fuse(base64).encode(json.encode({"category_ids": preparedCat, "search_query": preparedQuery}));
  }

  static Future addSearchQuery(String query, int freq) async {
    if (query == null || query == "") return;

    if (!_ready) await load();

    if (!_searchQuery.containsKey(query)) _searchQuery[query] = 0;

    _searchQuery[query] += freq;
    startSave();
  }

  static Future addCategoryID(List<int> catIDs, int freq) async {
    if (catIDs == null) return;


    if (!_ready) await load();

    for (var id in catIDs) {
      if (!_categoryID.containsKey(id.toString())) _categoryID[id.toString()] = 0;

      _categoryID[id.toString()] += freq;
    }
    startSave();
  }

  static Future<bool> clear() async {
    _categoryID = new Map<String, int>();
    _searchQuery = new Map<String, int>();
    return writeFile('userstat', "");
  }

  static bool isEmpty() {
    return (_searchQuery.isEmpty && _searchQuery.isEmpty);
  }
}
