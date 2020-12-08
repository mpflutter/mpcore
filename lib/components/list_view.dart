part of '../mpcore.dart';

_Element _encodeListView(Element element) {
  final indexedSemanticeParentElement = MPCore.findTarget<KeyedSubtree>(
    element,
    findParent: true,
  );
  if (indexedSemanticeParentElement == null) {
    return _Element(
      name: 'list_view',
      children: [],
    );
  }
  return _Element(
    name: 'list_view',
    children: _Element.childrenFromFlutterElement(
      indexedSemanticeParentElement,
    ),
  );
}
