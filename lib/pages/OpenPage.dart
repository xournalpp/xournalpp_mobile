import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:after_init/after_init.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:xournalpp/generated/l10n.dart';
import 'package:xournalpp/main.dart';
import 'package:xournalpp/pages/CanvasPage.dart';
import 'package:xournalpp/src/XppFile.dart';
import 'package:xournalpp/src/conditional/open_file/open_file_generic.dart'
    if (dart.library.html) 'package:xournalpp/src/conditional/open_file/open_file_web.dart'
    if (dart.library.io) 'package:xournalpp/src/conditional/open_file/open_file_io.dart';
import 'package:xournalpp/src/globals.dart';
import 'package:xournalpp/widgets/DropFile.dart';
import 'package:xournalpp/widgets/MainDrawer.dart';

class OpenPage extends StatefulWidget {
  @override
  _OpenPageState createState() => _OpenPageState();
}

class _OpenPageState extends State<OpenPage> with AfterInitMixin {
  bool _loadedRecent = false;
  Set recentFiles = Set();
  Completer<BuildContext> scaffoldCompleter = Completer();

  List<SharedMediaFile> _sharedFiles;

  @override
  void initState() {
    // trying to load fitting locale

    try {
      if (['en', 'de'].contains(window?.locale?.languageCode ?? 'en'))
        S.load(Locale(window.locale.languageCode));

      /// TODO: implement custom change of language
      // checking for locale override
      /*Preferences().fetch('language').then((languageCode) {
      switch (languageCode) {
        case 'en':
          S.load(Locale('en'));
          break;

        case 'de':
          S.load(Locale('de'));
          break;

        case 'fr':
          S.load(Locale('fr'));
          break;

          case 'tlh':
            S.load(Locale('tlh'));
            break;
          default:
            break;
        }
      });*/
    } catch (e) {}

    SharedPreferences.getInstance().then((prefs) {
      String jsonData = prefs.getString(PreferencesKeys.kRecentFiles);
      if (jsonData != null) {
        recentFiles = (jsonDecode(jsonData) as List).reversed.toList().toSet();
      }
      setState(() {
        _loadedRecent = true;
      });
    }).catchError((e) {
      print('No SharedPreferences available for this platform.');
      setState(() {
        _loadedRecent = true;
      });
    });
    super.initState();
  }

  @override
  void didInitState() {
    try {
      // For sharing images coming from outside the app while the app is in the memory
      ReceiveSharingIntent.getMediaStream().listen(
          (List<SharedMediaFile> value) {
        setState(() {
          _sharedFiles = value;
          receivedShareNotification(value);
        });
      }, onError: (err) {
        print("getIntentDataStream error: $err");
      });

      // For sharing images coming from outside the app while the app is closed
      ReceiveSharingIntent.getInitialMedia()
          .then((List<SharedMediaFile> value) {
        setState(() {
          _sharedFiles = value;
          receivedShareNotification(value);
        });
      }).catchError((e) {});

      // For sharing or opening urls/text coming from outside the app while the app is in the memory
      ReceiveSharingIntent.getTextStream().listen((String value) {
        receivedShareNotification(value);
      }, onError: (err) {
        print("getLinkStream error: $err");
      });

      // For sharing or opening urls/text coming from outside the app while the app is closed
      ReceiveSharingIntent.getInitialText().then((String value) {
        receivedShareNotification(value);
      }).catchError((e) {});
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Builder(
          /// just need a builder here to provide a valid context for background tasks
          builder: (context) {
            if (!scaffoldCompleter.isCompleted)
              scaffoldCompleter.complete(context);
            return Text('Xournal++');
          },
        ),
      ),
      body: ListView(
        children: [
          if (kIsWeb) DropFile(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Builder(
              builder: (context) => GestureDetector(
                onTap: () => XppFile.openAndEdit(context: context),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Card(
                    color: Theme.of(context).colorScheme.secondary,
                    child: DefaultTextStyle.merge(
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.folder,
                                color:
                                    Theme.of(context).colorScheme.onSecondary),
                            Text(S.of(context).open),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
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

  void receivedShareNotification(dynamic data) async {
    if (data == null ||
        lastIntentData == data ||
        data is List &&
            lastIntentData is List &&
            data[0].path == lastIntentData[0].path) return;
    lastIntentData = data;
    if (data is String) {
      /// checking if we were redirected from the web site
      if (data.startsWith('http')) {
        scaffoldCompleter.future.then((scaffoldContext) =>
            Scaffold.of(scaffoldContext).showSnackBar(SnackBar(
              content: Text(S.of(context).youveBeenRedirectedToTheLocalApp),
            )));
        return;
      } else {
        /// seems to be an opened file
        /// ... which is awfully encoded as a content:// URI using the path as **queryComponent** instead of as **path** (why???)
        /// unfortunately, android needs to copy the file to our own app directory
        /// TODO: don't copy files we can directly read
        String path = await FlutterAbsolutePath.getAbsolutePath(data as String);
        data = [
          SharedMediaFile(
              path, base64Encode(kTransparentImage), null, SharedMediaType.FILE)
        ];
        _sharedFiles = data;
      }
    }
    if (data is List) {
      bool _aborted = false;
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(S.of(context).openingFile),
                content: Text(S.of(context).opening +
                    ' ${data[0].path.substring(data[0].path.lastIndexOf('/') + 1, data[0].path.lastIndexOf('.'))} ...'),
                actions: [
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(S.of(context).background),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _aborted = true;
                    },
                    child: Text(S.of(context).abort),
                  )
                ],
              ));
      try {
        XppFile file = await XppFile.fromFilePickerCross(
            openFileByUri(_sharedFiles[0].path), (percentage) => null);
        if (_aborted) return;
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => CanvasPage(
                  file: file,
                )));
      } catch (e) {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(S.of(context).errorOpeningFile),
                  content: SelectableText(
                      S.of(context).imVerySorryButICouldntReadTheFile +
                          _sharedFiles[0].path +
                          S.of(context).areYouSureIHaveThePermissionAndAreYou +
                          '\n${e.toString()}'),
                  actions: [
                    FlatButton(
                        onPressed: () => Clipboard.setData(
                            ClipboardData(text: e.toString())),
                        child: Text(S.of(context).copyErrorMessage)),
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(S.of(context).okay),
                    ),
                  ],
                ));
      }
    } else {
      print('Unsupported runtimeType: ${data.runtimeType.toString()}');
    }
  }
}

Iterable<Widget> generateRecentFileList(Set files, BuildContext context) {
  return List.generate(files.length > 0 ? files.length : 1, (index) {
    if (files.length > 0) {
      Map fileInfo = files.toList()[index];
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
