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
  XppStroke({this.tool = XppStrokeTool.PEN, this.points, this.color});

  XppStrokeTool tool;
  List<XppStrokePoint> points;
  Color color;

  @override
  Offset getOffset() {
    double x = points[0].x;
    // finding smallest x point
    points.forEach((point) {
      if (point.x < x) x = point.x;
    });
    double y = points[0].y;
    // finding smallest y point
    points.forEach((point) {
      if (point.y < y) x = point.y;
    });
    return (Offset(x, y));
  }

  Offset get bottomRight {
    double x = points[0].x;
    // finding largest x point
    points.forEach((point) {
      if (point.x > x) x = point.x;
    });
    double y = points[0].y;
    // finding largest y point
    points.forEach((point) {
      if (point.y > y) x = point.y;
    });
    return (Offset(x, y));
  }

  @override
  Widget render() {
    Color colorToUse = color;
    if (tool == XppStrokeTool.ERASER) color = Colors.white;
    if (tool == XppStrokeTool.HIGHLIGHTER) {
      color = color.withOpacity(.5);
      print('Highlighter');
    }
    return new CustomPaint(
      size: Size(
          bottomRight.dx - getOffset().dx, bottomRight.dy - getOffset().dy),
      foregroundPainter: XppStrokePainter(
          points: points, color: colorToUse, topLeft: getOffset()),
    );
  }
}

class XppStrokePainter extends CustomPainter {
  @required
  final List<XppStrokePoint> points;
  @required
  final Color color;
  @required
  final Offset topLeft;

  XppStrokePainter({this.points, this.color, this.topLeft});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = points[0].width
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (points.isEmpty) return;
    var path = Path();
    path.moveTo(
        points[0].offset.dx - topLeft.dx, points[0].offset.dy - topLeft.dy);
    points.forEach((point) {
      Offset offset = point.offset;
      path.lineTo(offset.dx - topLeft.dx, offset.dy - topLeft.dy);
    });
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return null;
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

  XppStrokePoint({this.x, this.y, this.width});

  Offset get offset => Offset(x, y);
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
    return new Stack(
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
        style: TextStyle(color: color), child: new SelectableText(text));
  }
}
