import 'package:flutter/widgets.dart';

class MPScaffold extends StatelessWidget {
  final String name;
  final Widget body;
  final PreferredSizeWidget appBar;
  final Widget bottomBar;
  final Widget floatingBody;
  final Color backgroundColor;
  final bool isListBody;

  MPScaffold({
    this.name,
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
    return Stack(
      children: [
        appBar != null ? MPScaffoldAppBar(child: appBar) : Container(),
        body != null ? MPScaffoldBody(child: body) : Container(),
        bottomBar != null ? MPScaffoldBottomBar(child: bottomBar) : Container(),
        floatingBody != null
            ? MPScaffoldFloatingBody(child: floatingBody)
            : Container(),
      ],
    );
  }
}

class MPOverlayScaffold extends MPScaffold {
  final Function onBackgroundTap;

  MPOverlayScaffold({
    Widget body,
    Color backgroundColor,
    this.onBackgroundTap,
  }) : super(body: body, backgroundColor: backgroundColor);
}

class MPScaffoldBody extends StatelessWidget {
  final Widget child;

  MPScaffoldBody({
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class MPScaffoldAppBar extends StatelessWidget {
  final PreferredSizeWidget child;

  MPScaffoldAppBar({
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class MPScaffoldBottomBar extends StatelessWidget {
  final Widget child;

  MPScaffoldBottomBar({
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class MPScaffoldFloatingBody extends StatelessWidget {
  final Widget child;

  MPScaffoldFloatingBody({
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
