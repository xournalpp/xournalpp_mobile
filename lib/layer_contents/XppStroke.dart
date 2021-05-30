import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:xournalpp/src/HexColor.dart';
import 'package:xournalpp/src/XppLayer.dart';
import 'package:xournalpp/src/XppPageContentWidget.dart';
import 'package:xournalpp/widgets/ToolBoxBottomSheet.dart';

abstract class XppStroke extends XppContent {
  XppStroke(
      {this.tool = XppStrokeTool.PEN,
      this.points,
      this.color,
      this.editingTool});

  XppStrokeTool tool;
  List<XppStrokePoint>? points;
  Color? color;
  EditingTool? editingTool;

  @override
  Offset getOffset() {
    if (points!.isEmpty) return Offset(0, 0);
    double? x = points![0].x;
    // finding smallest x point
    points!.forEach((point) {
      if (point.x! < x!) x = point.x;
    });
    double y = points![0].y!;
    // finding smallest y point
    points!.forEach((point) {
      if (point.y! < y) x = point.y;
    });
    return (Offset(x!, y));
  }

  Offset get bottomRight {
    if (points!.isEmpty) return Offset(0, 0);
    double? x = points![0].x;
    // finding largest x point
    points!.forEach((point) {
      if (point.x! > x!) x = point.x;
    });
    double y = points![0].y!;
    // finding largest y point
    points!.forEach((point) {
      if (point.y! > y) x = point.y;
    });
    return (Offset(x!, y));
  }

  @override
  XppPageContentWidget render() {
    if (points!.isEmpty) {
      return XppPageContentWidget(child: (Container()));
    }
    Color? colorToUse = color;
    if (tool == XppStrokeTool.ERASER) color = Colors.white;
    if (tool == XppStrokeTool.HIGHLIGHTER) {
      color = color!.withOpacity(.5);
    }
    return XppPageContentWidget(
      child: CustomPaint(
        size: Size(
            bottomRight.dx - getOffset().dx, bottomRight.dy - getOffset().dy),
        foregroundPainter: XppStrokePainter(
            points: points,
            color: colorToUse,
            topLeft: getOffset(),
            smoothPressure: tool == XppStrokeTool.PEN),
      ),
      tool: EditingTool.STYLUS,
    );
  }

  @override
  XmlElement toXmlElement() {
    late String toolString;
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
      XmlAttribute(XmlName('color'), color!.toHexTriplet()),
      XmlAttribute(
          XmlName('width'), points!.map((e) => e.width.toString()).join(' ')),
    ], [
      XmlText(
          points!.map((e) => e.x.toString() + ' ' + e.y.toString()).join(' '))
    ]);
    return node;
  }

  bool _shouldErase({Offset? coordinates, double? radius}) {
    bool erase = false;
    points!.forEach((element) {
      if (_shouldRemovePoint(element, coordinates!, radius!)) erase = true;
    });
    return (erase);
  }

  @override
  XppContentEraseData eraseWhere({Offset? coordinates, double? radius}) {
    if (!_shouldErase(coordinates: coordinates, radius: radius))
      return XppContentEraseData();
    List<XppStroke> newStrokes = [];
    bool lastPointRemoved = true;
    for (int i = 0; i < points!.length; i++) {
      if (_shouldRemovePoint(points![i], coordinates!, radius!)) {
        lastPointRemoved = true;
      } else {
        if (lastPointRemoved) {
          newStrokes.add(newStroke(color: color, points: [points![i]]));
        } else {
          newStrokes.last.points!.add(points![i]);
        }
        lastPointRemoved = false;
      }
    }
    return XppContentEraseData(
        affected: true, delete: newStrokes.isEmpty, newContent: newStrokes);
  }

  @override
  bool inRegion({Offset? topLeft, Offset? bottomRight}) {
    // TODO: implement shouldSelectAt
    throw UnimplementedError();
  }

  @override
  bool shouldSelectAt({Offset? coordinates, EditingTool? tool}) {
    // TODO: implement shouldSelectAt
    throw UnimplementedError();
  }

  XppStroke newStroke({Color? color, List<XppStrokePoint>? points});

  bool _shouldRemovePoint(
      XppStrokePoint element, Offset coordinates, double radius) {
    return ((element.x! - coordinates.dx).abs() <
            (element.width! + radius) / 2 &&
        (element.y! - coordinates.dy).abs() < (element.width! + radius) / 2);
  }

  static XppStroke byTool(
      {required XppStrokeTool tool,
      List<XppStrokePoint>? points,
      Color? color}) {
    XppStroke? stroke;
    switch (tool) {
      case XppStrokeTool.PEN:
        stroke = XppStrokePen(color: color, points: points);
        break;
      case XppStrokeTool.HIGHLIGHTER:
        stroke = XppStrokeHighlight(color: color, points: points);
        break;
      case XppStrokeTool.ERASER:
        stroke = XppStrokeWhiteout(color: color, points: points);
        break;
    }
    return stroke;
  }
}

