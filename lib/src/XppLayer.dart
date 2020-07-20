class XppStroke {
  XppStroke({this.tool = XppStrokeTool.Pen, this.points});

  XppStrokeTool tool;
  List<XppStrikePoint> points;
}

enum XppStrokeTool { Pen }

class XppStrikePoint {
  final double x;
  final double y;
  final double width;

  XppStrikePoint(this.x, this.y, this.width);
}
