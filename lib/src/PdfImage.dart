import 'dart:typed_data';

import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:printing/printing.dart';
import 'package:xournalpp/src/XppPage.dart';

const double DPI = 96;

Future<int> pdfPageCount(FilePickerCross pdf) =>
    Printing.raster(pdf.toUint8List()).length;

Future<Uint8List> pdfImage(FilePickerCross pdf, int page) async =>
    Printing.raster(pdf.toUint8List(), dpi: 96)
        .toList()
        .then((value) => value[page].toPng());

Future<XppPageSize> pdfPageSize(FilePickerCross pdf, int page) async {
  final raster = await Printing.raster(pdf.toUint8List(), dpi: DPI)
      .toList()
      .then((value) => value[page]);
  return XppPageSize(
      width: raster.width.toDouble(), height: raster.height.toDouble());
}
