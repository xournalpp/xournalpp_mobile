import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:xournalpp/pages/CanvasPage.dart';
import 'package:xournalpp/widgets/drawer.dart';

class OpenPage extends StatefulWidget {
  @override
  _OpenPageState createState() => _OpenPageState();
}

class _OpenPageState extends State<OpenPage> {
  DropzoneViewController _fileDropController;

  bool _fileHover = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('Xournal++'),
      ),
      body: Column(
        children: [
          if (kIsWeb)
            Container(
                constraints: BoxConstraints(maxHeight: 320),
                child: Stack(
                  children: [
                    DropzoneView(
                      onDrop: (value) {
                        print(value);
                      },
                      onHover: () => _fileHover = true,
                      onLeave: () => _fileHover = false,
                      onError: (message) {
                        _fileHover = false;
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
                      operation: DragOperation.link,
                      //mime: ['application/x-gzip', 'xopp'],
                    ),
                    Center(
                      child: Text.rich(
                        TextSpan(children: [
                          WidgetSpan(child: Icon(Icons.file_upload)),
                          TextSpan(text: 'Drop files to open')
                        ]),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                    color: _fileHover
                        ? Theme.of(context).accentColor
                        : Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.circular(8)))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CanvasPage())),
        label: Text('New Notebook'),
        icon: Icon(Icons.insert_drive_file),
      ),
    );
  }
}
