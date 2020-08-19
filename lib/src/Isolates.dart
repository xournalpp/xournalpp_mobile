import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:archive/archive.dart';

void _myIsolate(SendPort isolateToMainStream) {
  ReceivePort mainToIsolateStream = ReceivePort();
  Completer<SendPort> portCompleter = Completer();
  isolateToMainStream.send(mainToIsolateStream.sendPort);

  mainToIsolateStream.listen((data) {
    if (data is Completer) {
      portCompleter.complete(data as SendPort);
    } else if (data is List<int>) {
      print('Decoding');

      /// decoding file bytes from GZip to a UTF-8 [Uint8List]
      List<int> bytes = GZipDecoder().decodeBytes(data);
      print('Finished decoding');

      /// decoding the [Uint8List] to a [String]
      String fileText = utf8.decode(bytes);
      print('Parsed text');
      isolateToMainStream.send(fileText);
    } else
      print('[mainToIsolateStream] $data');
  });
}

Future<String> decodeGzip(List<int> bytes) async {
  Isolate gzipIsolate;
  Completer<String> xmlStringCompleter = Completer();

  Completer<SendPort> sendPortCompleter = Completer();
  ReceivePort isolateToMainStream = ReceivePort();

  isolateToMainStream.listen((data) {
    if (data is SendPort) {
      SendPort mainToIsolateStream = data;
      sendPortCompleter.complete(mainToIsolateStream);
    } else if (data is String) {
      gzipIsolate.kill();
      xmlStringCompleter.complete(data);
    } else {
      print('[isolateToMainStream] $data');
    }
  });

  gzipIsolate = await Isolate.spawn(_myIsolate, isolateToMainStream.sendPort);
  (await sendPortCompleter.future).send(bytes);
  return xmlStringCompleter.future;
}
