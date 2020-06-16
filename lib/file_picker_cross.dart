import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'file_picker_stub.dart'
// ignore: uri_does_not_exist
    if (dart.library.io) 'file_picker_io.dart'
// ignore: uri_does_not_exist
    if (dart.library.html) 'file_picker_web.dart';

/// FilePickerCross allows you to select files on any of Flutters platforms.
class FilePickerCross {
  final FileTypeCross type;
  final String fileExtension;

  Uint8List _bytes;
  String _path;

  FilePickerCross({this.type = FileTypeCross.any, this.fileExtension = ''});

  /// Shows a dialog for selecting a file.
  Future<bool> pick() async {
    final Map<String,Uint8List> file =
        await selectSingleFileAsBytes(type: type, fileExtension: fileExtension);

    _path = file.keys.toList()[0];
    _bytes = file[_path];

    return (_bytes != null);
  }

  /// Returns a sting containing the file contents of plain text files. Please use it in a try {} catch (e) {} block if you are unsure if the opened file is plain text.
  String toString() => Utf8Codec().decode(_bytes);

  /// Returns the file as a list of bytes.
  Uint8List toUint8List() => _bytes;

  /// Returns the file as base64-encoded String.
  String toBase64() => base64.encode(_bytes);

  /// Returns the file as MultiPartFile for use with tha http package. Useful for file upload in apps.
  http.MultipartFile toMultipartFile({String filename}) {
    return http.MultipartFile.fromBytes('file', _bytes,
        contentType: new MediaType('application', 'octet-stream'),
        filename: filename);
  }

  /// Returns the file's length in bytes
  int get length => _bytes.lengthInBytes;
  
  /// Returns the file's path in the filesystem
  String get path => _path;
}

/// Supported file types
enum FileTypeCross { image, video, audio, any, custom }
