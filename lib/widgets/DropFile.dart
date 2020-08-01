import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:xournalpp/pages/CanvasPage.dart';
import 'package:xournalpp/src/XppFile.dart';

class DropFile extends StatefulWidget {
  @override
  _DropFileState createState() => _DropFileState();
}

class _DropFileState extends State<DropFile> {
  DropzoneViewController _fileDropController;

  bool _fileHover = false;
  bool _loadingDropZone = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedContainer(
          duration: Duration(milliseconds: 250),
          constraints: BoxConstraints(maxHeight: 256),
          child: Stack(
            children: [
              Builder(
                builder: (context) => DropzoneView(
                  onDrop: (file) {
                    setState(() {
                      _fileHover = false;
                      _loadingDropZone = true;
                    });

                    _fileDropController.getFilename(file).then((filename) {
                      var controller =
                          Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Opening file ' + filename + ' ...'),
                        duration: Duration(days: 999),
                      ));
                      _fileDropController.getFileData(file).then((bytes) {
                        XppFile.fromFilePickerCross(
                                FilePickerCross(bytes,
                                    path: filename,
                                    type: FileTypeCross.custom,
                                    fileExtension: 'xopp'),
                                (percentage) {})
                            .then((file) {
                          controller.close();
                          setState(() {
                            _loadingDropZone = false;
                          });
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CanvasPage(
                                    file: file,
                                  )));
                        }).catchError((e) {
                          controller.close();
                          setState(() {
                            _loadingDropZone = false;
                          });
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text('Error opening file'),
                                    content: SelectableText(
                                        'I\'m very sorry, but I couldn\'t read the file $filename . Are you sure I have the permission? And are you sure it is a Xournal++ file?\n${e.toString()}'),
                                    actions: [
                                      FlatButton(
                                          onPressed: () => Clipboard.setData(
                                              ClipboardData(
                                                  text: e.toString())),
                                          child: Text('Copy message')),
                                      FlatButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text('Okay'),
                                      ),
                                    ],
                                  ));
                        });
                      });
                    });
                  },
                  onHover: () {
                    setState(() => _fileHover = true);
                  },
                  onLeave: () {
                    setState(() => _fileHover = false);
                  },
                  onLoaded: () {
                    setState(() => _loadingDropZone = false);
                  },
                  onError: (message) {
                    setState(() {
                      _fileHover = false;
                      _loadingDropZone = false;
                    });
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text('Error loading file'),
                              actions: [
                                FlatButton(
                                  onPressed: () => Clipboard.setData(
                                      ClipboardData(text: message)),
                                  child: Text('Copy error message'),
                                ),
                                FlatButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text('Okay'))
                              ],
                              content: Text(
                                  'The following error was detected:\n$message'),
                            ));
                  },
                  onCreated: (controller) {
                    _fileDropController = controller;
                  },
                  operation: DragOperation.all,
                  //mime: ['application/x-xopp'],
                ),
              ),
              Center(
                child: _loadingDropZone
                    ? CircularProgressIndicator()
                    : DefaultTextStyle.merge(
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                        child: Row(
                          children: [
                            Icon(
                              Icons.file_upload,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            Text('Drop files to open')
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                      ),
              ),
            ],
          ),
          decoration: BoxDecoration(
              color: _fileHover
                  ? Theme.of(context).accentColor
                  : Theme.of(context).backgroundColor,
              border: _fileHover
                  ? Border.all(color: Theme.of(context).primaryColor, width: 2)
                  : Border.all(color: Colors.transparent, width: 2),
              borderRadius: BorderRadius.circular(16))),
    );
  }
}
