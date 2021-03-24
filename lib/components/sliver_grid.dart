part of '../mpcore.dart';

MPElement _encodeSliverGrid(Element element) {
  final indexedSemanticeParentElement = MPCore.findTarget<KeyedSubtree>(
    element,
    findParent: true,
  );
  if (indexedSemanticeParentElement == null) {
    return MPElement(
      hashCode: element.hashCode,
      name: 'sliver_grid',
      children: [],
      attributes: {},
    );
  }
  final widget = element.widget as SliverGrid;
  return MPElement(
    hashCode: element.hashCode,
    name: 'sliver_grid',
    children: MPElement.childrenFromFlutterElement(
      indexedSemanticeParentElement,
    ),
    attributes: {
      'padding': element
          .findAncestorWidgetOfExactType<SliverPadding>()
          ?.padding
          ?.toString(),
      // ignore: invalid_use_of_protected_member
      'width': (element.findRenderObject()?.constraints as SliverConstraints)
          ?.crossAxisExtent,
      'gridDelegate': _encodeGridDelegate(widget.gridDelegate),
    },
  );
}
