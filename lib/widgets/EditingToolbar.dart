import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:xournalpp/generated/l10n.dart';
import 'package:xournalpp/widgets/ToolBoxBottomSheet.dart';

class EditingToolBar extends StatefulWidget {
  final Function(Map<PointerDeviceKind, EditingTool>) onNewDeviceMap;
  final Function(double newWidth) onWidthChange;
  final Map<PointerDeviceKind, EditingTool> deviceMap;
  final Color color;
  final Function(Color) onColorChange;

  const EditingToolBar(
      {Key key,
      this.onNewDeviceMap,
      this.deviceMap,
      this.onWidthChange,
      this.color,
      this.onColorChange})
      : super(key: key);

  @override
  EditingToolBarState createState() => EditingToolBarState();
}

class EditingToolBarState extends State<EditingToolBar> {
  PointerDeviceKind currentDevice;

  double width = 2.5;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.all(8),
      alignment: Alignment.centerLeft,
      child: MouseRegion(
        onHover: (event) {
          currentDevice = event.kind;
        },
        child: ListView(
          children: [
            FloatingActionButton(
              heroTag: EditingTool.STYLUS,
              onPressed: () {
                setState(
                    () => widget.deviceMap[currentDevice] = EditingTool.STYLUS);
                saveDeviceTable();
              },
              child: Icon(Icons.edit),
              tooltip: S.of(context).pen,
              elevation: 6,
              backgroundColor:
                  widget.deviceMap[currentDevice] == EditingTool.STYLUS
                      ? null
                      : Theme.of(context).cardColor,
            ),
            FloatingActionButton(
              heroTag: EditingTool.HIGHLIGHT,
              onPressed: () {
                setState(() =>
                    widget.deviceMap[currentDevice] = EditingTool.HIGHLIGHT);
                saveDeviceTable();
              },
              child: Icon(Icons.brush),
              tooltip: S.of(context).highlighter,
              elevation: 6,
              backgroundColor:
                  widget.deviceMap[currentDevice] == EditingTool.HIGHLIGHT
                      ? null
                      : Theme.of(context).cardColor,
            ),
            FloatingActionButton(
              heroTag: EditingTool.MOVE,
              onPressed: () {
                setState(
                    () => widget.deviceMap[currentDevice] = EditingTool.MOVE);
                saveDeviceTable();
              },
              child: Icon(Icons.pan_tool),
              tooltip: S.of(context).move,
              elevation: 6,
              backgroundColor:
                  widget.deviceMap[currentDevice] == EditingTool.MOVE
                      ? null
                      : Theme.of(context).cardColor,
            ),
            FloatingActionButton(
              heroTag: EditingTool.TEXT,
              onPressed: () {
                setState(
                    () => widget.deviceMap[currentDevice] = EditingTool.TEXT);
                saveDeviceTable();
              },
              child: Icon(Icons.keyboard),
              tooltip: S.of(context).textNotImplemented,
              elevation: 6,
              backgroundColor:
                  widget.deviceMap[currentDevice] == EditingTool.TEXT
                      ? null
                      : Theme.of(context).cardColor,
            ),
            FloatingActionButton(
              heroTag: EditingTool.LATEX,
              onPressed: () {
                setState(
                    () => widget.deviceMap[currentDevice] = EditingTool.LATEX);
                saveDeviceTable();
              },
              child: Icon(Icons.science),
              tooltip: S.of(context).latexNotImplemented,
              elevation: 6,
              backgroundColor:
                  widget.deviceMap[currentDevice] == EditingTool.LATEX
                      ? null
                      : Theme.of(context).cardColor,
            ),
            FloatingActionButton(
              heroTag: EditingTool.ERASER,
              onPressed: () {
                setState(
                    () => widget.deviceMap[currentDevice] = EditingTool.ERASER);
                saveDeviceTable();
              },
              child: Icon(Icons.backspace),
              tooltip: S.of(context).eraser,
              elevation: 6,
              backgroundColor:
                  widget.deviceMap[currentDevice] == EditingTool.ERASER
                      ? null
                      : Theme.of(context).cardColor,
            ),
            FloatingActionButton(
              heroTag: EditingTool.WHITEOUT,
              onPressed: () {
                setState(() =>
                    widget.deviceMap[currentDevice] = EditingTool.WHITEOUT);
                saveDeviceTable();
              },
              child: Icon(Icons.format_paint),
              tooltip: S.of(context).whiteoutEraserNotImplemented,
              elevation: 6,
              backgroundColor:
                  widget.deviceMap[currentDevice] == EditingTool.WHITEOUT
                      ? null
                      : Theme.of(context).cardColor,
            ),
            FloatingActionButton(
              heroTag: EditingTool.IMAGE,
              onPressed: () {
                setState(
                    () => widget.deviceMap[currentDevice] = EditingTool.IMAGE);
                saveDeviceTable();
              },
              child: Icon(Icons.add_photo_alternate),
              tooltip: 'Image (not implemented)',
              elevation: 6,
              backgroundColor:
                  widget.deviceMap[currentDevice] == EditingTool.IMAGE
                      ? null
                      : Theme.of(context).cardColor,
            ),
            FloatingActionButton(
              heroTag: EditingTool.SELECT,
              onPressed: () {
                setState(
                    () => widget.deviceMap[currentDevice] = EditingTool.SELECT);
                saveDeviceTable();
              },
              child: Icon(Icons.tab_unselected),
              tooltip: S.of(context).selectNotImplemented,
              elevation: 6,
              backgroundColor:
                  widget.deviceMap[currentDevice] == EditingTool.SELECT
                      ? null
                      : Theme.of(context).cardColor,
            ),
            Container(
              constraints: BoxConstraints(maxWidth: 256, maxHeight: 48),
              child: Slider(
                  activeColor: Theme.of(context).colorScheme.secondary,
                  label: S.of(context).strokeWidth + ' $width',
                  inactiveColor: Theme.of(context).colorScheme.onPrimary,
                  value: width,
                  min: 0.1,
                  max: 30,
                  onChanged: (newWidth) {
                    setState(() {
                      width = newWidth;
                    });
                    widget.onWidthChange(newWidth);
                  }),
            ),
            FloatingActionButton(
              heroTag: MaterialPicker,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: Text(S.of(context).selectColor),
                    content: SingleChildScrollView(
                      child: MaterialPicker(
                        pickerColor: widget.color,
                        onColorChanged: (color) {
                          widget.onColorChange(color);
                          Navigator.of(context).pop();
                        },
                        enableLabel: true, // only on portrait mode
                      ),
                    ),
                    /*actions: <Widget>[
                      TextButton(
                        child: const Text('Save'),
                        onPressed: () {
                          setState(() => currentColor = pickerColor);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],*/
                  ),
                );
              },
              child: Icon(Icons.color_lens),
              tooltip: S.of(context).color,
              elevation: 6,
              backgroundColor: widget.color,
            ),
          ],
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  void saveDeviceTable() => widget.onNewDeviceMap(widget.deviceMap);
}
