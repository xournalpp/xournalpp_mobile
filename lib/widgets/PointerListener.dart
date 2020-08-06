import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:xournalpp/layer_contents/XppStroke.dart';
import 'package:xournalpp/src/XppLayer.dart';
import 'package:xournalpp/widgets/ToolBoxBottomSheet.dart';

class PointerListener extends StatefulWidget {
  @required
  final Function(XppContent) onNewContent;
  @required
  final Function({int device, PointerDeviceKind kind}) onDeviceChange;
  @required
  final Widget child;
  @required
  final Map<PointerDeviceKind, EditingTool> toolData;
  @required
  final Matrix4 translationMatrix;
  @required
  final double strokeWidth;
  @required
  final Color color;

  const PointerListener(
      {Key key,
      this.onNewContent,
      this.child,
      this.toolData = const {},
      this.translationMatrix,
      this.onDeviceChange,
      this.strokeWidth,
      this.color})
      : super(key: key);

  @override
  PointerListenerState createState() => PointerListenerState();
}

class PointerListenerState extends State<PointerListener> {
  List<XppStrokePoint> points = [];

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        widget.onDeviceChange(device: event.device, kind: event.kind);
      },
      opaque: false,
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerMove: (data) {
          widget.onDeviceChange(device: data.device, kind: data.kind);
          if (!isPen(data)) return;
          setState(() {
            points.add(XppStrokePoint(
                x: data.localPosition.dx,
                y: data.localPosition.dy,
                width: (data.pressure == 0
                    ? widget.strokeWidth
                    : data.pressure * widget.strokeWidth)));
          });
        },
        onPointerDown: (data) {
          widget.onDeviceChange(device: data.device, kind: data.kind);
        },
        onPointerUp: (data) {
          saveStroke();
          points.clear();
        },
        onPointerCancel: (data) {
          points.clear();
        },
        onPointerSignal: (data) {
          widget.onDeviceChange(device: data.device, kind: data.kind);
        },
        child: Stack(
          children: [
            widget.child,
            if (points.length > 0)
              CustomPaint(
                /*size: Size(
        bottomRight.dx - getOffset().dx, bottomRight.dy - getOffset().dy),*/
                foregroundPainter: XppStrokePainter(
                    points: points, color: widget.color, topLeft: Offset(0, 0)),
              ),
          ],
        ),
      ),
    );
  }

  // clearPoints method used to reset the canvas
  // method can be called using
  //   key.currentState.clearPoints();

  void clearPoints() {
    setState(() {
      points.clear();
    });
  }

  void saveStroke() {
    /// TODO: different colors
    /// TODO: different tools
    if (points.isNotEmpty) {
      XppStroke stroke = XppStroke(
          tool: XppStrokeTool.PEN,
          color: widget.color,
          points: List.from(points));
      widget.onNewContent(stroke);
    }
  }

  bool isPen(PointerMoveEvent data) {
    return (widget.toolData.keys.contains(data.kind) &&
            widget.toolData[data.kind] == EditingTool.STYLUS) ||
        (!widget.toolData.keys.contains(data.kind) &&
            data.kind == PointerDeviceKind.stylus) ||
        (widget.toolData.keys.contains(data.kind) &&
            widget.toolData[data.kind] == EditingTool.HIGHLIGHT);
  }
}
