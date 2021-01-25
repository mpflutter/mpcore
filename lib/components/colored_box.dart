part of '../mpcore.dart';

MPElement _encodeColoredBox(Element element) {
  final widget = element.widget as ColoredBox;
  return MPElement(
    name: 'colored_box',
    children: MPElement.childrenFromFlutterElement(element),
    // ignore: invalid_use_of_protected_member
    constraints: element.findRenderObject()?.constraints,
    attributes: {'color': widget.color.value.toString()},
  );
}
