import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:xournalpp/src/XppBackground.dart';
import 'package:xournalpp/src/XppPage.dart';

class ToolBoxBottomSheet extends StatefulWidget {
  @required
  final EditingTool tool;
  final Function(EditingTool) onToolChange;
  final Function(XppBackground) onBackgroundChange;

  const ToolBoxBottomSheet(
      {Key key, this.tool, this.onToolChange, this.onBackgroundChange})
      : super(key: key);

  @override
  _ToolBoxBottomSheetState createState() => _ToolBoxBottomSheetState();
}

class _ToolBoxBottomSheetState extends State<ToolBoxBottomSheet> {
  double _height = 320;

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        onClosing: () {
          Navigator.of(context).pop();
        },
        elevation: 16,
//        backgroundColor: Theme.of(context).backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        ),
        builder: (context) => Container(
              height: _height,
              child: ListView(
                padding: const EdgeInsets.all(8),
                shrinkWrap: true,
                children: [
                  Text(
                    'Page background',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Container(
                    height: 128,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                child: Card(
                                  child: SizedBox(
                                      width: 96,
                                      height: 96,
                                      child: XppBackground.none.render()),
                                ),
                                onTap: () => widget
                                    .onBackgroundChange(XppBackground.none),
                              ),
                              Text('None')
                            ],
                          ),
                        ),
                        AspectRatio(
                          aspectRatio: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                child: Card(
                                  child: XppBackgroundSolidPlain(
                                          size: XppPageSize(
                                              width: 96, height: 96),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary)
                                      .render(),
                                ),
                                onTap: () async => widget.onBackgroundChange(
                                    XppBackgroundSolidPlain(
                                        color: await pickBackgroundColor())),
                              ),
                              Text('Color')
                            ],
                          ),
                        ),
                        AspectRatio(
                          aspectRatio: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                child: Card(
                                  child: XppBackgroundSolidLined(
                                          size: XppPageSize(
                                              width: 96, height: 96))
                                      .render(),
                                ),
                                onTap: () async => widget.onBackgroundChange(
                                    XppBackgroundSolidLined(
                                        color: await pickBackgroundColor())),
                              ),
                              Text('Lined')
                            ],
                          ),
                        ),
                        AspectRatio(
                          aspectRatio: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Card(
                                child: XppBackground.none.render(),
                              ),
                              Text('Ruled' + ' (not implemented)')
                            ],
                          ),
                        ),
                        AspectRatio(
                          aspectRatio: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Card(
                                child: XppBackground.none.render(),
                              ),
                              Text('Math' + ' (not implemented)')
                            ],
                          ),
                        ),
                        AspectRatio(
                          aspectRatio: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Card(
                                child: XppBackground.none.render(),
                              ),
                              Text('PDF' + ' (not implemented)')
                            ],
                          ),
                        ),
                        AspectRatio(
                          aspectRatio: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Card(
                                child: XppBackground.none.render(),
                              ),
                              Text('Image' + ' (not implemented)')
                            ],
                          ),
                        ),
                      ],
                      scrollDirection: Axis.horizontal,
                    ),
                  )
                ],
              ),
            ));
  }

  Future<Color> pickBackgroundColor() async => await showDialog(
      context: context,
      child: AlertDialog(
        content: MaterialPicker(
          pickerColor: Colors.white,
          onColorChanged: (newColor) => Navigator.of(context).pop(newColor),
        ),
      ));
}

enum EditingTool {
  STYLUS,
  HIGHLIGHT,
  TEXT,
  LATEX,
  IMAGE,
  MOVE,
  SELECT,
  ERASER,
  WHITEOUT
}
