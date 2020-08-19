import 'package:flutter/material.dart';
import 'package:xournalpp/generated/l10n.dart';
import 'package:xournalpp/src/XppPage.dart';
import 'package:xournalpp/widgets/ContextualBottomSheet.dart';

import 'XppPageStack.dart';

class XppPagesListView extends StatefulWidget {
  @required
  final List<XppPage> pages;
  @required
  final Function(int pageNumber) onPageChange;
  final Function(int pageNumber) onPageDelete;
  final Function(int pageNumber, int newIndex) onPageMove;
  final int currentPage;

  const XppPagesListView(
      {Key key,
      this.pages,
      this.onPageChange,
      this.currentPage = 0,
      this.onPageDelete,
      this.onPageMove})
      : super(key: key);

  @override
  _XppPagesListViewState createState() => _XppPagesListViewState();
}

class _XppPagesListViewState extends State<XppPagesListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (c, i) {
        final page = widget.pages[i];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: GestureDetector(
              onTap: () {
                //setState(() => widget.currentPage = i);
                widget.onPageChange(i);
              },
              onSecondaryTap: () => showContext(i),
              onLongPress: () => showContext(i),
              child: Card(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: (widget.currentPage == i)
                          ? Border.all(color: Colors.red)
                          : Border.all(color: Color.fromARGB(1, 0, 0, 0)),
                      borderRadius: BorderRadius.circular(4)),
                  child: AspectRatio(
                    aspectRatio: page.pageSize.ratio,
                    child: FittedBox(
                      child: XppPageStack(
                        page: page,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      itemCount: widget.pages.length,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      primary: false,
    );
  }

  showContext(int i) => showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => ContextualBottomSheet(
            children: [
              ListTile(
                title: Text(S.of(context).deletePage),
                leading: Icon(Icons.delete_forever),
                onTap: () {
                  widget.onPageDelete(i);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text(S.of(context).movePage + '...'),
                leading: Icon(Icons.open_with),
                onTap: () async {
                  int newIndex = i;
                  if (await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text(S.of(context).movePage + ' $i'),
                            content: TextField(
                              onChanged: (string) =>
                                  newIndex = int.parse(string),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: S.of(context).newPageIndex,
                                  helperText: S.of(context).between1And +
                                      ' ${widget.pages.length}.'),
                            ),
                            actions: [
                              FlatButton(
                                child: Text(S.of(context).cancel),
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                              ),
                              FlatButton(
                                child: Text(S.of(context).okay),
                                onPressed: () {
                                  if (newIndex <= widget.pages.length)
                                    Navigator.of(context).pop(true);
                                },
                              ),
                            ],
                          ))) {
                    widget.onPageMove(i, newIndex);
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));
}
