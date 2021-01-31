import 'package:file_picker_cross/file_picker_cross.dart';

FilePickerCross openFileByUri(String url, String extension) {
  throw (UnsupportedError('Opening local files is not supported on the web.'));
}
