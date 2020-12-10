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
    );
  }
  final widget = element.widget as ListView;
  return MPElement(
    name: 'list_view',
    children: MPElement.childrenFromFlutterElement(
      indexedSemanticeParentElement,
    ),
    attributes: {
      'scrollDirection': widget.scrollDirection?.toString(),
    },
  );
}
