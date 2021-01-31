import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:xournalpp/generated/l10n.dart';
import 'package:xournalpp/pages/CanvasPage.dart';
import 'package:xournalpp/pages/OpenPage.dart';
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
      child: Card(
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
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              S.of(context).openingFile + filename + ' ...'),
                          duration: Duration(days: 999),
                        ));
                        _fileDropController.getFileData(file).then((bytes) {
                          XppFile.fromFilePickerCross(
                                  FilePickerCross(bytes,
                                      path: filename,
                                      type: FileTypeCross.custom,
                                      fileExtension: 'xopp'),
                                  (percentage) {},
                                  showMissingFileDialog)
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
                                      title:
                                          Text(S.of(context).errorOpeningFile),
                                      content: SelectableText(S
                                              .of(context)
                                              .imVerySorryButICouldntReadTheFile +
                                          '$filename' +
                                          S
                                              .of(context)
                                              .areYouSureIHaveThePermissionAndAreYou +
                                          '\n${e.toString()}'),
                                      actions: [
                                        TextButton(
                                            onPressed: () => Clipboard.setData(
                                                ClipboardData(
                                                    text: e.toString())),
                                            child: Text(S
                                                .of(context)
                                                .copyErrorMessage)),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text(S.of(context).okay),
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
                                title: Text(S.of(context).errorLoadingFile),
                                actions: [
                                  TextButton(
                                    onPressed: () => Clipboard.setData(
                                        ClipboardData(text: message)),
                                    child: Text(S.of(context).copyErrorMessage),
                                  ),
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text(S.of(context).okay))
                                ],
                                content: Text(
                                    S.of(context).theFollowingErrorWasDetected +
                                        '\n' +
                                        message),
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
                                Icons.open_with,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              Text(S.of(context).dropFilesToOpen)
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
            )),
      ),
    );
  }
}
