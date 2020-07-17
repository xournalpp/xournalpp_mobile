import 'dart:typed_data';

import 'file_picker_cross.dart';

/// Dummy file selection implementation throwing an error. Should be overwritten by conditional imports.
Future<Map<String, Uint8List>> selectSingleFileAsBytes(
    {FileTypeCross type, String fileExtension}) async {
  throw UnimplementedError('Unsupported Platform for file_picker_cross');
}
