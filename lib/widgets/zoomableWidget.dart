import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

class ZoomableWidget extends StatefulWidget {
  final Widget child;

  const ZoomableWidget({Key key, this.child}) : super(key: key);
  @override
  _ZoomableWidgetState createState() => _ZoomableWidgetState();
}

class _ZoomableWidgetState extends State<ZoomableWidget> {
  Matrix4 matrix = Matrix4.identity();

  @override
  Widget build(BuildContext context) {
    return MatrixGestureDetector(
      shouldRotate: false,
      onMatrixUpdate: (Matrix4 m, Matrix4 tm, Matrix4 sm, Matrix4 rm) {
        setState(() {
          matrix = m;
        });
      },
      child: Transform(
        transform: matrix,
        child: widget.child,
      ),
    );
  }
}
