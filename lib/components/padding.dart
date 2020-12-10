part of '../mpcore.dart';

MPElement _encodePadding(Element element) {
  final widget = element.widget as Padding;
  return MPElement(
    name: 'padding',
    children: MPElement.childrenFromFlutterElement(element),
    attributes: {
      'padding': widget.padding.toString(),
    },
  );
}

MPElement _encodeSliverPadding(Element element) {
  final widget = element.widget as SliverPadding;
  return MPElement(
    name: 'padding',
    children: MPElement.childrenFromFlutterElement(element),
    attributes: {
      'padding': widget.padding.toString(),
    },
  );
}
