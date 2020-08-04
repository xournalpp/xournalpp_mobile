import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:xournalpp/src/XppLayer.dart';

class XppPage {
  XppPage({this.pageSize, this.background, this.layers});

  XppPageSize pageSize;
  XppBackground background;
  @required
  List<XppLayer> layers;
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
}

abstract class XppBackground {
  XppBackgroundType type;

  static XppBackground get none =>
      _NoXppBackground()..type = XppBackgroundType.NONE;
}

/// page background for a [XppPage] made from an image URI. I am sure it will be hard to implement for web.
/// TODO: implement background for web
class XppBackgroundImage extends XppBackground {
  final String filename;
  final XppBackgroundImageDomain domain;

  XppBackgroundImage(
      {this.filename, this.domain = XppBackgroundImageDomain.ABSOLUTE});
}

/// page background for a [XppPage] made from a color and a style
class XppBackgroundSolid extends XppBackground {
  final Color color;
  final XppBackgroundStyle style;

  XppBackgroundSolid({this.color, this.style});
}

class XppBackgroundStyle {}

class _NoXppBackground extends XppBackground {}

enum XppBackgroundImageDomain { ABSOLUTE }

enum XppBackgroundType { NONE, SOLID, PIXMAP }
