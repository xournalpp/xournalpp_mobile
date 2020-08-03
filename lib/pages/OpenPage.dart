import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xournalpp/generated/l10n.dart';
import 'package:xournalpp/main.dart';
import 'package:xournalpp/pages/CanvasPage.dart';
import 'package:xournalpp/src/XppFile.dart';
import 'package:xournalpp/src/conditional/open_file/open_file_generic.dart'
    if (dart.library.html) 'package:xournalpp/src/conditional/open_file/open_file_web.dart'
    if (dart.library.io) 'package:xournalpp/src/conditional/open_file/open_file_io.dart';
import 'package:xournalpp/src/globals.dart';
import 'package:xournalpp/widgets/DropFile.dart';
import 'package:xournalpp/widgets/drawer.dart';

class OpenPage extends StatefulWidget {
  @override
  _OpenPageState createState() => _OpenPageState();
}

class _OpenPageState extends State<OpenPage> {
  bool _loadedRecent = false;
  List recentFiles = [];

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      String jsonData = prefs.getString(PreferencesKeys.kRecentFiles);
      if (jsonData != null) {
        recentFiles = (jsonDecode(jsonData) as List).reversed.toList();
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
        children: [
          if (kIsWeb) DropFile(),
          ListTile(
            title: Text(
              S.of(context).recentFiles,
              style: Theme.of(context).textTheme.headline3,
            ),
          )
        ]..addAll(_loadedRecent
            ? generateRecentFileList(recentFiles, context)
            : [Center(child: CircularProgressIndicator())]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CanvasPage())),
        label: Text(S.of(context).newNotebook),
        icon: Icon(Icons.note_add),
      ),
    );
  }
}

Iterable<Widget> generateRecentFileList(List files, BuildContext context) {
  return List.generate(files.length > 0 ? files.length : 1, (index) {
    if (files.length > 0) {
      Map fileInfo = files[index];
      return ListTile(
        isThreeLine: true,
        title: Container(),
        leading: AspectRatio(
          aspectRatio: 1,
          child: Container(
            alignment: Alignment.center,
            constraints: BoxConstraints(maxHeight: 256, minHeight: 128),
            child: Image.memory(base64Decode(fileInfo['preview'])),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        subtitle: Text(
          fileInfo['name'],
          style: Theme.of(context).textTheme.headline3.copyWith(
              color: Theme.of(context).textTheme.bodyText1.color,
              fontSize: kEmphasisFontSize * kFontSizeDivision),
        ),
        trailing: Tooltip(
          child: Icon(
            Icons.info_outline,
          ),
          message: fileInfo['path'],
        ),
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
        title: Text(S.of(context).noRecentFiles),
        trailing: IconButton(
          icon: Icon(Icons.note_add),
          tooltip: S.of(context).newNotebook,
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CanvasPage())),
        ),
      );
    }
  });
}
