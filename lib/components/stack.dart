part of '../mpcore.dart';

MPElement _encodeStack(Element element) {
  return MPElement(
    name: 'stack',
    children: MPElement.childrenFromFlutterElement(element),
    attributes: {},
  );
}
