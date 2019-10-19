import 'package:flutter/material.dart';

class IBLoader extends StatefulWidget{
  final bool white;
  IBLoader({this.white = false});

  @override
  IBLoaderState createState() => new IBLoaderState();
}

class IBLoaderState extends State<IBLoader> with TickerProviderStateMixin{

  AnimationController _controller;
  AnimationController _controllerSmaller;
  Animation<Offset> _offset;
  Animation<Offset> _offsetSmaller;
  IBLoaderState() : super(){
    _controller = new AnimationController(
        vsync: this,
        duration: new Duration(milliseconds: 850)
    );
    _offset = new Tween<Offset>(
        begin: const Offset(-.15, 0.0),
        end: const Offset(.15, 0.0)
    ).animate(new CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut)
    );

    _controllerSmaller = new AnimationController(
        vsync: this,
        duration: new Duration(milliseconds: 650)
    );
    _offsetSmaller = new Tween<Offset>(
        begin: const Offset(-.15, 0.0),
        end: const Offset(.15, 0.0)
    ).animate(new CurvedAnimation(
        parent: _controllerSmaller,
        curve: Curves.easeInOut)
    );
  }

  @override
  Widget build(BuildContext context){

    Container dot = new Container(
      width: 10.0,
      height: 10.0,
      decoration: BoxDecoration(
        color: widget.white ? Colors.white : Theme.of(context).accentColor.withAlpha(195),
        shape: BoxShape.circle,
      ),
    );


    SlideTransition transition = new SlideTransition(
      position: _offset,
      child: new Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: dot,
      ),
    );

    Container dotSmall = new Container(
      width: 6.0,
      height: 6.0,
      decoration: BoxDecoration(
        color: widget.white ? Colors.white : Colors.orangeAccent.withAlpha(195),
        shape: BoxShape.circle,
      ),
    );

    SlideTransition transitionSmall = new SlideTransition(
      position: _offsetSmaller,
      child: new Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: dotSmall,
      ),
    );

    _controller.forward().then((c) => reverseAnimation());
    _controllerSmaller.forward().then((c) => reverseAnimationSmaller());

    return new Container(
        width: 200.0,
        child: new Stack(
            alignment: FractionalOffset.center,
            fit: StackFit.passthrough,
            children: <Widget>[
              transition,
              transitionSmall,
            ]
        )
    );
  }

  void reverseAnimation(){
    _controller.reverse().then((c) => forwardAnimation());
  }

  void forwardAnimation(){
    _controller.forward().then((c) => reverseAnimation());
  }

  void reverseAnimationSmaller(){
    _controllerSmaller.reverse().then((c) => forwardAnimationSmaller());
  }

  void forwardAnimationSmaller(){
    _controllerSmaller.forward().then((c) => reverseAnimationSmaller());
  }

  @override
  void dispose(){
    _controller.dispose();
    _controllerSmaller.dispose();
    super.dispose();
  }
}