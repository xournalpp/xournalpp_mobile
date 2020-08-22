import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:xournalpp/src/HexColor.dart';
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

  @override
  XmlElement toXmlElement() => XmlElement(XmlName('text'), [
        XmlAttribute(XmlName('font'), fontFamily),
        XmlAttribute(XmlName('size'), size.toString()),
        XmlAttribute(XmlName('x'), offset.dx.toString()),
        XmlAttribute(XmlName('y'), offset.dy.toString()),
        XmlAttribute(XmlName('color'), color.toHexTriplet()),
      ], [
        XmlText(encodeText(text))
      ]);

  static String encodeText(String text) {
    text.replaceAll(r'&', r'&amp;');
    text.replaceAll(r'<', r'&lt;');
    text.replaceAll(r'>', r'&gt;');
    return text;
  }
}
