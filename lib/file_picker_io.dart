import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

import 'file_picker_cross.dart';

Future<Uint8List> selectSingleFileAsBytes(
    {FileTypeCross type, String fileExtension}) async {
  File file = await FilePicker.getFile(
      type: _fileTypeCrossParse(type),
      allowedExtensions: fileExtension.split(',').map((e) => e.trim()));
  return file.readAsBytesSync();
}

FileType _fileTypeCrossParse(FileTypeCross type) {
  FileType accept;
  switch (type) {
    case FileTypeCross.any:
      accept = FileType.any;
      break;
    case FileTypeCross.audio:
      accept = FileType.audio;
      break;
    case FileTypeCross.image:
      accept = FileType.image;
      break;
    case FileTypeCross.video:
      accept = FileType.video;
      break;
    case FileTypeCross.custom:
      accept = FileType.custom;
      break;
  }
  return accept;
}
