import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

class ZoomableWidget extends StatefulWidget {
  @required
  final Widget child;
  @required
  final ZoomController controller;
  final bool enabled;

  const ZoomableWidget(
      {Key key, this.child, this.controller, this.enabled = true})
      : super(key: key);
  @override
  _ZoomableWidgetState createState() => _ZoomableWidgetState();
}

class _ZoomableWidgetState extends State<ZoomableWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        print('DOUBLE TAP');
        widget.controller.matrix = Matrix4.identity();
      },
      child: MatrixGestureDetector(
        //shouldRotate: false,
        onMatrixUpdate: (Matrix4 m, Matrix4 tm, Matrix4 sm, Matrix4 rm) {
          if (!widget.enabled) return;
          print(m);
          setState(() {
            widget.controller.matrix = m;
          });
        },
        child: Transform(
          transform: widget.controller.matrix,
          child: widget.child,
        ),
      ),
    );
  }
}

class ZoomController {
  Matrix4 matrix = Matrix4.identity();
  double get zoom => matrix.getTranslation().z;
  set zoom(double newZoom) {
    matrix.scale(newZoom);
  }
}
