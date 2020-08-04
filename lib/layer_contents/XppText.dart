import 'package:flutter/material.dart';
import 'package:xournalpp/src/XppLayer.dart';

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
