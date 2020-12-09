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
  final widget = element.widget as ListView;
  return _Element(
    name: 'list_view',
    children: _Element.childrenFromFlutterElement(
      indexedSemanticeParentElement,
    ),
    attributes: {
      'scrollDirection': widget.scrollDirection?.toString(),
    },
  );
}