class XppStrokePen extends XppStroke {
  XppStrokeTool tool = XppStrokeTool.PEN;
  List<XppStrokePoint>? points;
  Color? color;

  EditingTool? editingTool;
  XppStrokePen({this.points, this.color})
      : super(
            points: points,
            color: color,
            tool: XppStrokeTool.PEN,
            editingTool: EditingTool.STYLUS);

  @override
  XppStroke newStroke({Color? color, List<XppStrokePoint>? points}) {
    return XppStrokePen(points: points, color: color);
  }
}

class XppStrokeWhiteout extends XppStroke {
  XppStrokeTool tool = XppStrokeTool.ERASER;
  List<XppStrokePoint>? points;
  Color? color;

  EditingTool? editingTool;
  XppStrokeWhiteout({this.points, this.color})
      : super(
            points: points,
            color: color,
            tool: XppStrokeTool.ERASER,
            editingTool: EditingTool.WHITEOUT);

  @override
  XppStroke newStroke({Color? color, List<XppStrokePoint>? points}) {
    return XppStrokeWhiteout(points: points, color: color);
  }
}

class XppStrokeHighlight extends XppStroke {
  XppStrokeTool tool = XppStrokeTool.HIGHLIGHTER;
  List<XppStrokePoint>? points;
  Color? color;

  EditingTool? editingTool;
  XppStrokeHighlight({this.points, this.color})
      : super(
            points: points,
            color: color,
            tool: XppStrokeTool.HIGHLIGHTER,
            editingTool: EditingTool.HIGHLIGHT);

  @override
  XppStroke newStroke({Color? color, List<XppStrokePoint>? points}) {
    return XppStrokeHighlight(points: points, color: color);
  }
}

class XppStrokePainter extends CustomPainter {
  @required
  final List<XppStrokePoint>? points;
  @required
  final Color? color;
  @required
  final Offset? topLeft;
  @required
  final bool? smoothPressure;

  XppStrokePainter({
    this.points,
    this.color,
    this.topLeft,
    this.smoothPressure,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points!.isEmpty) return;
    if (points!.length == 1) {
      var paint = Paint()
        ..color = color!
        ..strokeWidth = points![0].width ?? 5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      var path = Path();
      Offset offset = points![0].offset;
      path.moveTo(offset.dx - topLeft!.dx, offset.dy - topLeft!.dy);
      path.lineTo(offset.dx - topLeft!.dx, offset.dy - topLeft!.dy);
      canvas.drawPath(path, paint);
    }
    if (smoothPressure!) {
      for (int i = 1; i < points!.length; i++) {
        var paint = Paint()
          ..color = color!
          ..strokeWidth = points![i].width ?? 5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

        var path = Path();
        path.moveTo(points![i - 1].offset.dx - topLeft!.dx,
            points![i - 1].offset.dy - topLeft!.dy);
        Offset offset = points![i].offset;
        path.lineTo(offset.dx - topLeft!.dx, offset.dy - topLeft!.dy);
        canvas.drawPath(path, paint);
      }
    } else {
      double width = 0;

      var path = Path();
      path.moveTo(points![0].offset.dx - topLeft!.dx,
          points![0].offset.dy - topLeft!.dy);
      for (int i = 1; i < points!.length; i++) {
        Offset offset = points![i].offset;
        path.lineTo(offset.dx - topLeft!.dx, offset.dy - topLeft!.dy);
        width += points![i].width!;
      }
      width /= points!.length;
      var paint = Paint()
        ..color = color!
        ..strokeWidth = width
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; //!((oldDelegate is XppStrokePainter) && oldDelegate.points == points);
  }
}

enum XppStrokeTool {
  PEN,
  HIGHLIGHTER,
  ERASER,
}

class XppStrokePoint {
  final double? x;
  final double? y;
  final double? width;

  XppStrokePoint({this.x, this.y, this.width});

  Offset get offset => Offset(x!, y!);
}
