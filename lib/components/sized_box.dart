part of '../mpcore.dart';

MPElement _encodeSizedBox(Element element) {
  final widget = element.widget as SizedBox;
  return MPElement(
    hashCode: element.hashCode,
    flutterElement: element,
    name: 'sized_box',
    children: MPElement.childrenFromFlutterElement(element),
    // ignore: invalid_use_of_protected_member
    constraints: element.findRenderObject()?.constraints,
    attributes: {
      'width': widget.width.toString(),
      'height': widget.height.toString(),
    },
  );
}
