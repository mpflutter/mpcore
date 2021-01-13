part of '../mpcore.dart';

MPElement _encodeSliverList(Element element) {
  final indexedSemanticeParentElement = MPCore.findTarget<KeyedSubtree>(
    element,
    findParent: true,
  );
  if (indexedSemanticeParentElement == null) {
    return MPElement(
      name: 'sliver_list',
      children: [],
      attributes: {},
    );
  }
  return MPElement(
    name: 'sliver_list',
    children: MPElement.childrenFromFlutterElement(
      indexedSemanticeParentElement,
    ),
    attributes: {},
  );
}
