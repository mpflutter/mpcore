part of '../mpcore.dart';

_Element _encodeOpacity(Element element) {
  final widget = element.widget as Opacity;
  return _Element(
    name: 'opacity',
    children: _Element.childrenFromFlutterElement(element),
    attributes: {
      'opacity': widget.opacity,
    },
  );
}

_Element _encodeSliverOpacity(Element element) {
  final widget = element.widget as SliverOpacity;
  return _Element(
    name: 'opacity',
    children: _Element.childrenFromFlutterElement(element),
    attributes: {
      'opacity': widget.opacity,
    },
  );
}
