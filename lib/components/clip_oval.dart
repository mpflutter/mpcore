part of '../mpcore.dart';

MPElement _encodeClipOval(Element element) {
  return MPElement(
    name: 'clip_oval',
    children: MPElement.childrenFromFlutterElement(element),
    attributes: {},
  );
}
