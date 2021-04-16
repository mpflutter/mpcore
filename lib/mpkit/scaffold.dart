// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/widgets.dart';

import '../mpcore.dart';

class MPScaffold extends StatelessWidget {
  final String? name;
  final Map<String, String>? metaData;
  final Color? appBarColor; // Taro use only
  final Color? appBarTintColor; // Taro use only
  final Widget? body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomBar;
  final Widget? floatingBody;
  final Color? backgroundColor;
  final bool? isListBody;

  MPScaffold({
    this.name,
    this.metaData,
    this.appBarColor,
    this.appBarTintColor,
    this.body,
    this.appBar,
    this.bottomBar,
    this.floatingBody,
    this.backgroundColor,
    this.isListBody,
  });

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < 10 ||
        MediaQuery.of(context).size.height < 10) {
      return Container();
    }
    Widget child = Stack(
      children: [
        appBar != null ? MPScaffoldAppBar(child: appBar) : Container(),
        body != null ? MPScaffoldBody(child: body) : Container(),
        bottomBar != null ? MPScaffoldBottomBar(child: bottomBar) : Container(),
        floatingBody != null
            ? MPScaffoldFloatingBody(child: floatingBody)
            : Container(),
      ],
    );
    final app = context.findAncestorWidgetOfExactType<MPApp?>();
    if (app != null && app.maxWidth != null) {
      final mediaQuery = MediaQuery.of(context);
      if (mediaQuery.size.width > app.maxWidth!) {
        final newMediaQuery = mediaQuery.copyWith(
          size: Size(app.maxWidth!, mediaQuery.size.height),
        );
        child = MediaQuery(
          data: newMediaQuery,
          child: child,
        );
      }
    }
    return child;
  }
}

class MPOverlayScaffold extends MPScaffold {
  final Function? onBackgroundTap;
  final ModalRoute? parentRoute;

  MPOverlayScaffold({
    Widget? body,
    Color? backgroundColor,
    this.onBackgroundTap,
    this.parentRoute,
  }) : super(body: body, backgroundColor: backgroundColor);
}

class MPScaffoldBody extends StatelessWidget {
  final Widget? child;

  MPScaffoldBody({
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: child,
    );
  }
}

class MPScaffoldAppBar extends StatelessWidget {
  final PreferredSizeWidget? child;

  MPScaffoldAppBar({
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (child == null) {
      return Container();
    }
    return Container(
      constraints:
          BoxConstraints.tightFor(width: MediaQuery.of(context).size.width),
      child: child,
    );
  }
}

class MPScaffoldBottomBar extends StatelessWidget {
  final Widget? child;

  MPScaffoldBottomBar({
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (child == null) {
      return Container();
    }
    return Container(
      constraints:
          BoxConstraints.tightFor(width: MediaQuery.of(context).size.width),
      child: child,
    );
  }
}

class MPScaffoldFloatingBody extends StatelessWidget {
  final Widget? child;

  MPScaffoldFloatingBody({
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child ?? Container();
  }
}
