import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FilePickerCross filePicker = FilePickerCross();

  String _fileString;
  int _fileLength = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          padding: EdgeInsets.all(8),
          children: <Widget>[
            RaisedButton(
              onPressed: _selectFile,
              child: Text('Select File'),
            ),
            Text('File length: $_fileLength\n'),
            Text('File as String: $_fileString\n'),
          ],
        ),
      ),
    );
  }

  void _selectFile() {
    filePicker.pick().then((value) => setState(() {
          _fileLength = filePicker.toUint8List().lengthInBytes;
          try {
            _fileString = filePicker.toString();
          } catch (e) {
            _fileString =
                'Not a text file. Showing base64.\n\n' + filePicker.toBase64();
          }
        }));
  }
}
