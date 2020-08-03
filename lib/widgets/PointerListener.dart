import 'package:flutter/material.dart';
import 'package:xournalpp/layer_contents/XppStroke.dart';
import 'package:xournalpp/src/XppLayer.dart';

class PointerListener extends StatefulWidget {
  @required
  final Function(XppContent) onNewContent;
  @required
  final Widget child;

  const PointerListener({Key key, this.onNewContent, this.child})
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
        print('Moving');
        print(data);
        if (!isPen(data)) return;
        points.add(XppStrokePoint(
            x: data.position.dx,
            y: data.position.dy,
            width: data.pressure == 0 ? 5 : data.pressure * 10));
        print(points[points.length - 1].width);
        setState(() {});
      },
      onPointerDown: (data) {
        print('Down');
        print(data);
      },
      onPointerUp: (data) {
        print('Up');
        print(data);
        saveStroke();
        points.clear();
      },
      onPointerCancel: (data) {
        print('Cancel');
        print(data);
        points.clear();
      },
      onPointerSignal: (data) {
        print('Signal');
        print(data);
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

  void saveStroke() {
    /// TODO: different colors
    /// TODO: different tools
    if (points.isNotEmpty)
      widget.onNewContent(XppStroke(
          tool: XppStrokeTool.PEN, color: Colors.green, points: points));
  }

  bool isPen(PointerMoveEvent data) {
    return true;
  }
}
