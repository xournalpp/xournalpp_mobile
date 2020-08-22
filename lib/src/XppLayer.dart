import 'package:flutter/material.dart';
import 'package:xml/xml.dart';

class XppLayer {
  XppLayer({this.content});

  List<XppContent> content;

  static XppLayer empty() => XppLayer(content: []);

  XmlElement toXmlElement() => XmlElement(
      XmlName('layer'), const [], content.map((e) => e.toXmlElement()));
}

abstract class XppContent {
  Offset getOffset();

  Widget render();

  XmlElement toXmlElement();
}
