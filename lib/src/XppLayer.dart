import 'package:flutter/material.dart';

class XppLayer {
  XppLayer({this.content});

  List<XppContent> content;

  static XppLayer empty() => XppLayer(content: []);
}

abstract class XppContent {
  Offset getOffset();

  Widget render();
}
