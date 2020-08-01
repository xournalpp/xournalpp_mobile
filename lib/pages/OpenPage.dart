import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:xournalpp/pages/CanvasPage.dart';
import 'package:xournalpp/src/XppFile.dart';
import 'package:xournalpp/src/conditional/open_file/open_file_generic.dart';
import 'package:xournalpp/widgets/DropFile.dart';
import 'package:xournalpp/widgets/drawer.dart';

class OpenPage extends StatefulWidget {
  @override
  _OpenPageState createState() => _OpenPageState();
}

class _OpenPageState extends State<OpenPage> {
  bool _loadedRecent = false;
  List<Map> recentFiles = [];

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      String jsonData = prefs.getString('recentFiles');
      if (jsonData != null) {
        recentFiles = (jsonDecode(jsonData) as List<Map>).reversed;
      }
      setState(() {
        _loadedRecent = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('Xournal++'),
      ),
      body: ListView(
        children: [if (kIsWeb) DropFile()]..addAll(_loadedRecent
            ? generateRecentFileList(recentFiles, context)
            : [CircularProgressIndicator()]),
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

Iterable<Widget> generateRecentFileList(List<Map> files, BuildContext context) {
  return List.generate(files.length > 0 ? files.length : 1, (index) {
    if (files.length > 0) {
      Map fileInfo = files[index];
      return ListTile(
        isThreeLine: true,
        leading: Container(
          child: Stack(
            children: [
              CircularProgressIndicator(),
              FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: MemoryImage(base64Decode(fileInfo['preview']))),
            ],
          ),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        ),
        title: Text(fileInfo['name']),
        onTap: () async {
          XppFile file = await XppFile.fromFilePickerCross(
              openFileByUri(fileInfo['path']), (percent) {});
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => CanvasPage(file: file)));
        },
      );
    } else {
      return ListTile(
        leading: Icon(Icons.info),
        title: Text('No recent files.'),
      );
    }
  });
}
