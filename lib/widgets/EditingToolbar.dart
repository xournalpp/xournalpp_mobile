import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:xournalpp/widgets/ToolBoxBottomSheet.dart';

class EditingToolBar extends StatefulWidget {
  final Function(Map<PointerDeviceKind, EditingTool>) onNewDeviceMap;
  final Map<PointerDeviceKind, EditingTool> deviceMap;

  const EditingToolBar({Key key, this.onNewDeviceMap, this.deviceMap})
      : super(key: key);

  @override
  EditingToolBarState createState() => EditingToolBarState();
}

class EditingToolBarState extends State<EditingToolBar> {
  PointerDeviceKind currentDevice;

  @override
  Widget build(BuildContext context) {
    print(currentDevice);
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
              tooltip: 'Pen',
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
              tooltip: 'Highlighter (not implemented)',
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
              tooltip: 'Move',
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
              tooltip: 'Text (not implemented)',
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
              tooltip: 'LaTeX (not implemented)',
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
              tooltip: 'Eraser (not implemented)',
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
              tooltip: 'Whiteout eraser (not implemented)',
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
              tooltip: 'Select (not implemented)',
              elevation: 6,
              backgroundColor:
                  widget.deviceMap[currentDevice] == EditingTool.SELECT
                      ? null
                      : Theme.of(context).cardColor,
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
