part of '../mpcore.dart';

MPElement _encodeConstrainedBox(Element element) {
  // final widget = element.widget as ConstrainedBox;
  final childElements = MPElement.childrenFromFlutterElement(element);
  BoxConstraints? constraints;
  if (childElements.isEmpty) {
    final renderBox = element.findRenderObject();
    if (renderBox is RenderConstrainedBox) {
      // ignore: invalid_use_of_protected_member
      constraints = renderBox.additionalConstraints;
      if (constraints.hasInfiniteWidth && constraints.hasInfiniteHeight) {
        constraints = BoxConstraints(
          minWidth: 0,
          minHeight: 0,
          maxWidth: 0,
          maxHeight: 0,
        );
      }
    } else {
      constraints = BoxConstraints(
        minWidth: 0,
        minHeight: 0,
        maxWidth: 0,
        maxHeight: 0,
      );
    }
  } else {
    final renderBox = element.findRenderObject();
    if (renderBox is RenderBox) {
      constraints = renderBox.constraints;
    }
  }
  return MPElement(
    hashCode: element.hashCode,
    flutterElement: element,
    name: 'constrained_box',
    children: childElements,
    constraints: constraints,
    attributes: {},
  );
}
