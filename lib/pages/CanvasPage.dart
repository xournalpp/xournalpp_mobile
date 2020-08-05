import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:xournalpp/generated/l10n.dart';
import 'package:xournalpp/layer_contents/XppStroke.dart';
import 'package:xournalpp/src/XppFile.dart';
import 'package:xournalpp/widgets/EditingToolbar.dart';
import 'package:xournalpp/widgets/MainDrawer.dart';
import 'package:xournalpp/widgets/PointerListener.dart';
import 'package:xournalpp/widgets/ToolBoxBottomSheet.dart';
import 'package:xournalpp/widgets/XppPageStack.dart';
import 'package:xournalpp/widgets/XppPagesListView.dart';
import 'package:xournalpp/widgets/ZoomableWidget.dart';

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

  /// used fro parent-child communication
  final GlobalKey<XppPageStackState> _pageStackKey = GlobalKey();

  ZoomController _zoomController = ZoomController();

  GlobalKey<PointerListenerState> _pointerListenerKey = GlobalKey();

  Map<PointerDeviceKind, EditingTool> _toolData = {};

  PointerDeviceKind _currentDevice = PointerDeviceKind.touch;

  GlobalKey<EditingToolBarState> _editingToolbarKey = GlobalKey();

  @override
  void initState() {
    _setMetadata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Tooltip(
          message: S.of(context).doubleTapToChange,
          child: GestureDetector(
            onDoubleTap: _showTitleDialog,
            child: Text(widget.file?.title ?? S.of(context).newDocument),
          ),
        ),
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(64),
            child: EditingToolBar(
                key: _editingToolbarKey,
                deviceMap: _toolData,
                onNewDeviceMap: (newDeviceMap) => setState(
                      () => _toolData = newDeviceMap,
                    ))),
      ),
      drawer: MainDrawer(),
      body: Stack(fit: StackFit.expand, children: [
        Hero(
          tag: 'ZoomArea',
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.surface.withOpacity(.5),
                BlendMode.darken),
            child: ZoomableWidget(
              enabled: _toolData[_currentDevice] == null ||
                  _toolData[_currentDevice] == EditingTool.MOVE,
              controller: _zoomController,
              child: Center(
                child: PointerListener(
                  key: _pointerListenerKey,
                  translationMatrix: _zoomController.matrix,
                  toolData: _toolData,
                  onDeviceChange: ({int device, PointerDeviceKind kind}) {
                    //_currentDevice = device;
                    setDefaultDeviceIfNotSet(kind: kind);
                    _currentDevice = kind;
                    _editingToolbarKey.currentState.setState(() {
                      _editingToolbarKey.currentState.currentDevice = kind;
                    });
                  },
                  onNewContent: (newContent) {
                    setState(() {
                      /// TODO: manage layers
                      _file.pages[currentPage].layers[0].content =
                          new List.from(
                              _file.pages[currentPage].layers[0].content)
                            ..add(newContent);
                      _file.pages[currentPage].layers[0].content
                          .forEach((content) {
                        if (content.runtimeType is XppStroke)
                          (content as XppStroke)
                              .points
                              .toList()
                              .forEach((element) {
                            //print(element.x);
                            //print(element.y);
                            //print(element.width);
                          });
                      });
                    });
                    _pageStackKey.currentState
                        .setPageData(_file.pages[currentPage]);
                  },
                  child: Card(
                    elevation: 12,
                    color: Colors.white,
                    child: XppPageStack(
                      /// to communicate from [PointerListener] to [XppPageStack]
                      key: _pageStackKey,
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
                        _zoomController.zoom += .1;
                        if (_zoomController.zoom > 1) _zoomController.zoom = 1;
                      }),
                  SizedBox(
                    height: 128,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Slider(
                        min: 0,
                        max: 1,
                        label: '${_zoomController.zoom * 100} %',
                        value: _zoomController.zoom,
                        onChanged: (newZoom) =>
                            setState(() => _zoomController.zoom = newZoom),
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.remove),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        _zoomController.zoom -= .1;
                        if (_zoomController.zoom < 0) _zoomController.zoom = 0;
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
      floatingActionButtonLocation: kIsWeb
          ? FloatingActionButtonLocation.centerFloat
          : FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
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
                    /*tool: _currentTool,
                          onToolChange: (newTool) {
                            print(newTool);
                            setState(() => _currentTool = newTool);
                          },*/
                    ));
          },
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
}
