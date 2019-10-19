import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';


class ClickablePhoto extends StatelessWidget{
  String _imageLink;
  double _width;
  double _height;
  EdgeInsets _padding;

  ClickablePhoto({String imageLink, double width = null, double height = null, EdgeInsets padding = null}){
    _imageLink = imageLink;
    _width = width;
    _height = height;
    _padding = padding;
  }

  @override
  Widget build(BuildContext context){

    return new GestureDetector(
      onTapUp: (b) => showModalPhoto(context),
      child: new Container(
        width: _width,
        height: _height,
        child: new Image.network(_imageLink),
        padding: _padding
      ),
    );
  }

  void showModalPhoto(BuildContext context){
    Navigator.of(context).push(
        new MaterialPageRoute<Null>(builder: (BuildContext context){
          return new _ModalPhoto(new NetworkImage(_imageLink.replaceAll('s150x150/', '')));
        })
    );
  }

}

class _ModalPhoto extends StatelessWidget{
  ImageProvider _image;
  _ModalPhoto(this._image);


  Widget build(BuildContext context){
    /*Scaffold returnee = new Scaffold(
      body: new ZoomableImage(_image)
    );*/

    /*if (_photo is ImageProvider) {

    }
    else {
      Scaffold returnee = new Scaffold(
        body: new Center(
          child: new GestureDetector(
            onVerticalDragDown: (cb) => Navigator.of(context).pop(),
            child: new Container(color: Colors.transparent, child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _photo,
                  new Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: new Text("Swipe down to exit.", style: NormalStyle)
                  ),
                ]
            )),
          ),
        ),
      );
    }*/

    //Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Double tap to quit.")));

    return new ZoomableImage(_image, scale: 8.0, cb: () => Navigator.of(context).pop());
  }
}

class ZoomableImage extends StatefulWidget {
  ZoomableImage(this.image, {Key key, this.scale = 2.0, this.onTap, this.cb}) : super(key: key);

  final ImageProvider image;
  final double scale;
  final VoidCallback cb;

  final GestureTapCallback onTap;

  @override
  _ZoomableImageState createState() => new _ZoomableImageState(scale);
}

// See /flutter/examples/layers/widgets/gestures.dart
class _ZoomableImageState extends State<ZoomableImage> {
  _ZoomableImageState(this._scale);

  final double _scale;

  ImageStream _imageStream;
  ui.Image _image;

  // These values are treated as if unscaled.

  Offset _startingFocalPoint;

  Offset _previousOffset;
  Offset _offset = Offset.zero;

  double _previousZoom;
  double _zoom = 1.0;

  void _handleScaleStart(ScaleStartDetails d) {
    if (_image == null) {
      return;
    }
    _startingFocalPoint = d.focalPoint / _scale;
    _previousOffset = _offset;
    _previousZoom = _zoom;
  }

  void _handleScaleUpdate(Size size, ScaleUpdateDetails d) {
    if (_image == null) {
      return;
    }

    double newZoom = _previousZoom * d.scale;


    if (newZoom < 0.8 && widget.cb != null) widget.cb();

    bool tooZoomedIn = _image.width * _scale / newZoom <= size.width ||
        _image.height * _scale / newZoom <= size.height;
    if (tooZoomedIn) {
      return;
    }

    setState(() {
      _zoom = newZoom;

      // Ensure that item under the focal point stays in the same place despite zooming
      final Offset normalizedOffset =
          (_startingFocalPoint - _previousOffset) / _previousZoom;
      _offset = d.focalPoint / _scale - normalizedOffset * _zoom;
      if (_zoom < 1.1 && _offset.distance > 15.0 * _zoom && widget.cb != null) widget.cb();
    });
  }

  @override
  void didChangeDependencies() {
    _resolveImage();
    super.didChangeDependencies();
  }

  @override
  void reassemble() {
    _resolveImage(); // in case the image cache was flushed
    super.reassemble();
  }

  void _resolveImage() {
    _imageStream = widget.image.resolve(createLocalImageConfiguration(context));
    _imageStream.addListener(_handleImageLoaded);
  }

  void _handleImageLoaded(ImageInfo info, bool synchronousCall) {
    print("image loaded: $info $synchronousCall");
    setState(() {
      _image = info.image;
    });
  }

  @override
  void dispose() {
    _imageStream.removeListener(_handleImageLoaded);
    super.dispose();
  }

  Widget _child() {
    if (_image == null) {
      return null;
    }

    // Painting in a small box and blowing it up works, whereas painting in a large box and
    // shrinking it down doesn't because the gesture area becomes smaller than the screen.
    //
    // This is bit counterintuitive because it's backwards, but it works.

    Widget bloated = new CustomPaint(
      painter: new _ZoomableImagePainter(
        image: _image,
        offset: _offset,
        zoom: _zoom / _scale,
      ),
    );

    return new Transform(
      transform: new Matrix4.diagonal3Values(_scale, _scale, _scale),
      child: bloated,
    );
  }

  @override
  Widget build(BuildContext ctx) {
    return new GestureDetector(
      child: _child(),
      onTap: widget.onTap,
      onScaleStart: _handleScaleStart,
      onScaleUpdate: (d) => _handleScaleUpdate(ctx.size, d),
    );
  }
}

class _ZoomableImagePainter extends CustomPainter {
  const _ZoomableImagePainter({this.image, this.offset, this.zoom});

  final ui.Image image;
  final Offset offset;
  final double zoom;

  @override
  void paint(Canvas canvas, Size size) {
    paintImage(canvas: canvas, rect: offset & (size * zoom), image: image);
  }

  @override
  bool shouldRepaint(_ZoomableImagePainter old) {
    return old.image != image || old.offset != offset || old.zoom != zoom;
  }
}
