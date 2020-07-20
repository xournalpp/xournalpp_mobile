import 'package:flutter/material.dart';
import 'package:xournalpp/main.dart';
import 'package:xournalpp/src/xournalppFile.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.file_upload),
            title: Text('Open'),
            onTap: () => XppFile.open().then((openedFile) =>
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => CanvasPage(
                          file: openedFile,
                        )))),
          ),
          ListTile(
            leading: Icon(Icons.insert_drive_file),
            title: Text('New'),
            onTap: () =>
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => CanvasPage(
                          file: XppFile.empty(),
                        ))),
          ),
          ListTile(
            leading: Icon(Icons.save),
            title: Text('Save'),
            subtitle: Text('Not implemented'),
          ),
        ],
      ),
    );
  }
}
