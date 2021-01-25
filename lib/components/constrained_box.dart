part of '../mpcore.dart';

MPElement _encodeConstrainedBox(Element element) {
  final widget = element.widget as ConstrainedBox;
  return MPElement(
    name: 'constrained_box',
    children: MPElement.childrenFromFlutterElement(element),
    // ignore: invalid_use_of_protected_member
    constraints: element.findRenderObject()?.constraints,
    attributes: {
      'scrollable': MPCore.findTarget<Scrollable>(element) != null,
    },
  );
}
