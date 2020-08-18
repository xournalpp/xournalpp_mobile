import 'package:flutter/material.dart';
import 'package:xournalpp/src/XppPage.dart';
import 'package:xournalpp/widgets/ContextualBottomSheet.dart';

import 'XppPageStack.dart';

class XppPagesListView extends StatefulWidget {
  @required
  final List<XppPage> pages;
  @required
  final Function(int pageNumber) onPageChange;
  final Function(int pageNumber) onPageDelete;
  final int currentPage;

  const XppPagesListView(
      {Key key,
      this.pages,
      this.onPageChange,
      this.currentPage = 0,
      this.onPageDelete})
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
              onSecondaryTap: () => showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) => ContextualBottomSheet(
                        children: [
                          ListTile(
                            title: Text('Delete page'),
                            leading: Icon(Icons.delete_forever),
                            onTap: () {
                              widget.onPageDelete(i);
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      )),
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
}
