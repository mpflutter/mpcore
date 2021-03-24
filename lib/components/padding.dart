part of '../mpcore.dart';

MPElement _encodePadding(Element element) {
  final widget = element.widget as Padding;
  return MPElement(
    hashCode: element.hashCode,
    name: 'padding',
    children: MPElement.childrenFromFlutterElement(element),
    // ignore: invalid_use_of_protected_member
    constraints: element.findRenderObject()?.constraints,
    attributes: {
      'padding': widget.padding.toString(),
    },
  );
}

MPElement _encodeSliverPadding(Element element) {
  final widget = element.widget as SliverPadding;
  return MPElement(
    hashCode: element.hashCode,
    name: 'padding',
    children: MPElement.childrenFromFlutterElement(element),
    // ignore: invalid_use_of_protected_member
    constraints: element.findRenderObject()?.constraints,
    attributes: {
      'padding': widget.padding.toString(),
    },
  );
}
