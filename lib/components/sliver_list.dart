part of '../mpcore.dart';

_Element _encodeSliverList(Element element) {
  final indexedSemanticeParentElement = MPCore.findTarget<KeyedSubtree>(
    element,
    findParent: true,
  );
  if (indexedSemanticeParentElement == null) {
    return _Element(
      name: 'sliver_list',
      children: [],
    );
  }
  return _Element(
    name: 'sliver_list',
    children: _Element.childrenFromFlutterElement(
      indexedSemanticeParentElement,
    ),
  );
}
