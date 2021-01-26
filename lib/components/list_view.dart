part of '../mpcore.dart';

MPElement _encodeListView(Element element) {
  final indexedSemanticeParentElement = MPCore.findTarget<KeyedSubtree>(
    element,
    findParent: true,
  );
  if (indexedSemanticeParentElement == null) {
    return MPElement(
      name: 'list_view',
      children: [],
      // ignore: invalid_use_of_protected_member
      constraints: element.findRenderObject()?.constraints,
      attributes: {},
    );
  }
  final widget = element.widget as ListView;
  return MPElement(
    name: 'list_view',
    children: MPElement.childrenFromFlutterElement(
      indexedSemanticeParentElement,
    ),
    // ignore: invalid_use_of_protected_member
    constraints: element.findRenderObject()?.constraints,
    attributes: {
      'isRoot': (() {
        if (widget.primary == false) {
          return false;
        } else if (widget.scrollDirection == Axis.vertical &&
            element.findAncestorWidgetOfExactType<Scrollable>() == null &&
            element.findAncestorWidgetOfExactType<Align>() == null &&
            element.findAncestorWidgetOfExactType<Center>() == null) {
          return true;
        } else {
          return false;
        }
      })(),
      'padding': widget.padding?.toString(),
      'scrollDirection': widget.scrollDirection?.toString(),
    },
  );
}
