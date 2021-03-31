import 'package:flutter/material.dart';
import 'package:xml/xml.dart';

import 'XppPageContentWidget.dart';

class XppLayer {
  XppLayer({this.content});

  List<XppContent> content;

  static XppLayer empty() => XppLayer(content: []);

  XmlElement toXmlElement() => XmlElement(
      XmlName('layer'), const [], content.map((e) => e.toXmlElement()));
}

abstract class XppContent {
  Offset getOffset();

  XppPageContentWidget render();

  XmlElement toXmlElement();

  /// return [true] in case it should be fully deleted
  XppContentEraseData eraseWhere({Offset coordinates, double radius}) =>
      XppContentEraseData();
}

class XppContentEraseData {
  final bool affected;
  final bool delete;
  final List<XppContent> newContent;

  XppContentEraseData(
      {this.affected = false, this.delete = false, this.newContent = const []});
}
