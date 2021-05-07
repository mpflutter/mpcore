part of './mpkit_encoder.dart';

MPElement _encodeMPScaffold(Element element) {
  final stackedScaffold =
      element.findAncestorWidgetOfExactType<MPScaffold>() != null;
  final widget = element.widget as MPScaffold;
  final name = widget.name;
  final tabBodyElement = MPCore.findTarget<MPTabBody>(
    element,
    maxDepth: 20,
  );
  Element? headerElement;
  Element? tabBarElement;
  var isTabBody = false;
  var isListBody = widget.isListBody;
  final appBarElement = widget.appBarKey.currentContext as Element?;
  var bodyElement = widget.bodyKey.currentContext as Element?;
  var bottomBarElement = widget.bottomBarKey.currentContext as Element?;
  final floatingBodyElement = widget.floatingBodyKey.currentContext as Element?;
  final bodyBackgroundColor = widget.backgroundColor;
  if (tabBodyElement != null) {
    final tabBody = tabBodyElement.widget as MPTabBody;
    headerElement = (() {
      final target = tabBody.headerKey?.currentContext as Element?;
      if (target != null) {
        return MPCore.findFirstChild(target);
      }
    })();
    tabBarElement = (() {
      final target = tabBody.tabBarKey?.currentContext as Element?;
      if (target != null) {
        return MPCore.findFirstChild(target);
      }
    })();
    bodyElement = (() {
      final target = tabBody.tabBodyKey?.currentContext as Element?;
      if (target != null) {
        return MPCore.findFirstChild(target);
      }
    })();
    isTabBody = true;
  }
  if (isListBody == null &&
      MPCore.findTarget<Scrollable>(
            bodyElement,
            maxDepth: 20,
          ) !=
          null) {
    isListBody = true;
  }
  if (stackedScaffold && bodyElement != null) {
    return MPElement.fromFlutterElement(bodyElement);
  }
  final appBarPreferredSize =
      (appBarElement?.widget as MPScaffoldAppBar?)?.child?.preferredSize;
  return MPElement(
    hashCode: element.hashCode,
    flutterElement: element,
    name: 'mp_scaffold',
    attributes: {
      'name': name,
      'metaData': widget.metaData,
      'appBar': appBarElement != null
          ? MPElement.fromFlutterElement(appBarElement)
          : null,
      'appBarColor': widget.appBarColor != null
          ? widget.appBarColor!.value.toString()
          : null,
      'appBarTintColor': widget.appBarTintColor != null
          ? widget.appBarTintColor!.value.toString()
          : null,
      'appBarHeight': appBarPreferredSize?.height ?? 0.0,
      'header': headerElement != null
          ? MPElement.fromFlutterElement(headerElement)
          : null,
      'tabBar': tabBarElement != null
          ? MPElement.fromFlutterElement(tabBarElement)
          : null,
      'body': bodyElement != null
          ? MPElement.fromFlutterElement(bodyElement)
          : null,
      'floatingBody': floatingBodyElement != null
          ? MPElement.fromFlutterElement(floatingBodyElement)
          : null,
      'bottomBar': bottomBarElement != null
          ? MPElement.fromFlutterElement(bottomBarElement)
          : null,
      'backgroundColor': bodyBackgroundColor != null
          ? bodyBackgroundColor.value.toString()
          : null,
      'isListBody': isListBody,
      'isTabBody': isTabBody,
    },
  );
}
