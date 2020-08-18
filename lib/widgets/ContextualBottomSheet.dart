import 'package:flutter/material.dart';

class ContextualBottomSheet extends StatelessWidget {
  final List<Widget> children;

  const ContextualBottomSheet({Key key, this.children}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {
        Navigator.of(context).pop();
      },
      elevation: 16,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(shrinkWrap: true, children: children),
      ),
    );
  }
}
