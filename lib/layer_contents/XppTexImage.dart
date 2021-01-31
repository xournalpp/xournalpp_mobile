import 'package:flutter/material.dart';
import 'package:katex_flutter/katex_flutter.dart';
import 'package:xml/xml.dart';
import 'package:xournalpp/layer_contents/XppText.dart';
import 'package:xournalpp/src/XppLayer.dart';

class XppTexImage extends XppContent {
  Offset topLeft = Offset(0, 0);

  /// TODO: proper implementation of bottom and right
  Offset bottomRight = Offset(0, 0);

  @required
  final String text;

  XppTexImage({this.text, this.topLeft, this.bottomRight});

  static Future<XppTexImage> edit(
      {BuildContext context, String text = 'x^2', Offset topLeft}) async {
    var laTeXController = TextEditingController(text: text);
    bool result = await showDialog(
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
    return (XppTexImage(text: laTeXController.text, topLeft: topLeft));
  }

  @override
  Widget render() {
    return new KaTeX(laTeXCode: Text('\$\\displaystyle{$text}\$'));
  }

  @override
  Offset getOffset() => topLeft;

  @override
  XmlElement toXmlElement() => XmlElement(XmlName('teximage'), [
        XmlAttribute(XmlName('text'), text),
        XmlAttribute(XmlName('left'), topLeft.dx.toString()),
        XmlAttribute(XmlName('right'), bottomRight.dx.toString()),
        XmlAttribute(XmlName('top'), topLeft.dy.toString()),
        XmlAttribute(XmlName('bottom'), bottomRight.dy.toString()),
      ], [
        XmlText(XppText.encodeText(text))
      ]);
}
