import 'package:catcher/catcher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:xournalpp/src/XppFile.dart';
import 'package:xournalpp/src/XppPage.dart';
import 'package:xournalpp/widgets/XppPageStack.dart';
import 'package:zoom_widget/zoom_widget.dart';

import 'generated/l10n.dart';
import 'widgets/drawer.dart';

void main() {
  /// STEP 1. Create catcher configuration.
  /// Debug configuration with dialog report mode and console handler. It will show dialog and once user accepts it, error will be shown   /// in console.
  CatcherOptions debugOptions = CatcherOptions(DialogReportMode(), [
    ConsoleHandler(),
  ]);

  /// Release configuration. Same as above, but once user accepts dialog, user will be prompted to send email with crash to support.
  CatcherOptions releaseOptions = CatcherOptions(DialogReportMode(), [
    EmailManualHandler(["the-one@with-the-braid.cf"])
  ]);

  /// STEP 2. Pass your root widget (MyApp) along with Catcher configuration:
  Catcher(MyApp(), debugConfig: debugOptions, releaseConfig: releaseOptions);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kIsWeb ? 'Xournal++ Web' : 'Xournal++ - mobile edition',
      localizationsDelegates: [S.delegate],
      supportedLocales: [Locale('en'), Locale('de')],
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
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

  double _currentZoom = 1;

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

    return Scaffold(
      appBar: AppBar(
        title: Tooltip(
          message: S.of(context).doubleTapToChange,
          child: GestureDetector(
            onDoubleTap: _showTitleDialog,
            child: Text(widget.file?.title ?? S.of(context).newDocument),
          ),
        ),
      ),
      drawer: MainDrawer(),
      body: Stack(children: [
        Zoom(
          width: _file.pages[currentPage].pageSize.width * 5,
          height: _file.pages[currentPage].pageSize.height * 5,
          initZoom: _currentZoom,
          child: Center(
            child: SizedBox(
              width: _file.pages[currentPage].pageSize.width,
              height: _file.pages[currentPage].pageSize.height,
              child: Transform.scale(
                scale: 5,
                child: XppPageStack(
                  page: _file.pages[currentPage],
                ),
              ),
            ),
          ),
        ),
        Positioned(
            bottom: 16,
            right: 16,
            child: Tooltip(
              message: S.of(context).notWorkingYet,
              child: SizedBox(
                width: 64,
                child: Column(
                  children: [
                    IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          _currentZoom += .1;
                          if (_currentZoom > 1) _currentZoom = 1;
                        }),
                    SizedBox(
                      height: 128,
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Slider(
                          min: 0,
                          max: 1,
                          label: '${_currentZoom * 100} %',
                          value: _currentZoom,
                          onChanged: (newZoom) =>
                              setState(() => _currentZoom = newZoom),
                        ),
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          _currentZoom -= .1;
                          if (_currentZoom < 0) _currentZoom = 0;
                        }),
                  ],
                ),
              ),
            ))
      ]),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
            color: Colors.grey,
            constraints: BoxConstraints(maxHeight: 100),
            child: XppPagesListView(
              pages: _file.pages,
              onPageChange: (newPage) => setState(() => currentPage = newPage),
            )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () => Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(S.of(context).toolboxNotImplementedYet),
          )),
          tooltip: S.of(context).tools,
          child: Icon(Icons.format_paint),
        ),
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
            title: Text(S.of(context).setDocumentTitle),
            content: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: S.of(context).newTitle)),
            ),
            actions: [
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(S.of(context).cancel),
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    _file.title = titleController.text;
                  });
                  Navigator.of(context).pop();
                },
                child: Text(S.of(context).apply),
              ),
            ],
          );
        });
  }
}

class XppPagesListView extends StatefulWidget {
  @required
  final List<XppPage> pages;
  @required
  final Function(int pageNumber) onPageChange;
  final int initialPage;

  const XppPagesListView(
      {Key key, this.pages, this.onPageChange, this.initialPage = 0})
      : super(key: key);
  @override
  _XppPagesListViewState createState() => _XppPagesListViewState();
}

class _XppPagesListViewState extends State<XppPagesListView> {
  int currentPage;

  @override
  void initState() {
    currentPage = widget.initialPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (c, i) {
        final page = widget.pages[i];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: GestureDetector(
              onTap: () {
                setState(() => currentPage = i);
                widget.onPageChange(i);
              },
              child: Card(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: (currentPage == i)
                          ? Border.all(color: Colors.red)
                          : Border.all(color: Color.fromARGB(1, 0, 0, 0)),
                      borderRadius: BorderRadius.circular(4)),
                  child: AspectRatio(
                    aspectRatio: page.pageSize.width / page.pageSize.height,
                    child: FittedBox(
                      child: XppPageStack(
                        page: page,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      itemCount: widget.pages.length,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
    );
  }
}
