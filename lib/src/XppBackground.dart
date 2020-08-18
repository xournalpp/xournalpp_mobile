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

class XppBackgroundSolidRuled extends XppBackgroundSolid {
  Color color;
  XppPageSize size;

  XppBackgroundSolidRuled({this.color = Colors.white, this.size});
  @override
  Widget render() {
    return Container(
      color: color,
      child: CustomPaint(
        painter: _RuledPainter(color: color),
        size: size.toSize(),
      ),
    );
  }
}

class XppBackgroundSolidGraph extends XppBackgroundSolid {
  Color color;
  XppPageSize size;

  XppBackgroundSolidGraph({this.color = Colors.white, this.size});
  @override
  Widget render() {
    return Container(
      color: color,
      child: CustomPaint(
        painter: _GraphPainter(color: color),
        size: size.toSize(),
      ),
    );
  }
}

class XppBackgroundSolidDot extends XppBackgroundSolid {
  Color color;
  XppPageSize size;

  XppBackgroundSolidDot({this.color = Colors.white, this.size});
  @override
  Widget render() {
    return Container(
      color: color,
      child: CustomPaint(
        painter: _DotPainter(color: color),
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
      ..color = Colors.grey[500].withOpacity(.3)
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

class _RuledPainter extends CustomPainter {
  final Color color;

  _RuledPainter({this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[500].withOpacity(.3)
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

class _GraphPainter extends CustomPainter {
  final Color color;

  _GraphPainter({this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[500].withOpacity(.3)
      ..strokeWidth = 1;
    // 1 because no line at the top
    for (int i = 1; i < size.height / XppPageSize.pt2mm(5); i++) {
      canvas.drawLine(Offset(0, i * XppPageSize.pt2mm(5).toDouble()),
          Offset(size.width, i * XppPageSize.pt2mm(5).toDouble()), paint);
    }
    // 1 because no line at the beginning
    for (int i = 1; i < size.width / XppPageSize.pt2mm(5); i++) {
      canvas.drawLine(Offset(i * XppPageSize.pt2mm(5).toDouble(), 0),
          Offset(i * XppPageSize.pt2mm(5).toDouble(), size.height), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _DotPainter extends CustomPainter {
  final Color color;

  _DotPainter({this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[500].withOpacity(.3)
      ..strokeWidth = 1;
    // 1 because no line at the top
    for (int i = 1; i < size.height / XppPageSize.pt2mm(5); i++) {
      // 1 because no line at the beginning
      for (int j = 1; j < size.width / XppPageSize.pt2mm(5); j++) {
        canvas.drawCircle(
            Offset(j * XppPageSize.pt2mm(5).toDouble(),
                i * XppPageSize.pt2mm(5).toDouble()),
            XppPageSize.pt2mm(.5).toDouble(),
            paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

enum XppBackgroundImageDomain { ABSOLUTE, RELATIVE }

enum XppBackgroundType { NONE, SOLID, PIXMAP }
