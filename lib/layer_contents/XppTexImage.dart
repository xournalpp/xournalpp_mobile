import 'package:flutter/material.dart';
import 'package:katex_flutter/katex_flutter.dart';
import 'package:xournalpp/src/XppLayer.dart';

class XppTexImage extends XppContent {
  Offset topLeft = Offset(0, 0);
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
          FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel')),
          FlatButton(
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
    return new KaTeX(laTeXCode: Text('\$$text\$'));
  }

  @override
  Offset getOffset() => topLeft;
}
