import 'package:flutter/material.dart';
import '../Utils/lang.dart';
import 'Components/IBLoader.dart';
import '../Utils/StoreDetails.dart';
import 'themes.dart';
import '../Utils/netcode.dart';
import 'page_Store.dart';

class page_MoreReviews extends StatefulWidget{
  StoreDetails storeDetails;
  page_MoreReviews(this.storeDetails);

  @override
  page_MoreReviewsState createState() => new page_MoreReviewsState();
}

class page_MoreReviewsState extends State<page_MoreReviews>{

  bool _fetchingData = false;
  List<Review> allReviews;
  ScrollController _scrollController;
  bool reachedEnd = false;

  @override
  void initState() {
    allReviews = new List<Review>();
    getMoreReviews();

    _scrollController = new ScrollController();
    _scrollController.addListener(() {
      if (reachedEnd) return;
      if (_scrollController.position.atEdge && _scrollController.position.pixels != 0) {
        if (!_fetchingData) getMoreReviews();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        title: new Text("${IBLocale.REVIEWS_FOR}${widget.storeDetails.igName}"),
        centerTitle: true
      ),
      body: new ListView.builder(
        controller: _scrollController,
        itemCount: allReviews.length + 1,
        itemBuilder: (bc, i){
          if(i < allReviews.length){
            if (allReviews[i].id == -1) {
              reachedEnd = true;
              return new Padding(padding: const EdgeInsets.only(top: 7.0, bottom: 20.0),
                child: new Text(IBLocale.REVIEWS_END, style: LightStyle, textAlign: TextAlign.center),
              );
            }else{
              return new Padding(padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), child: new ReviewBlock(allReviews[i]));
            }
          }else{
            if (reachedEnd)
              return new Container();
            else
              return new Padding(padding: const EdgeInsets.only(top: 7.0, bottom: 20.0), child: new IBLoader());
          }
        }
      )
    );
  }

  void getMoreReviews(){
    _fetchingData = true;
    NetCode.getMoreReviews(widget.storeDetails.storeID, allReviews.length).then((l){
      setState((){allReviews.addAll(l);_fetchingData = false;});
    });
  }
}