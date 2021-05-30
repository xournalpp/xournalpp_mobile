import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
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
  CanvasPage({Key? key, this.file, this.filePath}) : super(key: key);

  @required
  final XppFile? file;
  final String? filePath;

  @override
  _CanvasPageState createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage> with TickerProviderStateMixin {
  XppFile? _file;

  int currentPage = 0;

  Color toolColor = Colors.blueGrey;
  double toolWidth = 5;

  TransformationController _zoomController = TransformationController();

  Map<PointerDeviceKind?, EditingTool> _toolData = {};
  PointerDeviceKind? _currentDevice = PointerDeviceKind.touch;

  /// used fro parent-child communication
  final GlobalKey<XppPageStackState> _pageStackKey = GlobalKey();
  final GlobalKey<EditingToolBarState> _editingToolbarKey = GlobalKey();
  final GlobalKey<PointerListenerState> _pointerListenerKey = GlobalKey();
  final GlobalKey<ZoomableWidgetState> _zoomableKey = GlobalKey();
  final GlobalKey<XppPagesListViewState> pageListViewKey = GlobalKey();

  double pageScale = 1;

  bool savingFile = false;

  Animation<Matrix4>? _animationReset;
  late AnimationController _controllerReset;

  @override
  void initState() {
    _setMetadata();
    super.initState();
    _controllerReset = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
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
              onInteractionStart: _onInteractionStart,
              onInteractionUpdate: (details) {
                //print(details);
                setState(() => pageScale = _zoomController.value.entry(0, 0));
              },
              child: Center(
                child: Card(
                  elevation: 12,
                  color: Colors.white,
                  child: AspectRatio(
                    aspectRatio: _file!.pages![currentPage].pageSize!.ratio,
                    child: FittedBox(
                      child: PointerListener(
                        key: _pointerListenerKey,
                        translationMatrix: _zoomController.value,
                        toolData: _toolData,
                        strokeWidth: toolWidth,
                        color: toolColor,
                        onDeviceChange: (
                            {int? device, PointerDeviceKind? kind}) {
                          //_currentDevice = device;
                          setDefaultDeviceIfNotSet(kind: kind);
                          _currentDevice = kind;
                          _editingToolbarKey.currentState!.setState(() {
                            _editingToolbarKey.currentState!.currentDevice =
                                kind;
                            _setZoomableState();
                          });
                        },
                        removeLastContent: () {
                          _file!.pages![currentPage].layers![0].content!
                              .removeLast();
                        },
                        filterEraser: ({Offset? coordinates, double? radius}) {
                          // if we would execute the removal instantly, we would destroy the order of the strokes
                          List<Function> removalFunctions = [];
                          _file!.pages![currentPage].layers![0].content!
                              .forEach((stroke) {
                            final delta = stroke!.eraseWhere(
                                coordinates: coordinates, radius: radius);
                            if (!delta.affected) return;

                            removalFunctions.add(() {
                              final int index = _file!
                                  .pages![currentPage].layers![0].content!
                                  .indexOf(stroke);
                              _file!.pages![currentPage].layers![0].content!
                                  .removeAt(index);
                              _file!.pages![currentPage].layers![0].content!
                                  .insertAll(index, delta.newContent);
                            });
                          });
                          if (removalFunctions.isNotEmpty) {
                            removalFunctions.forEach((element) {
                              element();
                            });
                            setState(() {});
                          }
                        },
                        onNewContent: (newContent) {
                          /// TODO: manage layers
                          _file!.pages![currentPage].layers![0].content =
                              new List.from(_file!
                                  .pages![currentPage].layers![0].content!)
                                ..add(newContent);

                          _pageStackKey.currentState!
                              .setPageData(_file!.pages![currentPage]);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: XppPageStack(
                            /// to communicate from [PointerListener] to [XppPageStack]
                            key: _pageStackKey,
                            page: _file!.pages![currentPage],
                          ),
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
                          _setScale(newZoom, animate: false);
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
              child: Text(widget.file?.title ?? S.of(context).newDocument)),
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
              if (item == S.of(context).sharePage) shareScreenshot();
            },
            itemBuilder: (BuildContext context) {
              return {
                S.of(context).saveAs,
                if (!kIsWeb) S.of(context).sharePage
              }.map((String choice) {
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
                        _toolData = newDeviceMap!;
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
                    key: pageListViewKey,
                    pages: _file!.pages,
                    onPageChange: (newPage) {
                      setState(() => currentPage = newPage);
                      _pageStackKey.currentState!
                          .setPageData(_file!.pages![currentPage]);
                    },
                    onPageDelete: (deletedIndex) => setState(() {
                          _file!.pages!.removeAt(deletedIndex);
                          if (_file!.pages!.length >= currentPage)
                            currentPage = _file!.pages!.length - 1;
                          if (_file!.pages!.isEmpty) {
                            _file!.pages!.add(XppPage.empty(
                                background: Theme.of(context).cardColor));
                            currentPage = 0;

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(S
                                    .of(context)
                                    .thereWereNoMorePagesWeAddedOne)));
                          }
                        }),
                    onPageMove: (initialIndex, movedTo) => setState(() {
                          final page = _file!.pages![initialIndex];
                          _file!.pages!.removeAt(initialIndex);
                          _file!.pages!.insert(movedTo - 1, page);
                        }),
                    currentPage: currentPage),
                FloatingActionButton(
                  heroTag: 'AddXppPage',
                  onPressed: () => setState(() {
                    currentPage++;
                    _file!.pages!.insert(currentPage,
                        XppPage.empty(background: Theme.of(context).cardColor));

                    _pageStackKey.currentState!
                        .setPageData(_file!.pages![currentPage]);
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
                      newBackground.size = _file!.pages![currentPage].pageSize;
                      setState(() => _file!.pages![currentPage].background =
                          newBackground);
                    },
                  ));
        },
        tooltip: S.of(context).tools,
        child: Icon(Icons.format_paint),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _setMetadata() {
    _file = widget.file;
    //if (widget.filePath != null) filePath = widget.filePath;
  }

  Future<void> _showTitleDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          TextEditingController titleController =
              TextEditingController(text: _file!.title);
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
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(S.of(context).cancel),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _file!.title = titleController.text;
                  });
                  Navigator.of(context).pop();
                },
                child: Text(S.of(context).apply),
              ),
            ],
          );
        });
  }

  void setDefaultDeviceIfNotSet({PointerDeviceKind? kind}) {
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
    final zoomEnabled = _toolData[_currentDevice] == null ||
        _toolData[_currentDevice] == EditingTool.MOVE;
    _zoomableKey.currentState!
        .setState(() => _zoomableKey.currentState!.enabled = zoomEnabled);
    _pointerListenerKey.currentState!.setState(() {
      _pointerListenerKey.currentState!.drawingEnabled = !zoomEnabled;
    });
  }

  void _setScale(double newZoom, {animate = true}) {
    newZoom = max(.1, min(5, newZoom));
    if (newZoom != pageScale) {
      // final translation =
      //     _zoomController.value.getTranslation() * newZoom / pageScale;
      pageScale = newZoom;
      if (animate) {
        _animateTransformation(_zoomController.value.clone()
          ..setDiagonal(Vector4(newZoom, newZoom, 1, 1)));
        // ..setTranslation(translation));
      } else {
        _zoomController.value.setDiagonal(Vector4(newZoom, newZoom, 1, 1));
        // _zoomController.value.setTranslation(translation);
      }
      setState(() {});
    }
  }

  void shareScreenshot() async {
    Uint8List imageBytes =
        await pageListViewKey.currentState!.getPng(currentPage);
    String fileName = await (FilePickerCross(imageBytes,
            fileExtension: '.png',
            path: '/export/' +
                (_file?.title ?? S.of(context).newFile) +
                ' ${currentPage + 1}' +
                '.png')
        .exportToStorage() as FutureOr<String>);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).successfullyShared + ' ' + fileName)));
  }

  void saveFile({bool export = false}) async {
    setState(() {
      savingFile = true;
    });
    ScaffoldFeatureController snackBarController =
        ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.of(context).savingFile),
        duration: Duration(days: 999),
      ),
    );
    //try {
    if (_file!.title == null) await _showTitleDialog();
    String path = _file!.title! + '.xopp';
    _file!.previewImage = kIsWeb
        ? kTransparentImage
        : await pageListViewKey.currentState!.getPng(0);
    FilePickerCross file = _file!.toFilePickerCross(filePath: path);
    if (export)
      file.exportToStorage();
    else
      file.saveToPath(path: path);

    /// starting async task to save recent files list
    SharedPreferences.getInstance().then((prefs) {
      String jsonData = prefs.getString(PreferencesKeys.kRecentFiles) ?? '[]';
      Set files = (jsonDecode(jsonData) as Iterable).toSet();
      files.removeWhere((element) => element['path'] == path);
      files.add({
        'preview': base64Encode(_file!.previewImage!),
        'name': _file!.title,
        'path': path
      });
      jsonData = jsonEncode(files.toList());
      prefs.setString(PreferencesKeys.kRecentFiles, jsonData);
    });
    snackBarController.close();
    setState(() {
      savingFile = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.of(context).successfullySaved),
      ),
    );
    /*} catch (e) {
      snackBarController.close();
      setState(() {
        savingFile = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(S.of(context).unfortunatelyThereWasAnErrorSavingThisFile),
        ),
      );
    }*/
  }

  void _onAnimationReset() {
    _zoomController.value = _animationReset!.value;
    if (!_controllerReset.isAnimating) {
      _animationReset?.removeListener(_onAnimationReset);
      _animationReset = null;
      _controllerReset.reset();
    }
  }

  void _animateTransformation(Matrix4 animateTo) {
    _controllerReset.reset();
    _animationReset = Matrix4Tween(
      begin: _zoomController.value,
      end: animateTo,
    ).animate(_controllerReset);
    _animationReset!.addListener(_onAnimationReset);
    _controllerReset.forward();
  }

  void _onInteractionStart(ScaleStartDetails details) {
    // If the user tries to cause a transformation while the reset animation is
    // running, cancel the reset animation.
    if (_controllerReset.status == AnimationStatus.forward) {
      _controllerReset.stop();
      _animationReset?.removeListener(_onAnimationReset);
      _animationReset = null;
      // assign animateTo value to skip to end
      // _zoomController.value = _animateTo;
    }
  }

  @override
  void dispose() {
    _controllerReset.dispose();
    super.dispose();
  }
}
