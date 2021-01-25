part of '../mpcore.dart';

MPElement _encodeAlign(Element element) {
  final widget = element.widget as Align;
  return MPElement(
    name: 'align',
    children: MPElement.childrenFromFlutterElement(element),
    // ignore: invalid_use_of_protected_member
    constraints: element.findRenderObject()?.constraints,
    attributes: {'alignment': widget.alignment.toString()},
  );
}
