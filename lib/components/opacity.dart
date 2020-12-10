part of '../mpcore.dart';

MPElement _encodeOpacity(Element element) {
  final widget = element.widget as Opacity;
  return MPElement(
    name: 'opacity',
    children: MPElement.childrenFromFlutterElement(element),
    attributes: {
      'opacity': widget.opacity,
    },
  );
}

MPElement _encodeSliverOpacity(Element element) {
  final widget = element.widget as SliverOpacity;
  return MPElement(
    name: 'opacity',
    children: MPElement.childrenFromFlutterElement(element),
    attributes: {
      'opacity': widget.opacity,
    },
  );
}
