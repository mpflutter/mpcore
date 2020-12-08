part of '../mpcore.dart';

_Element _encodePadding(Element element) {
  final widget = element.widget as Padding;
  return _Element(
    name: 'padding',
    children: _Element.childrenFromFlutterElement(element),
    attributes: {
      'padding': widget.padding.toString(),
    },
  );
}

_Element _encodeSliverPadding(Element element) {
  final widget = element.widget as SliverPadding;
  return _Element(
    name: 'padding',
    children: _Element.childrenFromFlutterElement(element),
    attributes: {
      'padding': widget.padding.toString(),
    },
  );
}
