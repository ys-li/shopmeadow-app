// ignore: invalid_constant
import 'dart:io' show File, Platform;

import 'package:flutter/services.dart';
import 'package:flutter/src/material/colors.dart';
import 'package:flutter/src/material/icons.dart';
import 'package:flutter/src/material/circle_avatar.dart';
import 'package:flutter/widgets.dart';

export 'package:flutter/services.dart' show NetworkImage;

/// Creates an [ImageConfiguration] based on the given [BuildContext] (and
/// optionally size).
///
/// This is the object that must be passed to [BoxPainter.paint] and to
/// [ImageProvider.resolve].
ImageConfiguration createLocalImageConfiguration(BuildContext context,
    {Size size}) {
  return new ImageConfiguration(
      bundle: DefaultAssetBundle.of(context),
      devicePixelRatio: MediaQuery
          .of(context)
          .devicePixelRatio,
      size: size,

      platform: getTargetPlatformFromStr(Platform.operatingSystem));
}

TargetPlatform getTargetPlatformFromStr(String s){
  switch (s){
    case "android":
      return TargetPlatform.android;
    case "fuchsia":
      return TargetPlatform.fuchsia;
    case "iOS":
      return TargetPlatform.iOS;
    default:
      return TargetPlatform.android;
  }
}

class NectarImage extends StatefulWidget {
  /// Creates a widget that displays an [ImageStream] obtained from the network.
  ///
  /// The [src], [scale], and [repeat] arguments must not be null.
  NectarImage.loadingScreen(String src,
      {Key key,
        double scale: 1.0,
        this.duration: 300,
        this.backgroundColor: Colors.black,
        this.foregroundColor: Colors.white,
        this.waiting,
        this.width,
        this.height,
        this.color,
        this.fit,
        this.alignment = FractionalOffset.center,
        this.repeat: ImageRepeat.noRepeat,
        this.centerSlice,
        this.gaplessPlayback: false,
        this.circular: false})
      : image = new NetworkImage(src, scale: scale),
        super(key: key);

  final int duration;

  final Color backgroundColor;

  final Color foregroundColor;

  final Widget waiting;

  /// The image to display.
  final ImageProvider image;

  /// If non-null, require the image to have this width.
  ///
  /// If null, the image will pick a size that best preserves its intrinsic
  /// aspect ratio.
  final double width;

  /// If non-null, require the image to have this height.
  ///
  /// If null, the image will pick a size that best preserves its intrinsic
  /// aspect ratio.
  final double height;

  /// If non-null, apply this color filter to the image before painting.
  final Color color;

  /// How to inscribe the image into the space allocated during layout.
  ///
  /// The default varies based on the other fields. See the discussion at
  /// [paintImage].
  final BoxFit fit;

  /// How to align the image within its bounds.
  ///
  /// An alignment of (0.0, 0.0) aligns the image to the top-left corner of its
  /// layout bounds.  An alignment of (1.0, 0.5) aligns the image to the middle
  /// of the right edge of its layout bounds.
  final FractionalOffset alignment;

  /// How to paint any portions of the layout bounds not covered by the image.
  final ImageRepeat repeat;

  /// The center slice for a nine-patch image.
  ///
  /// The region of the image inside the center slice will be stretched both
  /// horizontally and vertically to fit the image into its destination. The
  /// region of the image above and below the center slice will be stretched
  /// only horizontally and the region of the image to the left and right of
  /// the center slice will be stretched only vertically.
  final Rect centerSlice;

  /// Whether to continue showing the old image (true), or briefly show nothing
  /// (false), when the image provider changes.
  final bool gaplessPlayback;

  final bool circular;

  @override
  _NectarState createState() => new _NectarState();

  /*@override
  void debugFillDescription(List<String> description) {
    //super.debugFillDescription(description);
    description.add('image: $image');
    if (width != null) description.add('width: $width');
    if (height != null) description.add('height: $height');
    if (color != null) description.add('color: $color');
    if (fit != null) description.add('fit: $fit');
    if (alignment != null) description.add('alignment: $alignment');
    if (repeat != ImageRepeat.noRepeat) description.add('repeat: $repeat');
    if (centerSlice != null) description.add('centerSlice: $centerSlice');
  }*/
}

class _NectarState extends State<NectarImage>
    with SingleTickerProviderStateMixin {

  ImageStream _imageStream;
  ImageInfo _imageInfo;

  int _mix = 0;
  AnimationController _controller;

  _NectarState();

  @override
  void initState() {
    super.initState();

    _controller = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: widget.duration));

    final CurvedAnimation animation = new CurvedAnimation(
        parent: _controller, curve: Curves.ease);

    animation.addListener(() {
      setState(() {
        _mix = 255 - (255 * _controller.value).floor();
      });
    });
  }

  @override
  void didChangeDependencies() {
    _resolveImage();
    super.didChangeDependencies();
  }

  @override
  void didUpdateConfig(NectarImage oldConfig) {
    if (widget.image != oldConfig.image) _resolveImage();
  }

  @override
  void reassemble() {
    _resolveImage(); // in case the image cache was flushed
    super.reassemble();
  }

  void _resolveImage() {
    final ImageStream oldImageStream = _imageStream;
    _imageStream = widget.image.resolve(createLocalImageConfiguration(context,
        size: widget.width != null && widget.height != null ? new Size(
            widget.width, widget.height) : null));
    assert(_imageStream != null);
    if (_imageStream.key != oldImageStream?.key) {
      oldImageStream?.removeListener(_handleImageChanged);
      if (!widget.gaplessPlayback)
        setState(() {
          _imageInfo = null;
        });
      _imageStream.addListener(_handleImageChanged);
    }
  }

  void _handleImageChanged(ImageInfo imageInfo, bool synchronousCall) {
    setState(() {
      _imageInfo = imageInfo;
      _controller.forward();
    });
  }

  @override
  void dispose() {
    assert(_imageStream != null);
    _controller.dispose();
    _imageStream.removeListener(_handleImageChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_imageInfo != null) {
      if (widget.circular) {
        return new ClipOval(
            child: new RawImage(
                image: _imageInfo?.image,
                width: widget.width,
                height: widget.height,
                scale: _imageInfo?.scale ?? 1.0,
                color: new Color.fromARGB(255, _mix, _mix, _mix),
                fit: widget.fit,
                alignment: widget.alignment,
                repeat: widget.repeat,
                colorBlendMode: BlendMode.screen,
                centerSlice: widget.centerSlice
            )
        );
      }else {
        return new RawImage(
            image: _imageInfo?.image,
            width: widget.width,
            height: widget.height,
            scale: _imageInfo?.scale ?? 1.0,
            color: new Color.fromARGB(255, _mix, _mix, _mix),
            fit: widget.fit,
            alignment: widget.alignment,
            repeat: widget.repeat,
            colorBlendMode: BlendMode.screen,
            centerSlice: widget.centerSlice
        );
      }
    }
    else {
      return new Container(
        child: widget.waiting ?? new Icon(
            Icons.more_horiz,
            size: 12.0,
            color: widget.foregroundColor
        ),
        decoration: new BoxDecoration(
          //border: new Border.all(width: 0.0, color: Colors.grey),
          borderRadius: widget.circular ? new BorderRadius.circular(30.0) : null,
          color: widget.backgroundColor,
        ),
      );
    }
  }

  /*@override
  void debugFillDescription(List<String> description) {
    super.debugFillDescription(description);
    description.add('stream: $_imageStream');
    description.add('pixels: $_imageInfo');
  }*/
}