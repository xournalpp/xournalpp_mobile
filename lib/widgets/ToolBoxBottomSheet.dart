import 'package:flutter/material.dart';
import 'package:xournalpp/generated/l10n.dart';

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
  double _height = 320;

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
              child: ListView(
                padding: const EdgeInsets.all(8),
                shrinkWrap: true,
                children: [
                  Text(
                    S.of(context).tool,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Container(
                    height: 48,
                    child: ListView(
                      shrinkWrap: true,
                      children: [],
                      scrollDirection: Axis.horizontal,
                    ),
                  )
                ],
              ),
            ));
  }
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
