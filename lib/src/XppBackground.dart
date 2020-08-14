import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:xournalpp/src/XppPage.dart';

abstract class XppBackground {
  XppBackgroundType type;
  XppPageSize size;

  static XppBackground get none => _NoXppBackground();

  Widget render();
}

/// page background for a [XppPage] made from an image URI. I am sure it will be hard to implement for web.
/// TODO: implement background for web
class XppBackgroundImage extends XppBackground {
  final String filename;
  final XppBackgroundImageDomain domain;
  final XppBackgroundType type;

  XppBackgroundImage(
      {this.type,
      this.filename,
      this.domain = XppBackgroundImageDomain.ABSOLUTE});

  @override
  Widget render() {
    return (Container());
  }
}

/// page background for a [XppPage] made from a color and a style
abstract class XppBackgroundSolid extends XppBackground {
  Color color;
  XppPageSize size;
  XppBackgroundType type = XppBackgroundType.SOLID;
}

class XppBackgroundSolidLined extends XppBackgroundSolid {
  Color color;
  XppPageSize size;

  XppBackgroundSolidLined({this.color = Colors.white, this.size});
  @override
  Widget render() {
    return Container(
      color: color,
      child: CustomPaint(
        painter: _LinePainter(color: color),
        size: size.toSize(),
      ),
    );
  }
}

class XppBackgroundSolidPlain extends XppBackgroundSolid {
  Color color;
  XppPageSize size;

  XppBackgroundSolidPlain({this.color, this.size});
  @override
  Widget render() {
    return (Container(
      width: size.width,
      height: size.height,
      color: color,
    ));
  }
}

class _NoXppBackground extends XppBackground {
  XppPageSize size = XppPageSize(width: 0, height: 0);
  XppBackgroundType type = XppBackgroundType.NONE;

  @override
  Widget render() => Container();
}

class _LinePainter extends CustomPainter {
  final Color color;

  _LinePainter({this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[500]
      ..strokeWidth = 1;
    // 1 because no line at the top
    for (int i = 1; i < size.height / 24; i++) {
      canvas.drawLine(Offset(0, i * 24.toDouble()),
          Offset(size.width, i * 24.toDouble()), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

enum XppBackgroundImageDomain { ABSOLUTE, RELATIVE }

enum XppBackgroundType { NONE, SOLID, PIXMAP }
