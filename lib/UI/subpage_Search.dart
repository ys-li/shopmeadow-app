import 'package:flutter/material.dart';
import '../Utils/lang.dart';
import 'Components/Entry_Store.dart';
import '../Utils/StoreDetails.dart';
import '../Utils/netcode.dart';
import 'themes.dart';
import 'Components/IBLoader.dart';
import '../Utils/UserStat.dart';
import '../Utils/Categories.dart';
import '../Utils/DataVersionControl.dart';

class subpage_Search extends StatefulWidget{
  subpage_SearchState createState() => new subpage_SearchState();
}

class subpage_SearchState extends State<subpage_Search> {

  TextEditingController _txtController;
  ScrollController _scrollController;
  List<StoreDetails> searchResults;
  bool _searching = false;
  bool _reachedEnd = false;
  List<int> filterCategory = new List<int>();

  @override
  void initState() {
    _txtController = new TextEditingController();
    _scrollController = new ScrollController();
    searchResults = new List<StoreDetails>();

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge && _scrollController.position.pixels != 0) {
        if (!_reachedEnd && !_searching && searchResults.length > 0) getMoreSearch();
      }
    });
  }

  @override
  Widget build(BuildContext context){

    if (!DataVersionControl.serverUp && DataVersionControl.finished){
      return cannotConnectWidget();
    }

    var widgets = new List<Widget>();
    widgets.add(_buildSearchBar());
    if (searchResults.length == 0){
      widgets.add(
        new Center(child: new Text(
          IBLocale.EXAMPLE_QUERY,
          style: LightStyle
        ))
      );
    }

    ListView returnee = new ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
      controller: _scrollController,
      itemCount: searchResults.length + 3,
      itemBuilder: (bc, i){
        if (i == 0){
          return _buildSearchBar();
        }
        else if (i == 1){
          if (searchResults.length == 0){
            return new Center(
              child: new Text(
                IBLocale.EXAMPLE_QUERY,
                style: LightStyle.copyWith(color: Colors.grey)
            ));
          }else{
            return new Container();
          }
        }else if (i == searchResults.length + 2){
          if (searchResults.length > 0 && !_reachedEnd) return new Padding(padding: const EdgeInsets.only(top: 7.0, bottom: 20.0), child: new IBLoader());

          if (_searching)
            return new Padding(padding: const EdgeInsets.only(top: 7.0, bottom: 20.0), child: new IBLoader());
          else
            return new Container();
        }else{
          if (searchResults[i-2].storeID == -1){
            _reachedEnd = true;
            return new Center(child: new Text(IBLocale.SEARCH_END, style: LightStyle.copyWith(color: Colors.black)));
          }else {
            return new Entry_Store.ForSearch(searchResults[i - 2]);
          }
        }
      }
    );
    return returnee;
  }

  Widget _buildSearchBar(){
    TextField textField = new TextField(
      autofocus: true,
      controller: _txtController,
      onSubmitted: (s) => startSearch(),
      decoration: new InputDecoration.collapsed(hintText: IBLocale.SEARCHBAR)
    );
    Row row = new Row(
      children: <Widget>[
        new Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 2.5, bottom: 2.5),

            child: new Icon(Icons.search,color: Colors.black45)
        ),
        new Expanded(child: textField),
        new Padding(
            padding: const EdgeInsets.only(right: 15.0, left: 2.5, top: 2.5, bottom: 2.5),
            child: new IconButton(
                icon: new Icon(Icons.add,color: Colors.black45),
                onPressed: (){
                  showModalBottomSheet(context: context, builder: (c){
                    return new Column(

                      children: [
                        new Padding(child: new Text(IBLocale.FILTER_STORE, style: HeaderStyle), padding: const EdgeInsets.all(10.0)),
                        new Divider(),
                        new Container(height: 300.0, child: new Scrollbar(child: new ListView.builder(

                          itemCount: Categories.categoryList.length,
                          itemBuilder: (bc, i){
                            return new InkWell(
                              child: new Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: new Text(Categories.categoryList[i].nameByPref, style: LightStyle.copyWith(fontSize: 20.0), textAlign: TextAlign.center,),
                              ),
                              onTap: (){
                                setState(() {
                                  if (filterCategory.contains(Categories.categoryList[i].catID))
                                    filterCategory.remove(Categories.categoryList[i].catID);
                                  else
                                    filterCategory.add(Categories.categoryList[i].catID);
                                });
                                startSearch();
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        ))),
                      ]
                    );
                  });
                },
            )
        ),

      ]
    );


    Container finalContainer = new Container(

      decoration: new BoxDecoration(
        border: new Border.all(width: 1.0, color: Colors.black12),
        borderRadius: const BorderRadius.all(const Radius.circular(18.0)),
        color: Colors.white70,
      ),
      child: row,
    );

    ListView catScroll = new ListView.builder(

      scrollDirection: Axis.horizontal,
      itemCount: filterCategory.length,
      itemBuilder: (bc, i){
        return new Container(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          width: 100.0,
          child: new Chip(

            label: new Text(
              Categories.getCategoryByID(filterCategory[i]).nameByPref,
              style: LightStyle,
              softWrap: false,
              maxLines: 1,
            ),
            onDeleted: (){
              setState((){filterCategory.removeAt(i);});
              startSearch();
            },
        ));

      },
    );

    Padding searchBar = new Padding(padding: const EdgeInsets.only(top: 10.0, bottom: 15.0), child: finalContainer);

    List<Widget> columnWidgets = [searchBar];

    if (filterCategory.length > 0) columnWidgets.add(new Container(
        margin: const EdgeInsets.only(bottom: 15.0),
        height: 30.0,
        child: catScroll
    ));

    return new Column(
      children: columnWidgets
    );
  }

  void startSearch(){
    if (_txtController.text.length > 1){
      _reachedEnd = false;
      setState(() {searchResults.clear(); _searching = true;});
      String searchString = _txtController.text;
      for(int id in filterCategory){
        searchString += " " + Categories.getCategoryByID(id).nameForSearch;
      }
      //print(searchString);
      NetCode.getSearchResult(0, searchString).then((l) {
        setState(() {
          searchResults.addAll(l);
          _searching = false;
        });
      });
    }
  }

  void getMoreSearch(){
    if (_reachedEnd) return;
    setState(() {_searching = true;});
    String searchString = _txtController.text;
    for(int id in filterCategory){
      searchString += " " + Categories.getCategoryByID(id).nameForSearch;
    }
    NetCode.getSearchResult(searchResults.length, searchString).then((l) {
      setState(() {
        searchResults.addAll(l);
        _searching = false;
      });
    });

    UserStat.addSearchQuery(_txtController.text.toLowerCase(), 1);
  }
}