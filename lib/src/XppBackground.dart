import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:xournalpp/src/XppPage.dart';

abstract class XppBackground {
  XppBackgroundType type;

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
  final Color color;
  final XppPageSize size;
  XppBackgroundType type = XppBackgroundType.SOLID;

  XppBackgroundSolid({this.color, this.size});
}

class XppBackgroundSolidLined extends XppBackgroundSolid {
  final Color color;
  final XppPageSize size;

  XppBackgroundSolidLined({this.color, this.size});
  @override
  Widget render() {
    return CustomPaint(
      painter: _LinePainter(color: color),
      size: size.toSize(),
    );
    /*int lineCount = (size.height / 24).round();
    return (Container(
      width: size.width,
      height: size.height,
      color: color,
      child: Column(
        children: List.generate(
            lineCount * 2,
            (index) =>
                (lineCount.toDouble() % 2 == 0) ? Container() : Divider()),
      ),
    ));*/
  }
}

class XppBackgroundSolidPlain extends XppBackgroundSolid {
  final Color color;
  final XppPageSize size;

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
