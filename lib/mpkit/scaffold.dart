import 'package:flutter/widgets.dart';

import '../mpcore.dart';

final List<MPScaffoldState> scaffoldStates = [];

class MPScaffold extends StatefulWidget {
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
  final bool? isFragmentMode;

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
    this.isFragmentMode,
  });

  @override
  MPScaffoldState createState() => MPScaffoldState();
}

class MPScaffoldState extends State<MPScaffold> {
  final bodyKey = GlobalKey();
  final appBarKey = GlobalKey();
  final bottomBarKey = GlobalKey();
  final floatingBodyKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    scaffoldStates.add(this);
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < 10 ||
        MediaQuery.of(context).size.height < 10) {
      return Container();
    }
    Widget child = Stack(
      children: [
        widget.appBar != null
            ? MPScaffoldAppBar(key: appBarKey, child: widget.appBar)
            : Container(),
        widget.body != null
            ? MPScaffoldBody(
                key: bodyKey,
                child: widget.body,
                appBarHeight: widget.appBar != null
                    ? widget.appBar?.preferredSize.height
                    : null,
              )
            : Container(),
        widget.bottomBar != null
            ? MPScaffoldBottomBar(key: bottomBarKey, child: widget.bottomBar)
            : Container(),
        widget.floatingBody != null
            ? MPScaffoldFloatingBody(
                key: floatingBodyKey, child: widget.floatingBody)
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
  final double? appBarHeight;

  MPScaffoldBody({
    Key? key,
    this.child,
    this.appBarHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - (appBarHeight ?? 0.0),
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
