import 'package:flutter/material.dart';
import 'package:xournalpp/src/XppLayer.dart';
import 'package:xournalpp/src/XppPage.dart';

class XppPageStack extends StatefulWidget {
  final XppPage page;

  const XppPageStack({Key key, this.page}) : super(key: key);
  @override
  _XppPageStackState createState() => _XppPageStackState();
}

class _XppPageStackState extends State<XppPageStack> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.page.pageSize.width,
      height: widget.page.pageSize.height,
      child: (Stack(
          children: List.generate(widget.page.layers.length, (index) {
        XppLayer currentLayer = widget.page.layers[index];
        return Stack(
          children: List.generate(currentLayer.content.length, (n) {
            XppContent currentContent = currentLayer.content[n];
            if (currentContent == null) return (Container());
            return Positioned(
              child: currentContent.render(),
              top: currentContent?.getOffset()?.dy,
              left: currentContent?.getOffset()?.dx,
            );
          }),
        );
      }))),
    );
  }
}
