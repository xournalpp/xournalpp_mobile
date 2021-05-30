import 'package:flutter/material.dart';
import 'package:katex_flutter/katex_flutter.dart';
import 'package:xml/xml.dart';
import 'package:xournalpp/src/HexColor.dart';
import 'package:xournalpp/layer_contents/XppText.dart';
import 'package:xournalpp/src/XppLayer.dart';
import 'package:xournalpp/src/XppPageContentWidget.dart';
import 'package:xournalpp/widgets/ToolBoxBottomSheet.dart';

class XppTexImage extends XppContent {
  Offset? topLeft = Offset(0, 0);

  /// TODO: proper implementation of bottom and right
  Offset? bottomRight = Offset(0, 0);

  @required
  final String? text;

  Color? color;

  XppTexImage({this.text, this.topLeft, this.bottomRight, this.color});

  static Future<XppTexImage> edit(
      {required BuildContext context,
      String text = 'x^2',
      Offset? topLeft,
      Color? color}) async {
    var laTeXController = TextEditingController(text: text);
    bool? result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter LaTeX code'),
        content: TextField(
            controller: laTeXController = laTeXController,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'LaTeX code',
                helperText: 'No delimiter required')),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Okay'))
        ],
      ),
    );
    if (result == false) throw (UnsupportedError('Aborted.'));
    return (XppTexImage(
        text: laTeXController.text, topLeft: topLeft, color: color));
  }

  @override
  XppPageContentWidget render() {
    print(color);
    return XppPageContentWidget(
      child: DefaultTextStyle(
        style:
            TextStyle(color: color, fontSize: 18), // TODO: implement text size
        child: new KaTeX(laTeXCode: Text('\$\\displaystyle{$text}\$')),
      ),
      onSelected: () => print('Edit LaTeX!'),
      tool: EditingTool.LATEX,
    );
  }

  @override
  Offset? getOffset() => topLeft;

  @override
  XmlElement toXmlElement() => XmlElement(XmlName('teximage'), [
        XmlAttribute(XmlName('text'), text!),
        XmlAttribute(XmlName('color'), color!.toHexTriplet()),
        XmlAttribute(XmlName('left'), topLeft!.dx.toString()),
        XmlAttribute(XmlName('right'), bottomRight?.dx?.toString() ?? '0'),
        XmlAttribute(XmlName('top'), topLeft!.dy.toString()),
        XmlAttribute(XmlName('bottom'), bottomRight?.dy?.toString() ?? '0'),
      ], [
        XmlText(XppText.encodeText(text!))
      ]);

  @override
  bool inRegion({Offset? topLeft, Offset? bottomRight}) {
    // TODO: implement inRegion
    throw UnimplementedError();
  }

  @override
  bool shouldSelectAt({Offset? coordinates, EditingTool? tool}) {
    // TODO: implement shouldSelectAt
    throw UnimplementedError();
  }
}
