import 'dart:async';
import 'dart:typed_data';

import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class XppLayer {
  XppLayer({this.content});
  List<XppContent> content;
}

abstract class XppContent {
  Offset getOffset();
  Widget render();
}

enum XppContentTypes { STROKE, TEXT, IMAGE }

class XppStroke extends XppContent {
  XppStroke({this.tool = XppStrokeTool.PEN, this.points});

  XppStrokeTool tool;
  List<XppStrokePoint> points;

  @override
  Offset getOffset() {
    // TODO: implement getOffset
    throw UnimplementedError();
  }

  @override
  Widget render() {
    // TODO: implement render
    throw UnimplementedError();
  }
}

enum XppStrokeTool {
  PEN,
  HIGHLIGHTER,
  ERASER,
}

class XppStrokePoint {
  final double x;
  final double y;
  final double width;

  XppStrokePoint(this.x, this.y, this.width);
}

class XppImage extends XppContent {
  Offset topLeft;
  Offset bottomRight;

  @required
  final Uint8List data;

  XppImage({this.data, this.topLeft, this.bottomRight});

  static Future<XppImage> open({Offset topLeft}) async {
    FilePickerCross image =
        await FilePickerCross.pick(type: FileTypeCross.image);

    /// rendering the [Uint8List] into an image to determinate the height and width
    MemoryImage memoryImage = MemoryImage(image.toUint8List());
    Completer completer = new Completer();
    memoryImage.resolve(ImageConfiguration()).addListener(ImageStreamListener(
        (ImageInfo info, bool _) => completer.complete(info.image)));
    Image renderedImage = await completer.future;
    Offset bottomRight = Offset(
        topLeft.dx + renderedImage.width, topLeft.dy + renderedImage.height);
    return XppImage(
        data: image.toUint8List(), topLeft: topLeft, bottomRight: bottomRight);
  }

  @override
  Widget render() {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(),
        FadeInImage(
          image: MemoryImage(data),
          placeholder: MemoryImage(kTransparentImage),
          width: bottomRight.dx - topLeft.dx,
          height: bottomRight.dy - topLeft.dy,
        )
      ],
    );
  }

  @override
  Offset getOffset() => topLeft;
}

class XppText extends XppContent {
  @required
  final Color color;
  @required
  final double size;
  @required
  final String text;
  @required
  final Offset offset;
  @required
  final String fontFamily;

  XppText({this.size, this.offset, this.fontFamily, this.color, this.text});

  @override
  Offset getOffset() => offset;

  @override
  Widget render() {
    return DefaultTextStyle.merge(
        style: TextStyle(color: color), child: (SelectableText(text)));
  }
}
