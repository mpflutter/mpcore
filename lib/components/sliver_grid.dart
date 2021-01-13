part of '../mpcore.dart';

MPElement _encodeSliverGrid(Element element) {
  final indexedSemanticeParentElement = MPCore.findTarget<KeyedSubtree>(
    element,
    findParent: true,
  );
  if (indexedSemanticeParentElement == null) {
    return MPElement(
      name: 'sliver_grid',
      children: [],
      attributes: {},
    );
  }
  final widget = element.widget as SliverGrid;
  return MPElement(
    name: 'sliver_grid',
    children: MPElement.childrenFromFlutterElement(
      indexedSemanticeParentElement,
    ),
    attributes: {
      'padding': element
          .findAncestorWidgetOfExactType<SliverPadding>()
          ?.padding
          ?.toString(),
      'gridDelegate': _encodeGridDelegate(widget.gridDelegate),
    },
  );
}
