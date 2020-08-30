import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:xml/xml.dart';
import 'package:xournalpp/src/XppBackground.dart';
import 'package:xournalpp/src/XppLayer.dart';

class XppPage {
  XppPage({this.pageSize, this.background, this.layers});

  /// create an empty page
  static XppPage empty() => XppPage(
      pageSize: XppPageSize.a4,
      background: XppBackgroundSolidLined(size: XppPageSize.a4),
      layers: [XppLayer.empty()]);

  XppPageSize pageSize;
  XppBackground background;
  @required
  List<XppLayer> layers;

  XmlElement toXmlElement() => XmlElement(
      XmlName('page'),
      [
        XmlAttribute(XmlName('width'), pageSize.width.toString()),
        XmlAttribute(XmlName('height'), pageSize.height.toString())
      ],
      [background.toXmlElement()]..addAll(layers.map((e) => e.toXmlElement())));
}

class XppPageSize {
  /// The page width in pt
  final double width;

  /// The page height in pt
  final double height;

  XppPageSize({this.width, this.height});

  /// create a [XppPageSize] from pt (Points)
  static XppPageSize fromMillimeter({double width, double height}) {
    return XppPageSize(width: pt2mm(width), height: pt2mm(height));
  }

  /// helper function to convert mm to pt where 1 pt equals 1/72 inch
  static double pt2mm(double pt) => pt / 0.35277777777777775;

  static XppPageSize get a4 =>
      XppPageSize.fromMillimeter(width: 210, height: 297);

  /// Ratio of width / height
  double get ratio => width / height;

  Size toSize() => Size(width, height);
}
