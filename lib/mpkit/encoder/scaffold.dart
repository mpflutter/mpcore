part of './mpkit_encoder.dart';

MPElement _encodeMPScaffold(Element element) {
  final stackedScaffold =
      element.findAncestorWidgetOfExactType<MPScaffold>() != null;
  final widget = element.widget as MPScaffold;
  final name = widget.name;
  final tabBodyElement = MPCore.findTarget<MPTabBody>(element);
  Element? headerElement;
  Element? tabBarElement;
  var isTabBody = false;
  var isListBody = widget.isListBody;
  final appBarElement = MPCore.findTarget<MPScaffoldAppBar>(element);
  var bodyElement = MPCore.findTarget<MPScaffoldBody>(element);
  var bottomBarElement = MPCore.findTarget<MPScaffoldBottomBar>(element);
  final floatingBodyElement =
      MPCore.findTarget<MPScaffoldFloatingBody>(element);
  final bodyBackgroundColor = widget.backgroundColor;
  if (tabBodyElement != null) {
    headerElement = (() {
      final target = MPCore.findTargetKey(Key('tab_header'), tabBodyElement);
      if (target != null) {
        return MPCore.findFirstChild(target);
      }
    })();
    tabBarElement = (() {
      final target = MPCore.findTargetKey(Key('tab_bar'), tabBodyElement);
      if (target != null) {
        return MPCore.findFirstChild(target);
      }
    })();
    bodyElement = (() {
      final target = MPCore.findTargetKey(Key('tab_body'), tabBodyElement);
      if (target != null) {
        return MPCore.findFirstChild(target);
      }
    })();
    isTabBody = true;
  }
  if (isListBody == null &&
      MPCore.findTarget<Scrollable>(bodyElement) != null) {
    isListBody = true;
  }
  if (stackedScaffold && bodyElement != null) {
    return MPElement.fromFlutterElement(bodyElement);
  }
  return MPElement(
    hashCode: element.hashCode,
    name: 'mp_scaffold',
    attributes: {
      'name': name,
      'metaData': widget.metaData,
      'appBar': appBarElement != null
          ? MPElement.fromFlutterElement(appBarElement)
          : null,
      'appBarColor': widget.appBarColor?.value.toString(),
      'appBarTintColor': widget.appBarTintColor?.value.toString(),
      'appBarHeight': (appBarElement?.widget as MPScaffoldAppBar)
              .child
              ?.preferredSize
              ?.height ??
          0.0,
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
      'backgroundColor': bodyBackgroundColor?.value.toString(),
      'isListBody': isListBody,
      'isTabBody': isTabBody,
    },
  );
}
