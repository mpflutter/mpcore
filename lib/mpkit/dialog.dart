import 'package:flutter/widgets.dart';

import 'mpkit.dart';

Future<T> showMPDialog<T>({
  @required BuildContext context,
  WidgetBuilder builder,
  bool barrierDismissible = true,
  Color barrierColor,
}) {
  return Navigator.of(context).push(MPPageRoute(builder: (context) {
    return MPOverlayScaffold(
      backgroundColor: barrierColor,
      onBackgroundTap: () {
        if (barrierDismissible) {
          Navigator.of(context).pop();
        }
      },
      body: builder(context),
    );
  }));
}
