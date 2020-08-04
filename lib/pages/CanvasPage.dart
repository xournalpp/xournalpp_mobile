import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:xournalpp/generated/l10n.dart';
import 'package:xournalpp/src/XppFile.dart';
import 'package:xournalpp/widgets/XppPageStack.dart';
import 'package:xournalpp/widgets/XppPagesListView.dart';
import 'package:xournalpp/widgets/drawer.dart';
import 'package:zoom_widget/zoom_widget.dart';

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
    // trying to load fitting locale
    if (['en', 'de'].contains(window.locale.languageCode))
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
        Hero(
          tag: 'ZoomArea',
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.surface.withOpacity(.5),
                BlendMode.darken),
            child: Zoom(
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
                      color: Theme.of(context).primaryColor,
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
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        _currentZoom -= .1;
                        if (_currentZoom < 0) _currentZoom = 0;
                      }),
                ],
              ),
            ),
          ),
        )
      ]),
      bottomNavigationBar: BottomAppBar(
        shape: kIsWeb ? null : CircularNotchedRectangle(),
        child: Container(
            color: Theme.of(context).colorScheme.surface,
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
                  autofocus: true,
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
