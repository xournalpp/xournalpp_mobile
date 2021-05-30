import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:xournalpp/generated/l10n.dart';
import 'package:xournalpp/src/XppBackground.dart';
import 'package:xournalpp/src/XppLayer.dart';
import 'package:xournalpp/src/XppPage.dart';

class XppPageStack extends StatefulWidget {
  final XppPage? page;

  const XppPageStack({Key? key, this.page}) : super(key: key);

  @override
  XppPageStackState createState() => XppPageStackState();
}

class XppPageStackState extends State<XppPageStack>
    with AutomaticKeepAliveClientMixin {
  GlobalKey pngKey = GlobalKey();
  XppPage? page;

  XppBackground? _lastKnownBackground;
  Widget background = Container();

  @override
  void initState() {
    page = widget.page;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<Widget> children = [];

    if (page!.background != null && _lastKnownBackground != page!.background) {
      _lastKnownBackground = page!.background;
      background = page!.background!.render();
    }
    children.add(background);

    children.addAll(page!.layers!.map((e) => XppLayerStack(
          layer: e,
        )));
    return RepaintBoundary(
        key: pngKey,
        child: SizedBox(
            width: page!.pageSize!.width,
            height: page!.pageSize!.height,
            child: (Stack(children: children))));
  }

  void setPageData(XppPage pageData) {
    setState(() => page = pageData);
  }

  Future<Uint8List> toPng() async {
    RenderRepaintBoundary boundary =
        pngKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData byteData = await (image.toByteData(format: ui.ImageByteFormat.png)
        as FutureOr<ByteData>);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    return pngBytes;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void didUpdateWidget(covariant XppPageStack oldWidget) {
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }
}

class XppLayerStack extends StatefulWidget {
  final XppLayer? layer;

  const XppLayerStack({Key? key, this.layer}) : super(key: key);
  @override
  _XppLayerStackState createState() => _XppLayerStackState();
}

class _XppLayerStackState extends State<XppLayerStack> {
  Map<XppContent, Widget> renderedContent = {};
  @override
  Widget build(BuildContext context) {
    List<Widget?> children = [];
    widget.layer!.content!.forEach((element) {
      if (element == null) return;
      if (!renderedContent.keys.contains(element)) {
        renderedContent[element] = Positioned(
          child: element.render() ?? Text(S.of(context).error),
          top: element.getOffset()?.dy ?? 0,
          left: element.getOffset()?.dx ?? 0,
        );
      }
      children.add(renderedContent[element]);
    });
    return Stack(
      children: children as List<Widget>,
    );
  }
}
