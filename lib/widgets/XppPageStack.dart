import 'package:flutter/material.dart';
import 'package:xournalpp/generated/l10n.dart';
import 'package:xournalpp/src/XppLayer.dart';
import 'package:xournalpp/src/XppPage.dart';

class XppPageStack extends StatefulWidget {
  final XppPage page;

  const XppPageStack({Key key, this.page}) : super(key: key);

  @override
  XppPageStackState createState() => XppPageStackState();
}

class XppPageStackState extends State<XppPageStack>
    with AutomaticKeepAliveClientMixin {
  XppPage page;

  @override
  void initState() {
    page = widget.page;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      width: widget.page.pageSize.width,
      height: widget.page.pageSize.height,
      child: (Stack(
          children: List.generate(widget.page.layers.length + 1, (index) {
        if (index == 0) return widget.page.background.render();
        XppLayer currentLayer = widget.page.layers[index - 1];
        return Stack(
          children: List.generate(currentLayer.content.length, (n) {
            XppContent currentContent = currentLayer.content[n];
            if (currentContent == null ||
                currentContent.getOffset() == null ||
                currentContent.render() == null) {
              return (Container());
            }
            return Positioned(
              child: currentContent.render() ?? Text(S.of(context).error),
              top: currentContent.getOffset()?.dy ?? 0,
              left: currentContent.getOffset()?.dx ?? 0,
            );
          }),
        );
      }))),
    );
  }

  void setPageData(XppPage pageData) {
    setState(() => page = pageData);
  }

  @override
  bool get wantKeepAlive => true;
}
