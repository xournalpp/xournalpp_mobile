import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:xournalpp/generated/l10n.dart';

class QuotaTile extends StatefulWidget {
  @override
  _QuotaTileState createState() => _QuotaTileState();
}

class _QuotaTileState extends State<QuotaTile> {
  FileQuotaCross quota;
  @override
  void initState() {
    FilePickerCross.quota().then((value) => setState(() => quota = value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb ||
        [TargetPlatform.android, TargetPlatform.iOS]
            .contains(Theme.of(context).platform))
      return (quota != null
          ? Text(
              S.of(context).quota +
                  ': ${(quota.quota / 1e6).round()} ' +
                  S.of(context).mb +
                  ' - ' +
                  (quota.relative * 100).round().toString() +
                  '% ' +
                  S.of(context).used,
              style: Theme.of(context).textTheme.subtitle2,
            )
          : Center(
              child: CircularProgressIndicator(),
            ));
    else
      return Container();
  }
}
