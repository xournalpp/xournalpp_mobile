import 'package:flutter/material.dart';

class ZoomableWidget extends StatefulWidget {
  @required
  final Widget child;
  @required
  final TransformationController controller;
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
    return InteractiveViewer(
      transformationController: widget.controller,
      minScale: 0.1,
      maxScale: 5,
      child: widget.child,
    );
  }
}
