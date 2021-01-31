import 'dart:typed_data';

import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:printing/printing.dart';

Future<int> pdfPageCount(FilePickerCross pdf) =>
    Printing.raster(pdf.toUint8List()).length;

Future<Uint8List> pdfImage(FilePickerCross pdf, int page) async =>
    Printing.raster(pdf.toUint8List(), dpi: 96)
        .toList()
        .then((value) => value[page].toPng());
