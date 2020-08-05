import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:xournalpp/layer_contents/XppStroke.dart';
import 'package:xournalpp/src/XppLayer.dart';

class PointerListener extends StatefulWidget {
  @required
  final Function(XppContent) onNewContent;
  @required
  final Widget child;
  @required
  final bool enabled;
  @required
  final Matrix4 translationMatrix;

  const PointerListener(
      {Key key,
      this.onNewContent,
      this.child,
      this.enabled = true,
      this.translationMatrix})
      : super(key: key);

  @override
  _PointerListenerState createState() => _PointerListenerState();
}

class _PointerListenerState extends State<PointerListener> {
  List<XppStrokePoint> points = [];

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: (data) {
        if (!widget.enabled) return;
        points.add(XppStrokePoint(
            x: data.position.dx - widget.translationMatrix.getTranslation().x,
            y: data.position.dy - widget.translationMatrix.getTranslation().y,
            width: (data.pressure == 0 ? 5 : data.pressure * 10) *
                widget.translationMatrix.getTranslation().z));
        setState(() {});
      },
      onPointerDown: (data) {
        print('Down');
      },
      onPointerUp: (data) {
        print('Up');
        saveStroke();
        points.clear();
      },
      onPointerCancel: (data) {
        print('Cancel');
        points.clear();
      },
      onPointerSignal: (data) {
        print('Signal');
      },
      child: Stack(
        children: [
          widget.child,
          if (points.length > 0)
            CustomPaint(
              /*size: Size(
      bottomRight.dx - getOffset().dx, bottomRight.dy - getOffset().dy),*/
              foregroundPainter: XppStrokePainter(
                  points: points, color: Colors.green, topLeft: Offset(0, 0)),
            ),
        ],
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
          color: Colors.green,
          points: List.from(points));
      widget.onNewContent(stroke);
    }
  }
}
