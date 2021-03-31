import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:xml/xml.dart';
import 'package:xournalpp/src/XppLayer.dart';
import 'package:xournalpp/src/XppPageContentWidget.dart';
import 'package:xournalpp/widgets/ToolBoxBottomSheet.dart';

class XppImage extends XppContent {
  Offset topLeft = Offset(0, 0);
  Offset bottomRight = Offset(0, 0);

  @required
  final Uint8List data;

  XppImage({this.data, this.topLeft, this.bottomRight});

  static Future<XppImage> open({Offset topLeft}) async {
    FilePickerCross image =
        await FilePickerCross.importFromStorage(type: FileTypeCross.image);

    /// rendering the [Uint8List] into an image to determinate the height and width
    MemoryImage memoryImage = MemoryImage(image.toUint8List());
    Completer completer = new Completer();
    memoryImage.resolve(ImageConfiguration()).addListener(ImageStreamListener(
        (ImageInfo info, bool _) => completer.complete(info.image)));
    Image renderedImage = await completer.future;
    Offset bottomRight = Offset(
        topLeft.dx + renderedImage.width, topLeft.dy + renderedImage.height);
    return XppImage(
        data: image.toUint8List(), topLeft: topLeft, bottomRight: bottomRight);
  }

  @override
  XppPageContentWidget render() {
    return XppPageContentWidget(
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(),
          FadeInImage(
            image: MemoryImage(data),
            placeholder: MemoryImage(kTransparentImage),
            width: bottomRight.dx - topLeft.dx,
            height: bottomRight.dy - topLeft.dy,
          )
        ],
      ),
      tool: EditingTool.IMAGE,
    );
  }

  @override
  Offset getOffset() => topLeft;

  @override
  XmlElement toXmlElement() => XmlElement(XmlName('image'), [
        XmlAttribute(XmlName('left'), topLeft.dx.toString()),
        XmlAttribute(XmlName('right'), bottomRight.dx.toString()),
        XmlAttribute(XmlName('top'), topLeft.dy.toString()),
        XmlAttribute(XmlName('bottom'), bottomRight.dy.toString()),
      ], [
        XmlText(base64Encode(data))
      ]);
}
