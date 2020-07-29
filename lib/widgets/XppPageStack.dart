import 'package:flutter/material.dart';
import 'package:xournalpp/src/XppLayer.dart';
import 'package:xournalpp/src/XppPage.dart';

class XppPageStack extends StatelessWidget {
  final XppPage page;

  const XppPageStack({Key key, this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: page.pageSize.width,
      height: page.pageSize.height,
      child: (Stack(
          children: List.generate(page.layers.length, (index) {
        XppLayer currentLayer = page.layers[index];
        return Stack(
          children: List.generate(currentLayer.content.length, (n) {
            XppContent currentContent = currentLayer.content[n];
            if (currentContent == null ||
                currentContent.getOffset() == null ||
                currentContent.render() == null) return (Container());
            return Positioned(
              child: currentContent.render(),
              top: currentContent.getOffset()?.dy ?? 0,
              left: currentContent.getOffset()?.dx ?? 0,
            );
          }),
        );
      }))),
    );
  }
}
