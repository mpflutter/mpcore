import 'package:flutter/widgets.dart';

import '../mpcore.dart';

final List<GlobalKey> scaffoldKeys = [];

class MPScaffold extends StatelessWidget {
  final String? name;
  final Map<String, String>? metaData;
  final Color? appBarColor; // Taro use only
  final Color? appBarTintColor; // Taro use only
  final Widget? body;
  final bodyKey = GlobalKey();
  final PreferredSizeWidget? appBar;
  final appBarKey = GlobalKey();
  final Widget? bottomBar;
  final bottomBarKey = GlobalKey();
  final Widget? floatingBody;
  final floatingBodyKey = GlobalKey();
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
  }) : super(key: (() {
          scaffoldKeys
              .removeWhere((element) => element.currentContext?.owner == null);
          final key = GlobalKey();
          scaffoldKeys.add(key);
          return key;
        })());

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < 10 ||
        MediaQuery.of(context).size.height < 10) {
      return Container();
    }
    Widget child = Stack(
      children: [
        appBar != null
            ? MPScaffoldAppBar(key: appBarKey, child: appBar)
            : Container(),
        body != null ? MPScaffoldBody(key: bodyKey, child: body) : Container(),
        bottomBar != null
            ? MPScaffoldBottomBar(key: bottomBarKey, child: bottomBar)
            : Container(),
        floatingBody != null
            ? MPScaffoldFloatingBody(key: floatingBodyKey, child: floatingBody)
            : Container(),
      ],
    );
    final app = context.findAncestorWidgetOfExactType<MPApp>();
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
    Key? key,
    this.child,
  }) : super(key: key);

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
    Key? key,
    this.child,
  }) : super(key: key);

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
    Key? key,
    this.child,
  }) : super(key: key);

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
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child ?? Container();
  }
}
