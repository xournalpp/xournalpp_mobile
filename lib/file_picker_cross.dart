import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'file_picker_stub.dart'
// ignore: uri_does_not_exist
    if (dart.library.io) 'file_picker_io.dart'
// ignore: uri_does_not_exist
    if (dart.library.html) 'file_picker_web.dart';

class FilePickerCross {
  final FileTypeCross type;
  final String fileExtension;

  Uint8List _bytes;

  FilePickerCross({this.type = FileTypeCross.any, this.fileExtension = ''});

  Future<bool> pick() async {
    _bytes =
        await selectSingleFileAsBytes(type: type, fileExtension: fileExtension);
    return (_bytes != null);
  }

  String toString() => Utf8Codec().decode(_bytes);

  Uint8List toUint8List() => _bytes;

  String toBase64() => base64.encode(_bytes);

  http.MultipartFile toMultipartFile({String filename}) {
    return http.MultipartFile.fromBytes('file', _bytes,
        contentType: new MediaType('application', 'octet-stream'),
        filename: filename);
  }

  int get length => _bytes.lengthInBytes;
}

enum FileTypeCross { image, video, audio, any, custom }
