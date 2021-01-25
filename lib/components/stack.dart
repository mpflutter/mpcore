part of '../mpcore.dart';

MPElement _encodeStack(Element element) {
  return MPElement(
    name: 'stack',
    children: MPElement.childrenFromFlutterElement(element),
    // ignore: invalid_use_of_protected_member
    constraints: element.findRenderObject()?.constraints,
    attributes: {},
  );
}
