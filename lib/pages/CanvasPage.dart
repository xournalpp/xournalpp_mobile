import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:vector_math/vector_math_64.dart' show Vector4;
import 'package:xournalpp/generated/l10n.dart';
import 'package:xournalpp/src/XppFile.dart';
import 'package:xournalpp/src/XppPage.dart';
import 'package:xournalpp/src/globals.dart';
import 'package:xournalpp/widgets/EditingToolbar.dart';
import 'package:xournalpp/widgets/MainDrawer.dart';
import 'package:xournalpp/widgets/PointerListener.dart';
import 'package:xournalpp/widgets/ToolBoxBottomSheet.dart';
import 'package:xournalpp/widgets/XppPageStack.dart';
import 'package:xournalpp/widgets/XppPagesListView.dart';
import 'package:xournalpp/widgets/ZoomableWidget.dart';

class CanvasPage extends StatefulWidget {
  CanvasPage({Key key, this.file, this.filePath}) : super(key: key);

  final XppFile file;
  final String filePath;

  @override
  _CanvasPageState createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage> {
  XppFile _file;

  int currentPage = 0;

  Color toolColor = Colors.blueGrey;
  double toolWidth = 5;

  TransformationController _zoomController = TransformationController();

  Map<PointerDeviceKind, EditingTool> _toolData = {};
  PointerDeviceKind _currentDevice = PointerDeviceKind.touch;

  /// used fro parent-child communication
  final GlobalKey<XppPageStackState> _pageStackKey = GlobalKey();
  final GlobalKey<EditingToolBarState> _editingToolbarKey = GlobalKey();
  final GlobalKey<PointerListenerState> _pointerListenerKey = GlobalKey();
  final GlobalKey<ZoomableWidgetState> _zoomableKey = GlobalKey();

  double pageScale = 1;

  Completer<BuildContext> scaffoldCompleter = Completer();

  bool savingFile = false;

  @override
  void initState() {
    _setMetadata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      body: Stack(fit: StackFit.expand, children: [
        Hero(
          tag: 'ZoomArea',
          child: ZoomableWidget(
              key: _zoomableKey,
              controller: _zoomController,
              onInteractionUpdate: (details) {
                setState(() => pageScale = _zoomController.value.entry(0, 0));
              },
              child: Center(
                child: Card(
                  elevation: 12,
                  color: Colors.white,
                  child: AspectRatio(
                    aspectRatio: _file.pages[currentPage].pageSize.ratio,
                    child: FittedBox(
                      child: PointerListener(
                        key: _pointerListenerKey,
                        translationMatrix: _zoomController.value,
                        toolData: _toolData,
                        strokeWidth: toolWidth,
                        color: toolColor,
                        onDeviceChange: ({int device, PointerDeviceKind kind}) {
                          //_currentDevice = device;
                          setDefaultDeviceIfNotSet(kind: kind);
                          _currentDevice = kind;
                          _editingToolbarKey.currentState.setState(() {
                            _editingToolbarKey.currentState.currentDevice =
                                kind;
                            _setZoomableState();
                          });
                        },
                        onNewContent: (newContent) {
                          setState(() {
                            /// TODO: manage layers
                            _file.pages[currentPage].layers[0].content =
                                new List.from(
                                    _file.pages[currentPage].layers[0].content)
                                  ..add(newContent);
                          });
                          _pageStackKey.currentState
                              .setPageData(_file.pages[currentPage]);
                        },
                        child: XppPageStack(
                          /// to communicate from [PointerListener] to [XppPageStack]
                          key: _pageStackKey,
                          page: _file.pages[currentPage],
                        ),
                      ),
                    ),
                  ),
                ),
              ))
          /*ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.surface.withOpacity(.5),
                      BlendMode.darken),
                  child: child,
                )*/
          ,
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: Tooltip(
            message: '${(pageScale * 100).round()} %',
            child: SizedBox(
              width: 64,
              child: Column(
                children: [
                  IconButton(
                      icon: Icon(Icons.add),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        this._setScale(pageScale + 0.1);
                      }),
                  SizedBox(
                    height: 128,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Slider(
                        min: 0.1,
                        max: 5,
                        label: '${(pageScale * 100).round()} %',
                        value: pageScale,
                        onChanged: (newZoom) {
                          this._setScale(newZoom);
                        },
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.remove),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        this._setScale(pageScale - 0.1);
                      }),
                ],
              ),
            ),
          ),
        )
      ]),
      appBar: AppBar(
        title: Tooltip(
          message: S.of(context).doubleTapToChange,
          child: GestureDetector(
            onDoubleTap: _showTitleDialog,
            child: Builder(
              /// just need a builder here to provide a valid context for background tasks
              builder: (context) {
                if (!scaffoldCompleter.isCompleted)
                  scaffoldCompleter.complete(context);
                return Text(widget.file?.title ?? S.of(context).newDocument);
              },
            ),
          ),
        ),
        actions: [
          savingFile
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(Icons.save),
                  onPressed: saveFile,
                  tooltip: S.of(context).save,
                ),
          PopupMenuButton<String>(
            onSelected: (item) async {
              if (item == S.of(context).saveAs) saveFile(export: true);
            },
            itemBuilder: (BuildContext context) {
              return {S.of(context).saveAs}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(64),
            child: EditingToolBar(
                key: _editingToolbarKey,
                deviceMap: _toolData,
                color: toolColor,
                onWidthChange: (newWidth) {
                  setState(() {
                    toolWidth = newWidth *
                        2; // average pressure is 0.5, so multiplying by 2
                  });
                },
                onColorChange: (newColor) {
                  setState(() {
                    toolColor = newColor;
                  });
                },
                onNewDeviceMap: (newDeviceMap) => setState(
                      () {
                        _toolData = newDeviceMap;
                        _setZoomableState();
                      },
                    ))),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: kIsWeb ? null : CircularNotchedRectangle(),
        child: Container(
            color: Theme.of(context).colorScheme.surface,
            constraints: BoxConstraints(maxHeight: 100),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                XppPagesListView(
                    pages: _file.pages,
                    onPageChange: (newPage) =>
                        setState(() => currentPage = newPage),
                    onPageDelete: (deletedIndex) => setState(() {
                          _file.pages.removeAt(deletedIndex);
                          if (_file.pages.length >= currentPage)
                            currentPage = _file.pages.length - 1;
                          if (_file.pages.isEmpty) {
                            _file.pages.add(XppPage.empty());
                            currentPage = 0;
                            scaffoldCompleter.future.then((scaffoldContext) =>
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(S
                                        .of(context)
                                        .thereWereNoMorePagesWeAddedOne))));
                          }
                        }),
                    onPageMove: (initialIndex, movedTo) => setState(() {
                          final page = _file.pages[initialIndex];
                          _file.pages.removeAt(initialIndex);
                          _file.pages.insert(movedTo - 1, page);
                        }),
                    currentPage: currentPage),
                FloatingActionButton(
                  heroTag: 'AddXppPage',
                  onPressed: () => setState(() {
                    currentPage++;
                    _file.pages.insert(currentPage, XppPage.empty());

                    _pageStackKey.currentState
                        .setPageData(_file.pages[currentPage]);
                  }),
                  child: Icon(Icons.add),
                  tooltip: S.of(context).addPage,
                )
              ],
            )),
      ),
      floatingActionButtonLocation: kIsWeb
          ? FloatingActionButtonLocation.centerFloat
          : FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              elevation: 16,
              backgroundColor: Theme.of(context).backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
              ),
              context: context,
              builder: (context) => ToolBoxBottomSheet(
                    onBackgroundChange: (newBackground) {
                      newBackground.size = _file.pages[currentPage].pageSize;
                      setState(() =>
                          _file.pages[currentPage].background = newBackground);
                    },
                  ));
        },
        tooltip: S.of(context).tools,
        child: Icon(Icons.format_paint),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _setMetadata() {
    _file = widget.file ?? XppFile.empty();
    //if (widget.filePath != null) filePath = widget.filePath;
  }

  Future _showTitleDialog() {
    return showDialog(
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

  void setDefaultDeviceIfNotSet({PointerDeviceKind kind}) {
    if (!_toolData.keys.contains(kind)) {
      EditingTool tool;
      switch (kind) {
        case PointerDeviceKind.touch:
          tool = EditingTool.MOVE;
          break;
        case PointerDeviceKind.invertedStylus:
          tool = EditingTool.ERASER;
          break;
        case PointerDeviceKind.stylus:
          tool = EditingTool.STYLUS;
          break;
        case PointerDeviceKind.mouse:
          tool = EditingTool.SELECT;
          break;
        default:
          tool = EditingTool.MOVE;
          break;
      }
      _toolData[kind] = tool;
    }
  }

  void _setZoomableState() {
    _zoomableKey.currentState.setState(() => _zoomableKey.currentState.enabled =
        _toolData[_currentDevice] == null ||
            _toolData[_currentDevice] == EditingTool.MOVE);
  }

  void _setScale(double newZoom) {
    newZoom = max(.1, min(5, newZoom));
    if (newZoom != pageScale) {
      pageScale = newZoom;
      _zoomController.value.setDiagonal(Vector4(newZoom, newZoom, 1, 1));
      setState(() {});
    }
  }

  void saveFile({bool export = false}) async {
    setState(() {
      savingFile = true;
    });
    ScaffoldFeatureController snackBarController =
        Scaffold.of(await scaffoldCompleter.future).showSnackBar(
      SnackBar(
        content: Text(S.of(context).savingFile),
        duration: Duration(days: 999),
      ),
    );
    try {
      if (_file.title == null) await _showTitleDialog();
      String path = _file.title + '.xopp';
      FilePickerCross file = FilePickerCross(_file.toUint8List(),
          type: FileTypeCross.custom, fileExtension: 'xopp', path: path);
      if (export)
        file.exportToStorage();
      else
        file.saveToPath(path: path);

      /// starting async task to save recent files list
      SharedPreferences.getInstance().then((prefs) {
        String jsonData = prefs.getString(PreferencesKeys.kRecentFiles) ?? '[]';
        Set files = (jsonDecode(jsonData) as Iterable).toSet();
        if (files.where((element) => element['path'] == path).length < 1)
          files.add({
            'preview': base64Encode(kTransparentImage),
            'name': _file.title,
            'path': path
          });
        jsonData = jsonEncode(files.toList());
        prefs.setString(PreferencesKeys.kRecentFiles, jsonData);
      });
      snackBarController.close();
      setState(() {
        savingFile = false;
      });
      Scaffold.of(await scaffoldCompleter.future).showSnackBar(
        SnackBar(
          content: Text(S.of(context).successfullySaved),
        ),
      );
    } catch (e) {
      print(e);
      snackBarController.close();
      setState(() {
        savingFile = false;
      });
      Scaffold.of(await scaffoldCompleter.future).showSnackBar(
        SnackBar(
          content:
              Text(S.of(context).unfortunatelyThereWasAnErrorSavingThisFile),
        ),
      );
    }
  }
}
