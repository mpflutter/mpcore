part of '../mpcore.dart';

MPElement _encodeClipOval(Element element) {
  // final widget = element.widget as ClipOval;
  return MPElement(
    name: 'clip_oval',
    children: MPElement.childrenFromFlutterElement(element),
    attributes: {},
  );
}
