import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

import 'file_picker_cross.dart';

//
//    A valid case-insensitive filename extension, starting with a period (".") character. For example: .jpg, .pdf, or .doc.
//    A valid MIME type string, with no extensions.
//    The string audio/* meaning "any audio file".
//    The string video/* meaning "any video file".
//    The string image/* meaning "any image file".

Future<Map<String,Uint8List>> selectSingleFileAsBytes(
    {FileTypeCross type, String fileExtension}) {
  Completer<Map<String,Uint8List>> loadEnded = Completer();

  String accept = _fileTypeToAcceptString(type, fileExtension);
  html.InputElement uploadInput = html.FileUploadInputElement();
  uploadInput.draggable = true;
  uploadInput.accept = accept;
  uploadInput.click();

  uploadInput.onChange.listen((e) {
    final files = uploadInput.files;
    final file = files[0];
    final reader = new html.FileReader();

    reader.onLoadEnd.listen((e) {
      loadEnded.complete({file.relativePath:
          Base64Decoder().convert(reader.result.toString().split(",").last)});
    });
    reader.readAsDataUrl(file);
  });
  return loadEnded.future;
}

String _fileTypeToAcceptString(FileTypeCross type, String fileExtension) {
  String accept;
  switch (type) {
    case FileTypeCross.any:
      accept = '';
      break;
    case FileTypeCross.audio:
      accept = 'audio/*';
      break;
    case FileTypeCross.image:
      accept = 'image/*';
      break;
    case FileTypeCross.video:
      accept = 'video/*';
      break;
    case FileTypeCross.custom:
      accept = fileExtension;
      break;
  }
  return accept;
}
