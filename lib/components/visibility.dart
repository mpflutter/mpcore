part of '../mpcore.dart';

_Element _encodeVisibility(Element element) {
  final widget = element.widget as Visibility;
  return _Element(
    name: 'visibility',
    children: _Element.childrenFromFlutterElement(element),
    attributes: {
      'visible': widget.visible,
    },
  );
}

_Element _encodeSliverVisibility(Element element) {
  final widget = element.widget as SliverVisibility;
  return _Element(
    name: 'visibility',
    children: _Element.childrenFromFlutterElement(element),
    attributes: {
      'visible': widget.visible,
    },
  );
}
