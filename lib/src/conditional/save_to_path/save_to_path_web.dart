import 'dart:typed_data';

Future<void> saveToPath(String path, Uint8List bytes) {
  throw (UnsupportedError('Saving local files is not supported on the web.'));
}
