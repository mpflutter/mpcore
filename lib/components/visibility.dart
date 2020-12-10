part of '../mpcore.dart';

MPElement _encodeVisibility(Element element) {
  final widget = element.widget as Visibility;
  return MPElement(
    name: 'visibility',
    children: MPElement.childrenFromFlutterElement(element),
    attributes: {
      'visible': widget.visible,
    },
  );
}

MPElement _encodeSliverVisibility(Element element) {
  final widget = element.widget as SliverVisibility;
  return MPElement(
    name: 'visibility',
    children: MPElement.childrenFromFlutterElement(element),
    attributes: {
      'visible': widget.visible,
    },
  );
}
