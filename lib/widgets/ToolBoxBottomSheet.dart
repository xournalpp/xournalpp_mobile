import 'package:flutter/material.dart';

class ToolBoxBottomSheet extends StatefulWidget {
  @required
  final EditingTool tool;
  final Function(EditingTool) onToolChange;

  const ToolBoxBottomSheet({Key key, this.tool, this.onToolChange})
      : super(key: key);

  @override
  _ToolBoxBottomSheetState createState() => _ToolBoxBottomSheetState();
}

class _ToolBoxBottomSheetState extends State<ToolBoxBottomSheet> {
  EditingTool _currentTool;

  double _height = 320;

  @override
  void initState() {
    _currentTool = widget.tool;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        onClosing: () {
          Navigator.of(context).pop();
        },
        elevation: 16,
        backgroundColor: Theme.of(context).backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        ),
        builder: (context) => Container(
              height: _height,
              padding: const EdgeInsets.all(8),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text(
                    'Tool',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Container(
                    height: 48,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        FloatingActionButton(
                          onPressed: () {
                            setState(() => _currentTool = EditingTool.STYLUS);
                            widget.onToolChange(_currentTool);
                          },
                          child: Icon(Icons.edit),
                          tooltip: 'Pen',
                          elevation: 6,
                          backgroundColor: _currentTool == EditingTool.STYLUS
                              ? null
                              : Theme.of(context).cardColor,
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            setState(() => _currentTool = EditingTool.MOVE);
                            widget.onToolChange(_currentTool);
                          },
                          child: Icon(Icons.pan_tool),
                          tooltip: 'Move',
                          elevation: 6,
                          backgroundColor: _currentTool == EditingTool.MOVE
                              ? null
                              : Theme.of(context).cardColor,
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            setState(() => _currentTool = EditingTool.TEXT);
                            widget.onToolChange(_currentTool);
                          },
                          child: Icon(Icons.keyboard),
                          tooltip: 'Text',
                          elevation: 6,
                          backgroundColor: _currentTool == EditingTool.TEXT
                              ? null
                              : Theme.of(context).cardColor,
                        ),
                      ],
                      scrollDirection: Axis.horizontal,
                    ),
                  )
                ],
              ),
            ));
  }
}

enum EditingTool { STYLUS, TEXT, LATEX, IMAGE, MOVE, SELECT }
