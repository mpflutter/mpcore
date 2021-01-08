part of './mpkit_encoder.dart';

MPElement _encodeMPScaffold(Element element) {
  final stackedScaffold =
      element.findAncestorWidgetOfExactType<MPScaffold>() != null;
  final widget = element.widget as MPScaffold;
  final name = widget.name;
  final tabBodyElement = MPCore.findTarget<MPTabBody>(element);
  Element headerElement;
  Element tabBarElement;
  var isTabBody = false;
  var isListBody = widget.isListBody;
  final appBarElement = MPCore.findTarget<MPScaffoldAppBar>(element);
  var bodyElement = MPCore.findTarget<MPScaffoldBody>(element);
  var bottomBarElement = MPCore.findTarget<MPScaffoldBottomBar>(element);
  final floatingBodyElement =
      MPCore.findTarget<MPScaffoldFloatingBody>(element);
  final bodyBackgroundColor = widget.backgroundColor;
  if (tabBodyElement != null) {
    headerElement = MPCore.findFirstChild(
        MPCore.findTargetKey(Key('tab_header'), tabBodyElement));
    tabBarElement = MPCore.findFirstChild(
        MPCore.findTargetKey(Key('tab_bar'), tabBodyElement));
    bodyElement = MPCore.findFirstChild(
        MPCore.findTargetKey(Key('tab_body'), tabBodyElement));
    isTabBody = true;
  }
  if (isListBody == null &&
      MPCore.findTarget<Scrollable>(bodyElement) != null) {
    isListBody = true;
  }
  if (stackedScaffold) {
    return MPElement.fromFlutterElement(bodyElement);
  }
  return MPElement(
    name: 'mp_scaffold',
    attributes: {
      'name': name,
      'appBar': MPElement.fromFlutterElement(appBarElement),
      'appBarHeight': (appBarElement?.widget as MPScaffoldAppBar)
              ?.child
              ?.preferredSize
              ?.height ??
          0.0,
      'header': MPElement.fromFlutterElement(headerElement),
      'tabBar': MPElement.fromFlutterElement(tabBarElement),
      'body': MPElement.fromFlutterElement(bodyElement),
      'floatingBody': MPElement.fromFlutterElement(floatingBodyElement),
      'bottomBar': MPElement.fromFlutterElement(bottomBarElement),
      'backgroundColor': bodyBackgroundColor?.value?.toString(),
      'isListBody': isListBody,
      'isTabBody': isTabBody,
    },
  );
}
