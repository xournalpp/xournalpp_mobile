import 'package:flutter/material.dart';
import 'package:xournalpp/src/xournalppFile.dart';
import 'package:zoom_widget/zoom_widget.dart';

import 'generated/l10n.dart';
import 'widgets/drawer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Xournal++',
      localizationsDelegates: [S.delegate],
      supportedLocales: [Locale('en'), Locale('de')],
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.deepPurple,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CanvasPage(),
    );
  }
}

class CanvasPage extends StatefulWidget {
  CanvasPage({Key key, this.file}) : super(key: key);

  final XppFile file;

  @override
  _CanvasPageState createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage> {
  XppFile _file;
  double padding = 16;

  int currentPage = 0;

  void _openFile() {
    XppFile.open().then((file) => setState(() {
          _file = file;
        }));
  }

  @override
  void initState() {
    _setMetadata();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = 0;
    _file.pages.forEach((element) {
      if (element.pageSize.width > width) width = element.pageSize.width;
    });
    width += 2 * padding;

    double height = padding;

    _file.pages.forEach((element) {
      height += element.pageSize.height + padding;
    });

    final page = _file.pages[currentPage];
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text(widget.file?.title ?? S.of(context).newDocument),
          onDoubleTap: _showTitleDialog,
          onLongPress: _showTitleDialog,
        ),
      ),
      drawer: MainDrawer(),
      body: Zoom(
        width: page.pageSize.width * 5,
        height: page.pageSize.height * 5,
        initZoom: 1,
        child: Center(
          child: SizedBox(
            width: page.pageSize.width,
            height: page.pageSize.height,
            child: Transform.scale(
              scale: 5,
              child: Container(
                child: Text('Test'),
                color: Colors.green,
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: Colors.grey,
          constraints: BoxConstraints(maxHeight: 100),
          child: ListView.builder(
            itemBuilder: (c, i) {
              final page = _file.pages[i];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: GestureDetector(
                    onTap: () => setState(() => currentPage = i),
                    child: AspectRatio(
                      aspectRatio: page.pageSize.width / page.pageSize.height,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: (currentPage == i)
                                ? Border.all(color: Colors.red)
                                : null),
                        child: Text('Test'),
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: _file.pages.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openFile,
        tooltip: 'Open file',
        child: Icon(Icons.insert_drive_file),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _setMetadata() {
    _file = widget.file ?? XppFile.empty();
  }

  void _showTitleDialog() {
    showDialog(
        context: context,
        builder: (context) {
          TextEditingController titleController =
              TextEditingController(text: _file.title);
          return AlertDialog(
            title: Text('Set document title'),
            content: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'New title')),
            ),
            actions: [
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    _file.title = titleController.text;
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Apply'),
              ),
            ],
          );
        });
  }
}
