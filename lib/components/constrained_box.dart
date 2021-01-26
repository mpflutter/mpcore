part of '../mpcore.dart';

MPElement _encodeConstrainedBox(Element element) {
  final widget = element.widget as ConstrainedBox;
  final childElements = MPElement.childrenFromFlutterElement(element);
  return MPElement(
    name: 'constrained_box',
    children: childElements,
    // ignore: invalid_use_of_protected_member
    constraints: childElements.isEmpty
        ? (element.findRenderObject() as RenderConstrainedBox)
            ?.additionalConstraints
        : element.findRenderObject()?.constraints,
    attributes: {
      'scrollable': MPCore.findTarget<Scrollable>(element) != null,
    },
  );
}
