import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:xml/xml.dart';

class XppFile {
  XppFile({this.title, this.pages, this.previewImage});

  /// create an empty [XppFile]
  static XppFile empty({String title, PageSize pageSize}) {
    return XppFile(
        title: title, pages: [XppPage(pageSize: pageSize ?? PageSize.a4)]);
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
    // Clipboard.setData(ClipboardData(text: fileText));
    /// parsing the [String] to a [XmlDocument]
    XmlElement documentTree =
        XmlDocument.parse(fileText).findElements('xournal').toList()[0];

    /// decoding the preview image from base64 [String] to [Uint8List] of bytes
    Uint8List previewImage = base64Decode(
        documentTree.findElements('preview').toList()[0].innerText);

    List<XppPage> pages = [];
    documentTree.findElements('page').forEach((XmlElement element) {
      pages.add(XppPage(
          pageSize: PageSize(
              width: double.parse(element.getAttribute('width')),
              height: double.parse(element.getAttribute('height')))));
    });

    return XppFile(title: title, previewImage: previewImage, pages: pages);
  }

  /// thumbnail image data
  Uint8List previewImage;

  /// [List] of [XppPages] inside the document
  List<XppPage> pages;

  /// the main title of the document. usually the [String] between the last `/` and the last `.`.
  String title;

  /// encoding the document to a [XmlDocument]
  XmlDocument toXmlDocument() {
    // TODO: implement encoding the existing document to a [XmlDocument]
    throw UnimplementedError();
    return XmlDocument();
  }

  /// creating the XML-encoded, utf8-encoded and gzipped [Uint8List] to be used in a .xopp file
  Uint8List toUint8List() {
    return GZipEncoder()
        .encode(utf8.encode(toXmlDocument().toXmlString(pretty: true)));
  }
}

class XppPage {
  XppPage({this.pageSize, this.background, this.content});
  PageSize pageSize;
  XppBackground background;
  List content;
}

class XppBackground {}

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

class PageSize {
  /// The page width in pt
  final double width;

  /// The page height in pt
  final double height;

  PageSize({this.width, this.height});

  /// create a [PageSize] from pt (Points)
  static PageSize fromMillimeter({double width, double height}) {
    return PageSize(width: pt2mm(width), height: pt2mm(height));
  }

  /// helper function to convert mm to pt where 1 pt equals 1/72 inch
  static double pt2mm(double pt) => pt / 0.35277777777777775;

  static PageSize get a4 => PageSize.fromMillimeter(width: 210, height: 297);

  /// Ratio of width / height
  double get ratio => width / height;
}

class XppLayer {
  XppLayer({this.content});
  List content;
}
