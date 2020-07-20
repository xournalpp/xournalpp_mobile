import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:archive/archive.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/cupertino.dart';
import 'package:xml/xml.dart';

import 'XppLayer.dart';
import 'XppPage.dart';

class XppFile {
  XppFile({this.title, this.pages, this.previewImage});

  /// create an empty [XppFile]
  static XppFile empty({String title, XppPageSize pageSize}) {
    return XppFile(title: title, pages: [
      XppPage(
          pageSize: pageSize ?? XppPageSize.a4, layers: [XppLayer(content: [])])
    ]);
  }

  /// showing a file picker, decoding and parsing to [XppFile]
  static Future<XppFile> open() async {
    /// showing a [FilePickerCross]
    FilePickerCross rawFile = await FilePickerCross.pick(
        type: FileTypeCross.custom, fileExtension: 'xopp');

    /// extracting the document title
    String title = rawFile.path.substring(
        rawFile.path.lastIndexOf('/') + 1, rawFile.path.lastIndexOf('.'));

    /// decoding file bytes from GZip to a UTF-8 [Uint8List]
    List<int> bytes = GZipDecoder().decodeBytes(rawFile.toUint8List().toList());

    /// decoding the [Uint8List] to a [String]
    String fileText = utf8.decode(bytes);
    //Clipboard.setData(ClipboardData(text: fileText));

    /// parsing the [String] to a [XmlDocument]
    XmlElement documentTree =
        XmlDocument.parse(fileText).findElements('xournal').toList()[0];

    /// decoding the preview image from base64 [String] to [Uint8List] of bytes
    Uint8List previewImage = base64Decode(
        documentTree.findElements('preview').toList()[0].innerText);

    List<XppPage> pages = [];
    documentTree.findElements('page').forEach((XmlElement pageElement) {
      XppBackground background;
      if (pageElement.findElements('background').isNotEmpty) {
        XmlElement backgroundElement =
            pageElement.findElements('background').toList()[0];
        switch (backgroundElement.getAttribute('type')) {
          case "pixmap":
            background = XppBackgroundImage(
                filename: backgroundElement.getAttribute('filename'));
            break;
          case "solid":
            background = XppBackgroundImage(
                filename: backgroundElement.getAttribute('filename'));
            break;
          default:
            background = XppBackground.none;
            break;
        }
      }
      List<XppLayer> layers = [];
      pageElement.findElements('layer').forEach((XmlElement layer) {
        Map<int, XppContent> content = {};

        /// unfortunately, it's not possible to forEach threw all child **elements**, but only threw
        /// all **nodes** (including text nodes etc.). Let's workaround...

        /// cleaning nodes and numbering them
        int index = 0;
        layer.children.forEach((XmlNode node) {
          if (node.nodeType == XmlNodeType.TEXT) {
            if (node.text.trim().isNotEmpty)
              print('Skipping text \'${node.text}\'');
            return;
          }
          if (node.nodeType != XmlNodeType.ELEMENT) {
            print('Unexpected XmlNodeType. Expected XmlNodeType.ELEMENT, got ' +
                node.nodeType.toString() +
                '. Removing.');
            return;
          }
          //print(node.text);
          node.setAttribute('counter', index.toString());
          index++;
        });

        /// processing all images first
        layer.findElements('image').forEach((imageElement) {
          print('Found image.');
          content[int.parse(imageElement.getAttribute('counter'))] = XppImage(
              data: base64Decode(imageElement.text.trim()),
              topLeft: Offset(double.parse(imageElement.getAttribute('left')),
                  double.parse(imageElement.getAttribute('top'))),
              bottomRight: Offset(
                  double.parse(imageElement.getAttribute('right')),
                  double.parse(imageElement.getAttribute('bottom'))));
        });
        layers.add(XppLayer(
            content:
                List.generate(content.keys.length, (index) => content[index])));
      });
      pages.add(XppPage(
          background: background,
          layers: layers,
          pageSize: XppPageSize(
              width: double.parse(pageElement.getAttribute('width')),
              height: double.parse(pageElement.getAttribute('height')))));
    });

    return XppFile(title: title, previewImage: previewImage, pages: pages);
  }

  /// thumbnail image data
  Uint8List previewImage;

  /// [List] of [XppPages] inside the document
  @required
  List<XppPage> pages;

  /// the main title of the document. usually the [String] between the last `/` and the last `.`.
  String title;

  /// encoding the document to a [XmlDocument]
  XmlDocument toXmlDocument() {
    // TODO: implement encoding the existing document to a [XmlDocument]
    throw UnimplementedError();
    //return XmlDocument();
  }

  /// creating the XML-encoded, utf8-encoded and gzipped [Uint8List] to be used in a .xopp file
  Uint8List toUint8List() {
    return GZipEncoder()
        .encode(utf8.encode(toXmlDocument().toXmlString(pretty: true)));
  }
}
