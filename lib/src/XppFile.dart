import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:archive/archive.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';
import 'package:xournalpp/generated/l10n.dart';
import 'package:xournalpp/layer_contents/XppImage.dart';
import 'package:xournalpp/layer_contents/XppStroke.dart';
import 'package:xournalpp/layer_contents/XppTexImage.dart';
import 'package:xournalpp/layer_contents/XppText.dart';
import 'package:xournalpp/pages/CanvasPage.dart';
import 'package:xournalpp/src/HexColor.dart';

import 'XppLayer.dart';
import 'XppPage.dart';
import 'globals.dart';

class XppFile {
  XppFile({this.title, this.pages, this.previewImage});

  /// create an empty [XppFile]
  static XppFile empty({String title, XppPageSize pageSize}) {
    return XppFile(title: title, pages: [
      XppPage(
          pageSize: pageSize ?? XppPageSize.a4, layers: [XppLayer(content: [])])
    ]);
  }

  /// showing a [open] dialog and pushes a [CanvasPage] to the provided [BuildContext]'s [Navigator]
  static void openAndEdit({BuildContext context}) async {
    //double percentage = 0;
    ScaffoldFeatureController snackBarController = Scaffold.of(context)
        .showSnackBar(SnackBar(
            duration: Duration(days: 999),
            content: Builder(
                builder: (context) => Text(S.of(context).loadingFile))));
    XppFile file;
    try {
      file = await open((percentage) => null);

      snackBarController.close();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => CanvasPage(
                file: file,
              )));
    } catch (e) {
      snackBarController.close();
      showDialog(
          context: context,
          builder: (c) => AlertDialog(
                title: Text(S.of(context).noFileSelected),
                content: Text(S.of(context).youDidNotSelectAnyFile),
                actions: [
                  FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(S.of(context).close))
                ],
              ));
    }
  }

  /// showing a file picker, decoding and parsing to [XppFile]
  static Future<XppFile> open(Function(double) percentageCallback) async {
    /// showing a [FilePickerCross]
    FilePickerCross rawFile = await FilePickerCross.pick(
        type: FileTypeCross.custom, fileExtension: 'xopp');

    /// decoding by [fromFilePickerCross]
    XppFile file = await fromFilePickerCross(rawFile, percentageCallback);

    return file;
  }

  /// decoding and parsing a [FilePickerCross] to [XppFile]
  static Future<XppFile> fromFilePickerCross(
      FilePickerCross rawFile, Function(double) percentageCallback) async {
    /// for potential progress indicator and a better UX we provide feedback about
    /// the state of parsing. Huge documents may require a minute or two.
    double percentCompleted = 0;

    if (percentageCallback == null) percentageCallback = (percentage) {};

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
    int pageIndex = 0;
    Iterable<XmlElement> pageElements = documentTree.findElements('page');
    pageElements.forEach((XmlElement pageElement) {
      pageIndex++;
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
      int layerIndex = 0;
      Iterable<XmlElement> layerElements = pageElement.findElements('layer');
      layerElements.forEach((XmlElement layer) {
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
          node.setAttribute('counter', index.toString());
          index++;
        });

        /// processing all images first
        layer.findElements('image').forEach((imageElement) {
          content[int.parse(imageElement.getAttribute('counter'))] = XppImage(
              data: base64Decode(imageElement.text.trim()),
              topLeft: Offset(double.parse(imageElement.getAttribute('left')),
                  double.parse(imageElement.getAttribute('top'))),
              bottomRight: Offset(
                  double.parse(imageElement.getAttribute('right')),
                  double.parse(imageElement.getAttribute('bottom'))));
        });

        /// processing all texts
        layer.findElements('text').forEach((textElement) {
          Color color = Colors.black;
          if (textElement.getAttribute('color') != null) {
            switch (textElement.getAttribute('color')) {
              case "black":
                break;
              case "blue":
                color = Colors.blue;
                break;
              case "red":
                color = Colors.red;
                break;
              case "green":
                color = Colors.green;
                break;
              case "gray":
              case "grey":
                color = Colors.grey;
                break;
              case "lightblue":
                color = Colors.lightBlue;
                break;
              case "lightgreen":
                color = Colors.lightGreen;
                break;
              case "magenta":
                color = Colors.purpleAccent;
                break;
              case "orange":
                color = Colors.orange;
                break;
              case "yellow":
                color = Colors.yellow;
                break;
              case "white":
                color = Colors.white;
                break;
              default:
                final colorString = textElement.getAttribute('color');
                color = HexColor(colorString);
                break;
            }
          }
          content[int.parse(textElement.getAttribute('counter'))] = XppText(
              color: color,
              // note: not trimming
              text: textElement.text.replaceAllMapped(
                  RegExp(r'(&amp;|&lt;|&gt;)'), (Match subtext) {
                switch (subtext.group(0)) {
                  case '&amp;':
                    return '&';
                  case '&lt;':
                    return '<';
                  case '&gt;':
                    return '>';
                }
                return subtext.group(0);
              }),
              size: XppPageSize.pt2mm(
                  double.parse(textElement.getAttribute('size'))),
              fontFamily: textElement.getAttribute('font'),
              offset: Offset(double.parse(textElement.getAttribute('x')),
                  double.parse(textElement.getAttribute('y'))));
        });

        /// processing all lateximages
        layer.findElements('teximage').forEach((texElement) {
          content[int.parse(texElement.getAttribute('counter'))] = XppTexImage(
              text: texElement.getAttribute('text').trim(),
              topLeft: Offset(double.parse(texElement.getAttribute('left')),
                  double.parse(texElement.getAttribute('top'))),
              bottomRight: Offset(
                  double.parse(texElement.getAttribute('right')),
                  double.parse(texElement.getAttribute('bottom'))));
        });

        /// processing all strokes
        layer.findElements('stroke').forEach((strokeElement) {
          XppStrokeTool tool;
          switch (strokeElement.getAttribute('tool')) {
            case "pen":
              tool = XppStrokeTool.PEN;
              break;
            case "eraser":
              tool = XppStrokeTool.ERASER;

              /// TODO: implement whiteout eraser
              return;
              break;
            case "highlighter":
              tool = XppStrokeTool.HIGHLIGHTER;
              break;
            default:
              print("Unsupported XppStrokeType: " +
                  strokeElement.getAttribute('tool'));
              break;
          }
          Color color = Colors.black;
          if (strokeElement.getAttribute('color') != null) {
            switch (strokeElement.getAttribute('color')) {
              case "black":
                break;
              case "blue":
                color = Colors.blue;
                break;
              case "red":
                color = Colors.red;
                break;
              case "green":
                color = Colors.green;
                break;
              case "gray":
              case "grey":
                color = Colors.grey;
                break;
              case "lightblue":
                color = Colors.lightBlue;
                break;
              case "lightgreen":
                color = Colors.lightGreen;
                break;
              case "magenta":
                color = Colors.purpleAccent;
                break;
              case "orange":
                color = Colors.orange;
                break;
              case "yellow":
                color = Colors.yellow;
                break;
              case "white":
                color = Colors.white;
                break;
              default:
                final colorString = strokeElement.getAttribute('color');
                color = HexColor(colorString);
                break;
            }
          }
          List<XppStrokePoint> points = [];
          List<String> rawWidth =
              strokeElement.getAttribute('width').split(' ');
          List<String> rawPoints = strokeElement.text.trim().split(' ');
          for (int i = 0; i < rawPoints.length / 2; i++) {
            points.add(XppStrokePoint(
                width: double.parse(
                    (rawWidth.length > i) ? rawWidth[i] : rawWidth[0]),
                x: double.parse(rawPoints[i * 2]),
                y: double.parse(rawPoints[i * 2 + 1])));
          }
          if (points.isEmpty) return;
          content[int.parse(strokeElement.getAttribute('counter'))] =
              XppStroke(tool: tool, color: color, points: points);
        });

        layers.add(XppLayer(
            content:
                List.generate(content.keys.length, (index) => content[index])));
        layerIndex++;
        percentCompleted = (((pageIndex - 1) / pageElements.length) +
                (layerIndex / layerElements.length)) -
            1;
        //print(percentCompleted);
        try {
          percentageCallback(percentCompleted);
        } catch (e) {}
      });
      pages.add(XppPage(
          background: background,
          layers: layers,
          pageSize: XppPageSize(
              width: double.parse(pageElement.getAttribute('width')),
              height: double.parse(pageElement.getAttribute('height')))));
    });

    XppFile file =
        XppFile(title: title, previewImage: previewImage, pages: pages);

    /// starting async task to save recent files list
    SharedPreferences.getInstance().then((prefs) {
      String jsonData = prefs.getString(PreferencesKeys.kRecentFiles) ?? '[]';
      Set files = (jsonDecode(jsonData) as Iterable).toSet();
      if (files.where((element) => element['path'] == rawFile.path).length < 1)
        files.add({
          'preview': base64Encode(file.previewImage),
          'name': file.title,
          'path': rawFile.path
        });
      jsonData = jsonEncode(files.toList());
      prefs.setString(PreferencesKeys.kRecentFiles, jsonData);
    });

    return file;
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
