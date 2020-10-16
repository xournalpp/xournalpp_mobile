import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:xournalpp/src/HexColor.dart';
import 'package:xournalpp/src/XppLayer.dart';

class XppStroke extends XppContent {
  XppStroke({this.tool = XppStrokeTool.PEN, this.points, this.color});

  XppStrokeTool tool;
  List<XppStrokePoint> points;
  Color color;

  @override
  Offset getOffset() {
    if (points.isEmpty) return Offset(0, 0);
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
    if (points.isEmpty) return Offset(0, 0);
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
    if (points.isEmpty) {
      return (Container());
    }
    Color colorToUse = color;
    if (tool == XppStrokeTool.ERASER) color = Colors.white;
    if (tool == XppStrokeTool.HIGHLIGHTER) {
      color = color.withOpacity(.5);
    }
    return new CustomPaint(
      size: Size(
          bottomRight.dx - getOffset().dx, bottomRight.dy - getOffset().dy),
      foregroundPainter: XppStrokePainter(
          points: points, color: colorToUse, topLeft: getOffset()),
    );
  }

  @override
  XmlElement toXmlElement() {
    String toolString;
    switch (tool) {
      case XppStrokeTool.PEN:
        toolString = 'pen';
        break;
      case XppStrokeTool.HIGHLIGHTER:
        toolString = 'highlighter';
        break;
      case XppStrokeTool.ERASER:
        toolString = 'eraser';
        break;
    }
    XmlElement node = XmlElement(XmlName('stroke'), [
      XmlAttribute(XmlName('tool'), toolString),
      XmlAttribute(XmlName('color'), color.toHexTriplet()),
      XmlAttribute(
          XmlName('width'), points.map((e) => e.width.toString()).join(' ')),
    ], [
      XmlText(
          points.map((e) => e.x.toString() + ' ' + e.y.toString()).join(' '))
    ]);
    return node;
  }

  bool shouldErase({Offset coordinates, double radius}) {
    bool erase = false;
    points.forEach((element) {
      if (_shouldRemovePoint(element, coordinates, radius)) erase = true;
    });
    return (erase);
  }

  List<XppStroke> eraseWhere({Offset coordinates, double radius}) {
    List<XppStroke> newStrokes = [];
    bool lastPointRemoved = true;
    for (int i = 0; i < points.length; i++) {
      if (_shouldRemovePoint(points[i], coordinates, radius)) {
        lastPointRemoved = true;
      } else {
        if (lastPointRemoved) {
          newStrokes
              .add(XppStroke(tool: tool, color: color, points: [points[i]]));
        } else {
          newStrokes.last.points.add(points[i]);
        }
        lastPointRemoved = false;
      }
    }
    return newStrokes;
  }

  bool _shouldRemovePoint(
      XppStrokePoint element, Offset coordinates, double radius) {
    return ((element.x - coordinates.dx).abs() < (element.width + radius) / 2 &&
        (element.y - coordinates.dy).abs() < (element.width + radius) / 2);
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
    if (points.isEmpty) return;
    if (points.length == 1) {
      var paint = Paint()
        ..color = color
        ..strokeWidth = points[0]?.width ?? 5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      var path = Path();
      Offset offset = points[0].offset;
      path.moveTo(offset.dx - topLeft.dx, offset.dy - topLeft.dy);
      path.lineTo(offset.dx - topLeft.dx, offset.dy - topLeft.dy);
      canvas.drawPath(path, paint);
    }
    for (int i = 1; i < points.length; i++) {
      var paint = Paint()
        ..color = color
        ..strokeWidth = points[i]?.width ?? 5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      var path = Path();
      path.moveTo(points[i - 1].offset.dx - topLeft.dx,
          points[i - 1].offset.dy - topLeft.dy);
      Offset offset = points[i].offset;
      path.lineTo(offset.dx - topLeft.dx, offset.dy - topLeft.dy);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
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
